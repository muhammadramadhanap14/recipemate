import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';

class AccountExistsException implements Exception {
  final String email;
  final AuthCredential? pendingCredential;
  AccountExistsException(this.email, this.pendingCredential);

  @override
  String toString() => 'AccountExistsException: Email $email already exists with different credential.';
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In dibatalkan oleh pengguna.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw AccountExistsException(e.email ?? '', e.credential);
      }
      throw _handleAuthException(e);
    } catch (e) {
      if (e is AccountExistsException || e.toString().contains('dibatalkan')) {
        rethrow;
      }
      throw Exception('Gagal masuk menggunakan Google. Silakan coba lagi.');
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal masuk. Silakan coba lagi.');
    }
  }

  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await sendEmailVerification();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal mendaftar. Silakan coba lagi.');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal mengirim email reset kata sandi.');
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Failed to send email verification: ${e.code} - ${e.message}");
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint("Failed to send email verification: $e");
      throw Exception('Gagal mengirim email verifikasi: $e');
    }
  }

  Future<UserCredential?> linkPendingCredential(AuthCredential credential) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.linkWithCredential(credential);
      }
      throw Exception('Tidak ada pengguna yang masuk.');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal menautkan akun: $e');
    }
  }

  Future<void> linkEmailPassword(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: email.trim(),
          password: password,
        );
        await user.linkWithCredential(credential);
      } else {
        throw Exception('Tidak ada pengguna yang masuk.');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal menambahkan kata sandi: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('Gagal keluar akun. Silakan coba lagi.');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context) : null;
    switch (e.code) {
      case 'invalid-email':
        return l10n?.stEmailInvalid ?? 'Format email tidak valid.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return l10n?.stInvalidCredential ?? 'Email atau password salah.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'email-already-in-use':
        return l10n?.stEmailAlreadyInUse ?? 'Email sudah terdaftar. Silakan gunakan email lain atau masuk.';
      case 'weak-password':
        return l10n?.stPasswordTooShort ?? 'Kata sandi terlalu lemah. Gunakan minimal 8 karakter.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan gagal. Silakan coba lagi nanti.';
      case 'network-request-failed':
        return l10n?.stNoConnectionMessage ?? 'Koneksi internet bermasalah.';
      default:
        return e.message ?? 'Terjadi kesalahan autentikasi.';
    }
  }
}
