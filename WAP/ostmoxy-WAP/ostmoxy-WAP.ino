#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ESP8266WebServer.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>
#include <EEPROM.h>
#include <DNSServer.h>
#include <string.h>
#include <avr/pgmspace.h>
#include <SoftwareSerial.h>
#include <SimpleTimer.h>

/**
 * A sketch to open a Wireless Access Point from within printerX's case using
 *    an ESP8266-12E, provide a captive portal, and update a printer's WiFi
 *    access credentials
 *    
 * Matches hardware: ostmoxy pihat version 2.2
 * 
 * Serial receipt code is commented since we are not currently handling any
 *   events based on incoming serial data
 * 
 * @author costmo
 */

/**
 * Global variables
 */
// SSID broadcast prefix for all printerX access points. Will be suffixed with a unique ID generated from the WiFi module's MAC address.
String  ssidPrefix = "printerX-";
// Internal port for web access
int serverPort = 5050;
// User's SSID
String ssid = "";
// IP Address of the Software AP
String softIP  = "";
// Query port for captive portal DNS
const byte DNS_PORT = 53;
// // Flag for serial receiver
//bool receiving = false;
// // Receipt buffer size
//int bufferSize = 512;
// // Incoming serial data buffer
//char buff [512];
// // Current position in the buffer
//int bufferIndex = 0;

// Get third party libraries setup...
// Set pins 3 and 1 (RX and TX) for serial communications with a Raspberry Pi (through an ostmoxy pihat, by design)
SoftwareSerial softSerial( 3, 1 );
// The local access point's IP address
IPAddress ip;
// Run web servers on various ports that may be the targets of requests
ESP8266WebServer server( serverPort );
ESP8266WebServer server_443( 443 );
ESP8266WebServer server_80( 80 );
// A DNS server, which causes all traffic to redirect to a built-in captive portal
DNSServer dnsServer;

// A timer so we can shut down the access point after it should no longer be needed
SimpleTimer timer;
// Keep track of it so we can restart it if necessary
int timerId;
// Whether or not the Wireless Acess Point is currently enabled. Probably superfluous
bool wapEnabled = true;
// How long (in ms) after power-on te WAP should stay active. Currently 10 minutes.
int wapAwakeTime = (1000 * 60 * 10);

/**
 * Run on device power-on
 * 
 * @author costmo
 * @return void
 */
void setup() 
{
  // wait for serial port to connect
  Serial.begin( 19200 );
  while (!Serial) {
    ;
  }
  delay( 10 );

  // Start our services
  startSoftAP();
  startWebServer();
  softSerial.begin( 19200 );
  timerId = timer.setTimeout( wapAwakeTime, timeoutWAP );
}


/**
 * Run while the sketch is active
 * 
 * @return void
 * @author costmo
 */
void loop() 
{
  // Listen for API requests on our running server/ports
  server.handleClient();
  server_443.handleClient();
  server_80.handleClient();

  int incomingByte = 0;
  
  // Redirect users to the login portal by virtue of DNS failure
  dnsServer.processNextRequest();

  // Ingest and handle incoming serial data
  // Currently an academic excercise - we don't do anything with incoming serial requests
//  if( !receiving ) {
//    bufferIndex = 0;
//    memset( buff, 0, bufferSize );
//  }
//  if( Serial.available() > 0 ) {
//    receiving = true;
//    // read the incoming byte:
//    incomingByte = Serial.read();
//
//    // EOL or buffer boundary protection
//    if( incomingByte != 10 || bufferIndex == (bufferSize - 1) ) {
//      buff[bufferIndex] = (char)incomingByte;
//      bufferIndex++;
//    } else {
//      receiving = false;
//    }
//  }
//
//  if( !receiving && bufferIndex > 0 ) {
//    Serial.print( "Got string: " );
//    Serial.println( buff );
//  }

  timer.run();

}


/**
 * Iterate through the known server instances to find the value of a POSTed key
 * 
 * @return String
 * @param key         The key to parse
 * @author costmo
 */
String postValue( String key )
{
    String returnValue = server.arg( key );
    if( returnValue.length() < 1 ) {
      returnValue = server_443.arg( key );
    }
    if( returnValue.length() < 1 ) {
      returnValue = server_80.arg( key );
    }

    return returnValue;
}


/**
 * Start the local (software) access point
 * 
 * @return void
 * @author costmo
 */
