import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proposal_app/widget/Button.dart';

// ignore: must_be_immutable
class FutureWidget extends StatefulWidget {
  Future Function() fetchData;
  Widget Function() widgetBuilder;
  bool returnScaffold;

  FutureWidget(
      {super.key,
      required this.fetchData,
      required this.widgetBuilder,
      this.returnScaffold = false});
  @override
  State<FutureWidget> createState() => FutureWidgetState();
}

class FutureWidgetState extends State<FutureWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (widget.returnScaffold) {
              return Scaffold(
                  body: Center(
                      child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 200,
                      child: Text(snapshot.error.toString())),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(width: 100, child: Button(onPressed: () => setState(() {}), text: "Refresh")),
                  )
                ],
              )));
            }

            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(snapshot.error.toString())),
                Button(onPressed: () => setState(() {}), text: "Refresh")
              ],
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return widget.widgetBuilder();
          }

          if (widget.returnScaffold) {
            return const Scaffold(
                body: Center(
                    child: SizedBox(
                        height: 50, width: 50, child: CircularProgressIndicator())));
          }

          return const Center(
              child: SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator()));
        });
  }
}
