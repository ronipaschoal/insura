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
import '../widgets/home_webview_target.dart';
import '../widgets/home_welcome_banner.dart';

const _sectionTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onDestinationSelected(BuildContext context, int index) {
    // Only "Home/Seguros" (index 0) has a real screen today; the other menu
    // items open the placeholder WebView on top of Home, so the selection
    // stays on Home for when the user comes back.
    if (index == 0) {
      context.read<HomeCubit>().selectDestination(index);
    } else {
      _openWebView(context, homeMenuWebViewItems[index - 1]);
    }
  }

  void _openWebView(BuildContext context, HomeWebViewTarget target) {
    // No dedicated flow per quote category or menu item yet, so all of them
    // land on the same placeholder WebView (its URL lives in app_router.dart);
    // only the app bar's icon and title change, looked up from the id by the
    // route.
    context.push(
      Uri(
        path: AppRoutes.webview,
        queryParameters: {'page': target.id},
      ).toString(),
    );
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
                        HomeQuoteCategories(
                          onCategoryTap: (category) =>
                              _openWebView(context, category),
                        ),
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
