import 'package:flutter/material.dart';
import 'package:respect/routing_constants.dart';
import 'package:respect/screen/event_detail_screen.dart';
import 'package:respect/screen/events_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'model/event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Respect',
      initialRoute: EventScreen.routeName,
      routes: routes,
      onGenerateRoute: (settings) {
        if (settings.name == EventDetailScreen.routeName) {
          final arguments = settings.arguments as Event;

          return MaterialPageRoute(builder: (context) {
            return EventDetailScreen(event: arguments);
          });
        }
        return null;
      },
    );
  }
}
