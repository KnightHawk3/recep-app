import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:recep_app/features/recipe/data/models/recipe_response.dart';
import 'package:recep_app/features/recipe/domain/entities/recipe.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final ingredientResponse = new IngredientResponse(id: 'UUID', name: 'Onion');

  final recipeIngredientResponse = new RecipeIngredientResponse(
      amount: 1,
      unit: 'Cup',
      adjective: 'Diced',
      ingredient: ingredientResponse);

  final recipeResponse = new RecipeResponse(
      id: '000-000-000',
      title: 'Spaghetti Bolgenese',
      ingredients: [recipeIngredientResponse],
      steps: ['Fry the onions in oil', 'Add the tomato\'s to the pan']);

  group('toEntity', () {
    test('ingredientResponse implements toEntity', () async {
      expect(
          ingredientResponse.toEntity(), new Ingredient(id: 'UUID', name: 'Onion'));
    });
    test('recipeIngredientResponse implements toEntity', () async {
      expect(
          recipeIngredientResponse.toEntity(),
          new RecipeIngredient(
              amount: 1,
              unit: 'Cup',
              adjective: 'Diced',
              ingredient: ingredientResponse.toEntity()));
    });
    test('recipeResponse implements toEntity', () async {
      expect(
          recipeResponse.toEntity(),
          new Recipe(
              id: '000-000-000',
              ingredients: [recipeIngredientResponse.toEntity()],
              steps: recipeResponse.steps,
              title: 'Spaghetti Bolgenese'));
    });
  });

  group('fromJson', () {
    test(
      'should parse recipe and child objects',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('recipe.json'));
        final result = RecipeResponse.fromJson(jsonMap);
        expect(result, recipeResponse);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = recipeResponse.toJson();
        final Map<String, dynamic> expectedResult =
            json.decode(fixture('recipe.json'));
        expect(result, expectedResult);
      },
    );
  });
}
