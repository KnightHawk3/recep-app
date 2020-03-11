import 'package:flutter/material.dart';
import 'package:recep_app/features/recipe_list/domain/entities/recipe_list.dart';

class RecipeListDisplay extends StatelessWidget {
  final List<RecipeIdentifier> recipes;

  const RecipeListDisplay({
    Key key,
    @required this.recipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: ListView.separated(
            itemCount: recipes.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) => Text(recipes.elementAt(index).title)
        )
    );
  }
}
