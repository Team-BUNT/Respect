import 'package:respect/screen/add_event_screen.dart';
import 'package:respect/screen/apply_form_screen.dart';
import 'package:respect/screen/events_screen.dart';
import 'package:respect/screen/make_form_screen.dart';
import 'package:respect/screen/my_forms_screen.dart';

final routes = {
  EventScreen.routeName: (context) => const EventScreen(),
  AddEventScreen.routeName: (context) => const AddEventScreen(),
  MyFormsScreen.routeName: (context) => const MyFormsScreen(),
  ApplyFormScreen.routeName: (context) => const ApplyFormScreen(),
  // MakeFormScreen.routeName: (context) => const MakeFormScreen(),
};
