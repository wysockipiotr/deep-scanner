import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("About"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.only(left: 36.0, right: 36.0, bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/sut.png",
                  height: 350,
                ),
                Text(
                  "Engineer Thesis App",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Gliwice, 2020",
                    style: Theme.of(context).textTheme.caption),
                SizedBox(
                  height: 18,
                ),
                Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  "DeepScanner allows to scan text documents using device camera and denoise them using autoencoder deep neural networks",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "Supervisor",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text("dr inż. Grzegorz Baron"),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "Author",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text("Piotr Wysocki"),
              ],
            )),
      ));
}
