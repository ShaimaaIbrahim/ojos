import 'package:dio/dio.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/repositories/repository.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/features/order/data/requests/order_request.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';

abstract class OrderRepository extends Repository {
  Future<Result<BaseError, List<GeneralOrderItemEntity>>> getOrders({
    int? pagesize,
    int? page,
    Map<String, String>? filterParams,
    required CancelToken cancelToken,
  });
  Future<Result<BaseError, Object>> sendOrder({
    required OrderRequest request,
    required CancelToken cancelToken,
  });

  Future<Result<BaseError, Object>> deleteOrder({
    required int id,
    required CancelToken cancelToken,
  });
}
