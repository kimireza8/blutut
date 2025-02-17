import 'package:flutter/material.dart';

class StatusColorUtil {
  StatusColorUtil._(); // Private constructor to prevent instantiation

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
