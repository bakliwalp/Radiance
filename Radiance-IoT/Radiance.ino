
#include <Blynk.h>
#include <ArduinoJson.h>
#include <BlynkSimpleEsp8266.h>
#include <ESP8266WiFi.h>
#include <WidgetRTC.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

#define D_OUT        5
#define PIR          4
#define LED_MOTION   16
#define LED_BUILTIN  2

#define V_LED       V0
#define V_MOTION    V1
#define V_CONTROL   V2
#define V_TIMEOUT   V3
#define V_STATUS    V4
#define V_RESET     V5
#define V_ALARM     V6
#define V_OTA       V7

#define SUNSET      18
#define SUNRISE     7
#define MOTION_POLL 300L
#define FADE_DLY  1500
#define REBOOT_INTERVAL 1*60*1000L
#define OTA_INTERVAL  1000*60*3

#define BLYNK_PRINT     Serial
#define BLYNK_SERVER    IPAddress(35,200,226,184)
#define BLYNK_PORT      8080

WidgetLED led(V_LED);
WidgetRTC blynkRtc;
BlynkTimer t;

bool isNotified = false;
bool otaFlag = false;
bool setByMotion = false;
int motionTimerId = 999;
bool motionFlag = true;
bool alarmFlag = false;
bool isMotion = false;
bool isSensed = false;
int lastAnalogWrite;
long motionTimeout = 1000*60*1;

char auth[] = "tMejVGQgCMiN5REr2kp4HNkd0IH4BNba";
char ssid[] = "The EVIL GENIUS";
char pass[] = "samadhan118017";

void setup() {
  Serial.begin(9600);
  pinMode(D_OUT, OUTPUT);
  pinMode(PIR, INPUT);
  pinMode(LED_MOTION, OUTPUT);
  digitalWrite(LED_MOTION, HIGH);
  pinMode(LED_BUILTIN, OUTPUT);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, pass);
  Serial.print("Connecting to ");
  Serial.println(ssid);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    blinkLed();
  }
  Blynk.config(auth);       // Connect to default server
  //Blynk.config(auth, BLYNK_SERVER, BLYNK_PORT);
  //attachInterrupt(digitalPinToInterrupt(PIR), motionISR, CHANGE);
  t.setInterval(MOTION_POLL, motionISR);
  ArduinoOTA.setHostname("Radiance");
  ArduinoOTA.begin();
}

void loop() {
  Blynk.run();
  t.run();
  while(!Blynk.connected()) {
    Blynk.connect();
  }
  ArduinoOTA.handle();
}

BLYNK_CONNECTED() {
  blynkRtc.begin();
  setSyncInterval(10*60);
  Serial.println("Connected to Blynk Server on " + String(hour()) + ":" + String(minute()));
  Blynk.syncAll();
}

BLYNK_WRITE(V_MOTION) {
  switch(param.asInt()) {
    case 1:
      motionFlag = true;
      motionTimerId = t.setTimeout(motionTimeout, motionTimeoutISR);
      t.setTimeout(1000*10L, delayedSetByMotion);
      break;
    case 2:
      motionFlag = false;
      t.deleteTimer(motionTimerId);
      break;
  }
  Serial.print("motionFlag = ");
  Serial.println(motionFlag);
}

void delayedSetByMotion() {
  setByMotion = true;
}

BLYNK_WRITE(V_CONTROL) {
  int val = param.asInt();
  int mappedVal = map(val,0, 100, 0, 1023);
  if(motionFlag) {
    setByMotion = true;
    t.deleteTimer(motionTimerId);
    motionTimerId = t.setTimeout(motionTimeout, motionTimeoutISR);
  }
  /*if(setByMotion) {
    Blynk.virtualWrite(V_MOTION, 2);
    motionFlag = false;
  }
  setByMotion = false;
  */
  if(mappedVal >= lastAnalogWrite) {
    for(int i=lastAnalogWrite;i<=mappedVal;i++) {
      analogWrite(D_OUT, i);
      delayMicroseconds(FADE_DLY);
    }
  }
  else {
    for(int i=lastAnalogWrite;i>=mappedVal;i--) {
      analogWrite(D_OUT, i);
      delayMicroseconds(FADE_DLY);
    }
  }
  lastAnalogWrite = mappedVal;
  Blynk.virtualWrite(V_STATUS, val);
  Blynk.virtualWrite(V_LED, map(val,0, 100, 0, 255));
}

BLYNK_WRITE(V_TIMEOUT) {
  int val = param.asInt();
  motionTimeout = (1000*60*val);
  t.deleteTimer(motionTimerId);
  motionTimerId = t.setTimeout(motionTimeout, motionTimeoutISR);
  Serial.print("motionTimeout = ");
  Serial.println(motionTimeout);
}

BLYNK_WRITE(V_RESET) {
  int val = param.asInt();
  if(val) {
    reboot();
  }
}

BLYNK_WRITE(V_ALARM) {
  switch(param.asInt()) {
    case 1:
      alarmFlag = true;
      break;
    case 2:
      alarmFlag = false;
      break;
  }
  Serial.print("alarmFlag = ");
  Serial.println(alarmFlag);
}

BLYNK_WRITE(V_OTA) {
  switch(param.asInt()) {
    case 0:
      otaFlag = false;
      break;
    case 1:
      otaFlag = true;
      break;
  }
  Serial.print("otaFlag = ");
  Serial.println(otaFlag);
}

void motionISR() {
  Serial.println(String(hour()) + ":" + String(minute()));
  if(digitalRead(PIR) && alarmFlag && !isNotified) {
    Blynk.notify("Motion Detected - " + String(hour()) + ":" + String(minute()));
    Serial.println("Motion Detected - " + String(hour()) + ":" + String(minute()));
    isNotified = true;
  }
  if(motionFlag && ((hour() >= SUNSET) || (hour() <= SUNRISE))) {
  //if(1) {
    Serial.println(isMotion);
    digitalWrite(LED_MOTION, isMotion);
    if(digitalRead(PIR)) {
      isMotion = true;
      if(!setByMotion) {
        smoothGlow(lastAnalogWrite); 
      }
      setByMotion = true;
      Serial.println("Deleted timerID:\t"+String(motionTimerId));
      t.deleteTimer(motionTimerId);
      motionTimerId = t.setTimeout(motionTimeout, motionTimeoutISR);
      Serial.println("New timerID:\t"+String(motionTimerId));
    }
    else {
      isMotion = false;
      isNotified = false;
    }
    isSensed = true;
  }
  else {
    isMotion = false;
    isSensed = false;
  }
}

void motionTimeoutISR() {
  Serial.println("Timeout..");
  Serial.print("setByMotion:\t");
  Serial.println(setByMotion);
  if(setByMotion) {
    smoothFade();
    setByMotion = false;
  }
}

void smoothGlow(int val) {
  for(int i=0;i<=val;i++) {
    analogWrite(D_OUT, i);
    delayMicroseconds(FADE_DLY);
  }
  Blynk.virtualWrite(V_STATUS, map(val,0,1023,0,100));
}

void smoothFade() {
  for(int i=lastAnalogWrite;i>=0;i--) {
    analogWrite(D_OUT, i);
    delayMicroseconds(FADE_DLY);
  }
  Blynk.virtualWrite(V_STATUS, 0);
}

void blinkLed() {
  digitalWrite(LED_BUILTIN, LOW);
  delay(10);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(200);
}

void reboot() {
  Serial.println("User Reset Requested.");
  ESP.reset();
}
