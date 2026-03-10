import 'package:flutter/material.dart';

class MenuOption {
  final IconData icon;
  final String label;
  final String route;

  const MenuOption({
    required this.icon,
    required this.label,
    required this.route,
  });
}