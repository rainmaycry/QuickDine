import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'My Reservations',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: const Color(0xFF666666),
          indicatorColor: const Color(0xFF2196F3),
          tabs: const [
            Tab(text: 'Upcoming (3)'),
            Tab(text: 'Past (3)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(),
          _buildPastTab(),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildUpcomingReservationCard(
            name: 'Bella Vista',
            cuisine: 'Italian',
            rating: 4.8,
            status: 'confirmed',
            date: 'Today',
            time: '7:00 PM',
            guests: 2,
            address: '123 Main St, Downtown',
            note: 'Window seat preferred',
            confirmationCode: 'CONF-789456',
          ),
          const SizedBox(height: 16),
          _buildUpcomingReservationCard(
            name: 'The Garden Cafe',
            cuisine: 'American',
            rating: 4.5,
            status: 'confirmed',
            date: 'Tomorrow',
            time: '1:00 PM',
            guests: 4,
            address: '456 Oak Ave, Midtown',
            note: '',
            confirmationCode: 'CONF-123789',
          ),
          const SizedBox(height: 16),
          _buildUpcomingReservationCard(
            name: 'Sakura Sushi',
            cuisine: 'Japanese',
            rating: 4.9,
            status: 'pending',
            date: 'Jan 25, 2024',
            time: '6:30 PM',
            guests: 3,
            address: '789 Pine St, Uptown',
            note: '',
            confirmationCode: '',
          ),
        ],
      ),
    );
  }

  Widget _buildPastTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPastReservationCard(
            name: 'Ocean Breeze',
            cuisine: 'Seafood',
            rating: 4.6,
            status: 'completed',
            date: 'Jan 10, 2024',
            time: '8:00 PM',
            guests: 2,
            address: '321 Beach Blvd, Coastal',
            confirmationCode: 'CONF-654321',
          ),
          const SizedBox(height: 16),
          _buildPastReservationCard(
            name: 'Spice Junction',
            cuisine: 'Indian',
            rating: 4.7,
            status: 'completed',
            date: 'Jan 05, 2024',
            time: '7:30 PM',
            guests: 6,
            address: '654 Curry Lane, Spice District',
            confirmationCode: 'CONF-987654',
          ),
          const SizedBox(height: 16),
          _buildPastReservationCard(
            name: 'French Bistro',
            cuisine: 'French',
            rating: 4.4,
            status: 'cancelled',
            date: 'Dec 28, 2023',
            time: '6:00 PM',
            guests: 2,
            address: '987 Wine St, Gourmet District',
            confirmationCode: '',
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingReservationCard({
    required String name,
    required String cuisine,
    required double rating,
    required String status,
    required String date,
    required String time,
    required int guests,
    required String address,
    required String note,
    required String confirmationCode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with restaurant name and status
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xFFD4AF6A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$cuisine • ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const Icon(Icons.star, color: Color(0xFFFFB400), size: 16),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'confirmed'
                      ? const Color(0xFFE8F5E8)
                      : status == 'pending'
                          ? const Color(0xFFFFF3CD)
                          : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status == 'confirmed'
                          ? Icons.check_circle
                          : status == 'pending'
                              ? Icons.schedule
                              : Icons.cancel,
                      size: 12,
                      color: status == 'confirmed'
                          ? const Color(0xFF4CAF50)
                          : status == 'pending'
                              ? const Color(0xFFFF9800)
                              : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: status == 'confirmed'
                            ? const Color(0xFF4CAF50)
                            : status == 'pending'
                                ? const Color(0xFFFF9800)
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Reservation details
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.access_time, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.people, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                '$guests guests',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Address
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),

          // Note (if exists)
          if (note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Note: $note',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],

          // Confirmation code (if exists)
          if (confirmationCode.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              confirmationCode,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD4AF6A),
                    side: const BorderSide(color: Color(0xFFD4AF6A)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Modify'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.phone, color: Color(0xFFD4AF6A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPastReservationCard({
    required String name,
    required String cuisine,
    required double rating,
    required String status,
    required String date,
    required String time,
    required int guests,
    required String address,
    required String confirmationCode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with restaurant name and status
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xFFD4AF6A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$cuisine • ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const Icon(Icons.star, color: Color(0xFFFFB400), size: 16),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'completed'
                      ? const Color(0xFFE3F2FD)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status == 'completed' ? Icons.check_circle : Icons.cancel,
                      size: 12,
                      color: status == 'completed'
                          ? const Color(0xFF2196F3)
                          : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: status == 'completed'
                            ? const Color(0xFF2196F3)
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Reservation details
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.access_time, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.people, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                '$guests guests',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Address
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),

          // Confirmation code (if exists)
          if (confirmationCode.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              confirmationCode,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Action buttons for past reservations
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD4AF6A),
                    side: const BorderSide(color: Color(0xFFD4AF6A)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Call'),
                ),
              ),
              const SizedBox(width: 12),
              if (status == 'completed')
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD4AF6A),
                      side: const BorderSide(color: Color(0xFFD4AF6A)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.star_border, size: 18),
                    label: const Text('Review'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}