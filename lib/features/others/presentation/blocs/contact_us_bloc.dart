import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/usecases/contact_us.dart';
import 'package:ojos_app/main.dart';

abstract class ContactUsdState extends Equatable {}

class ContactUsdUninitialized extends ContactUsdState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ContactUsdUninitialized';
}

class ContactUsdLoading extends ContactUsdState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ContactUsdLoading';
}

class ContactUsdSuccess extends ContactUsdState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ContactUsdSuccess';
}

class ContactUsdFailure extends ContactUsdState {
  final BaseError? error;
  final VoidCallback? callback;

  ContactUsdFailure({
    required this.error,
    this.callback,
  });

  @override
  List<Object> get props => [error ?? "", callback ?? ""];

  @override
  String toString() => 'ContactUsdFailure { error: $error }';
}

abstract class BaseContactUsdEvent extends Equatable {}

class ContactUsdEvent extends BaseContactUsdEvent {
  final String? name;
  final String? phone;
  final String? message;
  final CancelToken cancelToken;

  ContactUsdEvent({
    this.name,
    this.message,
    this.phone,
    required this.cancelToken,
  });

  @override
  List<Object> get props => [
        name ?? '',
        cancelToken,
        message ?? "",
        phone ?? "",
      ];

  @override
  String toString() => 'ContactUsdEvent';
}

class ContactUsdBloc extends Bloc<BaseContactUsdEvent, ContactUsdState> {
  ContactUsdBloc() : super(ContactUsdUninitialized());

  @override
  Stream<ContactUsdState> mapEventToState(BaseContactUsdEvent event) async* {
    if (event is ContactUsdEvent) {
      yield ContactUsdLoading();
      final result = await ContactUsUseCase(locator<CoreRepository>())(
        ContactUsParams(
          message: event.message ?? '',
          name: event.name ?? '',
          phone: event.phone ?? '',
          cancelToken: event.cancelToken,
        ),
      );
      if (result.hasDataOnly) {
        yield ContactUsdSuccess();
      }
      if (result.hasErrorOnly) {
        yield ContactUsdFailure(
          error: result.error,
          callback: () {
            this.add(event);
          },
        );
      }
    }
  }
}
