import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const AuthGradientButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: LinearGradient(
          colors: [
            AppPallete.gradient1,
            AppPallete.gradient2,
            AppPallete.gradient3,
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(390, 50),
          foregroundColor: AppPallete.whiteColor,
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
