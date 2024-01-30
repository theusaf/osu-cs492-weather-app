import 'components/location/location.dart';
import 'package:flutter/material.dart';
import 'components/bottomNavigation/bottom_navigation.dart';

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

   // TODO: Create a variable to store the UserLocation
   // TODO: Create a setter function for the location variable
   // TODO: Pass the setter function to Location()
   // See location.dart for more TODO

    // this is the setter function used to set the _selected index value
    void setSelectedIndex(index){
      // setState is a built-in function that notifies the application that something has changed.
      // This causes the screen to re-render
      setState(() {
        _selectedIndex = index;
      });
    }

  
  // This stores the options for each page
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Weather',
    ),
    Location(),
    Text(
      'Alerts',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigation(setSelectedIndex: setSelectedIndex),
    );
  }
}
