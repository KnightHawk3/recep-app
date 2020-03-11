import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:recep_app/features/recipe/data/models/recipe_response.dart';

import '../../../../core/error/exceptions.dart';

abstract class RecipeRemoteDataSource {
  /// Calls the baseUrl/recipe/{id} endpoint.
  /// Throws a [ServerException] for all error codes.
  Future<RecipeResponse> getRemoteRecipe(String id);

  /// Calls the baseUrl/recipe/all endpoint.
  /// Throws a [ServerException] for all error codes.
  Future<List<RecipeResponse>> getAllRemoteRecipes();
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final http.Client client;

  RecipeRemoteDataSourceImpl({@required this.client});

  @override
  Future<RecipeResponse> getRemoteRecipe(String id) =>
      _getRecipeFromUrl('recipe/$id');

  @override
  Future<List<RecipeResponse>> getAllRemoteRecipes() =>
      _getRecipeListFromUrl('recipes');

  Future<dynamic> _getJsonFromUrl(String url) async {
    final baseUrl = 'http://10.0.2.2:8090/';
    final response = await client.get(
      baseUrl + url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException();
    }
  }

  Future<RecipeResponse> _getRecipeFromUrl(String url) async {
    final json = await _getJsonFromUrl(url);
    return RecipeResponse.fromJson(json);
  }

  Future<List<RecipeResponse>> _getRecipeListFromUrl(String url) async {
    final List<dynamic> json = await _getJsonFromUrl(url);

    return json.map((dynamic model) => RecipeResponse.fromJson(model)).toList();
  }
}
