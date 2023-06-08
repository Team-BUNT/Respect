import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:respect/routing_constants.dart';
import 'package:respect/screen/apply_form_screen.dart';
import 'package:respect/screen/event_detail_screen.dart';
import 'package:respect/screen/events_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:provider/provider.dart';
import 'package:respect/utils/form_builder.dart';
import 'amplifyconfiguration.dart';
import 'firebase_options.dart';
import 'model/event.dart';
import 'model/form_field_template.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _configureAmplify();

  KakaoSdk.init(
    nativeAppKey: '2d186b69c58ad09c9ab26dc636f3390a',
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => FormBuilder(
          formFieldList: [FormFieldTemplate()],
        ),
      ),
    ],
    child: const RespectApp(),
  ));
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
      initialRoute: EventScreen.routeName,
      routes: routes,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/event_detail_screen':
            final arguments = settings.arguments as Event;

            return MaterialPageRoute(
              builder: (context) => EventDetailScreen(
                event: arguments,
              ),
            );

          case '/apply_form_screen':
            final arguments = settings.arguments as ApplyFormScreenArguments;

            return MaterialPageRoute(
              builder: (context) => ApplyFormScreen(
                args: arguments,
              ),
            );
        }
        return null;
      },
    );
  }
}
