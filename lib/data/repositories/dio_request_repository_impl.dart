import 'package:dio_request_inspector/data/datasources/local_data_source.dart';
import 'package:dio_request_inspector/data/mappers/mapper.dart';
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
    try {
      final response = localDataSource!.getAllResponse;
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveResponse(Response response) async {
    try {
      final result =
          await localDataSource!.saveResponse(response.toHttpResponse());
      return Right(result);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveRequest(RequestOptions options) async {
    try {
      final result =
          await localDataSource!.saveRequest(options.toHttpRequest());
      return Right(result);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveError(DioException e) async {
    try {
      final result = await localDataSource!
          .saveError(e.toHttpError(), e.toHttpErrorFromResponse());
      return Right(result);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stream<List<HttpActivity>>>> clearAllLog() async {
    try {
      final result = localDataSource!.clearAllLog();
      return Right(result);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
