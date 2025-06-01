import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/auth/login_page.dart';
import 'package:style_board/home/home_page.dart';
import 'package:style_board/home/home_page_cubit.dart';
import 'package:style_board/closet/closet_page_cubit.dart';
import 'package:style_board/styling/styling_page_cubit.dart';
import 'package:style_board/styling/3d/styling_3d_page_cubit.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!);

  final authProvider = AuthProvider();
  await authProvider.checkLoginState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        BlocProvider(create: (_) => HomePageCubit()),
      ],
      child: const StyleBoard(),
    ),
  );
}

class StyleBoard extends StatelessWidget {
  const StyleBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.user?.uid;

    return MaterialApp(
      key: ValueKey(userId),
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Style Board',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEAF3FA),
          surface: const Color(0xFFF7F7F7),
          onSurface: const Color(0xFF333333),
          primary: const Color(0xFF0077CC),
          secondary: const Color(0xFF555555),
          error: const Color(0xFFE53935),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7F7),
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0077CC)),
          titleTextStyle: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFFE3E3E3),
              width: 0.5,
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFF7F7F7),
          selectedItemColor: Color(0xFF0077CC),
          unselectedItemColor: Color(0xFFA0A0A0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0077CC),
            foregroundColor: const Color(0xFFF7F7F7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      home: userId == null
          ? const LoginPage()
          : MultiProvider(
              providers: [
                BlocProvider(
                  key: ValueKey('styling-$userId'),
                  create: (_) => StylingPageCubit(userId),
                ),
                BlocProvider(
                  key: ValueKey('styling3D-$userId'),
                  create: (_) => Styling3DPageCubit(),
                ),
                BlocProvider(
                  key: ValueKey('closet-$userId'),
                  create: (_) => ClosetPageCubit(userId)..loadUserPhotos(),
                ),
              ],
              child: const HomePage(),
            ),
    );
  }
}