void startSoftAP()
{
  String mac = WiFi.macAddress();
  String macPartOne = mac.substring( 12, 14 );
  String macPartTwo = mac.substring( 15 );
  ssid = ssidPrefix + macPartOne + macPartTwo; // "printerX-" followed by the last 4 characters of the device MAC address

  WiFi.mode( WIFI_AP );
  WiFi.softAPConfig( WiFi.softAPIP(), WiFi.softAPIP(), IPAddress( 255, 255, 255, 0 ) );
  WiFi.softAP( ssid.c_str() );
  dnsServer.start( DNS_PORT, "*", WiFi.softAPIP() );
  
  softIP = WiFi.softAPIP().toString();
}


/**
 * Define the endpoints for a tiny API server for receiving and handling requests and start the web server on various (possibly) needed ports
 * 
 * @return void
 * @author costmo
 */
void startWebServer()
{
  server.on( "/", handleRoot );
  server.on( "/connect", handleConnect );
  server.on( "/shutdown", handleShutdownAP );
  server.onNotFound( handleRoot );
  server.begin();

  server_443.on( "/", handleRoot );
  server_443.on( "/connect", handleConnect );
  server_443.on( "/shutdown", handleShutdownAP );
  server_443.onNotFound( handleRoot );
  server_443.begin();

  server_80.on( "/", handleRoot );
  server_80.on( "/connect", handleConnect );
  server_80.on( "/shutdown", handleShutdownAP );
  server_80.onNotFound( handleRoot );
  server_80.begin();
}

/**
 * Gets the SSID and IP address of the local access point
 * 
 * @return String
 * @author costmo
 */
String getSoftAPStatus()
{
  String returnValue = "\n";
  returnValue += "SSID: " + ssid + "\n";
  returnValue += "IP  : " + softIP + "\n";

  return returnValue;
}

/**
 * Shut down the WAP after a pre-determined time.
 * 
 * Currently configured for 10 minutes after power-on
 * 
 * @return void
 * @author costmo
 */
void timeoutWAP()
{
  // Shut off the AP, but limit the number of times we try to do so -
  //   Guarantee that we are disconnected by issuing "disconnect" multiple times,
  //   but stop doing that after several ticks since at least one of them should 
  //   have succeeded
  WiFi.softAPdisconnect( true );
  wapEnabled = false;
}


/**
 * Provide a common header for rendered web pages
 * 
 * @return String       Opening HTML envelope for the captive portal
 * @author costmo
 */
String commonHeader()
{
  String returnValue =
    "<!DOCTYPE HTML>"
    "<html>"
      "<head>"
        "<meta name='viewport' content='width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0'>"
        "<title>printerX | Connect to your WiFi network</title>"
        "<style>"
          "body { background-color: #DADADA; font-family: 'Open Sans', sans-serif; Color: #000000; }"
          "p { line-height: 28px; }"
          "#container { width: 90%; max-width: 640px; text-align: center; background-color: #FFFFFF; margin-left: auto; margin-right: auto; border: 1px solid gray;border-radius: 5px; padding: 10px; }"
          "#header { width: 100%; text-align: center; }"
          "svg { width: 80%; height: auto; }"
          "#exit_text{ font-size: 11px; text-align: left; }"
          "#exit_text p{ line-height: 20px; }"
          "p.error { color: red; font-weight: bold; }"
          "#question{ cursor: pointer; font-weight: bold; }"
          "#answer{ display: none; }"
          "input[type=text], input[type=password] { width: 90%; height: 30px; padding-left: 10px; }"
        "</style>"
        "<script type='text/javascript'>"
          "function showAnswer() {"
            "var element = document.getElementById( 'answer' );"
            "element.style.display = 'block';"
          "}"
        "</script>"
      "</head>"
      "<body>";

  return returnValue;
}

/**
 * Provide a common footer for rendered web pages
 * 
 * @return String         Closing HTML envelope for the captive portal
 * @author costmo
 */
String commonFooter()
{
  String returnValue = "</body></html>";
  return returnValue;
}

/**
 * Handler for requests foro "/"
 * 
 * This should only provide the interface for providing WiFi credentials
 * 
 * @return void
 * @author costmo
 */
void handleRoot()
{
//  Serial.println( "Connecting" );
 
  server.send( 200, "text/html", connectionHtml() );
  server_443.send( 200, "text/html", connectionHtml() );
  server_80.send( 200, "text/html", connectionHtml() );
  
  delay( 100 );
}

/**
 * Handle a request to shutdown the soft AP
 * 
 * Sends an appropriate status page to the web browser, which should be a captive portal page
 * 
 * @return void
 * @author costmo
 */
