import 'components/location/location.dart';
import 'package:flutter/material.dart';
import 'components/bottomNavigation/bottom_navigation.dart';
import 'models/user_location.dart';

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

   UserLocation? _location;
   late List<Widget> _widgetOptions = setWidgetOptions();

   List<Widget> setWidgetOptions() {
        List<Widget> widgetOptions = <Widget>[
              Text(
                'Weather for ${_location?.city}, ${_location?.state} ${_location?.zip}',
              ),
              Location(setLocation: setLocation),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _widgetOptions.elementAt(_selectedIndex),
            Text("Testing: ${_location?.city}")
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigation(setSelectedIndex: setSelectedIndex),
    );
  }
}
