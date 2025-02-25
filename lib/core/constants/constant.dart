import 'package:flutter/material.dart';

class Constant {
  Constant._();

  // API related constants
  static const String baseUrl = 'https://app.ptmakassartrans.com';
  static const String loginEndpoint = '/index.php/auth/login.json';

  // Cookie key
  static const String cookieKey = 'cookie';

  // Text Styles
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const TextStyle hintTextStyle = TextStyle(
    fontSize: 14,
    color: Color.fromRGBO(153, 153, 153, 1),
    fontWeight: FontWeight.w400,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle valueStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  // Input Decorations
  static const EdgeInsets inputContentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  static final UnderlineInputBorder underlineInputBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!));

  static final OutlineInputBorder outlineInputBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(8));

  // Colors
  static const primaryBlue = Color.fromRGBO(29, 79, 215, 1);

  // Paddings and Border Radiuses
  static const defaultPadding = EdgeInsets.all(16);
  static const cardBorderRadius = 8.0;

  // Borders
  static final cardBorder = Border.all(color: Colors.grey.shade300);
}
