import 'dart:async';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const VideoCallScreen({Key? key, required this.user}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isCallActive = false;
  String _callDuration = '00:00';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate call connection
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCallActive = true;
          _startTimer();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    int seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds++;
      int minutes = seconds ~/ 60;
      int secs = seconds % 60;
      setState(() {
        _callDuration = '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isCallActive ? _buildActiveCallUI() : _buildCallingUI();
  }

  Widget _buildCallingUI() {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Calling ...', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(widget.user['avatar']!),
          ),
          const SizedBox(height: 20),
          Text(
            widget.user['name']!,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.user['phone'] ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Spacer(flex: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCallButton(Icons.call_end, Colors.red, () => Navigator.of(context).pop()),
              _buildCallButton(Icons.call, Colors.green, () {}), // Dummy action
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildActiveCallUI() {
    return Scaffold(
      body: Stack(
        children: [
          // Remote user video (placeholder)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: NetworkImage('https://i.pravatar.cc/500?u=remoteuser'), // Placeholder for remote user video
                image: NetworkImage(widget.user['avatar']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Local user video (placeholder)
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(widget.user['avatarMe']!), // Placeholder for local user video
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Call controls
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(_callDuration, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCallControlButton(Icons.volume_up_outlined, () {}),
                    _buildCallControlButton(Icons.mic_off_outlined, () {}),
                    _buildCallControlButton(Icons.call_end, () => Navigator.of(context).pop(), backgroundColor: Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(IconData icon, Color color, VoidCallback onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildCallControlButton(IconData icon, VoidCallback onPressed, {Color backgroundColor = Colors.white54}) {
     return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        backgroundColor: backgroundColor,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
