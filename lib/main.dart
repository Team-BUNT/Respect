import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:respect/routing_constants.dart';
import 'package:respect/screen/apply_event_screen.dart';
import 'package:respect/screen/event_detail_screen.dart';
import 'package:respect/screen/events_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:respect/screen/login_screen.dart';
import 'amplifyconfiguration.dart';
import 'firebase_options.dart';
import 'model/event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: "hypetown",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _configureAmplify();

  KakaoSdk.init(
    nativeAppKey: '2d186b69c58ad09c9ab26dc636f3390a',
  );

  runApp(const RespectApp());
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, storage]);

    // call Amplify.configure to use the initialized categories in your app
    await Amplify.configure(amplifyconfig);
  } on Exception catch (e) {
    safePrint('An error occurred configuring Amplify: $e');
  }
}

class RespectApp extends StatelessWidget {
  const RespectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Respect',
      initialRoute: LoginScreen.routeName,
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }

  Route<dynamic>? onGenerateRoute(settings) {
    switch (settings.name) {
      case '/event_detail_screen':
        final event = settings.arguments as DanceEvent;

        return MaterialPageRoute(
          builder: (context) => EventDetailScreen(event: event),
        );

      case '/apply_event_screen':
        final event = settings.arguments as DanceEvent;

        return MaterialPageRoute(
          builder: (context) => ApplyEventScreen(event: event),
        );
    }
    return null;
  }
}
