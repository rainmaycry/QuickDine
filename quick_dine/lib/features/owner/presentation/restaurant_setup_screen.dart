import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'forms/basic_info_form_screen.dart';
import 'forms/photos_form_screen.dart';
import 'forms/hours_form_screen.dart';
import 'forms/menu_form_screen.dart';
import 'forms/tables_form_screen.dart';
import 'forms/policies_form_screen.dart';

class RestaurantSetupScreen extends StatefulWidget {
  const RestaurantSetupScreen({super.key});

  @override
  State<RestaurantSetupScreen> createState() => _RestaurantSetupScreenState();
}

class _RestaurantSetupScreenState extends State<RestaurantSetupScreen> {
  bool _isPublishing = false;

  // Restaurant data that will be collected from forms
  final Map<String, dynamic> _restaurantData = {
    'basicInfo': {
      'name': '',
      'cuisine': '',
      'priceRange': '',
      'address': '',
      'phone': '',
      'website': '',
      'description': '',
      'features': <String>[],
    },
    'photos': <String>[],
    'hours': {
      'monday': {'open': '', 'close': '', 'closed': false},
      'tuesday': {'open': '', 'close': '', 'closed': false},
      'wednesday': {'open': '', 'close': '', 'closed': false},
      'thursday': {'open': '', 'close': '', 'closed': false},
      'friday': {'open': '', 'close': '', 'closed': false},
      'saturday': {'open': '', 'close': '', 'closed': false},
      'sunday': {'open': '', 'close': '', 'closed': false},
    },
    'menu': {
      'categories': <Map<String, dynamic>>[],
    },
    'tables': {
      'totalTables': 0,
      'tableLayouts': <Map<String, dynamic>>[],
    },
    'policies': {
      'cancellationPolicy': '',
      'gracePeriod': 15,
      'maxPartySize': 8,
      'specialRequests': '',
    },
  };

  // Setup steps with completion tracking
  List<Map<String, dynamic>> get _setupSteps => [
    {
      'id': 'basic-info',
      'title': 'Basic Information',
      'description': 'Name, location, and contact details',
      'completed': _isBasicInfoComplete(),
      'icon': Icons.store,
    },
    {
      'id': 'photos',
      'title': 'Restaurant Photos',
      'description': 'Upload at least 3 high-quality photos',
      'completed': _isPhotosComplete(),
      'icon': Icons.camera_alt,
    },
    {
      'id': 'hours',
      'title': 'Operating Hours',
      'description': 'Configure weekly and special hours',
      'completed': _isHoursComplete(),
      'icon': Icons.access_time,
    },
    {
      'id': 'menu',
      'title': 'Menu Management',
      'description': 'Add categories and items',
      'completed': _isMenuComplete(),
      'icon': Icons.restaurant_menu,
    },
    {
      'id': 'tables',
      'title': 'Table & Schedule',
      'description': 'Layout and availability',
      'completed': _isTablesComplete(),
      'icon': Icons.event_seat,
    },
    {
      'id': 'policies',
      'title': 'Restaurant Policies',
      'description': 'Cancellation and booking policies',
      'completed': _isPoliciesComplete(),
      'icon': Icons.description,
    },
  ];

  // Dynamic summary data based on form inputs
  Map<String, String> get _summary => {
    'name': _restaurantData['basicInfo']['name']?.isEmpty == true 
        ? 'Restaurant Name' 
        : _restaurantData['basicInfo']['name'],
    'cuisine': _restaurantData['basicInfo']['cuisine']?.isEmpty == true 
        ? 'Cuisine Type' 
        : _restaurantData['basicInfo']['cuisine'],
    'price': _restaurantData['basicInfo']['priceRange']?.isEmpty == true 
        ? 'Price Range' 
        : _restaurantData['basicInfo']['priceRange'],
    'address': _restaurantData['basicInfo']['address']?.isEmpty == true 
        ? 'Restaurant Address' 
        : _restaurantData['basicInfo']['address'],
    'phone': _restaurantData['basicInfo']['phone']?.isEmpty == true 
        ? 'Phone Number' 
        : _restaurantData['basicInfo']['phone'],
    'hours': _getFormattedHours(),
  };

  // Completion check methods
  bool _isBasicInfoComplete() {
    final basic = _restaurantData['basicInfo'];
    return basic['name']?.isNotEmpty == true &&
           basic['cuisine']?.isNotEmpty == true &&
           basic['priceRange']?.isNotEmpty == true &&
           basic['address']?.isNotEmpty == true &&
           basic['phone']?.isNotEmpty == true;
  }

  bool _isPhotosComplete() {
    return (_restaurantData['photos'] as List).length >= 3;
  }

