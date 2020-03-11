import 'package:recep_app/core/error/exceptions.dart';
import 'package:recep_app/core/error/failures.dart';
import 'package:recep_app/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recep_app/features/recipe/data/datasources/recipe_local_data_source.dart';
import 'package:recep_app/features/recipe/data/datasources/recipe_remote_data_source.dart';
import 'package:recep_app/features/recipe/data/models/recipe_response.dart';
import 'package:recep_app/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:recep_app/features/recipe/domain/entities/recipe.dart';

class MockRemoteDataSource extends Mock implements RecipeRemoteDataSource {}

class MockLocalDataSource extends Mock implements RecipeLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

// TODO: Write tests for getAllRecipes
void main() {
  RecipeRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RecipeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getRecipe', () {
    final id = '111-111-111';
    final recipeResponse =
        RecipeResponse(id: '111-111-111', title: 'SpagBol', steps: [
      "a"
    ], ingredients: [
      RecipeIngredientResponse(
          amount: 1,
          unit: 'Cup',
          adjective: 'Diced',
          ingredient: IngredientResponse(id: '1', name: 'Onion'))
    ]);

    final Recipe recipe = recipeResponse.toEntity();

    test(
      'should check if the device is online',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        repository.getRecipe(id);

        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          when(mockRemoteDataSource.getRemoteRecipe(any))
              .thenAnswer((_) async => recipeResponse);

          final result = await repository.getRecipe(id);

          verify(mockRemoteDataSource.getRemoteRecipe(id));
          expect(result, equals(Right(recipe)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          when(mockRemoteDataSource.getRemoteRecipe(any))
              .thenAnswer((_) async => recipeResponse);

          final result = await repository.getRecipe(id);

          verify(mockRemoteDataSource.getRemoteRecipe(id));
          verify(mockLocalDataSource.cacheRecipe(recipeResponse));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          when(mockRemoteDataSource.getRemoteRecipe(any))
              .thenThrow(ServerException());

          final result = await repository.getRecipe(id);

          verify(mockRemoteDataSource.getRemoteRecipe(id));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(mockLocalDataSource.getRecipe(any))
              .thenAnswer((_) async => recipeResponse);

          final result = await repository.getRecipe(id);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getRecipe(id));
          expect(result, equals(Right(recipeResponse)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          when(mockLocalDataSource.getRecipe(any)).thenThrow(CacheException());

          final result = await repository.getRecipe(id);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getRecipe(id));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
