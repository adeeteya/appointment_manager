import 'package:flutter/material.dart';

const kOffWhite = Color(0xFFF5F5F5);
const kPrimaryColor = Color(0xFF2B67F6);
const kDarkColor = Color(0xFF1C1F2A);
const kLightErrorColor = Color(0xFFB00020);
const kDarkErrorColor = Color(0xFFCF6679);

const kInputDecoration = InputDecoration(
  filled: true,
  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kPrimaryColor,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: kPrimaryColor,
    ),
  ),
);
