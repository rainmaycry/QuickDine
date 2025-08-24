import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HoursFormScreen extends StatefulWidget {
  final Map<String, dynamic> initialHours;
  final Function(Map<String, dynamic>) onSave;

  const HoursFormScreen({
    super.key,
    required this.initialHours,
    required this.onSave,
  });

  @override
  State<HoursFormScreen> createState() => _HoursFormScreenState();
}

class _HoursFormScreenState extends State<HoursFormScreen> {
  Map<String, dynamic> _hours = {};
  
  final List<String> _days = [
    'monday',
    'tuesday', 
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  final List<String> _dayLabels = [
    'Monday',
    'Tuesday',
    'Wednesday', 
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> _timeSlots = [
    '6:00 AM', '6:30 AM', '7:00 AM', '7:30 AM', '8:00 AM', '8:30 AM',
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM',
    '12:00 PM', '12:30 PM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
    '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM', '5:30 PM',
    '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM', '8:00 PM', '8:30 PM',
    '9:00 PM', '9:30 PM', '10:00 PM', '10:30 PM', '11:00 PM', '11:30 PM'
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _hours = Map<String, dynamic>.from(widget.initialHours);
    
    // Initialize empty days if not present
    for (String day in _days) {
      if (!_hours.containsKey(day)) {
        _hours[day] = {'open': '', 'close': '', 'closed': false};
      }
    }
  }

  void _handleSave() {
    widget.onSave(_hours);
  }

  void _copyToAllDays(String sourceDay) {
    final sourceHours = _hours[sourceDay];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Copy Hours'),
          content: Text('Copy ${_dayLabels[_days.indexOf(sourceDay)]} hours to all other days?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  for (String day in _days) {
                    if (day != sourceDay) {
                      _hours[day] = Map<String, dynamic>.from(sourceHours);
                    }
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Copy'),
            ),
          ],
        );
      },
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
          'Operating Hours',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                      'Weekly Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Set your restaurant\'s operating hours for each day of the week.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(_days.length, (index) {
                      final day = _days[index];
                      final dayLabel = _dayLabels[index];
                      return _buildDayRow(day, dayLabel, index);
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
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
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _setAllDaysHours('11:00 AM', '10:00 PM'),
                            icon: const Icon(Icons.schedule, size: 18),
                            label: const Text('Standard Hours'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.accent,
                              side: const BorderSide(color: AppColors.accent),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _clearAllHours,
                            icon: const Icon(Icons.clear, size: 18),
                            label: const Text('Clear All'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[600],
                              side: BorderSide(color: Colors.grey[400]!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Operating Hours',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow(String day, String dayLabel, int index) {
    final dayData = _hours[day];
    final isClosed = dayData['closed'] == true;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  dayLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Switch(
                      value: !isClosed,
                      onChanged: (bool value) {
                        setState(() {
                          _hours[day]['closed'] = !value;
                          if (!value) {
                            _hours[day]['open'] = '';
                            _hours[day]['close'] = '';
                          }
                        });
                      },
                      activeTrackColor: AppColors.accent.withOpacity(0.5),
                      thumbColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return AppColors.accent;
                        }
                        return Colors.grey[300]!;
                      }),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isClosed ? 'Closed' : 'Open',
                      style: TextStyle(
                        color: isClosed ? Colors.grey[600] : AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isClosed)
                IconButton(
                  onPressed: () => _copyToAllDays(day),
                  icon: const Icon(Icons.copy, size: 18),
                  color: AppColors.accent,
                  tooltip: 'Copy to all days',
                ),
            ],
          ),
          if (!isClosed) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 92),
                Expanded(
                  child: _buildTimeSelector(
                    label: 'Open',
                    value: dayData['open'],
                    onChanged: (String? value) {
                      setState(() {
                        _hours[day]['open'] = value ?? '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeSelector(
                    label: 'Close',
                    value: dayData['close'],
                    onChanged: (String? value) {
                      setState(() {
                        _hours[day]['close'] = value ?? '';
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required String value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: Text('Select $label', style: const TextStyle(fontSize: 12)),
              isExpanded: true,
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
              onChanged: onChanged,
              items: _timeSlots.map<DropdownMenuItem<String>>((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _setAllDaysHours(String openTime, String closeTime) {
    setState(() {
      for (String day in _days) {
        _hours[day] = {
          'open': openTime,
          'close': closeTime,
          'closed': false,
        };
      }
    });
  }

  void _clearAllHours() {
    setState(() {
      for (String day in _days) {
        _hours[day] = {
          'open': '',
          'close': '',
          'closed': false,
        };
      }
    });
  }
}
