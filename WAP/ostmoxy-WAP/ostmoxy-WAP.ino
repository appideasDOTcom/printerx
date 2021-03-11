#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ESP8266WebServer.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>
#include <EEPROM.h>
#include <ArduinoOTA.h>

/**
 * A sketch to open a Wireless Access Point from within printerX's case using
 *    an ESP8266-12E
 * 
 * @author costmo
 * @since  20180902
 */

// Setup a wireless access point so the user can be prompted to connect to a network
String  ssidPrefix = "printerx-";
int serverPort = 5050;
String ssid = "";
String softIP  = "";

IPAddress ip;
ESP8266WebServer server( serverPort );


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

  // initOta();
  // Listen for OTA updates
  ArduinoOTA.handle();
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
  delay( 100 );
}

void handleConnect()
{
  //String hardSSID = server.arg( "ssid" );
  //String hardPassword = server.arg( "password" );
  server.send( 200, "text/html", "YOU ARE CONNECTED" );
  Serial.println( "Connected to WiFi" );
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
  
  WiFi.softAP( ssid.c_str() );
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
  server.on( "/", handleRoot );
  server.on( "/connect", handleConnect );
  server.begin();
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
    "<link href='https://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>"
    "<style>"
    "body { background-color: #D3E3F1; font-family: \"Open Sans\", sans-serif; Color: #000000; }"
    "#header { width: 100%; text-align: center; }"
    "input[type=text], input[type=password] { width: 50%; height: 30px; padding-left: 10px; }"
    "</style>"
    "</head>"
    "<body>"
    "<div id='header'><h3>Connect to your WiFi network</h3></div>"
    "<FORM action=\"/connect\" method=\"post\">"
    "<P>"
    "<p><INPUT type=\"text\" name=\"ssid\" placeholder=\"SSID\" autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\"></p>"
    "<p><INPUT type=\"password\" name=\"password\" placeholder=\"Password\" autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\"></p>"
    "<p><INPUT type=\"text\" name=\"timezone\" placeholder=\"Timezone Offset (e.g. -8)\" autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\"></p><br>"
    "<p><INPUT type=\"submit\" value=\"CONNECT\"></p>"
    "</P>"
    "</FORM>"
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

// Requires connection to an established wifi network
//void initOta()
//{
//  ArduinoOTA.onStart( []() 
//  {
//    String type;
//    if( ArduinoOTA.getCommand() == U_FLASH )
//    {
//      type = "sketch";
//    }
//    else // U_SPIFFS
//    {
//      type = "filesystem";
//    }
//
//    // NOTE: if updating SPIFFS this would be the place to unmount SPIFFS using SPIFFS.end()
//    Serial.println( "Start updating " + type );
//  });
//  
//  ArduinoOTA.onEnd( []() 
//  {
//    Serial.println( "\nEnd" );
//  });
//  
//  ArduinoOTA.onProgress( [](unsigned int progress, unsigned int total ) 
//  {
//    Serial.printf( "Progress: %u%%\r", (progress / (total / 100)) );
//  });
//  
//  ArduinoOTA.onError( []( ota_error_t error ) 
//  {
//    Serial.printf( "Error[%u]: ", error );
//    if( error == OTA_AUTH_ERROR) { Serial.println( "Auth Failed" ); }
//    else if(error == OTA_BEGIN_ERROR) { Serial.println("Begin Failed"); }
//    else if(error == OTA_CONNECT_ERROR) { Serial.println("Connect Failed"); }
//    else if(error == OTA_RECEIVE_ERROR) { Serial.println("Receive Failed"); }
//    else if(error == OTA_END_ERROR) { Serial.println("End Failed"); }
//  });
//  ArduinoOTA.begin();
//}
