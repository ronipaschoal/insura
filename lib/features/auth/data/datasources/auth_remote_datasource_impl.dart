import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_client.dart';
import '../models/login_response_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._httpClient);

  final HttpClient _httpClient;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data!);
  }
}
