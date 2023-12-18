import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'broadcast_page.dart'; // Import the new file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Streaming Prototype',
      home: BroadcastPage(cameras: cameras),
    );
  }
}
