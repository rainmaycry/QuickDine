import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Mock data - in a real app, this would come from an API
  final Map<String, dynamic> stats = {
    'totalUsers': 2847,
    'totalCustomers': 2456,
    'totalOwners': 391,
    'totalRestaurants': 284,
    'totalReservations': 18654,
    'activeUsersToday': 342,
    'userReports': 23,
    'averagePlatformRating': 4.3,
    'mostPopularRestaurant': 'Bella Vista Italian'
  };

  final List<Map<String, dynamic>> topRestaurants = [
    {'id': '1', 'name': 'Bella Vista Italian', 'reservations': 1247, 'rating': 4.8, 'city': 'New York'},
    {'id': '2', 'name': 'Sushi Zen', 'reservations': 986, 'rating': 4.7, 'city': 'San Francisco'},
    {'id': '3', 'name': 'The Garden Bistro', 'reservations': 873, 'rating': 4.6, 'city': 'Chicago'},
    {'id': '4', 'name': 'Steakhouse Prime', 'reservations': 756, 'rating': 4.5, 'city': 'Los Angeles'}
  ];

  final List<Map<String, dynamic>> recentReports = [
    {
      'id': '1',
      'type': 'complaint',
      'description': 'Restaurant cancelled my reservation without notice',
      'reportedBy': 'Sarah Johnson',
      'reportedAgainst': 'Mario\'s Bistro',
      'status': 'pending',
      'createdAt': '2 hours ago',
      'priority': 'high'
    },
    {
      'id': '2',
      'type': 'bug',
      'description': 'Unable to edit reservation time after booking',
      'reportedBy': 'Mike Chen',
      'status': 'investigating',
      'createdAt': '5 hours ago',
      'priority': 'medium'
    },
    {
      'id': '3',
      'type': 'abuse',
      'description': 'Inappropriate messages from restaurant owner',
      'reportedBy': 'Emma Wilson',
      'reportedAgainst': 'The Garden Cafe',
      'status': 'investigating',
      'createdAt': '1 day ago',
      'priority': 'high'
    }
  ];

  String getInitials(String name) {
    return name.split(' ').map((n) => n[0]).join().toUpperCase();
  }

  Color getReportTypeColor(String type) {
    switch (type) {
      case 'complaint':
        return Colors.yellow.shade100;
      case 'bug':
        return Colors.blue.shade100;
      case 'abuse':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getReportTypeTextColor(String type) {
    switch (type) {
      case 'complaint':
        return Colors.yellow.shade800;
      case 'bug':
        return Colors.blue.shade800;
      case 'abuse':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.yellow.shade100;
      case 'investigating':
        return Colors.blue.shade100;
      case 'resolved':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.yellow.shade800;
      case 'investigating':
        return Colors.blue.shade800;
      case 'resolved':
        return Colors.green.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade100;
      case 'medium':
        return Colors.yellow.shade100;
      case 'low':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getPriorityTextColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade800;
      case 'medium':
        return Colors.yellow.shade800;
      case 'low':
        return Colors.green.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      'SA',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'System Overview',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/notifications'),
                    icon: const Icon(Icons.notifications_outlined),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person_outline),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Top Level Metrics
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: [
                        _buildStatCard(
                          'Total Users',
                          '${stats['totalUsers']}',
                          Icons.people_outline,
                          AppColors.primary,
                        ),
                        _buildStatCard(
                          'Total Restaurants',
                          '${stats['totalRestaurants']}',
                          Icons.business_outlined,
                          AppColors.primary,
                        ),
                        _buildStatCard(
                          'Total Reservations',
                          '${stats['totalReservations']}',
                          Icons.calendar_today_outlined,
                          AppColors.primary,
                        ),
                        _buildStatCard(
                          'User Reports',
                          '${stats['userReports']}',
                          Icons.warning_outlined,
                          Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // User Distribution
                    _buildUserDistributionCard(),
                    const SizedBox(height: 16),
                    // System Activity
                    _buildSystemActivityCard(),
                    const SizedBox(height: 16),
                    // Top Restaurants
                    _buildTopRestaurantsCard(),
                    const SizedBox(height: 16),
                    // Recent Reports
                    _buildRecentReportsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildUserDistributionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people_alt_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'User Distribution',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressRow(
            'Customers',
            stats['totalCustomers'],
            stats['totalUsers'],
          ),
          const SizedBox(height: 12),
          _buildProgressRow(
            'Restaurant Owners',
            stats['totalOwners'],
            stats['totalUsers'],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, int value, int total) {
    double percentage = value / total;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        SizedBox(
          width: 96,
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSystemActivityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'System Activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActivityRow(
            'Active Users Today',
            '${stats['activeUsersToday']}',
            Icons.trending_up,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildActivityRow(
            'Platform Rating',
            '${stats['averagePlatformRating']}',
            Icons.star,
            Colors.amber,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Most Popular',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                stats['mostPopularRestaurant'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String label, String value, IconData icon, Color iconColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopRestaurantsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_outline,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Top Restaurants',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Most popular restaurants by reservations',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ...topRestaurants.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> restaurant = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: index < topRestaurants.length - 1 ? 12 : 0),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant['city'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant['rating']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${restaurant['reservations']} bookings',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentReportsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Reports',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${stats['userReports']} pending',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recentReports.map((report) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: getReportTypeColor(report['type']),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              report['type'],
                              style: TextStyle(
                                fontSize: 10,
                                color: getReportTypeTextColor(report['type']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: getPriorityColor(report['priority']),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              report['priority'],
                              style: TextStyle(
                                fontSize: 10,
                                color: getPriorityTextColor(report['priority']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            report['createdAt'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              const TextSpan(text: 'By: '),
                              TextSpan(
                                text: report['reportedBy'],
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              if (report['reportedAgainst'] != null) ...[
                                const TextSpan(text: '   Against: '),
                                TextSpan(
                                  text: report['reportedAgainst'],
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: getStatusColor(report['status']),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          report['status'],
                          style: TextStyle(
                            fontSize: 10,
                            color: getStatusTextColor(report['status']),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
