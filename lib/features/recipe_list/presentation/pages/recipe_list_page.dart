import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recep_app/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:recep_app/features/recipe_list/presentation/bloc/bloc.dart';
import 'package:recep_app/features/recipe_list/presentation/widgets/recipe_list_display.dart';

import '../../../../injection_container.dart';

class RecipeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recep recep!'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<RecipeListBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecipeListBloc>()..add(GetRecipeListEvent()),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<RecipeListBloc, RecipeListState>(
                builder: (context, state) {
                  print(state);
                  if (state is Empty) {
                    return LoadingWidget();
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return RecipeListDisplay(recipes: state.recipes);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                  return MessageDisplay(message: 'Unexpected Event');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
