import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  // Owner fields
  final TextEditingController businessNameCtrl = TextEditingController();
  final TextEditingController businessAddressCtrl = TextEditingController();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void handleSignUp() {
    final role = tabController.index == 0 ? "customer" : "owner";
    // TODO: hook to Firebase/Auth backend
    print("Signed up as $role");
    context.go('/home'); // redirect after signup
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF6A);
    const darkNavy = Color(0xFF0C1B2A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkNavy),
          onPressed: () => context.go('/welcome'),
        ),
        title: const Text(
          "Create Account",
          style: TextStyle(color: darkNavy),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tabs for roles
          Container(
            color: Colors.grey.shade200,
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: darkNavy,
              unselectedLabelColor: Colors.black54,
              tabs: const [
                Tab(icon: Icon(Icons.person_outline), text: "Customer"),
                Tab(icon: Icon(Icons.store_mall_directory_outlined), text: "Owner"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // Customer form
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField("Full Name", nameCtrl, Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildTextField("Email", emailCtrl, Icons.email_outlined),
                      const SizedBox(height: 16),
                      _buildTextField("Password", passwordCtrl, Icons.lock_outline, obscure: true),
                      const SizedBox(height: 16),
                      _buildTextField("Confirm Password", confirmPasswordCtrl, Icons.lock_outline, obscure: true),
                    ],
                  ),
                ),
                // Owner form
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField("Your Name", nameCtrl, Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildTextField("Restaurant Name", businessNameCtrl, Icons.store),
                      const SizedBox(height: 16),
                      _buildTextField("Restaurant Address", businessAddressCtrl, Icons.location_on_outlined),
                      const SizedBox(height: 16),
                      _buildTextField("Email", emailCtrl, Icons.email_outlined),
                      const SizedBox(height: 16),
                      _buildTextField("Password", passwordCtrl, Icons.lock_outline, obscure: true),
                      const SizedBox(height: 16),
                      _buildTextField("Confirm Password", confirmPasswordCtrl, Icons.lock_outline, obscure: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkNavy,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: handleSignUp,
                    child: const Text("Create Account",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: const Text(
                    "Already have an account? Sign in",
                    style: TextStyle(color: gold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
