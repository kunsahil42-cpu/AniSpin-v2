import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String? status;

  const StatusChip({
    super.key,
    required this.status,
  });

  Color _getColor() {
    switch (status) {
      case 'FINISHED':
        return Colors.green;
      case 'RELEASING':
        return Colors.blue;
      case 'NOT_YET_RELEASED':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'HIATUS':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getText() {
    if (status == null || status!.isEmpty || status == 'Unknown') {
      return 'Unknown Status';
    }
    return status!.replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        Icons.circle,
        size: 12,
        color: _getColor(),
      ),
      label: Text(
        _getText(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: _getColor().withValues(alpha: 0.15),
    );
  }
}