import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recep_app/core/error/failures.dart';
import 'package:recep_app/core/usecases/usecase.dart';
import 'package:recep_app/features/recipe_list/domain/usecases/get_recipe_list.dart';
import 'package:recep_app/features/recipe_list/domain/entities/recipe_list.dart';
import 'package:recep_app/features/recipe_list/presentation/bloc/bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  final GetRecipeList getRecipeList;

  RecipeListBloc({
    @required this.getRecipeList,
  }) : assert(getRecipeList != null);

  @override
  RecipeListState get initialState => Empty();

  @override
  Stream<RecipeListState> mapEventToState(RecipeListEvent event) async* {
    if (event is GetRecipeListEvent) {
      yield Loading();
      final failureOrRecipes = await getRecipeList(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrRecipes);
    }
  }

  Stream<RecipeListState> _eitherLoadedOrErrorState(
    Either<Failure, List<RecipeIdentifier>> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (recipes) => Loaded(recipes: recipes),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
