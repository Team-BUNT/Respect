import 'package:provider/provider.dart';
import 'package:respect/screen/add_event_screen.dart';
import 'package:respect/screen/events_screen.dart';
import 'package:respect/screen/events_view_model.dart';
import 'package:respect/screen/sing_in_screen.dart';
import 'package:respect/screen/my_entry_screen.dart';

final routes = {
  EventScreen.routeName: (context) => ChangeNotifierProvider(
        create: (context) => EventsViewModel(),
        child: const EventScreen(),
      ),
  AddEventScreen.routeName: (context) => const AddEventScreen(),
  MyEntryScreen.routeName: (context) => const MyEntryScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
};