  bool _isHoursComplete() {
    final hours = _restaurantData['hours'] as Map<String, dynamic>;
    return hours.values.any((day) => 
        day['closed'] == true || 
        (day['open']?.isNotEmpty == true && day['close']?.isNotEmpty == true)
    );
  }

  bool _isMenuComplete() {
    final categories = _restaurantData['menu']['categories'] as List;
    return categories.isNotEmpty && 
           categories.any((cat) => (cat['items'] as List).isNotEmpty);
  }

  bool _isTablesComplete() {
    return _restaurantData['tables']['totalTables'] > 0;
  }

  bool _isPoliciesComplete() {
    final policies = _restaurantData['policies'];
    return policies['cancellationPolicy']?.isNotEmpty == true;
  }

  String _getFormattedHours() {
    final hours = _restaurantData['hours'] as Map<String, dynamic>;
    final openDays = hours.entries
        .where((entry) => entry.value['closed'] != true)
        .toList();
    
    if (openDays.isEmpty) return 'Hours not set';
    
    final firstDay = openDays.first.value;
    if (openDays.every((day) => 
        day.value['open'] == firstDay['open'] && 
        day.value['close'] == firstDay['close'])) {
      return 'Daily ${firstDay['open']} - ${firstDay['close']}';
    }
    
    return 'Varies by day';
  }

  int get _completedSteps => _setupSteps.where((s) => s['completed'] == true).length;
  int get _totalSteps => _setupSteps.length;
  double get _completionRatio => _totalSteps == 0 ? 0 : _completedSteps / _totalSteps;
  String get _completionLabel => '${(_completionRatio * 100).toStringAsFixed(0)}% complete';
  bool get _isReadyToPublish => _completedSteps == _totalSteps;

  Future<void> _handlePublishRestaurant() async {
    if (!_isReadyToPublish || _isPublishing) return;
    setState(() => _isPublishing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isPublishing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restaurant published successfully')),
    );
    Navigator.of(context).pop();
  }

