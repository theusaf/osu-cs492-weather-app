import 'package:flutter/material.dart';

class LocationText extends StatefulWidget {
  const LocationText(
      {super.key,
      required this.labelText,
      required this.width,
      required this.controller});

  final String labelText;
  final double width;
  final TextEditingController controller;

  @override
  State<LocationText> createState() => _LocationTextState();
}

class _LocationTextState extends State<LocationText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: widget.width,
        child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.labelText,
            )),
      ),
    );
  }
}
