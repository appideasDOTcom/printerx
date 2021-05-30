#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ESP8266WebServer.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>
#include <EEPROM.h>
#include <DNSServer.h>
#include <string.h>
#include <SoftwareSerial.h>

/**
 * A sketch to open a Wireless Access Point from within printerX's case using
 *    an ESP8266-12E, provide a captive portal, and update a printer's WiFi
 *    access credentials
 * 
 * @author costmo
 */

// SSID broadcast prefix for all printerX access points
String  ssidPrefix = "printerx-";
// Internal port for web access
int serverPort = 5050;
// User's SSID
String ssid = "";
// IP Address of the Software AP
String softIP  = "";
// Query port for captive portal DNS
const byte DNS_PORT = 53;
// Flag for serial receiver (not currently used)
bool receiving = false;
// Receipt buffer size
int bufferSize = 512;
// Invoming serial data buffer
char buff [512];
// Current position in the buffer
int bufferIndex = 0;

// Get third party libraries setup...
SoftwareSerial softSerial( 3, 1 );
IPAddress ip;
ESP8266WebServer server( serverPort );
ESP8266WebServer server_443( 443 );
ESP8266WebServer server_80( 80 );
DNSServer dnsServer;

/**
 * Run on device power-on
 * 
 * @author costmo
 * @since  20180902
 */
void setup() 
{
  // wait for serial port to connect
  Serial.begin( 57600 );
    while (!Serial) {
      ;
    }
  delay( 100 );

  // Start our services
  startSoftAP();
  startWebServer();
  softSerial.begin( 57600 );
}


/**
 * Run while the sketch is active
 * 
 * @return void
 * @author costmo
 * @since  20180902
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
  if( !receiving ) {
    bufferIndex = 0;
    memset( buff, 0, bufferSize );
  }
  if( Serial.available() > 0 ) {
    receiving = true;
    // read the incoming byte:
    incomingByte = Serial.read();

    // EOL or buffer boundary protection
    if( incomingByte != 10 || bufferIndex == (bufferSize - 1) ) {
      buff[bufferIndex] = (char)incomingByte;
      bufferIndex++;
    } else {
      receiving = false;
    }
  }

  if( !receiving && bufferIndex > 0 ) {
    Serial.print( "Got string: " );
    Serial.println( buff );
  }
}

/**
 * Handler for requests to "/"
 * 
 * This should only provide the interface for logging into a network
 * 
 * @return void
 * @author costmo
 * @since  20180913
 */
void handleRoot()
{
	Serial.println( "Connecting" );
 
	server.send( 200, "text/html", connectionHtml() );
  server_443.send( 200, "text/html", connectionHtml() );
  server_80.send( 200, "text/html", connectionHtml() );
  
  delay( 100 );
}

/**
 * Look through the known server instances to find a posted value
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
 * Handle POST requests to /connect - an attempt to reconfigure the printer's WiFi credentials
 */
void handleConnect()
{
  String hardSSID = postValue( "ssid" );
  String hardPassword = postValue( "password" );
  bool doSet = false;

  // Show the user a message
  // Common/top part first
  String html =
    "<!DOCTYPE HTML>"
    "<html>"
    "<head>"
    "<meta name = \"viewport\" content = \"width = device-width, initial-scale = 1.0, maximum-scale = 1.0, user-scalable=0\">"
    "<title>Connect to WiFi</title>"
    "<style>"
    "body { background-color: #D3E3F1; font-family: \"Open Sans\", sans-serif; Color: #000000; }"
    "#header { width: 100%; text-align: center; }"
    "input[type=text], input[type=password] { width: 50%; height: 30px; padding-left: 10px; }"
    "</style>"
    "</head>"
    "<body>";

    // Insufficient input
    if( hardSSID.length() < 1 )
    {
      html +=
        "<p style='font-weight:bold;color:red;'>You must supply an SSID.</p>"
        "<p><a href='/'>Click here</a> to go back to the form and try again.</p>";
    } else { // OK
      doSet = true;
      html +=
        "<p>The printerX web server will now restart so that it can connect to the WiFi network named <strong>" + hardSSID + "</strong></p>"
        "<p>You should be able to access your printer in a web browser at <a href='http://printerx.local/'>http://printerx.local/</a> in about 30 seconds.</p>"
        "<p>If your printer fails to connect to your network, <a href='/'>click here</a> to try again.</p>"
        "<p>If you're done, CANCEL this screen and reconnect to your network.</p>";
    }
    html +=
      "</body>"
      "</html>";
  
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

    Serial.println( "SENDING:" );
    Serial.println( sendString );

    softSerial.println( sendString );
  }
  
  Serial.println( "Connected to WiFi: " + hardSSID );
  delay( 100 );
}

