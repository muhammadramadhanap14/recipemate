# Task: Migration to Firebase Authentication

- [ ] Create `firebase_auth_service.dart` to handle Firebase Auth and Google Sign-In logic
- [ ] Update `DataSessionUtilController` to stream auth state changes and update local session values
- [ ] Refactor `LoginViewModel` to use Firebase Auth and handle Google Sign-In
- [ ] Refactor `RegisterViewModel` to use Firebase Auth for Email/Password registration
- [ ] Update `SplashViewModel` to verify session using Firebase Auth current user state
- [ ] Update `AccountViewModel` to include full sign-out logic (Firebase + Google)
- [ ] Update `ApiRepository` to disable legacy auth endpoints and handle Firebase token if needed
- [ ] Verify everything compiles and works correctly
