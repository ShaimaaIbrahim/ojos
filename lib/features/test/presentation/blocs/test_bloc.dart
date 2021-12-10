import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/domin/repositories/product_repository.dart';
import 'package:ojos_app/features/test/domain/usecase/get_test.dart';

import '../../../../main.dart';

@immutable
abstract class TestState extends Equatable {}

class TestUninitializedState extends TestState {
  @override
  String toString() => 'TestUninitializedState';

  @override
  List<Object> get props => [];
}

class TestLoadingState extends TestState {
  @override
  String toString() => 'TestLoadingState';

  @override
  List<Object> get props => [];
}

class TestDoneState extends TestState {
  final List<ProductEntity>? list;

  TestDoneState({this.list});

  @override
  String toString() => 'TestDoneState';

  @override
  List<Object> get props => [];
}

class TestFailureState extends TestState {
  final BaseError? error;

  TestFailureState(this.error);

  @override
  String toString() => 'TestFailureState';

  @override
  List<Object> get props => [error ?? ''];
}

@immutable
abstract class TestEvent extends Equatable {}

class GetTestEvent extends TestEvent {
  final CancelToken cancelToken;
  final Map<dynamic, dynamic>? filterParams;

  GetTestEvent({
    required this.cancelToken,
    this.filterParams,
  });

  @override
  List<Object> get props => [cancelToken];
}

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestUninitializedState());

  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    if (event is GetTestEvent) {
      yield TestLoadingState();

      final result = await GetTest(locator<ProductRepository>())(
        GetTestParams(
            cancelToken: event.cancelToken, filterParams: event.filterParams),
      );
      if (result.hasDataOnly) {
        yield TestDoneState(list: result.data);
      } else {
        final error = result.error;
        yield TestFailureState(error);
      }
    }
  }
}
