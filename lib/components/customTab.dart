import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color shimmerColor;
  final int delay;
  final Color selectedTextColor;
  final Color selectedBackgroundColor;

  const CustomTab({
    Key? key,
    required this.text,
    required this.icon,
    required this.shimmerColor,
    required this.delay,
    required this.selectedTextColor,
    required this.selectedBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent, // Default background color
      ),
      child: Tab(
        iconMargin: EdgeInsets.all(0),
        icon: Icon(icon),
        text: text,
      ),
    );
  }
}
