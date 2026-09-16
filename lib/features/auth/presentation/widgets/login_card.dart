import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'cpf_input_formatter.dart';
import 'pill_text_field.dart';
import 'submit_button.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.cpfController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.isLoading,
    required this.onSubmit,
  });

  final TextEditingController cpfController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final bool isLoading;
  final VoidCallback? onSubmit;

  /// How far the submit button pokes out below the card. `Positioned`
  /// children that overflow a `Stack`'s own bounds aren't hit-testable
  /// (`RenderBox.hitTest` gates on `size.contains(position)` before ever
  /// reaching children), so the card is wrapped in bottom padding of this
  /// same amount to grow the Stack's hit-testable area and keep the
  /// overflowing half of the button tappable.
  static const _buttonOverflow = 28.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: _buttonOverflow),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            decoration: BoxDecoration(
              color: AppColors.loginCardBackground,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        SizedBox(
                          width: 40,
                          height: 2,
                          child: ColoredBox(color: AppColors.loginAccent),
                        ),
                      ],
                    ),
                    SizedBox(width: 24),
                    Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white38, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PillTextField(
                  controller: cpfController,
                  hint: 'CPF',
                  keyboardType: TextInputType.number,
                  inputFormatters: [CpfInputFormatter()],
                ),
                const SizedBox(height: 16),
                PillTextField(
                  controller: passwordController,
                  hint: 'Senha',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: rememberMe,
                        onChanged: onRememberMeChanged,
                        activeColor: AppColors.loginAccent,
                        side: const BorderSide(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Lembrar Sempre',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'Esqueceu a senha?',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppColors.loginAccent,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: SubmitButton(isLoading: isLoading, onPressed: onSubmit),
        ),
      ],
    );
  }
}
