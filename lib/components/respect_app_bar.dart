import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:respect/screen/add_event_screen.dart';
import '../constants.dart';
import '../model/event_type.dart';

class RespectAppBar extends StatefulWidget implements PreferredSizeWidget {
  const RespectAppBar({super.key, required this.onSelected});

  final Function(int typeIndex) onSelected;

  @override
  State<RespectAppBar> createState() => _RespectAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(92.0);
}

class _RespectAppBarState extends State<RespectAppBar>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: EventType.values.length,
      vsync: this,
      // animationDuration: Duration.zero,
    );
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      widget.onSelected(tabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Image.asset(
        'asset/logos/AppLogo.png',
        fit: BoxFit.fitWidth,
        width: 115,
      ),
      actions: [
        CupertinoButton(
          child: const Icon(
            CupertinoIcons.add,
            size: 22.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              AddEventScreen.routeName,
            );
          },
        )
      ],
      bottom: TabBar(
        controller: tabController,
        isScrollable: true,
        indicatorColor: Colors.black,
        tabs: EventType.values.map((type) {
          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                type.convertToString,
                style: tabController.index == type.index
                    ? selectedTabTextStyle
                    : unselectedTabTextStyle,
              ),
            ),
          );
        }).toList(),
      ),
      elevation: 0.1,
      backgroundColor: Colors.white,
    );
  }
}
