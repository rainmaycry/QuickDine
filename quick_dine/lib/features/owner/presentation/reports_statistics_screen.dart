import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ReportsStatisticsScreen extends StatefulWidget {
  const ReportsStatisticsScreen({super.key});

  @override
  State<ReportsStatisticsScreen> createState() => _ReportsStatisticsScreenState();
}

class _ReportsStatisticsScreenState extends State<ReportsStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Week';

  // Mock data - in a real app, this would come from an API
  final Map<String, int> reservationStats = {
    'total': 156,
    'confirmed': 128,
    'completed': 98,
    'cancelled': 18,
    'noShows': 12,
    'pending': 8,
  };

  final List<Map<String, dynamic>> weeklyData = [
    {'date': 'Mon', 'reservations': 18, 'occupancyRate': 72, 'avgPartySize': 3.2},
    {'date': 'Tue', 'reservations': 22, 'occupancyRate': 68, 'avgPartySize': 2.8},
    {'date': 'Wed', 'reservations': 26, 'occupancyRate': 78, 'avgPartySize': 3.5},
    {'date': 'Thu', 'reservations': 24, 'occupancyRate': 82, 'avgPartySize': 3.1},
    {'date': 'Fri', 'reservations': 35, 'occupancyRate': 95, 'avgPartySize': 3.8},
    {'date': 'Sat', 'reservations': 42, 'occupancyRate': 98, 'avgPartySize': 4.2},
    {'date': 'Sun', 'reservations': 28, 'occupancyRate': 85, 'avgPartySize': 3.6},
  ];

  final List<Map<String, dynamic>> timeSlotData = [
    {'time': '5:00 PM', 'reservations': 12, 'occupancyRate': 60},
    {'time': '5:30 PM', 'reservations': 15, 'occupancyRate': 75},
    {'time': '6:00 PM', 'reservations': 18, 'occupancyRate': 90},
    {'time': '6:30 PM', 'reservations': 20, 'occupancyRate': 100},
    {'time': '7:00 PM', 'reservations': 22, 'occupancyRate': 100},
    {'time': '7:30 PM', 'reservations': 20, 'occupancyRate': 100},
    {'time': '8:00 PM', 'reservations': 16, 'occupancyRate': 80},
    {'time': '8:30 PM', 'reservations': 12, 'occupancyRate': 60},
    {'time': '9:00 PM', 'reservations': 8, 'occupancyRate': 40},
  ];

  final List<Map<String, dynamic>> topCustomers = [
    {'name': 'Sarah Johnson', 'visits': 12, 'avgPartySize': 4, 'lastVisit': '2 days ago', 'initials': 'SJ'},
    {'name': 'Mike Davis', 'visits': 8, 'avgPartySize': 2, 'lastVisit': '1 week ago', 'initials': 'MD'},
    {'name': 'Emily Wilson', 'visits': 6, 'avgPartySize': 3, 'lastVisit': '3 days ago', 'initials': 'EW'},
    {'name': 'John Smith', 'visits': 5, 'avgPartySize': 2, 'lastVisit': '5 days ago', 'initials': 'JS'},
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

  int getCompletionRate() {
    return ((reservationStats['completed']! / reservationStats['total']!) * 100).round();
  }

  int getCancellationRate() {
    return (((reservationStats['cancelled']! + reservationStats['noShows']!) / reservationStats['total']!) * 100).round();
  }

  int getAverageOccupancy() {
    return (weeklyData.map((day) => day['occupancyRate'] as int).reduce((a, b) => a + b) / weeklyData.length).round();
  }

  String getPeakHour() {
    var peak = timeSlotData.reduce((peak, slot) => 
      slot['reservations'] > peak['reservations'] ? slot : peak
    );
    return peak['time'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reports & Statistics',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _selectedPeriod,
              underline: const SizedBox(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              items: ['Week', 'Month', 'Quarter'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPeriod = newValue!;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.accent),
            onPressed: () {
              // Export functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppColors.accent,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Occupancy'),
                Tab(text: 'Customers'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildOccupancyTab(),
                _buildCustomersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Key Metrics
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                'Total Reservations',
                '${reservationStats['total']}',
                Icons.calendar_today,
                AppColors.accent,
              ),
              _buildMetricCard(
                'Avg Occupancy',
                '${getAverageOccupancy()}%',
                Icons.people,
                AppColors.accent,
              ),
              _buildMetricCard(
                'Completion Rate',
                '${getCompletionRate()}%',
                Icons.check_circle,
                Colors.green,
              ),
              _buildMetricCard(
                'Peak Hour',
                getPeakHour(),
                Icons.access_time,
                AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Reservation Status Breakdown
          _buildStatusBreakdownCard(),
          const SizedBox(height: 20),
          
          // Weekly Trend
          _buildWeeklyTrendCard(),
        ],
      ),
    );
  }

  Widget _buildOccupancyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPeakHoursCard(),
          const SizedBox(height: 20),
          _buildOccupancyInsightsCard(),
        ],
      ),
    );
  }

  Widget _buildCustomersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCustomerAnalyticsCard(),
          const SizedBox(height: 20),
          _buildTopCustomersCard(),
          const SizedBox(height: 20),
          _buildCustomerSatisfactionCard(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reservation Status Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Current week overview',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusItem('Completed', reservationStats['completed']!, Colors.green),
          _buildStatusItem('Confirmed', reservationStats['confirmed']!, Colors.blue),
          _buildStatusItem('Cancelled', reservationStats['cancelled']!, Colors.red),
          _buildStatusItem('No Shows', reservationStats['noShows']!, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, int value, Color color) {
    int percentage = ((value / reservationStats['total']!) * 100).round();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Reservations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Reservations by day of week',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ...weeklyData.map((day) => _buildWeeklyItem(day)).toList(),
        ],
      ),
    );
  }

  Widget _buildWeeklyItem(Map<String, dynamic> day) {
    Color occupancyColor = day['occupancyRate'] >= 90 
        ? Colors.green 
        : day['occupancyRate'] >= 70 
            ? Colors.orange 
            : Colors.red;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              day['date'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (day['reservations'] as int) / 45,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Text(
            '${day['reservations']}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: occupancyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${day['occupancyRate']}%',
              style: TextStyle(
                fontSize: 12,
                color: occupancyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeakHoursCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peak Hours Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Occupancy rates by time slot',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ...timeSlotData.map((slot) => _buildTimeSlotItem(slot)).toList(),
        ],
      ),
    );
  }

  Widget _buildTimeSlotItem(Map<String, dynamic> slot) {
    Color barColor = slot['occupancyRate'] == 100 
        ? Colors.red 
        : slot['occupancyRate'] >= 80 
            ? Colors.orange 
            : Colors.green;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              slot['time'],
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          Expanded(
            child: Container(
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (slot['occupancyRate'] as int) / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
          Text(
            '${slot['reservations']} res',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: barColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${slot['occupancyRate']}%',
              style: TextStyle(
                fontSize: 12,
                color: barColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Occupancy Insights',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightRow('Busiest Time', '7:00 PM - 7:30 PM'),
          _buildInsightRow('Quietest Time', '5:00 PM - 5:30 PM'),
          _buildInsightRow('Average Table Turn', '1.8 times/night'),
          _buildInsightRow('Optimal Capacity', '85% occupancy'),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAnalyticsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Analytics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Customer behavior insights',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '3.4',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Avg Party Size',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '4.7',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Avg Rating',
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '2.3',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Visits/Customer',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '18%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Return Rate',
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
    );
  }

  Widget _buildTopCustomersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Customers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Most frequent visitors',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ...topCustomers.map((customer) => _buildCustomerItem(customer)).toList(),
        ],
      ),
    );
  }

  Widget _buildCustomerItem(Map<String, dynamic> customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.accent.withOpacity(0.1),
            child: Text(
              customer['initials'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Avg ${customer['avgPartySize']} guests • ${customer['lastVisit']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${customer['visits']} visits',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSatisfactionCard() {
    final List<Map<String, dynamic>> satisfactionData = [
      {'stars': '5 Stars', 'percentage': 68, 'color': Colors.green},
      {'stars': '4 Stars', 'percentage': 22, 'color': Colors.lightGreen},
      {'stars': '3 Stars', 'percentage': 7, 'color': Colors.orange},
      {'stars': '2 Stars', 'percentage': 2, 'color': Colors.deepOrange},
      {'stars': '1 Star', 'percentage': 1, 'color': Colors.red},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Satisfaction',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...satisfactionData.map((data) => _buildSatisfactionItem(data)).toList(),
        ],
      ),
    );
  }

  Widget _buildSatisfactionItem(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              data['stars'],
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (data['percentage'] as int) / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: data['color'],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Text(
            '${data['percentage']}%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
