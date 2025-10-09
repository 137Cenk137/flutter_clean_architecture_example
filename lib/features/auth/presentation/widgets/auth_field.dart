import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final bool isPassordField;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.isPassordField = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool isObscureText = false;
  @override
  void initState() {
    super.initState();
    isObscureText = widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassordField
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                icon: Icon(
                  isObscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
      obscureText: isObscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
