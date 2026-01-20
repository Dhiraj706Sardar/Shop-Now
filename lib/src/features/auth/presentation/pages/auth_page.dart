import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ecommerce_app/src/core/theme/app_theme.dart';
import 'package:ecommerce_app/src/core/widgets/buttons.dart';
import 'package:ecommerce_app/src/core/widgets/text_fields.dart';
import 'package:ecommerce_app/src/router/app_router.dart';
import 'package:ecommerce_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/src/features/auth/presentation/bloc/auth_state.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_loginFormKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            SignInRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  void _onGoogleLogin() {
    context.read<AuthBloc>().add(const SignWithGoogleRequested());
  }

  void _onSignup() {
    if (_signupFormKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.router.replaceAll([const HomeRoute()]);
        } else if (state is AuthEmailVerificationRequired) {
          context.router.push(EmailVerificationRoute(email: state.email));
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingXl),
                // Header
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  'Discover your style with us',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingXxl),

                // Tabs
                Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.textSecondary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign Up'),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXl),

                // Tab View Content
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    return _tabController.index == 0
                        ? _buildLoginForm()
                        : _buildSignupForm();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingMd),
          PasswordTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Forgot password Todo
              },
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return PrimaryButton(
                text: 'Login',
                onPressed: _onLogin,
                isLoading: state is AuthLoading,
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingXl),
          _buildSocialLogin(),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _nameController,
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingMd),
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingMd),
          PasswordTextField(
            label: 'Password',
            hint: 'Create a password',
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingMd),
          PasswordTextField(
            label: 'Confirm Password',
            hint: 'Confirm your password',
            controller: _confirmPasswordController,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingLg),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return PrimaryButton(
                text: 'Sign Up',
                onPressed: _onSignup,
                isLoading: state is AuthLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppTheme.textHint.withOpacity(0.3))),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Text(
                'Or continue with',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(child: Divider(color: AppTheme.textHint.withOpacity(0.3))),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButtonWithBackground(
              icon: Icons.g_mobiledata, // Placeholder for Google
              onPressed: () {
                _onGoogleLogin();
              },
              size: 56,
            ),
            const SizedBox(width: AppTheme.spacingLg),
            IconButtonWithBackground(
              icon: Icons.apple,
              onPressed: () {},
              size: 56,
            ),
          ],
        ),
      ],
    );
  }
}
