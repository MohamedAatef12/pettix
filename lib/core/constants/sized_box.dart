import 'package:flutter/material.dart';

class SizedBoxConstants {
  // Vertical Spacers
  static const SizedBox verticalSmall = SizedBox(height: 8.0);
  static const SizedBox verticalMedium = SizedBox(height: 16.0);
  static const SizedBox verticalLarge = SizedBox(height: 24.0);
  static const SizedBox verticalExtraLarge = SizedBox(height: 32.0);

  // Horizontal Spacers
  static const SizedBox horizontalSmall = SizedBox(width: 8.0);
  static const SizedBox horizontalMedium = SizedBox(width: 16.0);
  static const SizedBox horizontalLarge = SizedBox(width: 24.0);
  static const SizedBox horizontalExtraLarge = SizedBox(width: 32.0);

  // Zero Spacer
  static const SizedBox zero = SizedBox.shrink();
}
