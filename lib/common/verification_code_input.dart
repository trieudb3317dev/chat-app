import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCodeInput extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final TextEditingController? controller;
  final String? initialValue; // New property to accept an initial OTP value

  const VerificationCodeInput({
    Key? key,
    required this.onCompleted,
    this.controller,
    this.initialValue, // Add to constructor
  }) : super(key: key);

  @override
  _VerificationCodeInputState createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());

    // Listen to external controller changes for auto-filling (optional)
    widget.controller?.addListener(_handleExternalControllerChange);

    // ** THE FIX IS HERE: Set initial value right at the beginning **
    if (widget.initialValue != null && widget.initialValue!.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = widget.initialValue![i];
      }
      // Update the external controller as well, if provided
      _updateExternalController();
    }

    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1) {
          if (i < 5) {
            _focusNodes[i + 1].requestFocus();
          }
          _updateExternalController();
          if (_controllers.every((c) => c.text.isNotEmpty)) {
            widget.onCompleted(_controllers.map((c) => c.text).join());
          }
        } else if (_controllers[i].text.isEmpty && i > 0) {
          _focusNodes[i - 1].requestFocus();
          _updateExternalController();
        }
      });
    }
  }

  void _handleExternalControllerChange() {
    final text = widget.controller?.text ?? '';
    if (text.length == 6) {
      for (int i = 0; i < 6; i++) {
        if (_controllers[i].text != text[i]) {
          _controllers[i].text = text[i];
        }
      }
      _focusNodes.last.requestFocus();
    }
  }

  void _updateExternalController() {
    final currentOtp = _controllers.map((c) => c.text).join();
    if (widget.controller != null && widget.controller!.text != currentOtp) {
      widget.controller!.value = TextEditingValue(
        text: currentOtp,
        selection: TextSelection.collapsed(offset: currentOtp.length),
      );
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleExternalControllerChange);
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 40,
          height: 40,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [LengthLimitingTextInputFormatter(3)],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        );
      }),
    );
  }
}
