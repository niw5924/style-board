import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/home/home_page.dart';
import 'package:style_board/home/home_page_cubit.dart';
import 'package:style_board/auth/login_page.dart';
import 'package:style_board/photo/photo_page_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  KakaoSdk.init(nativeAppKey: '91b7fda359f04e90e8e17447a18a5432');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        BlocProvider(create: (_) => HomePageCubit()),
        BlocProvider(
          create: (context) => PhotoPageCubit(context.read<AuthProvider>()),
        ),
      ],
      child: const StyleBoard(),
    ),
  );
}

class StyleBoard extends StatelessWidget {
  const StyleBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Style Board',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          surface: const Color(0xFFF7F7F7),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)),
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
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isLoggedIn ? const HomePage() : const LoginPage();
        },
      ),
    );
  }
}
