import 'package:flutter/material.dart';

class Dialogs {
  static void showSnakebar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 0, 212, 166),
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
                child: CircularProgressIndicator(
              backgroundColor: const Color.fromARGB(255, 0, 212, 166),
            )));
  }

  static void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Profile updated Successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Close'),
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
        );
      },
    );
  }
}
