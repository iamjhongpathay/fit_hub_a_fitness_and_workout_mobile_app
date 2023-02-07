import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/loading_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.black,
          size: 80.0,
        ),
      ),
    );
  }
}
