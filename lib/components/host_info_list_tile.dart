import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HostInfoListTile extends StatelessWidget {
  const HostInfoListTile({
    super.key,
    required this.profileUrl,
    required this.role,
    required this.name,
    required this.instaUrl,
  });

  final String profileUrl;
  final String role;
  final String name;
  final String instaUrl;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Color(0xFF8E8E93),
      fontSize: 15,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              profileUrl,
              width: 55.0,
              height: 55.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style: textStyle),
              const SizedBox(height: 8.0),
              Text(
                name,
                style: textStyle.copyWith(
                  color: Colors.black,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Image.asset(
              'asset/icons/insta_button.png',
              width: 40.0,
              height: 40.0,
            ),
            onPressed: () async {
              final uri = Uri.parse(instaUrl);

              if (await canLaunchUrl(uri)) {
                launchUrl(uri);
              }
            },
          ),
        ],
      ),
    );
  }
}
