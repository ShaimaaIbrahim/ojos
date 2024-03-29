import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/datasources/local/datasources/cached_extra_glasses_dao.dart';
import 'package:ojos_app/core/entities/extra_glasses_entity.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/params/no_params.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/usecases/get_extra_glasses.dart';
import 'package:ojos_app/features/profile/domin/entities/profile_entity.dart';
import 'package:ojos_app/features/profile/domin/repositories/profile_repository.dart';
import 'package:ojos_app/features/profile/domin/usecases/get_user_details.dart';

import '../../../../main.dart';

@immutable
abstract class SplashState extends Equatable {}

class SplashUninitializedState extends SplashState {
  @override
  String toString() => 'SplashUninitializedState';

  @override
  List<Object> get props => [];
}

class SplashLoadingState extends SplashState {
  @override
  String toString() => 'SplashLoadingState';

  @override
  List<Object> get props => [];
}

class SplashDoneState extends SplashState {
  final ExtraGlassesEntity? extraGlassesEntity;

  SplashDoneState({required this.extraGlassesEntity});

  @override
  String toString() => 'SplashDoneState';

  @override
  List<Object> get props => [];
}

class SplashUserDataDoneState extends SplashState {
  final ProfileEntity? profile;

  SplashUserDataDoneState({required this.profile});

  @override
  String toString() => 'SplashDoneState';

  @override
  List<Object> get props => [];
}

class SplashFailureState extends SplashState {
  final BaseError? error;

  SplashFailureState(this.error);

  @override
  String toString() => 'SplashFailureState';

  @override
  List<Object> get props => [error ?? ''];
}

class SplashUserDataFailureState extends SplashState {
  final BaseError? error;

  SplashUserDataFailureState(this.error);

  @override
  String toString() => 'SplashFailureState';

  @override
  List<Object> get props => [error ?? ''];
}

@immutable
abstract class SplashEvent extends Equatable {}

class SetupSplashEvent extends SplashEvent {
  final CancelToken cancelToken;

  SetupSplashEvent({
    required this.cancelToken,
  });

  @override
  List<Object> get props => [cancelToken];
}

class SetupUserDataEvent extends SplashEvent {
  final CancelToken cancelToken;

  SetupUserDataEvent({
    required this.cancelToken,
  });

  @override
  List<Object> get props => [cancelToken];
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashUninitializedState());
  CachedExtraGlassesDao _glassesDao = CachedExtraGlassesDao();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    print('event event event event : $event');
    if (event is SetupSplashEvent) {
      yield SplashLoadingState();
      try {
        final appInfoResult = await GetExtraGlasses(locator<CoreRepository>())(
          NoParams(cancelToken: event.cancelToken),
        );

        ///=============================  Succeed request app info remote ========================================
        if (appInfoResult.hasDataOnly) {
          final appInfoRemote = appInfoResult.data;

          if (appInfoRemote != null) {
            print('================= App info succeed request ============');
            try {
              await _glassesDao.updateOrInsert(appInfoRemote);
            } catch (e) {}
            yield SplashDoneState(extraGlassesEntity: appInfoRemote);
          }

          ///===============  App info succeed request but data null or empty ======================
          else {
            print(
                '=================Omar -> App info succeed request but data null or empty============');
            final categories = await _glassesDao.getExtraGlasses();

            if (categories != null) {
              print('getExtraGlasses local item ${categories.toJson()}');
              yield SplashDoneState(extraGlassesEntity: categories);
            } else {
              yield await _getCategories(event);
            }
          }
        }

        ///============================= Failed request app info remote ========================================
        else {
          print(
              '=================Omar -> Failed request app info remote ============');
          final categories = await _glassesDao.getExtraGlasses();

          if (categories != null) {
            print('getExtraGlasses local item ${categories.toJson()}');
            yield SplashDoneState(extraGlassesEntity: categories);
          } else {
            yield await _getCategories(event);
          }
        }
      } catch (e) {}
    }
    if (event is SetupUserDataEvent) {
      yield SplashLoadingState();

      final result = await GetUserDetails(locator<ProfileRepository>())(
        NoParams(cancelToken: event.cancelToken),
      );

      ///=============================  Succeed request app info remote ========================================
      if (result.hasDataOnly) {
        yield SplashUserDataDoneState(profile: result.data);
      } else {
        final error = result.error;
        yield SplashUserDataFailureState(error);
      }
    }
  }

  Future<SplashState> _getCategories(SetupSplashEvent event,
      {bool isUpdate = false}) async {
    final resultAll = await GetExtraGlasses(locator<CoreRepository>())(
      NoParams(cancelToken: event.cancelToken),
    );
    if (resultAll.hasDataOnly) {
      final data = resultAll.data;

      if (data != null) {
        try {
          await _glassesDao.updateOrInsert(data);
        } catch (e) {}
      }

      return SplashDoneState(extraGlassesEntity: resultAll.data);
    } else {
      final error = resultAll.error;
      return SplashFailureState(error);
    }
  }
}
