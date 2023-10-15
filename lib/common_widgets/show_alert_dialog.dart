import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../navigation.dart';

Future<void> showAlertDialog(
  BuildContext context, {
  required String title,
  required String? content,
  String? cancelActionText,
  required String defaultActionText,
  required ValueChanged<bool?> onActionsPressed,
}) {
  void onCancelPress(){
    onActionsPressed(false);
    pop(context);
  }
  void onSuccessPress(){
    onActionsPressed(true);
    pop(context);
  }
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content!),
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              onPressed: onCancelPress,
              child: Text(cancelActionText),
            ),
          TextButton(
            onPressed: onSuccessPress,
            child: Text(defaultActionText),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content!),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            onPressed: onCancelPress,
            child: Text(cancelActionText),
          ),
        CupertinoDialogAction(
          onPressed: onSuccessPress,
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}