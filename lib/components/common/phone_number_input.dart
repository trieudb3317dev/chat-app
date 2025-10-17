import 'package:chat_app/components/common/app_text_field.dart';
import 'package:flutter/material.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController? controller;
  final String initialCountryCode;
  final ValueChanged<String>? onCountryChanged;

  const PhoneNumberInput({
    Key? key,
    this.controller,
    this.initialCountryCode = '+44',
    this.onCountryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: initialCountryCode,
          onChanged: (newValue) {
            if (onCountryChanged != null && newValue != null) {
              onCountryChanged!(newValue);
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
            controller: controller,
            hintText: 'Enter Phone Number',
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}
