import 'components/location/location.dart';
import 'package:flutter/material.dart';
import 'components/bottomNavigation/bottom_navigation.dart';
import 'models/user_location.dart';
import 'components/weatherScreen/weather_screen.dart';


// TODO:
//  Create a new weather_screen.dart in a new weatherScreen folder in the components folder. 
//  main.dart should call this component instead of the Text() in widgetOptions
//  display the current location in the WeatherScreen() component
//  if you need help, check the readme for hints on accopmlishing today's todos




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS 492 Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   int _selectedIndex = 0;
   List<UserLocation> locations = [];
   UserLocation? _location;

   late List<Widget> _widgetOptions = setWidgetOptions();

   List<Widget> setWidgetOptions() {
        List<Widget> widgetOptions = <Widget>[
              WeatherScreen(getLocation: getLocation),
              Location(setLocation: setLocation, getLocation: getLocation, locations: locations),
              const Text(
                'Alerts',
              ),
            ];

      return widgetOptions;
   }

   void setLocation(UserLocation location){
    setState(() {
      _location = location;
      _widgetOptions = setWidgetOptions();
    });
   }

   UserLocation? getLocation(){
    return _location;
   }

    // this is the setter function used to set the _selected index value
    void setSelectedIndex(index){
      // setState is a built-in function that notifies the application that something has changed.
      // This causes the screen to re-render
      setState(() {
        _selectedIndex = index;
      });
    }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigation(setSelectedIndex: setSelectedIndex),
    );
  }
}
