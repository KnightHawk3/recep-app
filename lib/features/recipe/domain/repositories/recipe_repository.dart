import 'package:dartz/dartz.dart';
import 'package:recep_app/core/error/failures.dart';
import 'package:recep_app/features/recipe/domain/entities/recipe.dart';
import 'package:recep_app/features/recipe_list/domain/entities/recipe_list.dart';

abstract class RecipeRepository{
  Future<Either<Failure, Recipe>> getRecipe(String id);
  Future<Either<Failure, List<RecipeIdentifier>>> getAllRecipes();
}
