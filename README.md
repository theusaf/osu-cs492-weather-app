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

1/23/24
First phase was implemented in class.
This included geolocation and geocoding functionality.
This grabs GPS data from phone and finds address, or allows user to manually enter a city, state, zip and find the location.

1/24/24
Cleaned up naming and updated following conventions.
Weather location has been changed to user location.
Comments added in the user_location.dart models.
Extracted location text boxes from location.dart to location_text.dart

1/30/24
created bottom navigation menu
updated location.dart to store the location information in an array
added setters and getters for current location to main.dart


2/6/24
The TODO is in main.dart. The readme will also contain hints for accomplishing the todo.
If you want to try without hints, use main.dart. You can reference the hints as needed.

TODO:
Create a new widget for the Weather screen in components. 
main.dart should call this component instead of the Text() in widgetOptions
display the current location in the WeatherScreen() component


HINTS:
in components / create a folder called weatherScreen
    in weatherScreen create a file called weather_screen.dart
    in weather_screen.dart:
        use bottom_navigation.dart as a template (right click the name and Rename Symbol to WeatherScreen, rename other symbols as needed)
        weather screen should be passed a paramater Function getLocation (see location.dart for an example)
        return an empty Text() widget for now
    in main.dart:
        import the weather_screen component
        find widgetOptions and update the Text(*weather information*) to instead call the WeatherScreen component. 
        Pass the getLocation function to weatherScreen.
    in weather_screen.dart: 
        update the Text() return to display the location.city, location.state, location.zip
    
    EXTRAS:
        Use ternary logic to handle null values (see the Text() component in location.dart for an example of ternary logic)



