import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/featured/featured_cubit.dart';
import '../../manager/newest/newest_cubit.dart';



import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<FeaturedCubit>().fetchFeaturedBooks();
          await context.read<NewestCubit>().fetchNewestBooks();
        },
        child: const HomeViewModel(),
      ),
    );
  }
}

