import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:recep_app/core/error/exceptions.dart';
import 'package:recep_app/features/recipe/data/models/recipe_response.dart';
import 'package:sqflite/sqflite.dart';

abstract class RecipeLocalDataSource {
  /// Gets the cached [Recipe] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<RecipeResponse> getRecipe(String id);

  Future<List<RecipeResponse>> getAllRecipes();

  Future<void> cacheRecipe(RecipeResponse recipeToCache);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final tableName = 'recipes';
  final Database db;

  RecipeLocalDataSourceImpl({@required this.db});

  @override
  Future<RecipeResponse> getRecipe(String id) async {
    final map = await this.db.query(tableName, where: "id = ?", whereArgs: [id]);
    return RecipeResponse.fromJson(map.first['json']);
  }

  @override
  Future<List<RecipeResponse>> getAllRecipes() async {
    final maps = await this.db.query(tableName);

    return List.generate(maps.length, (i) {
      return RecipeResponse.fromJson(jsonDecode(maps[i]['json']));
    });
  }

  @override
  Future<void> cacheRecipe(RecipeResponse recipeToCache) async {
    final result = await this.db.insert(
        tableName, {'id': recipeToCache.id, 'json': jsonEncode(recipeToCache.toJson())},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
