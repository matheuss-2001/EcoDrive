import 'package:flutter/material.dart';

class CarPage extends StatefulWidget {
  const CarPage({Key? key}) : super(key: key);

  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(

      children: [
        Container(
          height: 30,
          width: 30,
          color: Colors.red,
        )
      ],
    );
  }
}
