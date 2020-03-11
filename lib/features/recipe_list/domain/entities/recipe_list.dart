import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeIdentifier extends Equatable {
  final String id;
  final String title;

  RecipeIdentifier({@required this.id, @required this.title}):
        assert(id != null),
        assert(id.length != 0),
        assert(title != null);

  @override
  List<Object> get props => [id, title];
}

