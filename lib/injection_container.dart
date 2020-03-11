import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:path/path.dart';
import 'package:recep_app/features/recipe/data/datasources/recipe_local_data_source.dart';
import 'package:recep_app/features/recipe/data/datasources/recipe_remote_data_source.dart';
import 'package:recep_app/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:recep_app/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:recep_app/features/recipe_list/domain/usecases/get_recipe_list.dart';
import 'package:recep_app/features/recipe_list/presentation/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  sl.registerFactory(() => RecipeListBloc(getRecipeList: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetRecipeList(sl()));

  // Repositories
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<RecipeLocalDataSource>(
    () => RecipeLocalDataSourceImpl(db: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

  final db = await openDatabase(join(await getDatabasesPath(), 'recep.db'),
      onCreate: (db, version) async {
    await db.execute("CREATE TABLE recipes(id TEXT PRIMARY KEY, json TEXT)");
  }, version: 1);
  sl.registerLazySingleton(() => db);
}
