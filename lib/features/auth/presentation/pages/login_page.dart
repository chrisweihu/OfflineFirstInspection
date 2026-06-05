import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/core/common/widgets/loader.dart';
import 'package:offline_first_inspection/core/theme/app_pallete.dart';
import 'package:offline_first_inspection/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:offline_first_inspection/features/auth/presentation/pages/signup_page.dart';
import 'package:offline_first_inspection/features/auth/presentation/widgets/auth_field.dart';
import 'package:offline_first_inspection/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:offline_first_inspection/core/utils/user_notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(IsAuthUserLoggedIn());
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailureState) {
              context.showSnackBarNotification(
                ErrorNotification(state.message),
              );
            } else if (state is AuthSuccessState) {
              context.showSnackBarNotification(
                const SuccessNotification('Login successfully!'),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Loader();
            }

            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 50, fontWeight: .bold),
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
                        context.read<AuthBloc>().add(
                          AuthLoginEvent(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
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
                                  fontWeight: .bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
