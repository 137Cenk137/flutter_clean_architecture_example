import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

Future<Either<Failure, T>> handleRepositoryCallFailure<T>({
  required Future<T> Function() function,
  Failure Function(Object e)? failureMapper,
  Future<Failure> Function()? noInternetConnectionFailureMapper,
}) async {
  try {
    return Right(await function());
  } on ServerExcepiton catch (e) {
    return Left(Failure(e.message.toString()));
  } catch (e) {
    if (failureMapper != null) {
      return Left(failureMapper(e));
    }
    if (noInternetConnectionFailureMapper != null) {
      return Left(await noInternetConnectionFailureMapper());
    }
    return Left(Failure(e.toString()));
  }
}
