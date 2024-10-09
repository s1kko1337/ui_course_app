import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class ButtonStyles {
  static ButtonStyle elevatedButtonStyle(RootColors colors) {
    return ElevatedButton.styleFrom(
      foregroundColor: colors.CardBaldCol,
      backgroundColor: colors.IconActiveCol, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), 
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 30, vertical: 15), 
    );
  }
}
