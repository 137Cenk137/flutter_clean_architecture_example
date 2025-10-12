import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar() //if there is a snackbar already, hide it. two snackbars can't be shown at the same time.
    ..showSnackBar(SnackBar(content: Text(message)));
}