/**
 * Start the local access point
 * 
 * @return void
 * @author costmo
 * @since  20180913
 */
void startSoftAP()
{
  String mac = WiFi.macAddress();
  String macPartOne = mac.substring( 12, 14 );
  String macPartTwo = mac.substring( 15 );
  ssid = ssidPrefix + macPartOne + macPartTwo; // "printerx-" followed by the last 4 characters of the device MAC address

  WiFi.mode( WIFI_AP );
  WiFi.softAPConfig( WiFi.softAPIP(), WiFi.softAPIP(), IPAddress( 255, 255, 255, 0 ) );
  WiFi.softAP( ssid.c_str() );
  dnsServer.start( DNS_PORT, "*", WiFi.softAPIP() );
  
  softIP = WiFi.softAPIP().toString();
  
  Serial.println( getSoftAPStatus() );
}


/**
 * Define the endpoints for a tiny API server for receiving and handling requests and start the web server
 * 
 * @return void
 * @author costmo
 * @since  20180902
 */
void startWebServer()
{
  server.on( "/", handleConnect );
  server.on( "/connect", handleConnect );
  server.onNotFound( handleRoot );
  server.begin();

  server_443.on( "/", handleRoot );
  server_443.on( "/connect", handleConnect );
  server_443.onNotFound( handleRoot );
  server_443.begin();

  server_80.on( "/", handleRoot );
  server_80.on( "/connect", handleConnect );
  server_80.onNotFound( handleRoot );
  server_80.begin();
}

/**
 * Gets the SSIS and IP address of the local access point
 * 
 * @return String
 * @author costmo
 * @since  20180913
 */
String getSoftAPStatus()
{
  String returnValue = "\n";
  returnValue += "SSID: " + ssid + "\n";
  returnValue += "IP  : " + softIP + "\n";

  return returnValue;
}

/**
 * HTML form for connecting to a WiFi network
 * 
 * @return const String
 * @author costmo
 * @since  20180913
 */
const String connectionHtml()
{
  const String returnValue =
    "<!DOCTYPE HTML>"
    "<html>"
    "<head>"
    "<meta name = \"viewport\" content = \"width = device-width, initial-scale = 1.0, maximum-scale = 1.0, user-scalable=0\">"
    "<title>Connect to WiFi</title>"
    "<style>"
    "body { background-color: #D3E3F1; font-family: \"Open Sans\", sans-serif; Color: #000000; }"
    "#header { width: 100%; text-align: center; }"
    "input[type=text], input[type=password] { width: 50%; height: 30px; padding-left: 10px; }"
    "</style>"
    "</head>"
    "<body>"
    "<div id='header'><h3>Connect to your WiFi network</h3></div>"
    "<div id='content'><p>To get printerX connected to your WiFi network,<br/>please provide your credentials below.</p></div>"
    "<FORM action=\"/connect\" method=\"post\">"
    "<P>"
    "<p><INPUT type=\"text\" name=\"ssid\" placeholder=\"SSID\" autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\"></p>"
    "<p><INPUT type=\"password\" name=\"password\" placeholder=\"Password\" autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\"></p>"
    "<p><INPUT type=\"submit\" value=\"CONNECT\"></p>"
    "</P>"
    "</FORM>"
    "<P>"
    "<FORM action=\"/disconnect\" method=\"post\">"
    "<INPUT type=\"submit\" value=\"RESET TO DEFAULT\">"
    "</FORM>"
    "</P>"
    "</body>"
    "</html>";

  return returnValue;
}
