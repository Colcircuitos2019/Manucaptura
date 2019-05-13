#include <ESP8266WiFi.h>

WiFiServer server(80); //Initialize the server on Port 80

String trama_ok = "";


void setup() {

  WiFi.mode(WIFI_AP); //Our ESP8266-12E is an AccessPoint
  WiFi.softAP("PruebaDesarrollo", "colcircuitos123"); // Provide the (SSID, password); .
  server.begin(); // Start the HTTP Server

  Serial.begin(115200); //Start communication between the ESP8266-12E and the monitor window
  IPAddress HTTPS_ServerIP = WiFi.softAPIP(); // Obtain the IP of the Server
  Serial.print("Server IP is: "); // Print the IP to the monitor window
  Serial.println(HTTPS_ServerIP);

}

void loop() {

  WiFiClient client = server.available();
  
  if (!client) {
    return;
  }
  
  String request = client.readStringUntil('\r');
  trama_ok = request.substring(5, request.indexOf(" HTTP/"));  
//Serial.println(request);
  Serial.println(trama_ok);
  // print your WiFi shield's IP address:
//  Serial.print("IP Address: ");
//  Serial.println(WiFi.localIP());


}
