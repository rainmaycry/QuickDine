import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void handleResetPassword() {
    // Mock reset password process
    final email = _emailController.text;
    if (email.isNotEmpty) {
      // TODO: Implement Firebase password reset
      print("Password reset sent to: $email");
      
      setState(() {
        _isEmailSent = true;
      });
    }
  }

  void handleSendAgain() {
    // Resend password reset
    final email = _emailController.text;
    print("Password reset resent to: $email");
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset link sent again'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Theme colors matching your design
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    const inputBackground = Color(0xFFFAFAFA);
    const borderColor = Color(0xFFE5E5E5);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          // Header matching other auth screens
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
                  onTap: () => context.go('/login'),
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
                  'Forgot Password',
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
                  // Forgot Password Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor.withOpacity(0.5)),
                    ),
                    child: _isEmailSent ? _buildSuccessContent(primary, accent) : _buildInitialContent(primary, accent, inputBackground, borderColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialContent(Color primary, Color accent, Color inputBackground, Color borderColor) {
    return Column(
      children: [
        // Card Header with Email Icon
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Email Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 30,
                  color: accent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'No worries! Enter your email address and we\'ll send you a reset link.',
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
              const SizedBox(height: 24),
              
              // Send Reset Link Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: handleResetPassword,
                  child: const Text(
                    'Send Reset Link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Back to Login Link
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text(
                  'Remember your password? Sign in',
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
    );
  }

  Widget _buildSuccessContent(Color primary, Color accent) {
    return Column(
      children: [
        // Success Header with Check Icon
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Check Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Check Your Email',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ve sent a password reset link to ${_emailController.text}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Didn\'t receive the email? Check your spam folder or wait a few minutes.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        // Action Buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              // Send Again Button (Outlined)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: handleSendAgain,
                  child: Text(
                    'Send Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Back to Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => context.go('/login'),
                  child: const Text(
                    'Back to Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
