# Radiance

![alt text](https://img.shields.io/badge/build-passing-brightgreen) ![alt text](https://img.shields.io/badge/platform-android%20%7C%20ios-lightgrey) ![GitHub language count](https://img.shields.io/github/languages/count/pranjal-joshi/Radiance) ![GitHub](https://img.shields.io/github/license/pranjal-joshi/Radiance)

### Quick Links

<a href="https://play.google.com/store/apps/details?id=com.cyberfox.radiance"><img src="https://steverichey.github.io/google-play-badge-svg/img/en_get.svg" width="150"></a>

### What is Radiance?

<img src="https://raw.githubusercontent.com/pranjal-joshi/Radiance/app-radiance/Tutorial-Images/radiance.jpg" width="300">

Radiance is an IoT based smart ambient lamp. It consist of an **ESP8266 (NodeMCU)** microcontroller and a PIR sensor tied to it to detect the motion in the room. This controller drives a 5V DC LED rice-light strip. To create an aureate ambience, these rice-lights can be kept inside a bottle and then it can hanged to the ceiling or a window!

You know that sky is the limit when it comes your creativity! :smile:

### How does it work?

1. ESP8266 (NodeMCU) connects to your WiFi.
2. It connects to a Blynk-IoT server.
3. Smartphone App, Website or even through voice commands (Google assistance) can be used to control the lamp.
4. With PIR sensor, the lamp is smart enough to sense the motion and switch itself ON and OFF! :sunglasses:

### Built with

This project is developed using following frameworks/technologies/plugins/add-ons.
- **[Blynk IoT](https://blynk.io/)**
- **[Flutter](https://flutter.dev/)**
- **[Arduino](https://arduino.cc/)**


## Wire it up

### Before you begin

Are you new to Arduino/NodeMCU or you don't know how to add NodeMCU board to arduino IDE? :confused:

Don't worry, Its really simple if you checkout this **[link](https://randomnerdtutorials.com/how-to-install-esp8266-board-arduino-ide/)** and follow the steps given there! :thumbsup:

### Setting up the Pin Configuration

<img src="http://www.martyncurrey.com/wp-content/uploads/2017/06/nodemcudevkit_v1-0_PinMap_1200.jpg" alt="NodeMCU-Arduino Pin Mapping" width="400">

The pin configuration that I have used for this project is given in **[this](https://github.com/pranjal-joshi/Radiance/blob/app-radiance/Radiance-IoT/Radiance.ino)** file.
The hardware configuration can be changed by changing the following values.
```
#define D_OUT        5
#define PIR          4
#define LED_MOTION   16
#define LED_BUILTIN  2
```
**Note**:
- The pin numbers used above are **GPIO pins** as per the given pinout diagram and **not the digital pins** printed on the board.

### Configuring the IoT Cloud

1. Download **[Blynk](https://blynk.io/)** App from Google Play (Android) or App Store (iOS).
2. Create a new project - Choose **NodeMCU** as a hardware model and **WiFi** as a connection type.
3. As soon as you setup the project, you will receive an email containing an **Authorization Token** from Blynk.
4. Copy this **Auth Token** and paste it into **creds.h** file. Also, add your Wi-Fi SSID and password so that NodeMCU will be able to connect to your network.
```
// Filename: creds.h
char auth[] = "YOUR_BLYNK_TOKEN";
char ssid[] = "WIFI_SSID_NAME";
char pass[] = "WIFI_PASSWORD";
```
(This token is your private key to access your hardware. Anyone who's having this token have a full access of your IoT device so make sure not to release this file into a public source control like GitHub!)

5. Feel free to tinker and play with your Blynk app. Try to make a few UIs, explore various widgets. Remember, for development and testing, we will use Blynk app but once you finalized your project architecture, you can create your own standalone & custom app (we'll cover that here as well!)

This is the UI that I have made in my blynk app while developing the project.

<img src="https://raw.githubusercontent.com/pranjal-joshi/Radiance/app-radiance/Tutorial-Images/Screenshot_2019-12-25-14-03-47-439_cc.blynk.jpg" width="250">

You can **Scan this QR code from the Blynk app** to get a copy of this layout.

<img src="https://raw.githubusercontent.com/pranjal-joshi/Radiance/app-radiance/Tutorial-Images/blynk_QR.png" width="200">

**Note:** If you made any changes into Virtual Pin configuration while flashing the code into the NodeMCU, make sure that same changes should be made into Blynk app to connect the respective widget to the appropriate V-pin.
```
// Default V-Pin configuration
// filname: Radiance.ino
#define V_LED       V0
#define V_MOTION    V1
#define V_CONTROL   V2
#define V_TIMEOUT   V3
#define V_STATUS    V4
#define V_RESET     V5
#define V_ALARM     V6
#define V_OTA       V7
```

### Integration with Google Assistance

Well, Rather than explaining everything here from the scratch, you can follow **[this tutorial (Step-5)](https://codeometry.in/home-automation-using-nodemcu-and-google-assistant/)** to integrate your Blynk project with Google Assistance using webhooks.

Thanks to **[codeometry.in](https://codeometry.in)** for their awesome tutorial! :clap:

## Creating a custom Application

### Setting up the environment

In 2019 ,As compared to Android-Java and Swift, **[Flutter](https://flutter.dev/)** is a new framework.

Here are some helpful links to setup & release your own app using flutter.
- **[Installation](https://flutter.dev/docs/get-started/install)**
- **[Release (Android)](https://flutter.dev/docs/deployment/android)**
- **[Release (iOS)](https://flutter.dev/docs/deployment/ios)**

Flutter uses the dart language for application development. You can find the source code in the following directory path
`Radiance-App/radiance_flutter/`

### App Screenshots - UI and Features

<img src="https://raw.githubusercontent.com/pranjal-joshi/Radiance/app-radiance/Radiance-App/Screenshots/Screenshots/combined.jpg" width="800">

### App Download

<a href="https://play.google.com/store/apps/details?id=com.cyberfox.radiance"><img src="https://steverichey.github.io/google-play-badge-svg/img/en_get.svg" width="150"></a>

### Contributing
Any contributions you make are highly appreciated

1. Fork the Project.
2. Create your own Branch.
3. Commit your changes.
4. Push to your Branch.
5. Open a Pull Request.

### Author
- Pranjal Joshi - <joshi.pranjal5@gmail.com>

### License
This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/pranjal-joshi/Radiance/blob/master/LICENSE) file for details.

The images used in this project may subjected to the copyright.
