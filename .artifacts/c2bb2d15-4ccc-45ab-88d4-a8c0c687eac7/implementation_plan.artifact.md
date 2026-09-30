# Migration to Firebase Authentication

This plan outlines the steps to migrate the existing Node.js-based authentication system to Firebase Authentication, including Email/Password and Google Sign-In, while maintaining compatibility with the existing GetX state management and Node.js backend for other features.

## User Review Required

> [!IMPORTANT]
> - **Google Sign-In Configuration**: Ensure you have added the SHA-1 and SHA-256 fingerprints to your Firebase Project settings and downloaded the latest `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).
> - **Backend ID Token Verification**: The custom Node.js backend must be updated to verify the Firebase ID Token instead of the legacy JWT token for all protected endpoints.
> - **Firebase Project**: Ensure Email/Password and Google Sign-In providers are enabled in the Firebase Console.

## Proposed Changes

### [Core Auth Service]

#### [NEW] [firebase_auth_service.dart](file:///C:/recipemate/lib/services/firebase_auth_service.dart)
Create a dedicated service to encapsulate all Firebase Auth logic, including:
- Email/Password sign-in and registration.
- Google Sign-In implementation.
- Sign-out logic.
- Mapping `FirebaseAuthException` codes to user-friendly messages.

### [State Management & Session]

#### [MODIFY] [data_session_util_controller.dart](file:///C:/recipemate/lib/utils/data_session_util_controller.dart)
Update the session controller to:
- Listen to `FirebaseAuth.instance.authStateChanges()`.
- Provide a method to retrieve the latest Firebase ID Token to be sent to the backend.
- Update user metadata (name, email, profile image) from the Firebase User object.

#### [MODIFY] [token_interceptor.dart](file:///C:/recipemate/lib/utils/token_interceptor.dart)
Update the interceptor to automatically fetch the latest Firebase ID Token before each request to the custom backend.

### [Authentication Flows]

#### [MODIFY] [login_view_model.dart](file:///C:/recipemate/lib/menus/02_login/view_model/login_view_model.dart)
- Replace legacy login call with `FirebaseAuthService` methods.
- Implement Google Sign-In button logic.
- Update error handling to use Firebase-specific messages.

#### [MODIFY] [register_view_model.dart](file:///C:/recipemate/lib/menus/03_register/view_model/register_view_model.dart)
- Replace legacy register call with `FirebaseAuthService.registerWithEmail`.
- Automatically update the user profile (display name) upon successful registration.

#### [MODIFY] [splash_view_model.dart](file:///C:/recipemate/lib/menus/01_splash/view_model/splash_view_model.dart)
- Change initial auth check from `sessionUtil.getToken()` to `FirebaseAuth.instance.currentUser`.

### [Account Management]

#### [MODIFY] [account_view_model.dart](file:///C:/recipemate/lib/menus/04_home/view_model/account_view_model.dart)
- Update logout logic to include `FirebaseAuth.instance.signOut()` and `GoogleSignIn().signOut()`.

### [Backend Compatibility]

#### [MODIFY] [api_repository.dart](file:///C:/recipemate/lib/repository/api_repository.dart)
- Disable/Comment out `postApiLogin` and `postApiRegister`.
- Ensure other API calls continue to function using the new ID Token.

## Verification Plan

### Automated Tests
- Run `flutter test` (if unit tests exist for auth logic).
- Verify successful initialization of Firebase in `main.dart`.

### Manual Verification
1. **Email/Password Login**: Register a new user, then log in.
2. **Google Sign-In**: Verify the Google picker appears and successful login.
3. **Session Persistence**: Close the app and reopen to verify the user remains logged in.
4. **Logout**: Verify the user is redirected to the login screen and session is cleared.
5. **Error Messages**: Test with wrong password, invalid email, etc., to verify friendly messages.
