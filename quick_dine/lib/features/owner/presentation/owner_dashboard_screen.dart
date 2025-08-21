import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for KPIs
  final Map<String, dynamic> stats = {
    'todayReservations': 24,
    'occupancyRate': 85,
    'averageRating': 4.8,
    'completionRate': 92,
  };

  // Mock reservations data
  final List<Map<String, dynamic>> todayReservations = [
    {
      'id': '1',
      'customerName': 'John Smith',
      'time': '6:00 PM',
      'guests': 2,
      'status': 'confirmed',
      'phone': '(555) 123-4567',
      'notes': 'Anniversary dinner'
    },
    {
      'id': '2',
      'customerName': 'Sarah Johnson',
      'time': '6:30 PM',
      'guests': 4,
      'status': 'pending',
      'phone': '(555) 987-6543',
    },
    {
      'id': '3',
      'customerName': 'Mike Davis',
      'time': '7:00 PM',
      'guests': 3,
      'status': 'confirmed',
      'phone': '(555) 456-7890',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'RO',
                          style: TextStyle(
                            color: accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Restaurant Dashboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                        Text(
                          'Welcome back, Restaurant',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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
                      icon: const Icon(Icons.person_outline, size: 20),
                      color: primary,
                      onPressed: () => context.push('/profile'),
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
                    // Stats Overview - 2x2 grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          "Today's Reservations",
                          "${stats['todayReservations']}",
                          Icons.calendar_today_outlined,
                          accent,
                        ),
                        _buildStatCard(
                          "Occupancy Rate",
                          "${stats['occupancyRate']}%",
                          Icons.people_outline,
                          accent,
                        ),
                        _buildStatCard(
                          "Avg Rating",
                          "${stats['averageRating']}",
                          Icons.star_outline,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          "Completion",
                          "${stats['completionRate']}%",
                          Icons.check_circle_outline,
                          Colors.green,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Quick Actions - 2x2 grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildActionCard(
                          "Menu",
                          Icons.restaurant_menu_outlined,
                          accent,
                        ),
                        _buildActionCard(
                          "Tables",
                          Icons.table_restaurant_outlined,
                          accent,
                        ),
                        _buildActionCard(
                          "Reports",
                          Icons.analytics_outlined,
                          accent,
                        ),
                        _buildActionCard(
                          "Set Up",
                          Icons.edit_outlined,
                          accent,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
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
                          Tab(text: 'Today'),
                          Tab(text: 'Upcoming'),
                          Tab(text: 'Analytics'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Tab content
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTodayTab(),
                          _buildUpcomingTab(),
                          _buildAnalyticsTab(),
                        ],
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: color == const Color(0xFFD4AF6A) ? const Color(0xFF0C1B2A) : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        if (title == "Tables") {
          context.push('/table-management');
        } else if (title == "Menu") {
          context.push('/menu-management');
        } else if (title == "Reports") {
          context.push('/reports-statistics');
        } else if (title == "Set Up") {
          context.push('/restaurant-setup');
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0C1B2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTab() {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Text(
              "Today's Reservations",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${todayReservations.where((r) => r['status'] != 'cancelled').length} active',
                style: TextStyle(
                  fontSize: 12,
                  color: accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Reservations list
        Expanded(
          child: ListView.builder(
            itemCount: todayReservations.length,
            itemBuilder: (context, index) {
              final reservation = todayReservations[index];
              return _buildReservationCard(reservation);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    
    Color getStatusColor(String status) {
      switch (status) {
        case 'confirmed': return Colors.green;
        case 'pending': return Colors.orange;
        case 'completed': return Colors.blue;
        default: return Colors.grey;
      }
    }

    String getInitials(String name) {
      return name.split(' ').map((n) => n[0]).join('').toUpperCase();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Header row
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      getInitials(reservation['customerName']),
                      style: TextStyle(
                        color: accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation['customerName'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reservation['time']} • ${reservation['guests']} guests',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(reservation['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      reservation['status'],
                      style: TextStyle(
                        fontSize: 11,
                        color: getStatusColor(reservation['status']),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Phone
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                reservation['phone'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          // Notes if available
          if (reservation['notes'] != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Note: ${reservation['notes']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // Action buttons
          if (reservation['status'] == 'pending') ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => print('Confirm ${reservation['id']}'),
                    child: const Text('Confirm', style: TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => print('Decline ${reservation['id']}'),
                    child: const Text('Decline', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ] else if (reservation['status'] == 'confirmed') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () => print('Mark completed ${reservation['id']}'),
                child: const Text('Mark as Completed', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: accent.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            "Tomorrow's Schedule",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have 18 reservations scheduled for tomorrow',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => print('View Tomorrow'),
            child: const Text('View Tomorrow'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    const primary = Color(0xFF0C1B2A);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Performance card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E5E5).withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.analytics_outlined, size: 20, color: primary),
                    const SizedBox(width: 8),
                    const Text(
                      "This Week's Performance",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAnalyticsRow('Total Reservations', '142'),
                _buildAnalyticsRow('Average Occupancy', '76%'),
                _buildAnalyticsRow('Average Party Size', '3.2 people'),
                _buildAnalyticsRow('Peak Hour', '7:00 PM - 8:00 PM'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Reviews card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E5E5).withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 20, color: primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Recent Reviews',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF6A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'JD',
                          style: TextStyle(
                            color: Color(0xFFD4AF6A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Jane Doe',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: List.generate(5, (index) => 
                                  const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '"Excellent service and amazing food. Will definitely come back!"',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0C1B2A),
            ),
          ),
        ],
      ),
    );
  }
}
