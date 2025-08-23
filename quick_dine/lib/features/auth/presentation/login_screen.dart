import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleLogin() {
    // Mock login process - let user choose their role based on email
    String role = 'customer';
    String name = 'John Doe';
    String route = '/customer-dashboard'; // Updated to use customer dashboard
    
    final email = _emailController.text.toLowerCase();
    
    if (email.contains('admin')) {
      role = 'admin';
      name = 'System Administrator';
      route = '/admin-dashboard';
    } else if (email.contains('owner')) {
      role = 'owner';
      name = 'Restaurant Owner';
      route = '/owner-dashboard';
    }
    
    final userData = {
      'id': '1',
      'name': name,
      'email': _emailController.text,
      'role': role,
    };
    
    print("Logged in: $userData");
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    // Theme colors matching your design
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    const inputBackground = Color(0xFFFAFAFA);
    const borderColor = Color(0xFFE5E5E5);
    const mutedForeground = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          // Header matching React design
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: borderColor, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.go('/welcome'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 18,
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Main content - centered card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Login Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor.withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        // Card Header
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Sign in to your QuickDine account',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        // Card Content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            children: [
                              // Email Field
                              _buildFormField(
                                'Email',
                                'Enter your email',
                                _emailController,
                                primary,
                                inputBackground,
                                borderColor,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              
                              // Password Field
                              _buildFormField(
                                'Password',
                                'Enter your password',
                                _passwordController,
                                primary,
                                inputBackground,
                                borderColor,
                                obscureText: true,
                              ),
                              const SizedBox(height: 16),
                              
                              // Forgot Password Link
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () => context.go('/forgot-password'),
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: accent,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Sign In Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: handleLogin,
                                  child: const Text(
                            'Log In',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Demo Mode Helper
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: accent.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: accent.withOpacity(0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Demo Mode:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: mutedForeground,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '• Use any email with "admin" (e.g. admin@quickdine.com) to see Admin Dashboard',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: mutedForeground,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '• Use any email with "owner" (e.g. owner@test.com) to see Restaurant Dashboard',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: mutedForeground,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '• Use any other email to see Customer Dashboard',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Sign Up Link
                              GestureDetector(
                                onTap: () => context.go('/signup'),
                                child: const Text(
                                  'Don\'t have an account? Sign up',
                                  style: TextStyle(
                                    color: accent,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    String placeholder,
    TextEditingController controller,
    Color primary,
    Color inputBackground,
    Color borderColor, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}