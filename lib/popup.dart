import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Widget popup(BuildContext context, String header, String text) {
  return AlertDialog(
      title: Text(header),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text(text)],
      ),
      actions: <Widget>[
        NeumorphicButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok')),
      ]);
}
