import 'package:flutter/material.dart';

import '../localization.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key? key,
    this.title,
    this.message,
  }) : super(key: key);
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title ?? AppLocalizations.of(context).translate('Nothing here'),
            style: TextStyle(fontSize: 32.0, color: Colors.black54),
          ),
          Text(
            message ?? AppLocalizations.of(context).translate('Add a new item to get started'),
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
