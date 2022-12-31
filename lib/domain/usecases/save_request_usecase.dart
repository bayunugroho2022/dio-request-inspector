import 'package:dio_request_inspector/common/failure.dart';
import 'package:dio_request_inspector/domain/repositories/dio_request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SaveRequestUseCase {
  final DioRequestRepository? repository;

  SaveRequestUseCase(this.repository);

  Future<Either<Failure, String>> execute(RequestOptions options) {
    return repository!.saveRequestUseCase(options);
  }

}