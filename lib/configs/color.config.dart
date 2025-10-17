import 'package:flutter/material.dart';

class ColorConfig {
  static BlueColors blue = BlueColors();
  static LightBlueColors lightBlue = LightBlueColors();
  static RedColors red = RedColors();
  static YellowColors yellow = YellowColors();
  static GreenColors green = GreenColors();
  static NeutralColors neutral = NeutralColors();
  static OtherColors other = OtherColors();

  static LightMode lightMode = LightMode();
  static DarkMode darkMode = DarkMode();
}

class LightMode {
  static NeutralColors neutral = NeutralColors();
  static LightBlueColors lightBlue = LightBlueColors();

  final Color primary50 = Color(0xFFFFFFFF);
  final Color neutral900Text = neutral.neutral900;
  final Color neutral100Text = neutral.neutral100;
  final Color neutral500Text = neutral.neutral500;
  final Color lightBlue900Text = lightBlue.lightBlue900;
  final Color lightBlue500Text = lightBlue.lightBlue500;
  final Color neutral100Border = neutral.neutral100;
  final Color neutral100BorderHover = neutral.neutral100;
  final Color bgBottom = Color(0xFF0C386A);
  final Color bgPopup = Color(0xFF092A51);
  final Color bgInput = Color(0xFF092A51);
  final Color bgCard = Color(0xFF092A51);
}

class DarkMode {
  static NeutralColors neutral = NeutralColors();

  final Color primary900 = Color(0xFF292929);
  final Color neutral50Text = neutral.neutral500;
  final Color neutral300Text = neutral.neutral300;
  final Color neutral200Text = neutral.neutral200;
  final Color neutral100Text = neutral.neutral100;
  final Color whiteText = Colors.white;
  final Color neutral400Border = neutral.neutral400;
  final Color neutral300BorderHover = neutral.neutral300;
  final Color bgBottom = neutral.neutral700;
  final Color bgPopup = neutral.neutral700;
  final Color bgInput = Colors.white;
  final Color bgCard = Color(0xFF292929);
}

class BlueColors {
  final Color blue50 = Color(0xFFE8F0F9);
  final Color blue100 = Color(0xFFB6CFEB);
  final Color blue200 = Color(0xFF93B8E2);
  final Color blue300 = Color(0xFF6298D5);
  final Color blue400 = Color(0xFF4484CD);
  final Color blue500 = Color(0xFF1565C0);
  final Color blue600 = Color(0xFF135CAF);
  final Color blue700 = Color(0xFF0F4888);
  final Color blue800 = Color(0xFF0C386A);
  final Color blue900 = Color(0xFF092A51);
}

class LightBlueColors {
  final Color lightBlue50 = Color(0xFFECF9FF);
  final Color lightBlue100 = Color(0xFFC4EDFF);
  final Color lightBlue200 = Color(0xFFA7E4FF);
  final Color lightBlue300 = Color(0xFF7FD7FF);
  final Color lightBlue400 = Color(0xFF66D0FF);
  final Color lightBlue500 = Color(0xFF40C4FF);
  final Color lightBlue600 = Color(0xFF3AB2E8);
  final Color lightBlue700 = Color(0xFF2D8BB5);
  final Color lightBlue800 = Color(0xFF236C8C);
  final Color lightBlue900 = Color(0xFF1B526B);
}

class RedColors {
  final Color red50 = Color(0xFFfeeceb);
  final Color red100 = Color(0xFFfcc5c1);
  final Color red200 = Color(0xFFfaa9a3);
  final Color red300 = Color(0xFFf88178);
  final Color red400 = Color(0xFFf6695e);
  final Color red500 = Color(0xFFf44336);
  final Color red600 = Color(0xFFde3d31);
  final Color red700 = Color(0xFFad3026);
  final Color red800 = Color(0xFF86251e);
  final Color red900 = Color(0xFF661c17);
}

class YellowColors {
  final Color yellow50 = Color(0xFFFFF9E6);
  final Color yellow100 = Color(0xFFFFEEB0);
  final Color yellow200 = Color(0xFFFFE58A);
  final Color yellow300 = Color(0xFFFFD954);
  final Color yellow400 = Color(0xFFFFD233);
  final Color yellow500 = Color(0xFFFFC700);
  final Color yellow600 = Color(0xFFE8B500);
  final Color yellow700 = Color(0xFFB58D00);
  final Color yellow800 = Color(0xFF8C6D00);
  final Color yellow900 = Color(0xFF6B5400);
}

class GreenColors {
  final Color green50 = Color(0xFFE6FAEE);
  final Color green100 = Color(0xFFB0EECA);
  final Color green200 = Color(0xFF8AE6B0);
  final Color green300 = Color(0xFF54DA8C);
  final Color green400 = Color(0xFF33D375);
  final Color green500 = Color(0xFF00C853);
  final Color green600 = Color(0xFF00B64C);
  final Color green700 = Color(0xFF008E3B);
  final Color green800 = Color(0xFF006E2E);
  final Color green900 = Color(0xFF005423);
}

class NeutralColors {
  final Color neutral50 = Color(0xFFF0F0F3);
  final Color neutral100 = Color(0xFFD0D1DB);
  final Color neutral200 = Color(0xFFBABAC9);
  final Color neutral300 = Color(0xFF9A9BB1);
  final Color neutral400 = Color(0xFF8688A1);
  final Color neutral500 = Color(0xFF686A8A);
  final Color neutral600 = Color(0xFF5F607E);
  final Color neutral700 = Color(0xFF4A4B62);
  final Color neutral800 = Color(0xFF393A4C);
  final Color neutral900 = Color(0xFF2C2D3A);
}

class OtherColors {
  final Color other50 = Color(0xFFFFFFFF);
  final Color other100 = Color(0xFF292929);
  final Color other200 = Color(0xFFBABAC9);
  final Color other300 = Color(0xFFBABAC9);
}
