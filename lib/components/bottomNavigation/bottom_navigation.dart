import 'package:flutter/material.dart';


class BottomNavigation extends StatefulWidget {
  // The setter fuction is passed from main.dart
  // This is better than passing the variable directly, as the variable is not final
  // The function is considered final

  final Function setSelectedIndex;
  const BottomNavigation({super.key, required this.setSelectedIndex});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState
    extends State<BottomNavigation> {
  int _selectedIndex = 0;
  

  // When a menu item is tapped, both the selected index here and in main.dart need to be changed
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // use widget. to access a variable from the statefulwidget class
    widget.setSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alerts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(215, 63, 9, 1.0),
        onTap: _onItemTapped,
      );
  }
}
