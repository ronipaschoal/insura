import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/cpf_input_formatter.dart';
import '../widgets/login_card.dart';
import '../widgets/login_header.dart';
import '../widgets/social_footer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.loginBackgroundDark,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.sizeOf(context).height * 0.42,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.loginGradientStart,
                      AppColors.loginGradientEnd,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    const LoginHeader(),
                    const SizedBox(height: 32),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            context.go(AppRoutes.home);
                          }
                          if (state is LoginError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                          if (state is LoginCredentialsLoaded) {
                            _cpfController.text = CpfInputFormatter()
                                .formatEditUpdate(
                                  TextEditingValue.empty,
                                  TextEditingValue(text: state.cpf),
                                )
                                .text;
                            _passwordController.text = state.password;
                            setState(() => _rememberMe = true);
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is LoginLoading;
                          return LoginCard(
                            cpfController: _cpfController,
                            passwordController: _passwordController,
                            rememberMe: _rememberMe,
                            onRememberMeChanged: (value) =>
                                setState(() => _rememberMe = value ?? true),
                            isLoading: isLoading,
                            onSubmit: isLoading
                                ? null
                                : () => context.read<LoginCubit>().login(
                                    cpf: _cpfController.text.replaceAll(
                                      RegExp(r'\D'),
                                      '',
                                    ),
                                    password: _passwordController.text,
                                    rememberMe: _rememberMe,
                                  ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    const SocialFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
