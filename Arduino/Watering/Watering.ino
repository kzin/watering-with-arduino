#include <Parse.h>
#include <Bridge.h>
#include <Process.h>

int pin2=2; // bomba de agua
int pin4=13; // led do reservatorio vazio
int pin5=5; // alimentacao sensor vaso
int pin6=6; // alimentacao sensor reservatorio

int limiteUmidade = 300; // limite do sensor do vaso
int limiteReservatorio = 350; // limite do reservatorio de agua

const int LM35 = A5; // Pino Analogico onde vai ser ligado ao pino 2 do LM35
const int BUFFER_SIZE = 1000; //Quantidade de vezes que vai ler para cria a média
const float CELSIUS_BASE = 0.4887585532746823069403714565; //Base de conversão para Graus Celsius ((5/1023) * 100)

bool acionado = false, push = false, debug = false;
const String path = "/mnt/sda1/";

void setup() {
  // put your setup code here, to run once:
  pinMode(pin2,OUTPUT);
  pinMode(pin4,OUTPUT);
  pinMode(pin5,OUTPUT);
  pinMode(pin6,OUTPUT);
  pinMode(LM35, INPUT);
   
  // Initialize Bridge
  Bridge.begin();
   
  // Initialize Serial
  if(debug) {
    Serial.begin(9600);
  
    while (!Serial); // wait for a serial connection
    Serial.println("Parse Starter Project");
  }
  
  // Initialize Parse
  Parse.begin("", "");
}

void loop() {
  // put your main code here, to run repeatedly:
  if (lerSensorReservatorio() < limiteReservatorio) {
    ligarLedReservatorio();
    enviarPush();
  }

  while (lerSensorReservatorio() < limiteReservatorio) {
    // depois de tudo funcionando, mudar para 1h 3600000
    delay(5000);
  }
  
  if(lerSensorVaso() < limiteUmidade) {
    ligarBomba();
    ligarLedReservatorio();
    acionado = true;
  }

  while(lerSensorVaso() < limiteUmidade && lerSensorReservatorio() > limiteReservatorio) {
    delay(1000);
  }

  delay(1000);
  desligarBomba();
  desligarLedReservatorio(); 

  if(acionado){
    saveData();
    acionado = false;
  }

  delay(1000);
}

void enviarPush(){
  if(push) {
    if(debug)
      Serial.println("Enviando push");
    ParseCloudFunction cloudFunction;
    cloudFunction.setFunctionName("send");
    ParseResponse response = cloudFunction.send(); 

    if(debug) {
      Serial.println("Response for saving a TestObject:");
      Serial.print(response.getJSONBody());
    }
    response.close(); // Do not forget to free the resource 
    push = true;
  }
}

int lerSensorVaso() {
  //Serial.println("ler sensor vaso");
  ligarSensores();
  delay(10);
  return analogRead(A0);
  desligarSensores();
}

int lerSensorReservatorio() {
  //Serial.println("ler sensor reservatorio");
  ligarSensores();
  delay(10);
  return analogRead(A1);
  desligarSensores();
}

void ligarLedReservatorio() {
  //Serial.println("Ligar LED");
  push = true;
  digitalWrite(pin4,HIGH);
}

void desligarLedReservatorio() {
  push = false;
  digitalWrite(pin4,LOW);
}

void ligarBomba() {
  if(debug)
    Serial.println("Ligar bomba");
  digitalWrite(pin2,HIGH);
}

float lerTemperatura(){
  float buffer = 0;
  for (int i = 0; i < BUFFER_SIZE; i++){
      buffer += analogRead(LM35);
  }
  return ((buffer/BUFFER_SIZE) * CELSIUS_BASE);
}

void desligarBomba() {
  if(debug)
    Serial.println("Desligar bomba");
  digitalWrite(pin2,LOW);
}

void ligarSensores() {
  digitalWrite(pin5,HIGH);
  digitalWrite(pin6,HIGH);
}

void desligarSensores() {
  digitalWrite(pin5,LOW);
  digitalWrite(pin6,LOW);
}

void saveData() { 
  
  String filepath = takePicture();

  ParseObjectCreate create;
  create.setClassName("Record");
  create.add("temperature", lerTemperatura());

  if(debug)
    Serial.println("Uploading photo");
  
  Process upload;
  upload.begin("curl");  // Process that launch the "curl" command
  upload.addParameter("-X");
  upload.addParameter("POST");
  upload.addParameter("-H");
  upload.addParameter("X-Parse-Application-Id: ");
  upload.addParameter("-H");
  upload.addParameter("X-Parse-REST-API-Key: ");
  upload.addParameter("-H");
  upload.addParameter("Content-Type: image/jpeg");
  upload.addParameter("--data-binary");
  upload.addParameter("@"+filepath);
  upload.addParameter("https://api.parse.com/1/files/picture.jpg"); 
  upload.run();    // Run the process and wait for its termination
  
  while (upload.available() > 0) {
    
    String name = upload.readStringUntil(':');
    name.replace("{","");
    name.replace("}","");
    name.replace("\"","");
    name.trim();
    
    String value = upload.readStringUntil(',');
    value.replace("{","");
    value.replace("}","");
    value.replace("\"","");
    value.trim();

    create.add(name.c_str(), value.c_str());
  }

  Process del;
  del.begin("rm");
  del.addParameter(path);
  del.run();

  if(debug)
    Serial.println("Saving data");

  ParseResponse response = create.send();

  if(debug) {
    Serial.println("Response for saving a TestObject:");
    Serial.print(response.getJSONBody());
  }
  
  if (!response.getErrorCode()) {
     String objectId = response.getString("objectId");

     if(debug) {
      Serial.print("Test object id:");
      Serial.println(objectId);
     }
  } else {
     if(debug)
      Serial.println("Failed to save the object");
  }
  response.close(); // Do not forget to free the resource
}

String takePicture() {
  if(debug)
    Serial.println("Taking photo");
    
  Process picture;
  
  String filename = "";
  picture.runShellCommand("date +%s");
  while (picture.running());

  while (picture.available() > 0) {
    char c = picture.read();
    filename += c;
  }
  
  filename.trim();
  filename += ".png";

  picture.runShellCommand("fswebcam " + path + filename + " -r 960x720");
  while (picture.running());
  
  return path + filename;
}
