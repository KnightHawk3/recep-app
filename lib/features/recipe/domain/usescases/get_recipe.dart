import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:recep_app/features/recipe/domain/entities/recipe.dart';
import 'package:recep_app/features/recipe/domain/repositories/recipe_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetRecipe implements UseCase<Recipe, Params> {
  final RecipeRepository repository;

  GetRecipe(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(Params params) async {
    return await repository.getRecipe(params.id);
  }
}

class Params extends Equatable {
  final String id;

  Params({this.id})
      : assert(id != null),
        assert(id.length != 0);

  @override
  List<Object> get props => [id];
}
