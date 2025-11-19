import 'package:annapurna/core/utils/enums.dart';
import 'package:annapurna/providers/auth_provider.dart';
import 'package:annapurna/view/auth/login.dart';
import 'package:annapurna/view/auth/splash.dart';
import 'package:annapurna/view/dashboard/tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStatusProvider);
    final authData = ref.read(authProvider);
    print("Auth status from Auth wrapper: $authStatus");

    switch (authStatus) {
      case AuthStatus.authenticated:
        return TabsScreen(userName: authData.user.userName);
      case AuthStatus.unauthenticated:
        return const LoginScreen();
      case AuthStatus.unknown:
        return const SplashScreen();
    }
  }
}