void handleShutdownAP()
{
   String html =
    commonHeader() +
    "<div id='container'>"
      "<div id='header'>"
        "<h3>Disabling Wireless Access Point</h3>"
      "</div>"
      "<div id='content'>"
        "<p>The <strong>printerX</strong> Wireless Access Point is powering down.</p>"
        "<div id='exit_text'>"
          "<p>If you need for the WAP to be available again, restart the <strong>printerX</strong> web server.</p>"
          "<p>This screen will disappear automatically in a few seconds.</p>"
        "</div>"
      "</div>"
    "</div>" +
    commonFooter();

  server.send( 200, "text/html", html );
  server_443.send( 200, "text/html", html );
  server_80.send( 200, "text/html", html );

  delay( 7000 );
  WiFi.softAPdisconnect( true );
}

/**
 * Handle POST requests to /connect - an attempt to reconfigure the printer's WiFi credentials
 * 
 * Sends an appropriate status page to the web browser, which should be a captive portal page
 * 
 * @return void
 * @author costmo
 */
void handleConnect()
{
  String hardSSID = postValue( "ssid" );
  String hardPassword = postValue( "password" );
  bool doSet = false;

  // Show the user a message
  // Common/top part first
  String html = 
    commonHeader() +
    "<div id='container'>"
      "<div id='header'>"
        "<h3>Connecting to your WiFi network...</h3>"
      "</div>"
      "<div id='content'>";

    // Insufficient input
    if( hardSSID.length() < 1 )
    {
      html +=
        "<p class='error'>You must supply an SSID.</p>"
        "<p><a href='/'>Click here</a> to go back to the form and try again.</p>";
    } else { // OK
      doSet = true;
      html +=
        "<p>The <strong>printerX</strong> web server will now restart so that it can connect to<br/>the WiFi network named <strong>" + hardSSID + "</strong></p>"
        "<div id='exit_text'>"
          "<p>You should be able to access your printer in a web browser at <a href='http://printerx.local/'>http://printerX.local/</a> in about 30 seconds.</p>"
          "<p>If your printer fails to connect to your network, <a href='/'>click here</a> to try again.</p>"
          "<p>If you are done, CANCEL this screen and reconnect to your network.</p>"
          "<p>For security purposes, this Wireless Access Point will only remain active for 10 minutes. If you wish to shut down the WAP right now, <a href='/shutdown'>click here</a>.</p>"
        "</div>";
    }
    html += 
      "</div>"
    "</div>"+
    commonFooter();
  
  server.send( 200, "text/html", html );
  server_443.send( 200, "text/html", html );
  server_80.send( 200, "text/html", html );

  // Send the instruction to reset credentials to the rPi
  if( doSet ) {

    String sendString = "{\"action\":\"set-wifi\",\"ssid\":\"";
    sendString += hardSSID;
    sendString += "\",\"password\":\"";
    sendString += hardPassword;
    sendString += "\"}";
    softSerial.println( sendString );

    // Give the WAP a new lease on life in case the user wants to try again
    timer.restartTimer( timerId );
  }
  
  //  Serial.println( "Connected to WiFi: " + hardSSID );
  delay( 100 );
}


/**
 * Provide the HTML form and content for connecting to a WiFi network
 * 
 * @return const String
 * @author costmo
 */
const String connectionHtml()
{
  String returnValue =
    commonHeader() +
    "<div id='container'>"
      "<div id='header'>"
        "<h3>Connect to your WiFi network</h3>"
      "</div>"
      "<div id='content'>"
        "<p>To get <strong>printerX</strong> connected to your WiFi network,<br/>please provide your credentials below.</p>"
        "<p>"
        "<FORM action='/connect' method='post'>"
          "<p><INPUT type='text' name='ssid' placeholder='SSID' autocomplete='off' autocorrect='off' autocapitalize='off' spellcheck='false'></p>"
          "<p><INPUT type='password' name='password' placeholder='Password' autocomplete='off' autocorrect='off' autocapitalize='off' spellcheck='false'></p>"
          "<p><INPUT type='submit' value='CONNECT'></p>"
        "</FORM action='/connect' method='post'>"
        "</p>"
        "<div id='exit_text'>"
           "<div id='question' onClick='showAnswer();return false;'>What is this?</div>"
           "<div id='answer'>"
            "<p>"
              "A Wireless Access Point (WAP) powers on with the <strong>printerX</strong> web server. "
              "While it is running, it enables you to reconfigure the web server's access to your wireless network by providing credentials in the boxes above. "
              "After providing an SSID and (optional) password, click 'CONNECT' and your web server's WiFi access credentials will be updated, the web server will reboot, and the <strong>printerX</strong> web server should become available at <a href='http://printerx.local'>http://printerX.local</a> after about 30 seconds. "
            "</p>"
            "<p>"
              "For security purposes, this WAP will only remain active for 10 minutes. If you wish to shut down the WAP right now, <a href='/shutdown'>click here</a>."
            "</p>"
          "</div>"
        "</div>"
      "</div>" +
      commonFooter();

  return returnValue;
}
