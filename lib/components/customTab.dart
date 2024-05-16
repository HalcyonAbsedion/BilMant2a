import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTab extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Color borderColor;

  const CustomTab({
    Key? key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.borderColor = Colors.grey, // Default border color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // Transparent background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? borderColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: borderColor.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                  ),
                ]
              : [],
          color: Colors.transparent,
        ),
        child: Container(
          width: 100,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) // Show icon only if tab is selected
                Icon(
                  icon,
                  size: 20,
                  color: Colors.white,
                ),
              if (isSelected)
                const SizedBox(width: 8), // Add spacing if icon is shown
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
