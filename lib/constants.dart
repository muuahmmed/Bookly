import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff050a30);

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
