# cs492-weather-app

Yet-to-be-named weather app for use in CS492 at OSU-Cascades in the Winter 2024 term.

# cs492_weather_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

## Progress Notes:

### 1/23/24

First phase was implemented in class.
This included geolocation and geocoding functionality.
This grabs GPS data from phone and finds address, or allows user to manually enter a city, state, zip and find the location.

### 1/24/24

Cleaned up naming and updated following conventions.
Weather location has been changed to user location.
Comments added in the user_location.dart models.
Extracted location text boxes from location.dart to location_text.dart

### 1/30/24

created bottom navigation menu
updated location.dart to store the location information in an array
added setters and getters for current location to main.dart

### 2/6/24

The TODO is in main.dart. The readme will also contain hints for accomplishing the todo.
If you want to try without hints, use main.dart. You can reference the hints as needed.

TODO:
Create a new widget for the Weather screen in components.
main.dart should call this component instead of the Text() in widgetOptions
display the current location in the WeatherScreen() component

HINTS:
in components / create a folder called weatherScreen
in weatherScreen create a file called weather*screen.dart
in weather_screen.dart:
use bottom_navigation.dart as a template (right click the name and Rename Symbol to WeatherScreen, rename other symbols as needed)
weather screen should be passed a parameter Function getLocation (see location.dart for an example)
return an empty Text() widget for now
in main.dart:
import the weather_screen component
find widgetOptions and update the Text(\_weather information*) to instead call the WeatherScreen component.
Pass the getLocation function to weatherScreen.
in weather_screen.dart:
update the Text() return to display the location.city, location.state, location.zip

    EXTRAS:
        Use ternary logic to handle null values (see the Text() component in location.dart for an example of ternary logic)

### 2/13/24

    You'll need to add a new line to your android manifest.xml (Android->App->Src->Main->AndroidManifext.xml)
    <uses-permission android:name="android.permission.INTERNET" />
    see: https://docs.flutter.dev/cookbook/networking/fetch-data

    run the following in your terminal to make sure dependencies are good:
        flutter clean
        flutter pub get

    TODO:
    Look at the new weather_forecast.dart file (in models).
    Read through the class, including the factory.
    Read through the getWeatherForecasts function.
    Try to figure out what each line of code is accomplishing.

    Work through the TODOs in order (each one is numbered)

    EXTRAS:
    If you are able to return the forecasts to the weather_screen.dart,
    Attempt to display some of the information in the text return in ForecastWidget
    Remember to use ternary logic to handle null cases.

### 2/20/24

    Be sure to run:

    flutter clean
    flutter pub get

    TODO:
    Read through the TODO's in main.dart
    They are all numbered.

    The goals for today are:
      1. set up a togglable light/dark mode
      2. save the light/dark mode setting as a boolean to preferences
      3. load the light/dark mode setting from preferences and apply it


    There is a final challenge TODO which will require some customization of other files as well.

    The goal for this:
      When the user adds/updates their current location, save that to preferences as a jsonEncode string
      Load the string from preferences when the app is initialized and decode the string and map it to the UserLocation object

### 2/27/24

    Be sure to run:

    flutter clean
    flutter pub get

    TODO:
    There are todos in the new location_database.dart file.
    We will also be adding new assets to the assets/sql folder.
    These assets will need to be added to the pubspec.yaml file as well.

    The primary goal for today's class is to get practice with using sqflite for persistence of data
    When a user adds a location, it should be added to the database as well.
    When a user deletes a location, it should be deleted from the database.
    The location rows should be called from the database during initState() and used to update the widget.locations list.
    This should automatically populate saved locations.
