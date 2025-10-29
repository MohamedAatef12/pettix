import 'package:flutter/material.dart';

class SubmitApplication extends StatelessWidget {
  const SubmitApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adopt Buddy'), centerTitle: true),
      body: Column(children: [Text('Submitted Your Application')]),
    );
  }
}
