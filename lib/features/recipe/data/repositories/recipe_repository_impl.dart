import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:recep_app/features/recipe/data/datasources/recipe_local_data_source.dart';
import 'package:recep_app/features/recipe/data/datasources/recipe_remote_data_source.dart';
import 'package:recep_app/features/recipe/domain/entities/recipe.dart';
import 'package:recep_app/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:recep_app/features/recipe_list/domain/entities/recipe_list.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RecipeRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Recipe>> getRecipe(
    String id,
  ) async {
    return _remoteOrLocal(remote: () async {
      final remote = await this.remoteDataSource.getRemoteRecipe(id);
      this.localDataSource.cacheRecipe(remote);
      return remote.toEntity();
    }, local: () async {
      final local = await this.localDataSource.getRecipe(id);
      return local.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<RecipeIdentifier>>> getAllRecipes() async {
    return _remoteOrLocal(remote: () async {
      final remote = await this.remoteDataSource.getAllRemoteRecipes();
      remote.map((recipe) async {
        await this.localDataSource.cacheRecipe(recipe);
      }).toList();
      return remote
          .map((recipe) => RecipeIdentifier(id: recipe.id, title: recipe.title))
          .toList();
    }, local: () async {
      final local = await this.localDataSource.getAllRecipes();
      return local
          .map((recipe) => RecipeIdentifier(id: recipe.id, title: recipe.title))
          .toList();
    });
  }

  // I am not entirely sure if this is good or if TS has rotted my brain.
  // However, it does make sense to me and it's a personal project.
  /// Calls [remote] if network is connected,
  /// otherwise falls back to [local]
  Future<Either<Failure, T>> _remoteOrLocal<T>(
      {Future<T> local(), Future<T> remote()}) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remote());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await local());
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }
}
