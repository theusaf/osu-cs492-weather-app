import 'package:flutter/material.dart';

class WeatherLocationWidget extends StatefulWidget {
  const WeatherLocationWidget({Key? key}) : super(key: key);

  @override
  State<WeatherLocationWidget> createState() => _WeatherLocationWidgetState();
}

class _WeatherLocationWidgetState extends State<WeatherLocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(
                  child: Text('Weather Location'),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 350,
                  child: Row(
                    children: [
                      WeatherTextField(label: "City"),
                      WeatherTextField(label: "State"),
                      WeatherTextField(label: "ZIP"),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherTextField extends StatelessWidget {
  final String label;

  const WeatherTextField({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
