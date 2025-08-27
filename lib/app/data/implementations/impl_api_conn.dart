import 'dart:convert';

import '../../domain/repositories/repository_api_conn.dart';

import '../../../core/errors/dts_http_failure.dart';

import '../../../core/network/aro_result.dart';
import '../../../core/network/dts_api_call.dart';
import '../../../core/network/mdl_api_success.dart';

class APIConnImpl implements ApiConnRepository {
  APIConnImpl(this._getFromAPI);

  final ApiCall _getFromAPI;

  @override
  Future<void> fetchConfig() async {
    ARoResult<ApiFailure, ApiSuccess> response = await _getFromAPI.request(
      bearer: '',
      endpoint: '/api/auth/login-app',
      body: json.encode({"type": ''}),
      epName: 'Response for LogIn/Account: tmp,',
    );

    if (response.isFailure) {
      return;
    } else {
      return;
    }
  }

  @override
  Future<void> fetchTableNiveles() {
    throw UnimplementedError();
  }

  @override
  Future<void> fetchTickets() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendTicket() {
    throw UnimplementedError();
  }
}
