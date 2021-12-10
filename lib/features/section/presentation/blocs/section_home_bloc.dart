import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/datasources/local/datasources/cached_extra_glasses_dao.dart';
import 'package:ojos_app/core/entities/brand_entity.dart';
import 'package:ojos_app/core/entities/extra_glasses_entity.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/params/no_params.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/usecases/get_brands.dart';
import 'package:ojos_app/core/usecases/get_categories.dart';
import 'package:ojos_app/core/usecases/get_extra_glasses.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/domin/repositories/product_repository.dart';
import 'package:ojos_app/features/product/domin/usecases/get_products.dart';
import 'package:ojos_app/features/section/presentation/args/section_args_home.dart';

import '../../../../main.dart';

@immutable
abstract class SectionHomeState extends Equatable {}

class SectionHomeUninitializedState extends SectionHomeState {
  @override
  String toString() => 'SectionHomeUninitializedState';

  @override
  List<Object> get props => [];
}

class SectionHomeLoadingState extends SectionHomeState {
  @override
  String toString() => 'SectionHomeLoadingState';

  @override
  List<Object> get props => [];
}

class SectionHomeDoneState extends SectionHomeState {
  final List<SectionArgsHome>? sectionArgsHome;

  SectionHomeDoneState({this.sectionArgsHome});

  @override
  String toString() => 'SectionHomeDoneState';

  @override
  List<Object> get props => [];
}

class SectionHomeFailureState extends SectionHomeState {
  final BaseError? error;

  SectionHomeFailureState(this.error);

  @override
  String toString() => 'SectionHomeFailureState';

  @override
  List<Object> get props => [error ?? ''];
}

@immutable
abstract class SectionHomeEvent extends Equatable {}

class GetSectionHomeEvent extends SectionHomeEvent {
  final CancelToken cancelToken;

  GetSectionHomeEvent({
    required this.cancelToken,
  });

  @override
  List<Object> get props => [cancelToken];
}

class SectionHomeBloc extends Bloc<SectionHomeEvent, SectionHomeState> {
  SectionHomeBloc() : super(SectionHomeUninitializedState());
  List<SectionArgsHome> list = [];

  @override
  Stream<SectionHomeState> mapEventToState(SectionHomeEvent event) async* {
    if (event is GetSectionHomeEvent) {
      yield SectionHomeLoadingState();

      final result = await GetCategories(locator<CoreRepository>())(
        NoParams(cancelToken: event.cancelToken),
      );
      if (result.hasDataOnly) {
        if (result.data != null && (result.data?.isNotEmpty ?? false)) {
          for (int i = 0; i < (result.data?.length ?? 0); i++) {
            final resultData = await GetProduct(locator<ProductRepository>())(
              GetProductParams(
                page: 0,
                pagesize: 100,
                filterParams: {
                  "category_id": result.data?[i].id.toString() ?? '-1'
                },
                cancelToken: event.cancelToken,
              ),
            );

            if (resultData.data != null &&
                (resultData.data?.isNotEmpty ?? false)) {
              list.add(SectionArgsHome(
                  list: resultData.data,
                  name: result.data![i].name ?? '',
                  id: result.data![i].id));
            }
          }
          yield SectionHomeDoneState(sectionArgsHome: list);
        }
      } else {
        final error = result.error;
        yield SectionHomeFailureState(error);
      }
    }
  }
}
