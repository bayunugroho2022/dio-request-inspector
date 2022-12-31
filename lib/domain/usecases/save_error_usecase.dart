import 'package:dio_request_inspector/common/failure.dart';
import 'package:dio_request_inspector/domain/repositories/dio_request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SaveErrorUseCase {
  final DioRequestRepository? repository;

  SaveErrorUseCase(this.repository);

  Future<Either<Failure, String>> execute(DioError error) {
    return repository!.saveErrorUseCase(error);
  }
}
