import 'package:dio_request_inspector/data/datasources/local_data_source.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/domain/repositories/dio_request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio_request_inspector/common/failure.dart';
import 'package:dio/dio.dart';

class DioRequestRepositoryImpl implements DioRequestRepository {
  LocalDataSource? localDataSource;

  DioRequestRepositoryImpl({this.localDataSource});

  @override
  Future<Either<Failure, Stream<List<HttpActivity>>>> getListResponse() async {
    final response = localDataSource!.getAllResponse;
    return Right(response);
  }

  @override
  Future<Either<Failure, String>> saveResponse(Response response) async {
    final result = await localDataSource?.saveResponse(response);
    return Right(result!);
  }

  @override
  Future<Either<Failure, String>> saveRequestUseCase(
      RequestOptions options) async {
    final result = await localDataSource?.saveRequest(options);
    return Right(result!);
  }

  @override
  Future<Either<Failure, String>> saveErrorUseCase(DioError error) async {
    final result = await localDataSource?.saveError(error);
    return Right(result!);
  }
  
  @override
  Future<Either<Failure, Stream<List<HttpActivity>>>> clearAllLog() async {
    final response = localDataSource!.clearAllLog();
    return Right(response);
  }

}
