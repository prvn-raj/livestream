  import 'package:flutter/material.dart';
  import 'package:camera/camera.dart';
  import 'comment_model.dart'; // Import the Comment model
  import 'reactions_widget.dart'; // Import the ReactionsWidget
  import 'viewercountwidget.dart'; // Import the ViewerCountWidget
  import 'namelogic.dart'; // Import the names logic
  import 'dart:math'; // Import for random logic

  class BroadcastPage extends StatefulWidget {
    final List<CameraDescription> cameras;

    BroadcastPage({required this.cameras});

    @override
    _BroadcastPageState createState() => _BroadcastPageState();
  }

  class _BroadcastPageState extends State<BroadcastPage> {
    CameraController? _controller;
    List<Comment> _comments = [];
    final ScrollController _scrollController = ScrollController();
    bool _isStreaming = false;
    bool _isMuted = false;

    @override
    void initState() {
      super.initState();
      _initCamera(widget.cameras.first);
    }

    Future<void> _initCamera(CameraDescription cameraDescription) async {
      _controller = CameraController(cameraDescription, ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    }

    void _switchCamera() {

      CameraDescription newCamera = widget.cameras.firstWhere(
            (camera) => camera.lensDirection != _controller!.description.lensDirection,
        orElse: () => widget.cameras.first,
      );

      if (newCamera != null) {
        _initCamera(newCamera);
      }
    }

    void _startCommentUpdates() {
      if (_isStreaming) {
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              String randomName = generateRandomName();
              Comment newComment = generateRandomComment(_comments.length);
              Comment updatedComment = Comment(username: randomName, message: newComment.message);

              _comments.add(updatedComment);
            });

            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent + 72.0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }

            _startCommentUpdates();
          }
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Material(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            CameraPreview(_controller!),
            if (_isStreaming) ...[
              ReactionsWidget(isMuted: _isMuted),
              Positioned(
                top: 20,
                right: 20,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text("Live Streaming", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: ViewerCountWidget(),
              ),
            ],
            Positioned(
              bottom: 300,
              right: 20,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(_isStreaming ? Icons.stop : Icons.play_arrow),
                    color: Colors.red, iconSize: 50,
                    onPressed: () {
                      setState(() {
                        _isStreaming = !_isStreaming;
                        if (_isStreaming) {
                          _startCommentUpdates();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.switch_camera),
                    color: Colors.white,
                    onPressed: _switchCamera,
                  ),
                  IconButton(
                    icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                    color: Colors.white,
                    onPressed: () => setState(() {
                      _isMuted = !_isMuted;
                    }),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _isStreaming ? _buildCommentsSection() : SizedBox.shrink(),
            ),
          ],
        ),
      );
    }

    Widget _buildCommentsSection() {
      return Container(
        height: 200,
        padding: EdgeInsets.all(8.0),
        color: Colors.black54,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            Random random = Random();
            bool isMale = random.nextBool();
            IconData avatarIcon = isMale ? Icons.face : Icons.face_outlined;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                maxRadius: 5,
                child: Icon(avatarIcon, color: Colors.white),
              ),
              title: Text(_comments[index].username, style: TextStyle(color: Colors.white)),
              subtitle: Text(_comments[index].message, style: TextStyle(color: Colors.white70)),
            );
          },
        ),
      );
    }

    @override
    void dispose() {
      _controller?.dispose();
      super.dispose();
    }
  }