  void _navigateToStepForm(String stepId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _buildStepFormScreen(stepId),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {}); // Refresh the UI to show updated completion status
      }
    });
  }

  Widget _buildStepFormScreen(String stepId) {
    switch (stepId) {
      case 'basic-info':
        return BasicInfoFormScreen(
          initialData: _restaurantData['basicInfo'],
          onSave: (data) {
            setState(() {
              _restaurantData['basicInfo'] = data;
            });
            Navigator.of(context).pop(true);
          },
        );
      case 'photos':
        return PhotosFormScreen(
          initialPhotos: List<String>.from(_restaurantData['photos']),
          onSave: (photos) {
            setState(() {
              _restaurantData['photos'] = photos;
            });
            Navigator.of(context).pop(true);
          },
        );
      case 'hours':
        return HoursFormScreen(
          initialHours: Map<String, dynamic>.from(_restaurantData['hours']),
          onSave: (hours) {
            setState(() {
              _restaurantData['hours'] = hours;
            });
            Navigator.of(context).pop(true);
          },
        );
      case 'menu':
        return MenuFormScreen(
          initialMenu: Map<String, dynamic>.from(_restaurantData['menu']),
          onSave: (menu) {
            setState(() {
              _restaurantData['menu'] = menu;
            });
            Navigator.of(context).pop(true);
          },
        );
      case 'tables':
        return TablesFormScreen(
          initialTables: Map<String, dynamic>.from(_restaurantData['tables']),
          onSave: (tables) {
            setState(() {
              _restaurantData['tables'] = tables;
            });
            Navigator.of(context).pop(true);
          },
        );
      case 'policies':
        return PoliciesFormScreen(
          initialPolicies: Map<String, dynamic>.from(_restaurantData['policies']),
          onSave: (policies) {
            setState(() {
              _restaurantData['policies'] = policies;
            });
            Navigator.of(context).pop(true);
          },
        );
      default:
        return const Scaffold(
          body: Center(child: Text('Form not implemented yet')),
        );
    }
  }

  // Visual previews per step (non-functional, design-focused)
  Widget _buildStepPreview(String id) {
    switch (id) {
      case 'basic-info':
        return _basicInfoPreview();
      case 'photos':
        return _photosPreview();
      case 'hours':
        return _hoursPreview();
      case 'menu':
        return _menuPreview();
      case 'tables':
        return _tablesPreview();
      case 'policies':
        return _policiesPreview();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      );

  Widget _infoRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: AppColors.accent),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(color: Colors.grey[800], fontSize: 12))),
          ],
        ),
      );

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(label, style: TextStyle(color: Colors.grey[800], fontSize: 11, fontWeight: FontWeight.w600)),
      );

  Widget _basicInfoPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Overview'),
          _infoRow(Icons.store, _summary['name']!),
          _infoRow(Icons.category, _summary['cuisine']!),
          _infoRow(Icons.attach_money, _summary['price']!),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip('Family Friendly'),
              _chip('Reservations'),
              _chip('Wi‑Fi'),
            ],
          ),
          const SizedBox(height: 12),
          _sectionTitle('Location & Contact'),
          _infoRow(Icons.location_on, _summary['address']!),
          _infoRow(Icons.call, _summary['phone']!),
          _infoRow(Icons.public, 'www.casabella.example'),
        ],
      ),
    );
  }

  Widget _photosPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 4 / 3,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.image, color: AppColors.primary),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hoursPreview() {
    final days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          for (final d in days) ...[
            Row(
              children: [
                SizedBox(width: 36, child: Text(d, style: const TextStyle(fontWeight: FontWeight.w600))),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Text('11:00 AM - 10:00 PM', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _menuPreview() {
    final sections = [
      {'title': 'Starters', 'items': 6},
      {'title': 'Mains', 'items': 8},
      {'title': 'Desserts', 'items': 4},
      {'title': 'Drinks', 'items': 10},
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          for (final s in sections) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.folder_open, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(s['title'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('${s['items']} items',
                        style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tablesPreview() {
    // simple schematic with seats as dots
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(18, (i) {
          final highlighted = i % 5 == 0;
          return Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: highlighted ? AppColors.accent.withOpacity(0.15) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: highlighted ? AppColors.accent : Colors.grey[300]!),
            ),
            child: Center(
              child: Text('T${i + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: highlighted ? AppColors.accent : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          );
        }),
      ),
    );
  }

  Widget _policiesPreview() {
    final items = const [
      {'icon': Icons.cancel_schedule_send, 'text': '24-hour cancellation notice'},
      {'icon': Icons.event_busy, 'text': '15-minute grace period for reservations'},
      {'icon': Icons.groups_2, 'text': 'Max party size: 8 guests'},
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          for (final it in items) ...[
            Row(
              children: [
                Icon(it['icon'] as IconData, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(it['text'] as String,
                      style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Setup Completion',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressOverviewCard(),
            const SizedBox(height: 16),
            _buildChecklistCard(),
            const SizedBox(height: 16),
            _buildSummaryCard(),
            const SizedBox(height: 16),
            _buildPublishCard(),
            const SizedBox(height: 16),
            _buildHelpCard(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Progress Overview
  Widget _buildProgressOverviewCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Setup Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _completionLabel,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _completionRatio,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text(
              'Completed $_completedSteps of $_totalSteps steps',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Setup Checklist
  Widget _buildChecklistCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Setup Checklist',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            ..._setupSteps.map(_buildChecklistItem).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(Map<String, dynamic> step) {
    final completed = step['completed'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Icon(step['icon'] as IconData, color: AppColors.primary),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['description'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(completed),
            ],
          ),
          trailing: TextButton(
            onPressed: () => _navigateToStepForm(step['id'] as String),
            style: TextButton.styleFrom(
              foregroundColor: completed ? Colors.grey[700] : AppColors.accent,
            ),
            child: Text(completed ? 'Edit' : 'Complete'),
          ),
          children: [
            _buildStepPreview(step['id'] as String),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool completed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: completed ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: completed ? Colors.green : Colors.orange),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.hourglass_bottom,
            size: 14,
            color: completed ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            completed ? 'Complete' : 'Pending',
            style: TextStyle(
              fontSize: 11,
              color: completed ? Colors.green[800] : Colors.orange[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Restaurant Summary
  Widget _buildSummaryCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Restaurant Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey[200],
                    child: const Icon(Icons.restaurant, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _summary['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_summary['cuisine']} • ${_summary['price']}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(_summary['address']!, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.call, size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(_summary['phone']!, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(_summary['hours']!, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Publish Actions
  Widget _buildPublishCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Publish Restaurant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isReadyToPublish
                  ? 'All steps are complete. You can publish your restaurant now.'
                  : 'Complete all required steps before publishing your restaurant.',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isReadyToPublish && !_isPublishing ? _handlePublishRestaurant : null,
                icon: _isPublishing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.rocket_launch, size: 18),
                label: Text(_isPublishing ? 'Publishing...' : 'Publish Restaurant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 6),
            if (!_isReadyToPublish)
              Text(
                '$_completedSteps/$_totalSteps steps completed',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  // Help / Support
  Widget _buildHelpCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need help?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'If you have any questions or need assistance, our support team is here to help.',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: implement support chat or email
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.accent),
                    label: const Text('Contact Support'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.help_outline, size: 16, color: AppColors.primary),
                    label: const Text('View Documentation'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
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
