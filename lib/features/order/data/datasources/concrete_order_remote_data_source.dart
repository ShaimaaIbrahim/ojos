import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/http/http_method.dart';
import 'package:ojos_app/core/responses/empty_response.dart';
import 'package:ojos_app/features/order/data/api_responses/general_order_item_response.dart';
import 'package:ojos_app/features/order/data/models/general_order_item_model.dart';
import 'package:ojos_app/features/order/data/models/order_send_result.dart';
import 'package:ojos_app/features/order/data/requests/order_request.dart';
import 'order_remote_data_source.dart';
import 'package:dartz/dartz.dart';

class ConcreteOrderRemoteDataSource extends OrderRemoteDataSource {
  @override
  Future<Either<BaseError, List<GeneralOrderItemModel>>> fetchOrders({
    int? pagesize,
    int? page,
    Map<String, String>? filterParams,
    required CancelToken cancelToken,
  }) {
    Map<String, String> queryParams = {};
    if (filterParams != null) {
      filterParams
          .forEach((key, value) => queryParams.putIfAbsent(key, () => value));
    }
    return request<List<GeneralOrderItemModel>, GeneralOrderItemResponse>(
      responseStr: 'GeneralOrderItemResponse',
      converter: (json) => GeneralOrderItemResponse.fromJson(json),
      method: HttpMethod.GET,
      url: API_GET_ORDER,
      queryParameters: queryParams,
      withAuthentication: true,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Either<BaseError, Object>> sendOrder(
      {required OrderRequest orderRequest, required CancelToken cancelToken}) {
    return request<Object, EmptyResponse>(
      responseStr: 'EmptyResponse',
      converter: (json) => EmptyResponse.fromJson(json),
      withAuthentication: true,
      url: API_SEND_ORDER,
      data: orderRequest.toJson(),
      cancelToken: cancelToken,
      method: HttpMethod.POST,
      // filePath: ,
      // fileKey: '',
    );
  }

  @override
  Future<Either<BaseError, Object>> deleteOrder({
    required int id,
    required CancelToken cancelToken,
  }) {
    return request<Object, EmptyResponse>(
      responseStr: 'EmptyResponse',
      converter: (json) => EmptyResponse.fromJson(json),
      method: HttpMethod.DELETE,
      withAuthentication: true,
      url: API_GET_ORDER + "/$id",
      cancelToken: cancelToken,
    );
  }
}
