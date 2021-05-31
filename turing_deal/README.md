# turing_deal
Turing deal app

## Screenshots

![price dataframe](https://github.com/ivofernandes/turingDealApp/blob/main/turing_deal/screenshots/bigPicture.jpeg?raw=true)

## Getting Started

This project can be executed like any flutter application just by importing in android studio, flutter pub get and running in a device

Ideas about the arquitecture of the app:

- lib -> All the flutter code
    - data
        - api -> external API calls definition
        - core -> algorithms and computation stuff
            - strategy -> Stuff related with the evaluation of a trading strategy
        - state -> state machine
        - screen -> Widgets to define entire screens of the app
            - bigPictureScreen ->  Screen to have a snapshot of how multiple assets are performing in the market  

#####  Palette URL: http://paletton.com/#uid=32V0u0ksHn-iOuBomrKwbjjHje4
*** Primary color:

   shade 0 = #0E8B34 = rgb( 14,139, 52) = rgba( 14,139, 52,1) = rgb0(0.055,0.545,0.204)
   shade 1 = #4AB46A = rgb( 74,180,106) = rgba( 74,180,106,1) = rgb0(0.29,0.706,0.416)
   shade 2 = #27A34D = rgb( 39,163, 77) = rgba( 39,163, 77,1) = rgb0(0.153,0.639,0.302)
   shade 3 = #007222 = rgb(  0,114, 34) = rgba(  0,114, 34,1) = rgb0(0,0.447,0.133)
   shade 4 = #005319 = rgb(  0, 83, 25) = rgba(  0, 83, 25,1) = rgb0(0,0.325,0.098)

*** Secondary color (1):

   shade 0 = #BC6813 = rgb(188,104, 19) = rgba(188,104, 19,1) = rgb0(0.737,0.408,0.075)
   shade 1 = #F4AD65 = rgb(244,173,101) = rgba(244,173,101,1) = rgb0(0.957,0.678,0.396)
   shade 2 = #DD8A35 = rgb(221,138, 53) = rgba(221,138, 53,1) = rgb0(0.867,0.541,0.208)
   shade 3 = #9A4E00 = rgb(154, 78,  0) = rgba(154, 78,  0,1) = rgb0(0.604,0.306,0)
   shade 4 = #703900 = rgb(112, 57,  0) = rgba(112, 57,  0,1) = rgb0(0.439,0.224,0)

*** Secondary color (2):

   shade 0 = #9E1051 = rgb(158, 16, 81) = rgba(158, 16, 81,1) = rgb0(0.62,0.063,0.318)
   shade 1 = #CD558B = rgb(205, 85,139) = rgba(205, 85,139,1) = rgb0(0.804,0.333,0.545)
   shade 2 = #BA2C6D = rgb(186, 44,109) = rgba(186, 44,109,1) = rgb0(0.729,0.173,0.427)
   shade 3 = #81003B = rgb(129,  0, 59) = rgba(129,  0, 59,1) = rgb0(0.506,0,0.231)
   shade 4 = #5E002B = rgb( 94,  0, 43) = rgba( 94,  0, 43,1) = rgb0(0.369,0,0.169)
    
# Running project as flutter web
As we will access yahoo finance data from our browser we need to avoid the CORS error,
 avoiding the error by going to chrome.dart in your flutter path, example:
        /flutter/packages/flutter_tools/lib/src/web/chrome.dart

1- Go to flutter\bin\cache and remove a file named: flutter_tools.stamp

2- Go to flutter\packages\flutter_tools\lib\src\web and open the file chrome.dart.

3- Find '--disable-extensions'

4- Add '--disable-web-security'


# Generate icons
flutter pub run flutter_launcher_icons:main
