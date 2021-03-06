import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/utils/fonts.dart';

TextStyle homeTaskTextStyle = const TextStyle(
    color: Colors.white,

    fontSize: 10,

    fontWeight: FontWeight.w700);
TextStyle homeTaskCompletedTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 10,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.redAccent,
    decorationStyle: TextDecorationStyle.solid,decorationThickness: 2,
    fontWeight: FontWeight.bold);


TextStyle addListTitleStyle= const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600);

TextStyle updateListDateStyle =
    TextStyle(color: Colors.grey.shade500, fontFamily: comfortaa, fontSize: 12);

TextStyle updateTaskTextStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold);

TextStyle updateTaskCompletedTextStyle = const TextStyle(
    fontSize: 17,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.redAccent,
    decorationStyle: TextDecorationStyle.solid,decorationThickness: 2,
    fontWeight: FontWeight.bold);

TextStyle submitTextStyle= const TextStyle(
    fontFamily: comfortaa,
    fontWeight: FontWeight.bold);
