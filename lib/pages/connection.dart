// import 'package:flutter/material.dart';

// class connection extends StatefulWidget {
//   const connection({Key? key}) : super(key: key);

//   @override
//   State<connection> createState() => _connectionState();
// }

// class _connectionState extends State<connection> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class connection extends StatefulWidget {
  @override
  _connectionState createState() => _connectionState();
}

class _connectionState extends State<connection> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        setState(() {
          devices.add(result.device);
        });
      }
    });

    // Stop the scan after the specified timeout
    //   flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (BuildContext context, int index) {
          BluetoothDevice device = devices[index];
          return ListTile(
            title: Text(device.name),
            subtitle: Text(device.id.toString()),
            onTap: () {
              // Handle device selection
              print('Selected device: ${device.name} (${device.id})');
            },
          );
        },
      ),
    );
  }
}
