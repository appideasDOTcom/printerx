#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ESP8266WebServer.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>
#include <EEPROM.h>
#include <DNSServer.h>

/**
 * A sketch to open a Wireless Access Point from within printerX's case using
 *    an ESP8266-12E
 * 
 * @author costmo
 * @since  20180902
 */

// Setup a wireless access point so the user can be prompted to connect to a network
String  ssidPrefix = "printerx-beta-";
int serverPort = 5050;
String ssid = "";
String softIP  = "";
const byte DNS_PORT = 53;

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
  Serial.begin( 57600 );
  delay( 100 );

  startSoftAP();
  startWebServer();
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
  // Listen for API requests
  server.handleClient();
  server_443.handleClient();
  server_80.handleClient();
  
  // Redirect users to the login portal
  dnsServer.processNextRequest();
  delay( 1000 );
}

/**
 * Handler for requests to "/"
 * 
 * This should only provide the interface for logging into a network or show a "you are already connected" message
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
      returnValue = server_443.arg( "ssid" );
    }
    if( returnValue.length() < 1 ) {
      returnValue = server_80.arg( "ssid" );
    }

    return returnValue;
}

void handleConnect()
{
  String hardSSID = postValue( "ssid" );
  String hardPassword = postValue( "password" );

  // TODO: Set parameters on the pi to connect to WiFi, reboot the pi, then show the user a "success" message

  const String html =
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
    "<p>The printerX web server will now restart to connect to the WiFi network named <strong>" + hardSSID + "</strong></p>"
    "<p>You should be able to access your printer in a web browser at <a href='http://printerx.local/'>http://printerx.local/</a> in about 30 seconds.</p>"
    "<p>If your printer fails to connect to your network, <a href='/'>click here</a> to try again.</p>"
    "<p>If you're done, CANCEL this screen and reconnect to your network.</p>"
    "</body>"
    "</html>";
  
  server.send( 200, "text/html", html );
  server_443.send( 200, "text/html", html );
  server_80.send( 200, "text/html", html );
  
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
//  dnsServer.start( DNS_PORT, "printerx.local", IPAddress( 192, 168, 4, 99 ) );
  
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
    "<!-- <P>"
    "<FORM action=\"/disconnect\" method=\"post\">"
    "<INPUT type=\"submit\" value=\"RESET\">"
    "</FORM>"
    "</P> -->"
    "</body>"
    "</html>";

  return returnValue;
}

/**
 * Attempt to redirect users after successful attempt to connect to a WiFi network
 * 
 * This doesn't currently work since the user is disconnected from the ESP prior to this being an option to be offered
 * 
 * @return String
 * @author costmo
 * @since  20180902
 */
String redirect( String newIP )
{
  String returnValue =
    "<!DOCTYPE HTML>"
    "<html>"
    "<head>"
    "<script type=\"text/javascript\">"
    " window.location = \"http://" + newIP + "/\""
    "</script>"
    "</head>"
    "<body>"
    "</body>"
    "</html>";

  return returnValue;
}
