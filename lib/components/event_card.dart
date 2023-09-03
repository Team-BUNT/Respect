import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:intl/intl.dart';
import '../model/event.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final DanceEvent event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.0 / 1.3,
              child: Image.network(
                event.posterURL ?? "",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                decoration: BoxDecoration(
                    color: dDayChipColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6.0)),
                child: Text(
                  'D-${int.parse(event.date?.toDate().difference(DateTime.now()).inDays.toString() ?? "")}',
                  style: dDayChipTextStyle,
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 10.0,
          ),
          child: Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text(
                  event.type ?? "행사 유형",
                  style: eventTypeChipTextStyle,
                ),
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: -4.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                backgroundColor: eventTypeChipColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Wrap(
                spacing: 8,
                children: List.generate(event.genres?.length ?? 0, (index) {
                  return Chip(
                    label: Text(
                      event.genres?[index] ?? "장르",
                      style: genreChipTextStyle,
                    ),
                    labelPadding: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: -4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    backgroundColor: genreChipColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            event.title ?? "행사 명",
            style: curateEventTitleStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Text(
            DateFormat('yyyy.MM.dd').format(event.date!.toDate()),
            style: curateEventDateTextStyle,
          ),
        ),
      ],
    );
  }
}
