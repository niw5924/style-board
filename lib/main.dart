import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/home/home_page.dart';
import 'package:style_board/home/home_page_cubit.dart';
import 'package:style_board/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  KakaoSdk.init(nativeAppKey: '91b7fda359f04e90e8e17447a18a5432');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
    return MaterialApp(
      title: 'Style Board',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isLoggedIn ? const HomePage() : const LoginPage();
        },
      ),
    );
  }
}
