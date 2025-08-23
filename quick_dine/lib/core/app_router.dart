import 'package:go_router/go_router.dart';
import 'package:quick_dine/features/owner/presentation/menu_management_screen.dart';
import 'package:quick_dine/features/owner/presentation/table_schedule_management_screen.dart';
import '../features/common/presentation/splash_screen.dart';
import '../features/common/presentation/welcome_screen.dart';
import '../features/common/presentation/notifications_screen.dart';
import '../features/common/presentation/profile_screen.dart';
import '../features/common/presentation/settings_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/owner/presentation/owner_dashboard_screen.dart';
import '../features/owner/presentation/reports_statistics_screen.dart';
import '../features/owner/presentation/restaurant_setup_screen.dart';
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/customer/presentation/customer_dashboard_screen.dart';
import '../features/customer/presentation/my_reservations_screen.dart';
import '../features/customer/presentation/my_favorites_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/owner-dashboard',
        builder: (context, state) => const OwnerDashboardScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/table-management',
        builder: (context, state) => const TableScheduleManagementScreen(),
      ),
      GoRoute(
        path: '/menu-management',
        builder: (context, state) => const MenuManagementScreen(),
      ),
      GoRoute(
        path: '/reports-statistics',
        builder: (context, state) => const ReportsStatisticsScreen(),
      ),
      GoRoute(
        path: '/restaurant-setup',
        builder: (context, state) => const RestaurantSetupScreen(),
      ),
      GoRoute(
        path: '/customer-dashboard',
        builder: (context, state) => const CustomerDashboardScreen(),
      ),
      GoRoute(
        path: '/my-reservations',
        builder: (context, state) => const MyReservationsScreen(),
      ),
      GoRoute(
        path: '/my-favorites',
        builder: (context, state) => const MyFavoritesScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
    ],
  );
}
