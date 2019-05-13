#include <ESP8266HTTPClient.h>
#include <ESP8266WiFi.h>
String trama_ok ="";
// Replace with your network credentials
const char* ssid     = "MANUFACTURA";// ANALISTA01 2668 MANUFACTURA
const char* password = "ColcircuitosZ298";// n;52061J ColcircuitosZ298
static int estado_lectura = 0;
String DataPuertoSerial="", mensaje="";
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

  /*
  estado_lectura
  P&-1 = Estado de lectura del puerto serial activado.
  P&-0 = Estado de lectura del puerto serial desactivado o no hay conexion con el servidor.
  */
  // put your main code here, to run repeatedly:
  WiFiClient client = server.available();   // Listen for incoming clients

  // ...

  if(Serial.available() > 0){
    
    //Serial.print(Serial.available());
    DataPuertoSerial = Serial.readStringUntil('\n');
    Serial.print(DataPuertoSerial);

    if(DataPuertoSerial.equals("P&-0")){

      estado_lectura = 0;
      
    }else{
      
      if(DataPuertoSerial.equals("P&-1")){

        estado_lectura = 1;
      
      }
      
    }
    
  }
      
  //...
  
  if (client) {  // If a new client connects,
             
    request = client.readStringUntil('\r');
    trama_ok = request.substring(5, request.indexOf(" HTTP/"));

      switch(estado_lectura){
        case 0:
          mensaje = "Alerta!!!;No se pudo procesar la información.";
          break;
        case 1:
          mensaje = "Envío Exitoso!;Se pudo procesar el dato.";
          Serial.println(trama_ok);
          break;  
        //case 2:
          //mensaje = "No hay conexión con el servidor.";  //Dato que va a retornar a la aplicacion movil "APP manucaptura" 
         //break;
      }
        
      //Response the server
      client.println("HTTP/1.1 200 OK");
      client.println("Content-Type: text/plain");
      client.println(""); // Comillas importantes.
      client.println(mensaje);
    
   }
    
  if (WiFi.status() != WL_CONNECTED) {
    
    setup();
    
  }
  //else{
  // FE y TE -> 192.168.1.101
  // EN -> 192.168.0.101
    //if(!WiFi.localIP().equals("192.168.1.101")){ // La dirección IP del modulo
      //setup();
    //}
    
  //}
}
