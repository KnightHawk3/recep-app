import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RecipeListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetRecipeListEvent extends RecipeListEvent {}
