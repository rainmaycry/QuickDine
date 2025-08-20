import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TableScheduleManagementScreen extends StatefulWidget {
  const TableScheduleManagementScreen({super.key});

  @override
  State<TableScheduleManagementScreen> createState() => _TableScheduleManagementScreenState();
}

class _TableScheduleManagementScreenState extends State<TableScheduleManagementScreen> with TickerProviderStateMixin {
  static const primary = Color(0xFF0C1B2A);
  static const accent = Color(0xFFD4AF6A);
  static const borderColor = Color(0xFFE5E5E5);

  late TabController _tabController;

  // Mock data for tables
  List<Map<String, dynamic>> tables = [
    {'id': '1', 'number': 1, 'seats': 2, 'location': 'Window', 'isActive': true},
    {'id': '2', 'number': 2, 'seats': 4, 'location': 'Center', 'isActive': true},
    {'id': '3', 'number': 3, 'seats': 6, 'location': 'Private', 'isActive': true},
    {'id': '4', 'number': 4, 'seats': 2, 'location': 'Bar', 'isActive': true},
    {'id': '5', 'number': 5, 'seats': 4, 'location': 'Patio', 'isActive': false},
  ];

  // Mock data for time slots
  List<Map<String, dynamic>> timeSlots = [
    {'id': '1', 'time': '17:00', 'duration': 120, 'maxPartySize': 8, 'isActive': true},
    {'id': '2', 'time': '17:30', 'duration': 120, 'maxPartySize': 8, 'isActive': true},
    {'id': '3', 'time': '18:00', 'duration': 120, 'maxPartySize': 8, 'isActive': true},
    {'id': '4', 'time': '18:30', 'duration': 120, 'maxPartySize': 8, 'isActive': true},
    {'id': '5', 'time': '19:00', 'duration': 120, 'maxPartySize': 8, 'isActive': true},
    {'id': '6', 'time': '19:30', 'duration': 120, 'maxPartySize': 8, 'isActive': true},
    {'id': '7', 'time': '20:00', 'duration': 120, 'maxPartySize': 8, 'isActive': true},
    {'id': '8', 'time': '20:30', 'duration': 120, 'maxPartySize': 8, 'isActive': true},
    {'id': '9', 'time': '21:00', 'duration': 90, 'maxPartySize': 6, 'isActive': true},
  ];

  // Form data for new table
  Map<String, dynamic> newTable = {
    'number': 0,
    'seats': 2,
    'location': '',
    'isActive': true,
  };

  // Form data for new time slot
  Map<String, dynamic> newTimeSlot = {
    'time': '18:00',
    'duration': 120,
    'maxPartySize': 8,
    'isActive': true,
  };

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

  String formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $ampm';
  }

  void _addTable() {
    if (newTable['number'] > 0 && newTable['seats'] > 0 && newTable['location'].isNotEmpty) {
      setState(() {
        tables.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'number': newTable['number'],
          'seats': newTable['seats'],
          'location': newTable['location'],
          'isActive': newTable['isActive'],
        });
        newTable = {'number': 0, 'seats': 2, 'location': '', 'isActive': true};
      });
    }
  }

  void _toggleTableStatus(String id) {
    setState(() {
      final index = tables.indexWhere((table) => table['id'] == id);
      if (index != -1) {
        tables[index]['isActive'] = !tables[index]['isActive'];
      }
    });
  }

  void _deleteTable(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Table'),
        content: const Text('Are you sure you want to delete this table?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tables.removeWhere((table) => table['id'] == id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  color: primary,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Table & Schedule Management',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: accent,
              tabs: [
                Tab(text: 'Tables (${tables.where((t) => t['isActive']).length})'),
                Tab(text: 'Slots (${timeSlots.where((ts) => ts['isActive']).length})'),
                const Tab(text: 'Availability'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTablesTab(),
                _buildTimeSlotsTab(),
                _buildAvailabilityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Restaurant Tables',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                  Text(
                    'Manage your table configuration',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddTableDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Table'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tables List
          ...tables.map((table) => _buildTableCard(table)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableCard(Map<String, dynamic> table) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.5)),
        boxShadow: table['isActive'] ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Table Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: table['isActive'] ? accent.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  table['number'].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: table['isActive'] ? accent : Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Table Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Table ${table['number']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${table['seats']} seats',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (table['isActive']) ...[
                        const SizedBox(width: 12),
                        Text(
                          table['location'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Status Badge
            if (!table['isActive'])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Inactive',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            const SizedBox(width: 8),

            // Action Buttons
            Row(
              children: [
                TextButton(
                  onPressed: () => _toggleTableStatus(table['id']),
                  style: TextButton.styleFrom(
                    foregroundColor: table['isActive'] ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: Text(
                    table['isActive'] ? 'Deactivate' : 'Activate',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteTable(table['id']),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  color: Colors.red,
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsTab() {
    return const Center(
      child: Text('Time Slots Tab - Coming Soon'),
    );
  }

  Widget _buildAvailabilityTab() {
    return const Center(
      child: Text('Availability Tab - Coming Soon'),
    );
  }

  void _showAddTableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Table'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Table Number *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                newTable['number'] = int.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Number of Seats *',
                border: OutlineInputBorder(),
              ),
              value: newTable['seats'],
              items: [2, 4, 6, 8, 10, 12].map((seats) {
                return DropdownMenuItem(
                  value: seats,
                  child: Text('$seats seats'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  newTable['seats'] = value;
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Location *',
                border: OutlineInputBorder(),
              ),
              value: newTable['location'].isEmpty ? null : newTable['location'],
              items: ['Window', 'Center', 'Bar', 'Patio', 'Private', 'Corner'].map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  newTable['location'] = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                newTable = {'number': 0, 'seats': 2, 'location': '', 'isActive': true};
              });
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTable();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: const Text('Add Table', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
