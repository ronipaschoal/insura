import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:insura/app/app.dart';
import 'package:insura/core/di/injector.dart';

void main() {
  setUp(() {
    setupInjector();
    // `useFakeAuth` may be `false` (real Firebase Auth/Firestore), which
    // needs `Firebase.initializeApp()` — unavailable under `flutter test`.
    // Swap in in-memory fakes so widget tests never touch real Firebase.
    getIt
      ..unregister<FirebaseAuth>()
      ..registerLazySingleton<FirebaseAuth>(MockFirebaseAuth.new)
      ..unregister<FirebaseFirestore>()
      ..registerLazySingleton<FirebaseFirestore>(FakeFirebaseFirestore.new);
  });

  tearDown(resetInjector);

  testWidgets('App starts on the login page', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Bem vindo!'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'CPF'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Senha'), findsOneWidget);
  });
}
