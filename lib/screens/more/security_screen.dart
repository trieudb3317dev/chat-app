
import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _pinSecurity = false;
  bool _faceRecognition = false;
  bool _fingerprintSecurity = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  title: const Text('PIN Security'),
                  value: _pinSecurity,
                  onChanged: (value) {
                    setState(() {
                      _pinSecurity = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Face Recognition'),
                  value: _faceRecognition,
                  onChanged: (value) {
                    setState(() {
                      _faceRecognition = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Fingerprint Security'),
                  value: _fingerprintSecurity,
                  onChanged: (value) {
                    setState(() {
                      _fingerprintSecurity = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _pinSecurity ? () {} : null,
              child: const Text('Change PIN'),
            ),
          ),
        ],
      ),
    );
  }
}
