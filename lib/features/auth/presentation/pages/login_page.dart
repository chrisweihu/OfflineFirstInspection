import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_inspection/core/common/widgets/loader.dart';
import 'package:offline_first_inspection/core/theme/app_pallete.dart';
import 'package:offline_first_inspection/features/auth/presentation/providers/auth_provider.dart';
import 'package:offline_first_inspection/features/auth/presentation/pages/signup_page.dart';
import 'package:offline_first_inspection/features/auth/presentation/widgets/auth_field.dart';
import 'package:offline_first_inspection/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:offline_first_inspection/core/utils/user_notification.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(authProvider.notifier).isUserLoggedIn();
      }
    });
  }

  @override
  void dispose() {
    //dispose all controllers
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthFailureState) {
        context.showSnackBarNotification(
          ErrorNotification(next.message),
        );
      } else if (next is AuthSuccessState) {
        context.showSnackBarNotification(
          const SuccessNotification('Login successfully!'),
        );
      }
    });

    final state = ref.watch(authProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: state is AuthLoadingState
            ? const Loader()
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthField(
                      hintText: 'Email',
                      controller: emailController,
                      key: const ValueKey('login_email'),
                    ),
                    const SizedBox(height: 15),
                    AuthField(
                      hintText: 'Password',
                      controller: passwordController,
                      isPassword: true,
                      key: const ValueKey('login_password'),
                    ),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      buttonText: 'Log In',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(authProvider.notifier).login(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppPallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
