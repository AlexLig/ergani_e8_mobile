import 'package:flutter/material.dart';

enum SnackbarType { Info, Warning, Success, Error }

void showSnackbar({
  @required scaffoldContext,
  String message,
  Duration duration,
  SnackbarType type,
  SnackBarAction action,
}) {
  Scaffold.of(scaffoldContext).showSnackBar(
    SnackBar(
      backgroundColor: _pickColor(type),
      duration: duration ?? Duration(seconds: 4),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          type != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(_pickIcon(type)),
                )
              : null,
          Expanded(child: Text(message))
        ].where((val) => val != null).toList(),
      ),
      action: action,
    ),
  );
}

 Color _pickColor(SnackbarType type) {
  switch (type) {
    case SnackbarType.Success:
      return Colors.green[700];
    case SnackbarType.Error:
      return Colors.red;
    default:
      return null;
  }
}

IconData _pickIcon(SnackbarType type) {
  switch (type) {
    case SnackbarType.Info:
      return Icons.info;
    case SnackbarType.Warning:
      return Icons.warning;
    case SnackbarType.Success:
      return Icons.check;
    case SnackbarType.Error:
      return Icons.error;
    default:
      return null;
  }
}
