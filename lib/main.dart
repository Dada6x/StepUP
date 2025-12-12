import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:kyc_test/presentation/layout/mobile/mobile_layout.dart';
import 'package:kyc_test/presentation/pages/auth/bank/bank_screen.dart';
import 'package:kyc_test/presentation/pages/auth/veriff/kyc_verriff.dart';
// import 'package:kyc_test/presentation/layout/mobile/mobile_layout.dart';
import 'package:kyc_test/presentation/pages/introduction_screens/intro_screen.dart';
import 'package:logger/logger.dart';
import 'package:kyc_test/core/app/controller/app_controller.dart';
import 'package:kyc_test/core/constants/themes/app_theme.dart';
import 'package:kyc_test/core/services/network_service.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:local_auth/local_auth.dart';

//! dependency injection
final getIt = GetIt.instance;

//! logger
var logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    methodCount: 0,
    errorMethodCount: 3,
    printEmojis: true,
  ),
);

String LaptopIp = "192.168.43.12";

bool isMobile(BuildContext context) => context.isPhone;
bool isDesktop(BuildContext context) => context.isLandscape;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
}

AppController get app => Get.find<AppController>();
//! main Function
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ! the bits_dojo Package
  //$ App Controller
  Get.put(AppController(), permanent: true);
  logger.i("App Controller has been initialized");
  await setupDependencies();
  //@ Register NetworkService as a GetX service (bound to whole app)
  await Get.putAsync<NetworkService>(
    () async => NetworkService(getIt<Connectivity>()).init(),
  );
  runApp(const MyApp());
}

//! my App
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => Obx(
        () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Step Up ',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: app.themeMode.value,
          // home: ObsidianSplashPage(),
          home: MobileLayout(),
        ),
      ),
    );
  }
}
