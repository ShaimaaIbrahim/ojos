import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/features/cart/domin/entities/coupon_code_entity.dart';
import 'package:ojos_app/features/cart/domin/repositories/cartr_repository.dart';
import 'package:ojos_app/features/cart/domin/usecases/apply_coupon_code.dart';

import '../../../../main.dart';

@immutable
abstract class CouponState extends Equatable {}

class CouponUninitializedState extends CouponState {
  @override
  String toString() => 'CouponUninitializedState';

  @override
  List<Object> get props => [];
}

class CouponLoadingState extends CouponState {
  @override
  String toString() => 'CouponLoadingState';

  @override
  List<Object> get props => [];
}

class CouponDoneState extends CouponState {
  final CouponCodeEntity couponInfo;

  CouponDoneState({required this.couponInfo});

  @override
  String toString() => 'CouponDoneState';

  @override
  List<Object> get props => [];
}

class CouponFailureState extends CouponState {
  final BaseError? error;

  CouponFailureState(this.error);

  @override
  String toString() => 'CouponFailureState';

  @override
  List<Object> get props => [error ?? 'error is null'];
}

@immutable
abstract class CouponEvent extends Equatable {}

class ApplyCouponEvent extends CouponEvent {
  final CancelToken cancelToken;
  final String couponCode;
  final String total;

  ApplyCouponEvent({
    required this.cancelToken,
    required this.total,
    required this.couponCode,
  });

  @override
  List<Object> get props =>
      [cancelToken, total  , couponCode  ];
}

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc() : super(CouponUninitializedState());

  @override
  Stream<CouponState> mapEventToState(CouponEvent event) async* {
    if (event is ApplyCouponEvent) {
      yield CouponLoadingState();

      final result = await ApplyCouponCode(locator<CartRepository>())(
        ApplyCouponCodeParams(
            couponCode: event.couponCode,
            total: event.total,
            cancelToken: event.cancelToken),
      );

      ///=============================  Succeed request app info remote ========================================
      if (result.hasDataOnly) {
        yield CouponDoneState(couponInfo: result.data!);
      } else {
        final error = result.error;
        yield CouponFailureState(error);
      }
    }
  }
}
