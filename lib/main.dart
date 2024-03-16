import 'dart:convert';

import 'package:cs492_weather_app/theme.dart';
import 'package:cs492_weather_app/widgets/theme_builder.dart';
import 'components/location/location.dart';
import 'package:flutter/material.dart';
import 'models/user_location.dart';
import 'components/weatherScreen/weather_screen.dart';
import 'models/weather_forecast.dart';
import 'package:shared_preferences/shared_preferences.dart';

const sqlCreateDatabase = 'assets/sql/create.sql';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.prefs}) {
    notifier.value =
        prefs.getBool("light") == false ? ThemeMode.dark : ThemeMode.light;
  }

  final SharedPreferences prefs;
  final ValueNotifier<ThemeMode> notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'CS 492 Weather App',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          home: MyHomePage(
              title: "CS492 Weather App", notifier: notifier, prefs: prefs),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final ValueNotifier<ThemeMode> notifier;
  final SharedPreferences prefs;
  const MyHomePage({
    super.key,
    required this.title,
    required this.notifier,
    required this.prefs,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserLocation> locations = [];
  List<WeatherForecast> _forecasts = [];
  List<WeatherForecast> _forecastsHourly = [];
  UserLocation? _location;

  void setLocation(UserLocation location) async {
    setState(() {
      _location = location;
      _getForecasts();
    });
  }

  void _getForecasts() async {
    if (_location != null) {
      // We collect both the twice-daily forecasts and the hourly forecasts
      List<WeatherForecast> forecasts =
          await getWeatherForecasts(_location!, false);
      List<WeatherForecast> forecastsHourly =
          await getWeatherForecasts(_location!, true);
      setState(() {
        _forecasts = forecasts;
        _forecastsHourly = forecastsHourly;
      });
    }
  }

  List<WeatherForecast> getForecasts() {
    return _forecasts;
  }

  List<WeatherForecast> getForecastsHourly() {
    return _forecastsHourly;
  }

  UserLocation? getLocation() {
    return _location;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  bool _light = true;

  @override
  void initState() {
    super.initState();
    _light = widget.notifier.value == ThemeMode.light;

    _initMode();
  }

  void _initMode() async {
    String? locationString = widget.prefs.getString("location");

    if (locationString != null) {
      setLocation(UserLocation.fromJson(jsonDecode(locationString)));
    }
  }

  void _toggleLight(value) async {
    setState(() {
      _light = value;
      _setTheme(value);
    });
    widget.prefs.setBool("light", value);
  }

  void _setTheme(value) {
    widget.notifier.value = value ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Open Settings',
            onPressed: _openEndDrawer,
          )
        ],
      ),
      body: WeatherScreen(
          getLocation: getLocation,
          getForecasts: getForecasts,
          getForecastsHourly: getForecastsHourly,
          setLocation: setLocation),
      endDrawer: Drawer(
        child: settingsDrawer(),
      ),
    );
  }

  SizedBox modeToggle() {
    return SizedBox(
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_light ? "Light Mode" : "Dark Mode",
              style: Theme.of(context).textTheme.labelLarge),
          Transform.scale(
            scale: 0.5,
            child: Switch(
              value: _light,
              onChanged: _toggleLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsDrawer() {
    return SafeArea(
      child: ThemeBuilder(builder: (context, colorScheme, textTheme) {
        return Column(
          children: [
            SettingsHeaderText(context: context, text: "Settings:"),
            modeToggle(),
            SettingsHeaderText(context: context, text: "My Locations:"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Location(
                  setLocation: setLocation,
                  getLocation: getLocation,
                  closeEndDrawer: _closeEndDrawer),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                ),
                onPressed: _closeEndDrawer,
                child: const Text("Close Settings"))
          ],
        );
      }),
    );
  }
}

class SettingsHeaderText extends StatelessWidget {
  final String text;
  final BuildContext context;
  const SettingsHeaderText(
      {super.key, required this.context, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
