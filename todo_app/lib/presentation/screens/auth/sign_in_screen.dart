// screens/auth/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/screens/todo/home_screen.dart';
import 'package:todo_app/blocs/auth/auth_bloc.dart';
import 'package:todo_app/blocs/auth/auth_event.dart';
import 'package:todo_app/blocs/auth/auth_state.dart';
import 'package:todo_app/presentation/screens/auth/sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Expanded Image Logo at the Top
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'lib/assets/union-sign.png', // Replace with your actual image path
                            height: 180,
                            width: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Form fields and Sign In Button at the bottom
                      Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),

                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: Icon(Icons.visibility_off),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8.0),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Handle Forgot Password
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final email = emailController.text;
                                final password = passwordController.text;
                                context.read<AuthBloc>().add(
                                      LoginRequested(email, password),
                                    );
                              }
                            },
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()),
                                  );
                                },
                                child: Text(
                                  'Sign up',
                                  style:
                                      TextStyle(color: Colors.deepOrangeAccent),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.0), // Extra spacing at the bottom
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
