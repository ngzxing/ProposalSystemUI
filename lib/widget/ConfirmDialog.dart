import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConfirmDialog extends StatelessWidget{

  Widget message;

  ConfirmDialog({super.key, required this.message});
  

  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Confirm',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: message,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black54,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
  }


  
}