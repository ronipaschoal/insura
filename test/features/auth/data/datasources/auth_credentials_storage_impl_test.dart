import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/auth/data/datasources/auth_credentials_storage_impl.dart';

void main() {
  late AuthCredentialsStorageImpl storage;

  setUp(() {
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform({});
    storage = AuthCredentialsStorageImpl(const FlutterSecureStorage());
  });

  test('read returns null when nothing was saved', () async {
    expect(await storage.read(), isNull);
  });

  test('save then read round-trips the CPF and password', () async {
    await storage.save(cpf: '12345678909', password: 'insura1234');

    final saved = await storage.read();

    expect(saved, isNotNull);
    expect(saved!.cpf, '12345678909');
    expect(saved.password, 'insura1234');
  });

  test('clear removes previously saved credentials', () async {
    await storage.save(cpf: '12345678909', password: 'insura1234');

    await storage.clear();

    expect(await storage.read(), isNull);
  });

  test('read returns null when only one of the two keys is present', () async {
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform({
      'auth_remember_cpf': '12345678909',
    });
    storage = AuthCredentialsStorageImpl(const FlutterSecureStorage());

    expect(await storage.read(), isNull);
  });
}
