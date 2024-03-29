import 'package:dio/dio.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/features/order/data/datasources/order_remote_data_source.dart';
import 'package:ojos_app/features/order/data/models/general_order_item_model.dart';
import 'package:ojos_app/features/order/data/models/order_send_result.dart';
import 'package:ojos_app/features/order/data/requests/order_request.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';
import 'package:ojos_app/features/order/domain/repositories/order_repository.dart';

class ConcreteOrderRepository extends OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  ConcreteOrderRepository(this.remoteDataSource);

  @override
  Future<Result<BaseError, List<GeneralOrderItemEntity>>> getOrders({
    int? pagesize,
    int? page,
    Map<String, String>? filterParams,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.fetchOrders(
      pagesize: pagesize,
      page: page,
      filterParams: filterParams,
      cancelToken: cancelToken,
    );
    return executeForList<GeneralOrderItemModel, GeneralOrderItemEntity>(
      remoteResult: remoteResult,
    );
  }

  @override
  Future<Result<BaseError, Object>> sendOrder({
    required OrderRequest request,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.sendOrder(
      orderRequest: request,
      cancelToken: cancelToken,
    );

    return executeForNoData(
      remoteResult: remoteResult,
    );
  }

  @override
  Future<Result<BaseError, Object>> deleteOrder({
    required int id,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.deleteOrder(
      id: id,
      cancelToken: cancelToken,
    );

    return executeForNoData(
      remoteResult: remoteResult,
    );
  }
}
