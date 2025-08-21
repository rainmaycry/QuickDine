import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<Map<String, dynamic>> notifications;
  String _userRole = 'owner'; // Default to owner

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detectUserRole();
    _loadNotifications();
  }

  void _detectUserRole() {
    try {
      final String? currentRoute = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
      if (currentRoute != null) {
        if (currentRoute.contains('admin')) {
          _userRole = 'admin';
        } else if (currentRoute.contains('owner')) {
          _userRole = 'owner';
        } else {
          _userRole = 'customer';
        }
      }
    } catch (e) {
      _userRole = 'owner'; // Default fallback
    }
  }

  void _loadNotifications() {
    if (_userRole == 'admin') {
      // Admin users see empty state
      notifications = [];
    } else if (_userRole == 'owner') {
      // Owner users see restaurant notifications
      notifications = [
        {
          'id': '1',
          'title': 'New Reservation',
          'message': 'Sarah Johnson booked a table for 4 guests tonight at 6:30 PM.',
          'type': 'reservation',
          'time': '30 minutes ago',
          'isRead': false,
          'icon': Icons.calendar_today_outlined,
          'color': const Color(0xFFD4AF6A),
        },
        {
          'id': '2',
          'title': 'Reservation Cancelled',
          'message': 'Mike Davis cancelled his reservation for 3 guests at 7:00 PM.',
          'type': 'reservation',
          'time': '1 hour ago',
          'isRead': false,
          'icon': Icons.cancel_outlined,
          'color': Colors.red,
        },
        {
          'id': '3',
          'title': 'New Review',
          'message': 'You received a 5-star review from Emily Wilson. "Amazing food and service!"',
          'type': 'review',
          'time': '3 hours ago',
          'isRead': true,
          'icon': Icons.star_outline,
          'color': Colors.orange,
        },
        {
          'id': '4',
          'title': 'High Demand Alert',
          'message': 'You have 15 pending reservations for this weekend. Review them now.',
          'type': 'general',
          'time': '6 hours ago',
          'isRead': true,
          'icon': Icons.info_outline,
          'color': const Color(0xFF0C1B2A),
        },
      ];
    } else {
      // Customer notifications
      notifications = [
        {
          'id': '1',
          'title': 'Reservation Confirmed',
          'message': 'Your reservation for 2 guests at 7:00 PM tonight has been confirmed.',
          'type': 'reservation',
          'time': '1 hour ago',
          'isRead': false,
          'icon': Icons.check_circle_outline,
          'color': Colors.green,
        },
      ];
    }
  }

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
