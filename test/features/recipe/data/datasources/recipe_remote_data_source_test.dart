import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:recep_app/core/error/exceptions.dart';
import 'package:recep_app/features/recipe/data/datasources/recipe_remote_data_source.dart';
import 'package:recep_app/features/recipe/data/models/recipe_response.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  RecipeRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = RecipeRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 500));
  }

  group('getRemoteRecipe', () {
    void setUpMockHttpClientSuccess200() {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('recipe.json'), 200));
    }

    final id = '000-000-000';
    final recipeResponse =
        RecipeResponse.fromJson(json.decode(fixture('recipe.json')));

    test(
      '''should perform a GET request on a URL with the recipe id being the
         endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRemoteRecipe(id);
        // assert
        verify(mockHttpClient.get(
          'http://10.0.2.2:8090/recipe/$id',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return Recipe when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRemoteRecipe(id);
        // assert
        expect(result, equals(recipeResponse));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRemoteRecipe;
        // assert
        expect(() => call(id), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getAllRecipes', () {
    void setUpMockHttpClientSuccess200() {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('recipe_list.json'), 200));
    }

    final recipeResponse = [
      RecipeResponse.fromJson(json.decode(fixture('recipe.json')))
    ];

    test(
      '''should perform a GET request on the /all endpoint and with
         application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getAllRemoteRecipes();
        // assert
        verify(mockHttpClient.get(
          'http://10.0.2.2:8090/recipes',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return Recipe when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getAllRemoteRecipes();
        // assert
        expect([result.first], equals(recipeResponse));
      },
    );
  });
}
