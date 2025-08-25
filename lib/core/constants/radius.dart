import 'package:flutter/material.dart';

class RadiusConstants {
  // Uniform BorderRadius
  static const BorderRadius small = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius large = BorderRadius.all(Radius.circular(24.0));
  static const BorderRadius extraLarge = BorderRadius.all(
    Radius.circular(32.0),
  );

  // Circular BorderRadius
  static const BorderRadius circular = BorderRadius.all(Radius.circular(50.0));
  static const BorderRadius none = BorderRadius.zero;

  // Specific Corner BorderRadius (Only one corner)
  static const BorderRadius topLeft = BorderRadius.only(
    topLeft: Radius.circular(16.0),
  );
  static const BorderRadius topRight = BorderRadius.only(
    topRight: Radius.circular(16.0),
  );
  static const BorderRadius bottomLeft = BorderRadius.only(
    bottomLeft: Radius.circular(16.0),
  );
  static const BorderRadius bottomRight = BorderRadius.only(
    bottomRight: Radius.circular(16.0),
  );

  // Combinations of Two Corners
  static const BorderRadius topCorners = BorderRadius.only(
    topLeft: Radius.circular(16.0),
    topRight: Radius.circular(16.0),
  );

  static const BorderRadius bottomCorners = BorderRadius.only(
    bottomLeft: Radius.circular(16.0),
    bottomRight: Radius.circular(16.0),
  );

  static const BorderRadius leftCorners = BorderRadius.only(
    topLeft: Radius.circular(16.0),
    bottomLeft: Radius.circular(16.0),
  );

  static const BorderRadius rightCorners = BorderRadius.only(
    topRight: Radius.circular(16.0),
    bottomRight: Radius.circular(16.0),
  );

  // Asymmetric BorderRadius
  static const BorderRadius asymmetric = BorderRadius.only(
    topLeft: Radius.circular(8.0),
    topRight: Radius.circular(16.0),
    bottomLeft: Radius.circular(24.0),
    bottomRight: Radius.circular(32.0),
  );
}
