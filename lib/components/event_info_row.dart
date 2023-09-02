import 'package:flutter/material.dart';

class EventInfoRow extends StatelessWidget {
  const EventInfoRow({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    const infoStyle = TextStyle(
      color: Color(0xFF636366),
      fontSize: 15,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
    );
    
    return Row(
      children: [
        SizedBox(
          width: 70.0,
          child: Text(title, style: infoStyle),
        ),
        const SizedBox(width: 4.0),
        Text(
          content,
          style: infoStyle.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
