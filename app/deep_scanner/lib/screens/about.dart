import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
              padding: EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/sut.png",
                    height: 300,
                  ),
                  Text(
                    "Engineer Thesis App",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "This application allows to scan documents using device camera and denoise them using autoencoder deep neural networks",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "Author",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text("Piotr Wysocki")
                ],
              )),
        ));
  }
}
