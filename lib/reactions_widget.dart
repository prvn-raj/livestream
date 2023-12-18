import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ReactionsWidget extends StatefulWidget {
  final bool isMuted; // Add this line

  ReactionsWidget({Key? key, required this.isMuted}) : super(key: key); // Modify this line

  @override
  _ReactionsWidgetState createState() => _ReactionsWidgetState();
}

class _ReactionsWidgetState extends State<ReactionsWidget> {
  List<String> _reactions = ["😀", "😍", "👍", "🔥", "❤️", ""];
  Random _random = Random();
  Timer? _timer;
  List<Widget> _floatingReactions = [];
  AudioCache audioCache = AudioCache();

  @override
  void initState() {
    super.initState();
    audioCache = AudioCache(prefix: 'assets/sound/', fixedPlayer: AudioPlayer());
    _startReactions();
  }

  void _startReactions() {
    _timer = Timer.periodic(Duration(milliseconds: 500 + _random.nextInt(1000)), (timer) {
      if (!mounted) return;
      _generateBunchOfReactions();
    });
  }

  void _generateBunchOfReactions() {
    int numberOfReactions = 1 + _random.nextInt(4); // Random bunch size between 1 and 4
    for (int i = 0; i < numberOfReactions; i++) {
      var reactionWidget = _buildReaction();
      Future.delayed(Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _floatingReactions.remove(reactionWidget);
          });
        }
      });
      setState(() {
        _floatingReactions.add(reactionWidget);
      });
      if (!widget.isMuted) { // Check if sound is muted
        audioCache.play('pop.mp3'); // Play the sound effect
      }
    }
  }

  Widget _buildReaction() {
    String reaction = _reactions[_random.nextInt(_reactions.length)];
    double startPositionX = _random.nextDouble() * MediaQuery.of(context).size.width;
    return FloatingReaction(
      reaction: reaction,
      startPositionX: startPositionX,
      duration: Duration(seconds: 3 + _random.nextInt(2)), // Duration between 3 to 5 seconds
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _floatingReactions);
  }

  @override
  void dispose() {
    _timer?.cancel();
    audioCache.fixedPlayer?.stop(); // Stop any ongoing playback
    audioCache.clearAll(); // Clear cached audio files
    super.dispose();
  }
}

class FloatingReaction extends StatelessWidget {
  final String reaction;
  final double startPositionX;
  final Duration duration;

  FloatingReaction({required this.reaction, required this.startPositionX, required this.duration});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double fadeStart = screenHeight * 0.3;

    return TweenAnimationBuilder(
      tween: Tween(begin: Offset(startPositionX, 1), end: Offset(startPositionX, 0)),
      duration: duration,
      builder: (context, Offset value, child) {
        double opacity = (value.dy * screenHeight > fadeStart) ? 1.0 : (value.dy * screenHeight) / fadeStart;
        return Positioned(
          left: value.dx,
          top: value.dy * screenHeight,
          child: Opacity(
            opacity: max(0, opacity),
            child: Transform.scale(
              scale: 1 + (1 - value.dy),
              child: Text(reaction, style: TextStyle(fontSize: 20)),
            ),
          ),
        );
      },
    );
  }
}
