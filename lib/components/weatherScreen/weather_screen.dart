import 'package:cs492_weather_app/models/weather_forecast.dart';
import 'package:cs492_weather_app/util/math.dart';
import 'package:cs492_weather_app/widgets/shimmer.dart';
import 'package:cs492_weather_app/widgets/theme_builder.dart';
import 'package:cs492_weather_app/widgets/weather_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/user_location.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  final Function getLocation;
  final Function getForecasts;
  final Function getForecastsHourly;
  final Function setLocation;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String units;
  final String unitType;

  const WeatherScreen({
    super.key,
    required this.getLocation,
    required this.getForecasts,
    required this.getForecastsHourly,
    required this.setLocation,
    required this.scaffoldKey,
    required this.units,
    required this.unitType,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return (widget.getLocation() != null
        ? ForecastWidget(
            context: context,
            location: widget.getLocation(),
            forecasts: widget.getForecastsHourly(),
            unit: widget.units,
            unitType: widget.unitType,
          )
        : NoLocationDisplay(widget: widget));
  }
}

class ForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> forecasts;
  final BuildContext context;
  final String unit;
  final String unitType;

  const ForecastWidget({
    super.key,
    required this.context,
    required this.location,
    required this.forecasts,
    required this.unit,
    required this.unitType,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LocationTextWidget(location: location),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: DescriptionWidget(
                      forecast:
                          forecasts.isNotEmpty ? forecasts.elementAt(0) : null),
                ),
                Expanded(
                  flex: 1,
                  child: TemperatureWidget(
                    forecasts: forecasts,
                    unit: unit,
                    unitType: unitType,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    this.forecast,
  });

  final WeatherForecast? forecast;

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (context, colorScheme, textTheme) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          forecast != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: WeatherIcon(weather: forecast!.shortForecast),
                )
              : const ShimmerBox(
                  width: 200,
                  height: 200,
                ),
          forecast != null
              ? Text(
                  forecast!.shortForecast,
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                )
              : const ShimmerBox(
                  width: 200,
                  height: 20,
                )
        ],
      ));
    });
  }
}

class TemperatureWidget extends StatelessWidget {
  const TemperatureWidget({
    super.key,
    required this.forecasts,
    required this.unit,
    required this.unitType,
  });

  final List<WeatherForecast> forecasts;
  final String unit;
  final String unitType;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 60),
      child: ThemeBuilder(builder: (context, colorScheme, textTheme) {
        return Center(
          child: forecasts.isEmpty
              ? Shimmer.fromColors(
                  baseColor: colorScheme.onBackground.withAlpha(200),
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.onBackground,
                    ),
                  ))
              : displayContent(),
        );
      }),
    );
  }

  Widget displayContent() {
    String tempString = '';
    String tempTypeString = '';
    double tempValue = forecasts.elementAt(0).temperature.toDouble();
    switch (unit) {
      case 'Celsius':
        tempValue = fahrenheitToCelsius(tempValue);
        break;
      case 'Kelvin':
        tempValue = fahrenheitToKelvin(tempValue);
        break;
      case 'Felcius':
        tempValue = fahrenheitToFelcius(tempValue);
        break;
    }
    if (unitType == 'degrees') {
      tempString = tempValue.toStringAsFixed(0);
      tempTypeString = '°';
    } else {
      tempString = degreesToRadians(tempValue).toStringAsFixed(3);
      tempTypeString = ' rad';
    }
    return ThemeBuilder(builder: (context, colorScheme, textTheme) {
      return Text('$tempString$tempTypeString', style: textTheme.displayLarge);
    });
  }
}

class LocationTextWidget extends StatelessWidget {
  const LocationTextWidget({
    super.key,
    required this.location,
  });

  final UserLocation location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Text(
          '${location.city}, ${location.state}, ${location.zip}',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class NoLocationDisplay extends StatelessWidget {
  const NoLocationDisplay({
    super.key,
    required this.widget,
  });

  final WeatherScreen widget;

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (context, colorScheme, textTheme) {
      return LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight / 2),
              child: Image.asset('assets/images/confused.png'),
            ),
            SizedBox(
              height: 125,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No locations saved. Open the settings to add locations.',
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: Text(
                      'Open Settings',
                      style: textTheme.labelLarge,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      });
    });
  }
}
