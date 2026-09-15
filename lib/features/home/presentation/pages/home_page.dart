import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/responsive/responsive_scaffold.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_nav_destinations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onDestinationSelected(BuildContext context, int index) {
    context.read<HomeCubit>().selectDestination(index);
    if (index == 1) {
      context.push(
        Uri(
          path: AppRoutes.webview,
          queryParameters: {'url': 'https://example.com', 'title': 'WebView'},
        ).toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return ResponsiveScaffold(
            title: 'Home',
            destinations: homeNavDestinations,
            selectedIndex: state.selectedIndex,
            onDestinationSelected: (index) =>
                _onDestinationSelected(context, index),
            body: const Center(child: Text('Bem-vindo(a)!')),
          );
        },
      ),
    );
  }
}
