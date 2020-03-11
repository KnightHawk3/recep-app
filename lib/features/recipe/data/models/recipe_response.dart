import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recep_app/features/recipe/domain/entities/recipe.dart';

part 'recipe_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RecipeResponse extends Equatable {
  final String id;
  final String title;
  @JsonKey(
      fromJson: _$RecipeIngredientResponseFromJson,
      toJson: _$RecipeIngredientResponseToJson)
  final List<RecipeIngredientResponse> ingredients;
  final List<String> steps;

  RecipeResponse(
      {@required this.id, @required this.title, @required this.ingredients, @required this.steps})
      : assert(id != null),
        assert(title != null),
        assert(ingredients != null),
        assert(steps != null);

  Map<String, dynamic> toJson() => _$RecipeResponseToJson(this);

  Recipe toEntity() => Recipe(
      id: id,
      title: title,
      ingredients: ingredients.map((i) => i.toEntity()).toList(),
      steps: steps);

  factory RecipeResponse.fromJson(Map<String, dynamic> json) =>
      _$RecipeResponseFromJson(json);

  @override
  List<Object> get props => [id, title, ingredients, steps];
}

@JsonSerializable(explicitToJson: true)
class RecipeIngredientResponse extends Equatable{
  final int amount;
  final String unit;
  final String adjective;
  final IngredientResponse ingredient;

  RecipeIngredientResponse(
      {@required this.amount,
        @required this.unit,
        @required this.adjective,
        @required this.ingredient})
      : assert(amount != null),
        assert(unit != null),
        assert(adjective != null),
        assert(ingredient != null);

  RecipeIngredient toEntity() => RecipeIngredient(
      amount: amount,
      unit: unit,
      adjective: adjective,
      ingredient: ingredient.toEntity());

  Map<String, dynamic> toJson() => _$RecipeIngredientResponseToJson(this);

  factory RecipeIngredientResponse.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientResponseFromJson(json);

  @override
  List<Object> get props => [amount, unit, adjective, ingredient];
}

@JsonSerializable()
class IngredientResponse extends Equatable{
  final String id;
  final String name;

  IngredientResponse({@required this.id, @required this.name})
      : assert(id != null),
        assert(name != null);

  Map<String, dynamic> toJson() => _$IngredientResponseToJson(this);

  Ingredient toEntity() => Ingredient(id: id, name: name);

  factory IngredientResponse.fromJson(Map<String, dynamic> json) =>
      _$IngredientResponseFromJson(json);

  @override
  List<Object> get props => [id, name];
}
