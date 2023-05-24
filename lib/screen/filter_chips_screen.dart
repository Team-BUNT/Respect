import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../components/filter_menu_chip.dart';
import '../constants.dart';
import '../model/event_genre.dart';
import '../model/province.dart';

class FilterChipsScreen extends StatefulWidget {
  const FilterChipsScreen(
      {super.key, required this.selectedProvince, required this.selectedGenre});

  final Function(Province province) selectedProvince;
  final Function(EventGenre genre) selectedGenre;

  @override
  State<FilterChipsScreen> createState() => _FilterChipsScreenState();
}

class _FilterChipsScreenState extends State<FilterChipsScreen> {
  Province selectedProvince = Province.all;
  EventGenre selectedGenre = EventGenre.all;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          PullDownButton(
            itemBuilder: (context) => Province.values.map((province) {
              return PullDownMenuItem.selectable(
                onTap: () {
                  widget.selectedProvince(province);
                  setState(() {
                    selectedProvince = province;
                  });
                },
                title: province.convertToString,
              );
            }).toList(),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: FilterMenuChip(chipName: selectedProvince.convertToString),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          PullDownButton(
            itemBuilder: (context) => EventGenre.values.map((genre) {
              return PullDownMenuItem.selectable(
                onTap: () {
                  widget.selectedGenre(genre);
                  setState(() {
                    selectedGenre = genre;
                  });
                },
                title: genre.convertToString,
              );
            }).toList(),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: FilterMenuChip(chipName: selectedGenre.convertToString),
            ),
          ),
          const Spacer(),
          const Text(
            'D-day 순',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: dDayTextColor,
              fontFamily: 'Pretendard',
            ),
          )
        ],
      ),
    );
  }
}
