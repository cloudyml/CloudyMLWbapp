
import 'dart:async';

//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloudyml_app2/MyAccount/myaccount.dart';
import 'package:cloudyml_app2/Providers/AppProvider.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/Services/database_service.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/models/user_details.dart';
import 'package:cloudyml_app2/models/video_details.dart';
import 'package:cloudyml_app2/my_Courses.dart';
import 'package:cloudyml_app2/offline/offline_videos.dart';
import 'package:cloudyml_app2/screens/splash.dart';
import 'package:cloudyml_app2/services/local_notificationservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

//Recieve message when app is in background ...solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'image',
        channelName: 'CloudyML',
        channelDescription: "CloudyML",
        enableLights: true)
  ]);*/
  LocalNotificationService.initialize();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: "AIzaSyBdAio1wI3RVwl32RoKE7F9GNG_oWBpfbM",
    appId: "1:67056708090:web:f4a43d6b987991016ddc43",
    messagingSenderId: "67056708090",
    projectId: "cloudyml-app",
    databaseURL: "https://cloudyml-app-default-rtdb.firebaseio.com",
    authDomain: "cloudyml-app.firebaseapp.com"));
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StyledToast(
        locale: const Locale('en', 'US'),
        textStyle: TextStyle(
            fontSize: 16.0, color: Colors.white, fontFamily: 'Medium'),
        backgroundColor: Colors.black,
        borderRadius: BorderRadius.circular(30.0),
        textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        toastAnimation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: Offset(0.0, 3.0),
        reverseEndOffset: Offset(0.0, 3.0),
        duration: Duration(seconds: 3),
        animDuration: Duration(milliseconds: 500),
        alignment: Alignment.center,
        toastPositions: StyledToastPosition.bottom,
        curve: Curves.bounceIn,
        reverseCurve: Curves.bounceOut,
        dismissOtherOnShow: true,
        fullWidth: false,
        isHideKeyboard: false,
        isIgnoring: true,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: UserProvider.initialize()),
            ChangeNotifierProvider.value(value: AppProvider()),
            StreamProvider<List<CourseDetails>>.value(
              value: DatabaseServices().courseDetails,
              initialData: [],
            ),
            StreamProvider<List<VideoDetails>>.value(
              value: DatabaseServices().videoDetails,
              initialData: [],
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CloudyML',
            builder: (BuildContext context, Widget? widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return Container();
              };
              return widget!;
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
              // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            ),
            home: splash(),
            routes: {
              "account": (_) => MyAccountPage(),
              "courses": (_) => HomeScreen(),
            },
          ),
        ),
      ),
    );
  }
}

class ScreenController extends StatelessWidget {
  const ScreenController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
