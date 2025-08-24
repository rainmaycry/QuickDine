import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum UserRole { customer, owner }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  UserRole selectedRole = UserRole.customer;
  
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
    'businessName': TextEditingController(),
    'businessAddress': TextEditingController(),
  };

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedRole = tabController.index == 0 ? UserRole.customer : UserRole.owner;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void handleSignUp() {
    // Mock sign up process - similar to React version
    final userData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _controllers['name']!.text,
      'email': _controllers['email']!.text,
      'role': selectedRole.toString().split('.').last,
    };
    
    print("Signed up: $userData");
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    // Theme colors matching your React design
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    const secondary = Color(0xFFF5F5F5);
    const inputBackground = Color(0xFFFAFAFA);
    const borderColor = Color(0xFFE5E5E5);

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
                  'Create Account',
                  style: TextStyle(
                    fontSize: 18,
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tabs matching React TabsList design
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      indicatorPadding: const EdgeInsets.all(4),
                      labelColor: primary,
                      unselectedLabelColor: Colors.black54,
                      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      unselectedLabelStyle: const TextStyle(fontSize: 14),
                      tabs: const [
                        Tab(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline, size: 16),
                              SizedBox(width: 8),
                              Text('Customer'),
                            ],
                          ),
                        ),
                        Tab(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.store_outlined, size: 16),
                              SizedBox(width: 8),
                              Text('Owner'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Content cards matching React Card design
                  SizedBox(
                    height: 500, // Fixed height for TabBarView
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        // Customer tab content
                        _buildCustomerCard(primary, inputBackground, borderColor),
                        
                        // Owner tab content  
                        _buildOwnerCard(primary, inputBackground, borderColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Column(
                    children: [
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
                          onPressed: handleSignUp,
                          child: const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: const Text(
                          'Already have an account? Log in',
                          style: TextStyle(
                            color: accent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Color primary, Color inputBackground, Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign up as Customer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Create an account to discover and book tables at your favorite restaurants',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          
          // Card content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _buildFormField('Full Name', 'Enter your full name', _controllers['name']!, primary, inputBackground, borderColor),
                  const SizedBox(height: 16),
                  _buildFormField('Email', 'Enter your email', _controllers['email']!, primary, inputBackground, borderColor, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildFormField('Password', 'Create a password', _controllers['password']!, primary, inputBackground, borderColor, obscureText: true),
                  const SizedBox(height: 16),
                  _buildFormField('Confirm Password', 'Confirm your password', _controllers['confirmPassword']!, primary, inputBackground, borderColor, obscureText: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerCard(Color primary, Color inputBackground, Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign up as Restaurant Owner',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Create an account to manage your restaurant and accept reservations',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          
          // Card content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _buildFormField('Your Name', 'Enter your full name', _controllers['name']!, primary, inputBackground, borderColor),
                  const SizedBox(height: 16),
                  _buildFormField('Restaurant Name', 'Enter restaurant name', _controllers['businessName']!, primary, inputBackground, borderColor),
                  const SizedBox(height: 16),
                  _buildFormField('Restaurant Address', 'Enter restaurant address', _controllers['businessAddress']!, primary, inputBackground, borderColor),
                  const SizedBox(height: 16),
                  _buildFormField('Email', 'Enter your email', _controllers['email']!, primary, inputBackground, borderColor, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildFormField('Password', 'Create a password', _controllers['password']!, primary, inputBackground, borderColor, obscureText: true),
                  const SizedBox(height: 16),
                  _buildFormField('Confirm Password', 'Confirm your password', _controllers['confirmPassword']!, primary, inputBackground, borderColor, obscureText: true),
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
