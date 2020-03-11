import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;

  Recipe(
      {@required this.id, @required this.title, @required this.ingredients, @required this.steps})
      : assert(id != null),
        assert(title != null),
        assert(ingredients != null),
        assert(steps != null);

  @override
  List<Object> get props => [id, title, ingredients, steps];
}

class RecipeIngredient extends Equatable {
  final int amount;
  final String unit;
  final String adjective;
  final Ingredient ingredient;

  RecipeIngredient({this.amount, this.unit, this.adjective, this.ingredient})
      : assert(amount != null),
        assert(unit != null),
        assert(adjective != null),
        assert(ingredient != null);

  @override
  List<Object> get props => [amount, unit, adjective, ingredient];
}

class Ingredient extends Equatable {
  final String id;
  final String name;

  Ingredient({@required this.id, @required this.name})
      : assert(id != null),
        assert(name != null);

  @override
  List<Object> get props => [id, name];
}
