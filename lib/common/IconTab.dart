import 'package:flutter/material.dart';
import 'package:chat_app/configs/color.config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconTab extends StatelessWidget {
  const IconTab({
    super.key,
    required int currentIndex,
    required this.value,
    required this.index,
  }) : _currentIndex = currentIndex;

  final int _currentIndex;
  final String value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 54,
      width: 54,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: _currentIndex == index
            ? ColorConfig.blue.blue500
            : (isDark ? Color(0x00FFFFFF) : ColorConfig.neutral.neutral50),
        border: Border.all(
          width: 1,
          color: _currentIndex == index
              ? ColorConfig.neutral.neutral600
              : (isDark ? Color(0x00FFFFFF) : ColorConfig.neutral.neutral50),
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: SvgPicture.asset(
        value,
        height: 36,
        width: 36,
        fit: BoxFit.cover,
        color: _currentIndex == index
            ? ColorConfig.neutral.neutral50
            : (isDark
                  ? ColorConfig.neutral.neutral200
                  : ColorConfig.neutral.neutral900),
      ),
    );
  }
}

class TabItem {
  final String label;
  final String iconSvgPath;
  final int index;

  TabItem({
    required this.label,
    required this.iconSvgPath,
    required this.index,
  });
}
