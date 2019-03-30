#include <ESP8266HTTPClient.h>
#include <ESP8266WiFi.h>
String trama_ok ="";
// Replace with your network credentials
const char* ssid     = "Grupo Invertronica";
const char* password = "WlaN1nV3rTr0N1c4";
String request;

// Set web server port number to 80
WiFiServer server(80);

// Variable to store the HTTP request
String header;

void setup() {

  pinMode(LED_BUILTIN, OUTPUT); 
  Serial.begin(115200);
  // Initialize the output variables as outputs

  // Connect to Wi-Fi network with SSID and password
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    
    Serial.print(".");
      digitalWrite(LED_BUILTIN, LOW);   // Turn the LED on (Note that LOW is the voltage level
    delay(200);                      // Wait for a second
    digitalWrite(LED_BUILTIN, HIGH);  // Turn the LED off by making the voltage HIGH
    delay(200);
    
  }
  // Print local IP address and start web server.
  
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  if (WiFi.status() == WL_CONNECTED){
  digitalWrite(LED_BUILTIN, LOW);
  }
  server.begin();
   
}

void loop() {

  
  // put your main code here, to run repeatedly:
  WiFiClient client = server.available();   // Listen for incoming clients

  if (client) {                             // If a new client connects,
             
    request = client.readStringUntil('\r');
    trama_ok = request.substring(5, request.indexOf(" HTTP/"));

    //Serial.println(request);
    Serial.println(trama_ok);
    //Serial.println("\n");
    //...
    
   HTTPClient http;    //Declare object of class HTTPClient
 
   http.begin("http://192.168.4.173:9090/hello.php?ID=HolaMundo");  //Specify request destination
   http.addHeader("Content-Type", "text/html");  //Specify content-type header
 
   int httpCode = http.POST("Message from ESP8266");   //Send the request
   String payload = http.getString();                  //Get the response payload
 
   //Serial.println(httpCode);   //Print HTTP return code
   //Serial.println(payload);    //Print request response payload
 
   http.end();  //Close connection

    //...
    //Response the server
    client.println("HTTP/1.1 200 OK");
    client.println("Content-Type: text/html");
    client.println("");   // Comillas importantes.
    client.println(payload);  //Dato que va a retornar a la aplicacion movil "APP manucaptura"
  }

  if (WiFi.status() != WL_CONNECTED) {
    setup();
  }
}
