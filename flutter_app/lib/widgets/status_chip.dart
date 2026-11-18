import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color background;

    switch (status) {
      case 'Resolved':
        background = Colors.green.shade100;
        break;
      case 'In Progress':
        background = Colors.orange.shade100;
        break;
      default:
        background = Colors.blueGrey.shade100;
    }

    return Chip(
      label: Text(status),
      backgroundColor: background,
      side: BorderSide.none,
    );
  }
}
