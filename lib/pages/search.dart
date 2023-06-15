import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LedControlPage extends StatelessWidget {
  final String esp8266IP;

  LedControlPage({required this.esp8266IP});

  Future<void> _turnLedOn() async {
    await http.get(Uri.http(esp8266IP, '/on'));
  }

  Future<void> _turnLedOff() async {
    await http.get(Uri.http(esp8266IP, '/off'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LED Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _turnLedOn,
              child: Text('Turn On LED'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _turnLedOff,
              child: Text('Turn Off LED'),
            ),
          ],
        ),
      ),
    );
  }
}
