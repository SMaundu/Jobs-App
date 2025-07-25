import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:country_codes/country_codes.dart';

import 'app/core/theme/app_theme.dart';
import 'app/di/locator.dart';
import 'app/modules/auth/bindings/auth_binding.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/auth/views/login/login_view.dart';
import 'app/modules/root/views/root_view.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const JobsFlutterApp());
}

class JobsFlutterApp extends StatelessWidget {
  const JobsFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GetMaterialApp(
        locale: Get.locale,
        debugShowCheckedModeBanner: false,
        initialBinding: AuthBinding(),
        home: const SplashScreen(),
        getPages: AppPages.routes,
        theme: AppTheme.lightTheme,
        defaultTransition: Transition.cupertino,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Run initializations in parallel to improve startup time
    await Future.wait([
      GetStorage.init(),
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
      if (!kIsWeb)
        CountryCodes.init().catchError((e) {
          debugPrint("CountryCodes init failed: $e");
        }),
    ]);

    // After initialization, navigate to the main app screen
    Get.off(() => const _AuthWrapper());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _AuthWrapper extends GetView<AuthController> {
  const _AuthWrapper();

  @override
  Widget build(BuildContext context) {
    // TODO: Re-enable authentication check when ready.
    // The original logic was:
    // return Obx(() => controller.currentUser != null ? RootView() : LoginView());
    return RootView();
  }
}
