import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Gallery extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: .5,
        crossAxisSpacing: .5,
        children: List.generate(25, (int index) => index)
            .map(
              (int i) => Card(
                elevation: 2.0,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            )
            .toList());
  }
}
