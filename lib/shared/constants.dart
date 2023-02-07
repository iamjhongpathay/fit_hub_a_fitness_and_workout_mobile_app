import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  border: OutlineInputBorder(),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0),),
  errorBorder:
  OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
  focusedErrorBorder:
  OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
  errorStyle: TextStyle(color: Colors.red),
  labelStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),

);