import 'package:dio_request_inspector/data/datasources/local_data_source.dart';
import 'package:dio_request_inspector/data/repositories/dio_request_repository_impl.dart';
import 'package:dio_request_inspector/domain/repositories/dio_request_repository.dart';
import 'package:dio_request_inspector/domain/usecases/get_log_usecase.dart';
import 'package:dio_request_inspector/domain/usecases/save_error_usecase.dart';
import 'package:dio_request_inspector/domain/usecases/save_request_usecase.dart';
import 'package:dio_request_inspector/domain/usecases/save_response_usecase.dart';
import 'package:dio_request_inspector/presentation/dashboard/provider/dashboard_notifier.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  //repositories
  if (!locator.isRegistered<DioRequestRepository>()) {
    locator.registerLazySingleton<DioRequestRepository>(
      () => DioRequestRepositoryImpl(
        localDataSource: LocalDataSourceImpl(),
      ),
    );
  }

  //usecases
  locator.registerLazySingleton<SaveResponseUseCase>(
      () => SaveResponseUseCase(locator()));
  locator.registerLazySingleton<SaveRequestUseCase>(
      () => SaveRequestUseCase(locator()));
  locator.registerLazySingleton<SaveErrorUseCase>(
      () => SaveErrorUseCase(locator()));
  locator.registerLazySingleton<GetLogUseCase>(() => GetLogUseCase(
      DioRequestRepositoryImpl(localDataSource: LocalDataSourceImpl())));

  // provider
  locator.registerLazySingleton<DashboardNotifier>(() => locator());
}
