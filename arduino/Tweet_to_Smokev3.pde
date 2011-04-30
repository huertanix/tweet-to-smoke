/*
  Tweet_to_Smoke
  
  Incorporates coding samples from both:
  Web client
  and
  Morse
 
 This sketch connects to a website (http://www.google.com)
 using an Arduino Wiznet Ethernet shield. 
 
 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 
 Based on Arduino Wiznet Ethernet shield example created 18 Dec 2009
 by David A. Mellis

 Hacked heavily by Will Bradley, Jeremy Leung, and David Huerta
 
 */

#include <SPI.h>
#include <Ethernet.h>
#include "pitches.h"

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 172,16,0,59 };
byte gateway[] = { 172, 16, 0, 1 }; // Gangplank
byte subnet[] = { 255, 255, 252, 0 };
//byte ip[] = { 10,0,1,59 };
//byte gateway[] = { 10, 0, 1, 1 }; // Bradley-Rosenthal Terran base
//byte subnet[] = { 255, 255, 255, 0 };
byte server[] = { 50, 56, 124, 136 }; // Zyphon Web Server

// Define LED and Buzzer Pins
int led = 13;                   // LED connected to digital pin 13
int buzzer = 7;                // buzzer connected to digital pin 12
int unit = 500;                  // duration of a pulse

// Morsecode array
char* morsecode[] = {
    "-----",   // 0
    ".----",   // 1
    "..---",   // 2
    "...--",   // 3
    "....-",   // 4
    ".....",   // 5
    "-....",   // 6 
    "--...",   // 7
    "---..",   // 8
    "----.",   // 9
    "---...",  // :
    "-.-.-.",  // ;
    "",        // < (there's no morse for this symbol)
    "-...-",   // =
    "",        // > (there's no morse for this symbol)
    "..--..",  // ?
    ".--._.",  // @
    ".-",      // A
    "-...",    // B
    "-.-.",    // C
    "-..",     // D
    ".",       // E
    "..-.",    // F
    "--.",     // G
    "....",    // H
    "..",      // I
    ".---",    // J
    "-.-",     // K
    ".-..",    // L
    "--",      // M
    "-.",      // N
    "---",     // O
    ".--.",    // P
    "--.-",    // Q
    ".-.",     // R
    "...",     // S
    "-",       // T
    "..-",     // U
    "...-",    // V
    ".--",     // W
    "-..-",    // X
    "-.--",    // Y
    "--.."     // Z
    "",        // [ (there's no morse for this symbol)
    "",        // ^ (there's no morse for this symbol)
    "..__._",  // _ 
    "",        // ` (there's no morse for this symbol)
    ".-",      // a
    "-...",    // b
    "-.-.",    // c
    "-..",     // d
    ".",       // e
    "..-.",    // f
    "--.",     // g
    "....",    // h
    "..",      // i
    ".---",    // j
    "-.-",     // k
    ".-..",    // l
    "--",      // m
    "-.",      // n
    "---",     // o
    ".--.",    // p
    "--.-",    // q
    ".-.",     // r
    "...",     // s
    "-",       // t
    "..-",     // u
    "...-",    // v
    ".--",     // w
    "-..-",    // x
    "-.--",    // y
    "--.."     // z
    
};


// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
Client client(server, 80);

// variables used during the loop
String httpresponse = "";
char buffer[240];

void setup() {
  // start the serial library:
  Serial.begin(9600);
  
  Serial.println("beep");
  tone(buzzer, 500, 500);
  delay(1000);
  tone(buzzer, 500, 500);
  delay(1000);
  
  // start the Ethernet connection:
  Ethernet.begin(mac, ip, gateway, subnet);
  
  //delay(30000);
  // define pins as output
  pinMode(led, OUTPUT);
  pinMode(buzzer, OUTPUT);
}

void say_morse_word(char* msg){
  int index = 0;
  while(msg[index]!='\0'){
    // say a dash
    if(msg[index]=='-'){
      dash();
    }
    // say a dot
    if(msg[index]=='.'){
      dot();
    }
    // gap beetween simbols
    intragap();
    index++;
  }
}
 
// beep
void beep(int time){
  
  digitalWrite(led, HIGH);
  tone(buzzer, 100, time);
  digitalWrite(led, LOW);
  delay(time);
}
 
// silence
void silence(int time){
  digitalWrite(led, LOW);
  delay(time);
}
 
// general procedure for .
void dot() {
  beep(unit);
}
 
// general procedure for -
void dash() {
  beep(unit*3);
}
 
// gap between dots and dashes
void intragap() {
  silence(unit);
}
 
// gap between letters
void shortgap() {
  silence(3*unit);
}
 
// gap be  tween words
void mediumgap() {
  silence(7*unit);
}
 
void say_char(char letter){
  if((letter>='0')&&(letter<='z')&&(letter!='<')&&(letter!='>')&&(letter!='[')&&(letter!='^')&&(letter!='`')){
    Serial.print(morsecode[letter-'0']);
    Serial.print(' ');
    say_morse_word(morsecode[letter-'0']);
    shortgap();
  } else {
    if(letter==' '){
      Serial.print(" \\ ");
      mediumgap();
    }else{
      Serial.print("X");
    }
  }
}

// say an entire string of characters
void say_string(String asciimsg){
  int index = 0;
  char charac;
  charac = asciimsg[index];
  while(charac!='\0'){
    say_char(charac);
    Serial.println(charac);
    charac = asciimsg[++index];
    shortgap();
  }
}

void loop()
{
  Serial.println("loop");
  
  
  // Our array that will hold the http header and tweet message
  
  
  // give the Ethernet shield a second to initialize.  We put in 30 seconds
  // for the Gangplank network:

  Serial.println("connecting...");

  // if you get a connection, report back via serial:
  if (client.connect()) {
    Serial.println("connected");
    // Make a HTTP request:
    client.println("GET /~huertanix/cgi-bin/replies.cgi HTTP/1.0");
    client.println();
  } 
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
  }
  

  // if there are incoming bytes available 
  // from the server, read them and print them:
  while (client.available()) {
    Serial.print(".");
    httpresponse += (char)client.read();
  }
  
  if(httpresponse.length()>0) { 
    Serial.println("Response: ");
    int c = httpresponse.indexOf('$');
    
    //httpresponse.substring(c+1).toCharArray(buffer, 240);
    Serial.println(httpresponse.substring(c+1));
    say_string(httpresponse.substring(c+1)); 
    
    httpresponse = "";
    //memset(buffer, 0, 240);
    Serial.println("End Response");
  }

  
  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting?");
    client.stop();

    // do nothing forevermore:
   // for(;;)
     // ;
  }
  
}

