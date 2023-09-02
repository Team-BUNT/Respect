import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxTermListTile extends StatelessWidget {
  const CheckboxTermListTile({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  width: 1.0,
                  color: value ? Colors.black : const Color(0xFFCCCCCC),
                ),
              ),
            ),
            child: Image.asset(
              'asset/icons/checkmark_circle_fill.png',
              width: 20.0,
              height: 20.0,
              color: value ? null : Colors.transparent,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF636366),
              fontSize: 15,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          CupertinoButton(
            minSize: 0.0,
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.right_chevron,
              size: 16.0,
              color: Color(0xFFAEAEB2),
            ),
            onPressed: () {
              debugPrint('DEBUG: tab navigate to $title');
            },
          )
        ],
      ),
      onPressed: () {
        onChanged(!value);
      },
    );
  }
}
