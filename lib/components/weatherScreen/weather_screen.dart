import 'package:cs492_weather_app/util/strings.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cs492_weather_app/models/weather_forecast.dart';
import 'package:cs492_weather_app/models/user_location.dart';
import 'package:cs492_weather_app/util/math.dart';
import 'package:cs492_weather_app/widgets/shimmer.dart';
import 'package:cs492_weather_app/widgets/theme_builder.dart';
import 'package:cs492_weather_app/widgets/weather_icon.dart';

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
            forecastsHourly: widget.getForecastsHourly(),
            forecastsTwiceDaily: widget.getForecasts(),
            unit: widget.units,
            unitType: widget.unitType,
          )
        : NoLocationDisplay(widget: widget));
  }
}

class ForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> forecastsHourly;
  final List<WeatherForecast> forecastsTwiceDaily;
  final BuildContext context;
  final String unit;
  final String unitType;

  const ForecastWidget({
    super.key,
    required this.context,
    required this.location,
    required this.forecastsHourly,
    required this.forecastsTwiceDaily,
    required this.unit,
    required this.unitType,
  });

  @override
  Widget build(BuildContext context) {
    return SingleForecastView(
        location: location,
        forecastsHourly: forecastsHourly,
        forecastsTwiceDaily: forecastsTwiceDaily,
        unit: unit,
        unitType: unitType);
  }
}

class SingleForecastView extends StatelessWidget {
  const SingleForecastView({
    super.key,
    required this.location,
    required this.forecastsHourly,
    required this.forecastsTwiceDaily,
    required this.unit,
    required this.unitType,
  });

  final UserLocation location;
  final List<WeatherForecast> forecastsHourly;
  final List<WeatherForecast> forecastsTwiceDaily;
  final String unit;
  final String unitType;

  @override
  Widget build(BuildContext context) {
    final currentForecast =
        forecastsHourly.isNotEmpty ? forecastsHourly.elementAt(0) : null;
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
            constraints: const BoxConstraints(maxWidth: 400, minHeight: 250),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: DescriptionWidget(forecast: currentForecast),
                ),
                Expanded(
                  flex: 1,
                  child: TemperatureWidget(
                    forecast: currentForecast,
                    unit: unit,
                    unitType: unitType,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          FutureForecastListing(
            forecastsHourly: forecastsHourly,
            forecastsTwiceDaily: forecastsTwiceDaily,
            unit: unit,
            unitType: unitType,
          ),
        ],
      ),
    );
  }
}

class FutureForecastListing extends StatefulWidget {
  const FutureForecastListing({
    super.key,
    required this.forecastsHourly,
    required this.forecastsTwiceDaily,
    required this.unit,
    required this.unitType,
  });

  final List<WeatherForecast> forecastsHourly;
  final List<WeatherForecast> forecastsTwiceDaily;
  final String unit;
  final String unitType;

  @override
  State<FutureForecastListing> createState() => _FutureForecastListingState();
}

class _FutureForecastListingState extends State<FutureForecastListing> {
  bool isHourly = true;

  @override
  Widget build(BuildContext context) {
    final forecastItems =
        isHourly ? widget.forecastsHourly : widget.forecastsTwiceDaily;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isHourly = true;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isHourly
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text('Hourly Forecast',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: isHourly
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isHourly = false;
                  });
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: !isHourly
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.all(8),
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    'Daily Forecast',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: !isHourly
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            key: ValueKey(isHourly),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: forecastItems.isEmpty ? 5 : forecastItems.length,
            itemBuilder: (context, index) {
              if (forecastItems.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ShimmerBox(
                    width: 150,
                    height: 250,
                  ),
                );
              }
              final forecast = forecastItems[index];
              return SizedBox(
                width: 150,
                child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isHourly
                          ? HourlyForecastCard(
                              forecast: forecast,
                              unit: widget.unit,
                              unitType: widget.unitType)
                          : DailyForecastCard(
                              forecast: forecast,
                              unit: widget.unit,
                              unitType: widget.unitType)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DailyForecastCard extends StatelessWidget {
  const DailyForecastCard({
    super.key,
    required this.forecast,
    required this.unit,
    required this.unitType,
  });

  final WeatherForecast forecast;
  final String unit;
  final String unitType;

  @override
  Widget build(BuildContext context) {
    return Text('${forecast.temperature}${forecast.name}°');
  }
}

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard({
    super.key,
    required this.forecast,
    required this.unit,
    required this.unitType,
  });

  final WeatherForecast forecast;
  final String unit;
  final String unitType;

  @override
  Widget build(BuildContext context) {
    String tempString = '';
    String tempTypeString = '';
    [tempString, tempTypeString] = getTemperatureValue(
        unit: unit,
        unitType: unitType,
        temperature: forecast.temperature.toDouble());

    return ThemeBuilder(builder: (context, colorScheme, textTheme) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${forecast.startTime.month}/${forecast.startTime.day} ${padZeroes(number: forecast.startTime.hour)}:${padZeroes(number: forecast.startTime.minute)}',
            style: textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
            child: WeatherIcon(weather: forecast.shortForecast),
          ),
          Text('$tempString$tempTypeString',
              style: textTheme.bodyLarge, textAlign: TextAlign.center),
          Text(forecast.shortForecast,
              style: textTheme.bodyMedium, textAlign: TextAlign.center),
        ],
      );
    });
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
    this.forecast,
    required this.unit,
    required this.unitType,
  });

  final WeatherForecast? forecast;
  final String unit;
  final String unitType;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: ThemeBuilder(builder: (context, colorScheme, textTheme) {
        return Center(
          child: forecast == null
              ? Shimmer.fromColors(
                  baseColor: colorScheme.onBackground.withAlpha(200),
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    width: 100,
                    height: 80,
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
    [tempString, tempTypeString] = getTemperatureValue(
        unit: unit,
        unitType: unitType,
        temperature: forecast!.temperature.toDouble());

    return ThemeBuilder(builder: (context, colorScheme, textTheme) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                '$tempString$tempTypeString',
                style: textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              Text('${forecast!.windSpeed} ${forecast!.windDirection}',
                  style: textTheme.bodyLarge),
            ],
          ),
        ),
      );
    });
  }
}

List<String> getTemperatureValue(
    {required String unit,
    required String unitType,
    required double temperature}) {
  String tempString = '';
  String tempTypeString = '';
  switch (unit) {
    case 'Celsius':
      temperature = fahrenheitToCelsius(temperature);
      break;
    case 'Kelvin':
      temperature = fahrenheitToKelvin(temperature);
      break;
    case 'Felcius':
      temperature = fahrenheitToFelcius(temperature);
      break;
  }
  if (unitType == 'degrees') {
    tempString = temperature.toStringAsFixed(0);
    tempTypeString = '°';
  } else {
    tempString = degreesToRadians(temperature).toStringAsFixed(3);
    tempTypeString = ' rad';
  }
  return [tempString, tempTypeString];
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
