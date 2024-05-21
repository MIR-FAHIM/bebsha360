import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final posServiceProvider = Provider((ref) {
  return POSService(ref);
});

abstract class POSRepository {
  Future<Response> store({required Map<String, dynamic> data});
}

class POSService implements POSRepository {
  final Ref ref;
  const POSService(this.ref);
  @override
  Future<Response> store({required Map<String, dynamic> data}) {
    final response = ref.read(apiClientProvider).post(
          AppConstants.posStore,
          data: data,
        );

    return response;
  }
}
