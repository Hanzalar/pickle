// checkin_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkin_model.dart';  // Update with your actual import path.

class CheckinView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckinModel>(
      builder: (context, checkinModel, child) {
        return Container();  // Replace with your actual UI
      },
    );
  }
}