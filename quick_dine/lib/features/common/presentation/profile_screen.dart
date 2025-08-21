import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;
  
  // Dynamic user data based on role - in real app this would come from state management
  String _name = '';
  String _email = '';
  String _role = '';
  
  // Mock user data for different roles
  final Map<String, Map<String, String>> _userData = {
    'admin': {
      'name': 'System Administrator',
      'email': 'admin@quickdine.com',
      'role': 'admin',
    },
    'owner': {
      'name': 'Restaurant Owner',
      'email': 'owner@test.com',
      'role': 'owner',
    },
    'customer': {
      'name': 'John Customer',
      'email': 'customer@test.com',
      'role': 'customer',
    },
  };
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Don't call _loadUserData here - wait for didChangeDependencies
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now context is fully available, safe to access inherited widgets
    _loadUserData();
  }
  
  void _loadUserData() {
    // In a real app, this would detect the current user's role from authentication/state management
    // For now, we'll detect based on the current route or context
    // Default to admin when coming from admin dashboard
    String currentRole = _detectUserRole();
    
    final userData = _userData[currentRole] ?? _userData['owner']!;
    _name = userData['name']!;
    _email = userData['email']!;
    _role = userData['role']!;
    
    _nameController.text = _name;
    _emailController.text = _email;
  }
  
  String _detectUserRole() {
    // In a real app, this would come from your authentication system
    // For demo purposes, we'll use route-based detection
    
    try {
      // Get the current route to determine user type
      final String? currentRoute = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
      
      // Simple heuristic based on navigation context
      if (currentRoute != null) {
        if (currentRoute.contains('admin') || 
            ModalRoute.of(context)?.settings.name?.contains('admin') == true) {
          return 'admin';
        } else if (currentRoute.contains('owner') || 
                   ModalRoute.of(context)?.settings.name?.contains('owner') == true) {
          return 'owner';
        }
      }
    } catch (e) {
      // If context access fails, fall back to stored role
      print('Error detecting user role from context: $e');
    }
    
    // You can also add a method to switch roles for testing
    // For now, default based on a simple preference or last used role
    return _getStoredUserRole();
  }
  
  String _getStoredUserRole() {
    // In a real app, this would get the role from secure storage or state management
    // For demo, you can manually change this to test different roles:
    // 'admin', 'owner', or 'customer'
    return 'admin'; // Change this to test different roles
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    return name.split(' ').map((n) => n[0]).join('').toUpperCase();
  }

  String _getRoleDisplayName() {
    switch (_role) {
      case 'admin':
        return 'System Administrator';
      case 'owner':
        return 'Restaurant Owner';
      case 'customer':
        return 'Customer';
      default:
        return 'User';
    }
  }

  Color _getRoleColor() {
    const accent = Color(0xFFD4AF6A);
    const primary = Color(0xFF0C1B2A);
    
    switch (_role) {
      case 'admin':
        return primary;
      case 'owner':
        return accent;
      case 'customer':
        return accent;
      default:
        return Colors.grey;
    }
  }

  void _handleSaveProfile() {
    setState(() {
      _name = _nameController.text;
      _email = _emailController.text;
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleUpdatePassword() {
    // Mock password update
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/welcome');
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    const secondary = Color(0xFFF5F5F5);
    const borderColor = Color(0xFFE5E5E5);

    return Scaffold(
      backgroundColor: secondary,
      body: Column(
        children: [
          // Header
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      color: primary,
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, size: 20),
                      color: primary,
                      onPressed: () => context.push('/notifications'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, size: 20),
                      color: primary,
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Tabs section
                    Container(
                      decoration: BoxDecoration(
                        color: secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        indicatorPadding: const EdgeInsets.all(2),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: primary,
                        unselectedLabelColor: Colors.black54,
                        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        tabs: const [
                          Tab(text: 'Profile'),
                          Tab(text: 'Security'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Tab content
                    SizedBox(
                      height: 600,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildProfileTab(),
                          _buildSecurityTab(),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sign Out Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor.withOpacity(0.5)),
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _handleSignOut,
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Sign Out', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    const borderColor = Color(0xFFE5E5E5);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your account details and preferences',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Avatar Section
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: _getRoleColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(_name),
                          style: TextStyle(
                            color: _getRoleColor(),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: accent, width: 1),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 12,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getRoleColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _getRoleColor().withOpacity(0.2)),
                        ),
                        child: Text(
                          _getRoleDisplayName(),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getRoleColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Account Details Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Account Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accent),
                    foregroundColor: accent,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        _nameController.text = _name;
                        _emailController.text = _email;
                      }
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(
                    _isEditing ? Icons.close : Icons.edit_outlined,
                    size: 16,
                  ),
                  label: Text(
                    _isEditing ? 'Cancel' : 'Edit',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Form Fields
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  enabled: _isEditing,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _isEditing ? Colors.white : const Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: accent),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  enabled: _isEditing,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _isEditing ? Colors.white : const Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: accent),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Account Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _getRoleDisplayName(),
                  enabled: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                
                if (_isEditing) ...[
                  const SizedBox(height: 24),
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
                      ),
                      onPressed: _handleSaveProfile,
                      child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTab() {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    const borderColor = Color(0xFFE5E5E5);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Change Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Update your password to keep your account secure',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Password Form
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter current password',
                    filled: true,
                    fillColor: const Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: accent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                    filled: true,
                    fillColor: const Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: accent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Confirm New Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm new password',
                    filled: true,
                    fillColor: const Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: accent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                
                const SizedBox(height: 24),
                
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
                    ),
                    onPressed: _handleUpdatePassword,
                    child: const Text('Update Password', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
