import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:recep_app/features/recipe_list/domain/entities/recipe_list.dart';

@immutable
abstract class RecipeListState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends RecipeListState {}

class Loading extends RecipeListState {}

class Loaded extends RecipeListState {
  final List<RecipeIdentifier> recipes;

  Loaded({@required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class Error extends RecipeListState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
