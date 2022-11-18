import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_workshop/src/core/config/di/application_controller.dart';
import 'package:flutter_workshop/src/core/config/di/di.dart';
import 'package:flutter_workshop/src/core/config/locale/localizations_delegate.dart';
import 'package:flutter_workshop/src/core/config/route/routes.dart';
import 'package:flutter_workshop/src/core/config/flavor/flavor_config.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_workshop/src/core/config/fcm/fcm_service.dart';

void mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Status bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  // System UI
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );

  // Lock orientation
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // DI
  await initGetX();

  // Firebase initialize
  await Firebase.initializeApp();

  runApp(const MyApp());

  // FCM
  await PushNotificationService().setupInteractedMessage();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final title = "Flutter Demo Home Page";

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      locale: Get.locale,
      supportedLocales: ApplicationController.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      // For 404 page
      // unknownRoute: GetPage(name: '/notfound', page: () => UnknownRoutePage()),
      getPages: Routes.getPageRoutes(),
      initialRoute: "/",
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Flavor: ${FlavorConfig.instance.name}"),
            const Divider(height: 8,),
            Image.asset(
              "assets/show_1.png",
              width: 100,
              height: 100,
              color: Colors.red,
              colorBlendMode: BlendMode.hue,
              repeat: ImageRepeat.noRepeat,
            ),
            Image.network(
              "https://i.pinimg.com/originals/0e/3a/14/0e3a14f24ec57009648910c958f318af.jpg",
              width: 100,
              height: 100,
              headers: const {"Authorization": "Bearer TOKEN"},
            ),
            FadeInImage(
              width: 100,
              height: 100,
              fadeInDuration: const Duration(milliseconds: 700),
              fadeOutDuration: const Duration(milliseconds: 300),
              placeholder: MemoryImage(kTransparentImage),
              image: const NetworkImage(
                "https://i.pinimg.com/originals/0e/3a/14/0e3a14f24ec57009648910c958f318af.jpg",
                headers: {"header": "value"},
              ),
              fit: BoxFit.contain,
            ),
            const LinearProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
