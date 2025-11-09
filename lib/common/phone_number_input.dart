import 'package:flutter/material.dart';

import 'app_text_field.dart';

class PhoneNumberInput extends StatefulWidget {
  final TextEditingController? controller;
  final String initialCountryCode;
  final ValueChanged<String>? onCountryChanged;

  const PhoneNumberInput({
    Key? key,
    this.controller,
    this.initialCountryCode = '+84',
    this.onCountryChanged,
  }) : super(key: key);

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late String _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCountryCode;

    if (widget.controller != null && widget.controller!.text.isEmpty) {
      widget.controller!.text = _selectedCountryCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: _selectedCountryCode,
          onChanged: (newValue) {
            if (newValue != null && newValue != _selectedCountryCode) {
              final oldCode = _selectedCountryCode;
              final newCode = newValue;

              if (widget.controller != null) {
                final currentText = widget.controller!.text;
                String phoneNumber = currentText;

                if (currentText.startsWith(oldCode)) {
                  phoneNumber = currentText.substring(oldCode.length);
                }
                
                widget.controller!.text = newCode + phoneNumber;
              }

              setState(() {
                _selectedCountryCode = newValue;
              });

              if (widget.onCountryChanged != null) {
                widget.onCountryChanged!(newValue);
              }
            }
          },
          items: <String>['+44', '+1', '+84'] // Example country codes
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppTextField(
            controller: widget.controller,
            hintText: 'Enter Phone Number',
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}
