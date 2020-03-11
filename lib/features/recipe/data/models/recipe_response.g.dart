// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeResponse _$RecipeResponseFromJson(Map<String, dynamic> json) {
  return RecipeResponse(
    id: json['id'] as String,
    title: json['title'] as String,
    ingredients: (json['ingredients'] as List)
        .map(
            (e) => RecipeIngredientResponse.fromJson(e as Map<String, dynamic>))
        .toList(),
    steps: (json['steps'] as List).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$RecipeResponseToJson(RecipeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'steps': instance.steps,
    };

RecipeIngredientResponse _$RecipeIngredientResponseFromJson(
    Map<String, dynamic> json) {
  return RecipeIngredientResponse(
    amount: json['amount'] as int,
    unit: json['unit'] as String,
    adjective: json['adjective'] as String,
    ingredient:
        IngredientResponse.fromJson(json['ingredient'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RecipeIngredientResponseToJson(
        RecipeIngredientResponse instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'unit': instance.unit,
      'adjective': instance.adjective,
      'ingredient': instance.ingredient.toJson(),
    };

IngredientResponse _$IngredientResponseFromJson(Map<String, dynamic> json) {
  return IngredientResponse(
    id: json['id'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$IngredientResponseToJson(IngredientResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
