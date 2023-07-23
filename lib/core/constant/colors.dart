import 'package:flutter/material.dart';

class CColors {
  const CColors._();

  static const neutral0 = Color.fromARGB(255, 255, 255, 255);
  static const neutral25 = Color.fromARGB(255, 249, 249, 249);
  static const neutral50 = Color.fromARGB(255, 242, 242, 242);
  static const neutral100 = Color.fromARGB(255, 230, 230, 230);
  static const neutral200 = Color.fromARGB(255, 204, 204, 204);
  static const neutral300 = Color.fromARGB(255, 179, 179, 179);
  static const neutral400 = Color.fromARGB(255, 153, 153, 153);
  static const neutral500 = Color.fromARGB(255, 128, 128, 128);
  static const neutral600 = Color.fromARGB(255, 102, 102, 102);
  static const neutral700 = Color.fromARGB(255, 77, 77, 77);
  static const neutral800 = Color.fromARGB(255, 51, 51, 51);
  static const neutral900 = Color.fromARGB(255, 26, 26, 26);
  static const neutral1000 = Color.fromARGB(255, 0, 0, 0);

  static const neutral1000t8 = Color.fromARGB(8, 0, 0, 0);
  static const neutral1000t16 = Color.fromARGB(16, 0, 0, 0);
  static const neutral1000t32 = Color.fromARGB(32, 0, 0, 0);
  static const neutral1000t64 = Color.fromARGB(64, 0, 0, 0);
  static const neutral1000t128 = Color.fromARGB(128, 0, 0, 0);

  static const neutral0t8 = Color.fromARGB(8, 255, 255, 255);
  static const neutral0t16 = Color.fromARGB(16, 255, 255, 255);
  static const neutral0t32 = Color.fromARGB(32, 255, 255, 255);
  static const neutral0t64 = Color.fromARGB(64, 255, 255, 255);
  static const neutral0t128 = Color.fromARGB(128, 255, 255, 255);

  static const orangeRedCrayola500 = Color.fromARGB(255, 255, 94, 94);
  static const screaminGreen500 = Color.fromARGB(255, 92, 255, 92);
  static const neonBlue500 = Color.fromARGB(255, 92, 92, 255);
  static const maximumYellowRed500 = Color.fromARGB(255, 255, 201, 92);

  static const transparent = Colors.transparent;

  static const primary = neutral0;
  static const background = neutral1000;
  static const surface = neutral800;
  static const positive = screaminGreen500;
  static const negative = orangeRedCrayola500;
  static const info = neonBlue500;
  static const warning = maximumYellowRed500;
  static const disabled = neutral500;

  static const onPrimary = neutral1000;
  static const onBackground = neutral0;
  static const onSurface = neutral0;
  static const onPositive = neutral1000;
  static const onNegative = neutral1000;
  static const onWarning = neutral1000;
  static const onInfo = neutral0;
  static const onDisabled = neutral400;

  static const defaultTextColor = neutral100;
  static const highlightTextColor = neutral0;

  /// Less emphasis text color.
  static const secondaryTextColor = neutral400;
}
