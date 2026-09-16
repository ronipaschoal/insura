import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/responsive/responsive_scaffold.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_nav_destinations.dart';
import '../widgets/home_placeholder_card.dart';
import '../widgets/home_quote_categories.dart';
import '../widgets/home_welcome_banner.dart';

const _sectionTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onDestinationSelected(BuildContext context, int index) {
    context.read<HomeCubit>().selectDestination(index);
    // Only "Home/Seguros" (index 0) has a real screen today; the rest of
    // the menu items from the new nav design have no feature built yet.
    if (index != 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Em breve!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.loggedOut) {
            context.go(AppRoutes.login);
          }
        },
        builder: (context, state) {
          return ResponsiveScaffold(
            destinations: homeNavDestinations,
            userName: state.userName,
            selectedIndex: state.selectedIndex,
            onDestinationSelected: (index) =>
                _onDestinationSelected(context, index),
            onLogout: () => context.read<HomeCubit>().logout(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeWelcomeBanner(userName: state.userName),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cotar e Contratar',
                          style: _sectionTitleStyle,
                        ),
                        const SizedBox(height: 12),
                        const HomeQuoteCategories(),
                        const SizedBox(height: 28),
                        const Text('Minha Família', style: _sectionTitleStyle),
                        const SizedBox(height: 12),
                        const HomePlaceholderCard(
                          icon: Icons.add_circle_outline,
                          message:
                              'Adicione aqui membros da sua família e '
                              'compartilhe os seguros com eles.',
                        ),
                        const SizedBox(height: 28),
                        const Text('Contratados', style: _sectionTitleStyle),
                        const SizedBox(height: 12),
                        const HomePlaceholderCard(
                          icon: Icons.sentiment_dissatisfied_outlined,
                          message: 'Você ainda não possui seguros contratados.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
