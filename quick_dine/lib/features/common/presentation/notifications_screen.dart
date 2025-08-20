import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  final List<Map<String, dynamic>> notifications = [
    // Commented out for admin - showing empty state instead
    /*
    {
      'id': '1',
      'title': 'New Reservation',
      'message': 'John Smith booked a table for 2 at 7:00 PM today',
      'type': 'reservation',
      'time': '2 minutes ago',
      'isRead': false,
      'icon': Icons.calendar_today_outlined,
      'color': Color(0xFFD4AF6A),
    },
    {
      'id': '2',
      'title': 'Reservation Cancelled',
      'message': 'Sarah Johnson cancelled her reservation for tonight',
      'type': 'cancellation',
      'time': '15 minutes ago',
      'isRead': false,
      'icon': Icons.cancel_outlined,
      'color': Colors.red,
    },
    {
      'id': '3',
      'title': 'New Review',
      'message': 'Mike Davis left a 5-star review: "Amazing food and service!"',
      'type': 'review',
      'time': '1 hour ago',
      'isRead': true,
      'icon': Icons.star_outline,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'Table Ready',
      'message': 'Table 5 is now available for the next reservation',
      'type': 'table',
      'time': '2 hours ago',
      'isRead': true,
      'icon': Icons.table_restaurant_outlined,
      'color': Colors.green,
    },
    {
      'id': '5',
      'title': 'Payment Received',
      'message': 'Payment of \$85.50 received for order #1234',
      'type': 'payment',
      'time': '3 hours ago',
      'isRead': true,
      'icon': Icons.payment_outlined,
      'color': Colors.blue,
    },
    {
      'id': '6',
      'title': 'Staff Update',
      'message': 'Emily Wilson clocked in for the evening shift',
      'type': 'staff',
      'time': '4 hours ago',
      'isRead': true,
      'icon': Icons.person_outline,
      'color': Color(0xFF0C1B2A),
    },
    */ // This is just to be able to show how it looks when there are no notifications.
  ];

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    const secondary = Color(0xFFF5F5F5);
    const borderColor = Color(0xFFE5E5E5);

    final unreadCount = notifications.where((n) => !n['isRead']).length;

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
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  color: primary,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
                // Title
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                const Spacer(),
                // Unread count badge
                if (unreadCount > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount new',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                // Mark all as read
                TextButton(
                  onPressed: _markAllAsRead,
                  child: Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: 14,
                      color: accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notifications list
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    const primary = Color(0xFF0C1B2A);
    const borderColor = Color(0xFFE5E5E5);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: notification['isRead'] 
              ? borderColor.withOpacity(0.5)
              : Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _markAsRead(notification['id']),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notification['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    notification['icon'],
                    color: notification['color'],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and time
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification['isRead'] 
                                    ? FontWeight.w500 
                                    : FontWeight.w600,
                                color: primary,
                              ),
                            ),
                          ),
                          Text(
                            notification['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Message
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Unread indicator
                if (!notification['isRead']) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 40,
              color: accent,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You don\'t have any notifications right now.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
  }
}
