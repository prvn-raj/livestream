import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ViewerCountWidget extends StatefulWidget {
  @override
  _ViewerCountWidgetState createState() => _ViewerCountWidgetState();
}

class _ViewerCountWidgetState extends State<ViewerCountWidget> {
  int _viewerCount = 12570; // Start with 10K viewers
  Timer? _viewerCountTimer;

  @override
  void initState() {
    super.initState();
    _viewerCountTimer = Timer.periodic(Duration(milliseconds: 500), (timer) { // Faster update interval
      setState(() {
        _viewerCount = _randomViewerCount();
      });
    });
  }

  int _randomViewerCount() {
    // Randomly increase the viewer count, max up to 1 million
    if (_viewerCount < 1000000) {
      int increase = Random().nextInt(100) + 50; // Increase by a random number between 100 and 600
      return _viewerCount + increase;
    }
    return _viewerCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Viewers: ${_viewerCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', // Format the number with commas
        style: TextStyle(color: Colors.white, fontSize: 20, ),
      ),
    );
  }

  @override
  void dispose() {
    _viewerCountTimer?.cancel();
    super.dispose();
  }
}
