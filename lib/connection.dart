import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class checkConnection extends StatefulWidget {
  const checkConnection({super.key});

  @override
  State<checkConnection> createState() => _checkConnectionState();
}

class _checkConnectionState extends State<checkConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DARSHAN'),
      ),
      body: Center(
        child: Column(
          children:   [
            Text('DARSHAN WELCOME'),
          ],
        ),
      ),
    );
  }
}
