import 'package:dartz/dartz.dart';
import 'package:recep_app/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:recep_app/features/recipe_list/domain/entities/recipe_list.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetRecipeList implements UseCase<List<RecipeIdentifier>, NoParams> {
  final RecipeRepository repository;

  GetRecipeList(this.repository);

  @override
  Future<Either<Failure, List<RecipeIdentifier>>> call(NoParams params) async {
    final result = await repository.getAllRecipes();
    return result;
  }
}
