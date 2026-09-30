import 'package:firebase_auth/firebase_auth.dart';

class AuthRouteResolver {
  static Future<String> resolveRoute(User? user) async {
    if (user == null) {
      return '/login';
    }

    final isEmailUser = user.providerData.any((p) => p.providerId == 'password');
    if (isEmailUser && !user.emailVerified) {
      try {
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser != null && !refreshedUser.emailVerified) {
          return '/email_verification';
        }
      } catch (_) {}
    }

    return '/home';
  }
}
