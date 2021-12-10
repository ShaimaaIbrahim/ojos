import './http_error.dart';

class UnauthorizedHttpError extends HttpError {
  final String? message;

  UnauthorizedHttpError({required this.message});

  @override
  List<Object> get props => [
        message ?? ' message null in UnauthorizedHttpError',
      ];
}
