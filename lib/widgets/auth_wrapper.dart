import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/main_screen.dart';
import '../screens/login_page.dart';
import '../theme/app_colors.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    developer.log('AUTH_WRAPPER: Building AuthWrapper', name: 'AuthWrapper');
    
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Log the current snapshot state
        developer.log(
          'AUTH_WRAPPER: AuthState: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, user: ${snapshot.data?.uid}', 
          name: 'AuthWrapper'
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          developer.log('AUTH_WRAPPER: User authenticated, navigating to MainScreen', name: 'AuthWrapper');
          return const MainScreen();
        }
        
        developer.log('AUTH_WRAPPER: User not authenticated, showing LoginPage', name: 'AuthWrapper');
        return const LoginPage();
      },
    );
  }
}
