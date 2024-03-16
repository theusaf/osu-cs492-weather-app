import 'package:cs492_weather_app/models/weather_forecast.dart';
import 'package:cs492_weather_app/widgets/theme_builder.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/user_location.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  final Function getLocation;
  final Function getForecasts;
  final Function getForecastsHourly;
  final Function setLocation;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const WeatherScreen({
    super.key,
    required this.getLocation,
    required this.getForecasts,
    required this.getForecastsHourly,
    required this.setLocation,
    required this.scaffoldKey,
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
            forecasts: widget.getForecastsHourly())
        : NoLocationDisplay(widget: widget));
  }
}

class ForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> forecasts;
  final BuildContext context;

  const ForecastWidget({
    super.key,
    required this.context,
    required this.location,
    required this.forecasts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationTextWidget(location: location),
        TemperatureWidget(forecasts: forecasts),
        DescriptionWidget(forecasts: forecasts)
      ],
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 25),
      child: ThemeBuilder(builder: (context, colorScheme, textTheme) {
        return Center(
            child: forecasts.isEmpty
                ? Shimmer.fromColors(
                    baseColor: colorScheme.onBackground.withAlpha(200),
                    highlightColor: Colors.grey.shade400,
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: colorScheme.onBackground,
                      ),
                    ))
                : Text(forecasts.elementAt(0).shortForecast,
                    style: textTheme.bodyMedium));
      }),
    );
  }
}

class TemperatureWidget extends StatelessWidget {
  const TemperatureWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

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
              : Text('${forecasts.elementAt(0).temperature}°',
                  style: textTheme.displayLarge),
        );
      }),
    );
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
          style: Theme.of(context).textTheme.headlineSmall,
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
