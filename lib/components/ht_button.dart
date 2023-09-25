import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class HTButton extends StatelessWidget {
  const HTButton({
    super.key,
    this.icon,
    required this.title,
    this.isLoading,
    this.titleColor,
    this.strokeColor,
    required this.backgroundColor,
    this.onPressed,
  });

  final Image? icon;
  final String title;
  final bool? isLoading;
  final Color? titleColor;
  final Color? strokeColor;
  final Color backgroundColor;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
        side: BorderSide(color: strokeColor ?? Colors.transparent, width: 0.5),
        borderRadius: BorderRadius.circular(12.0),
      )),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: backgroundColor,
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            const SizedBox(width: 5),
            if (isLoading == null || isLoading == false)
              Text(
                title,
                style: Constants.regularNormalTextStyle
                    .copyWith(color: titleColor),
              )
            else
              const SizedBox(
                width: 16.0,
                height: 16.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}
