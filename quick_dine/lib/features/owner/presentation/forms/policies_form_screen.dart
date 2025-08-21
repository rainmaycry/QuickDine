import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PoliciesFormScreen extends StatefulWidget {
  final Map<String, dynamic> initialPolicies;
  final Function(Map<String, dynamic>) onSave;

  const PoliciesFormScreen({
    super.key,
    required this.initialPolicies,
    required this.onSave,
  });

  @override
  State<PoliciesFormScreen> createState() => _PoliciesFormScreenState();
}

class _PoliciesFormScreenState extends State<PoliciesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cancellationController = TextEditingController();
  final _specialRequestsController = TextEditingController();
  
  int _gracePeriod = 15;
  int _maxPartySize = 8;
  String _selectedCancellationPolicy = '';
  
  final List<String> _cancellationPolicies = [
    '24-hour cancellation notice required',
    '12-hour cancellation notice required',
    '6-hour cancellation notice required',
    '2-hour cancellation notice required',
    'Same-day cancellations allowed',
    'No cancellation policy',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _cancellationController.text = widget.initialPolicies['cancellationPolicy'] ?? '';
    _specialRequestsController.text = widget.initialPolicies['specialRequests'] ?? '';
    _gracePeriod = widget.initialPolicies['gracePeriod'] ?? 15;
    _maxPartySize = widget.initialPolicies['maxPartySize'] ?? 8;
    _selectedCancellationPolicy = widget.initialPolicies['cancellationPolicy'] ?? '';
  }

  @override
  void dispose() {
    _cancellationController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'cancellationPolicy': _selectedCancellationPolicy.isNotEmpty 
            ? _selectedCancellationPolicy 
            : _cancellationController.text.trim(),
        'gracePeriod': _gracePeriod,
        'maxPartySize': _maxPartySize,
        'specialRequests': _specialRequestsController.text.trim(),
      };
      widget.onSave(data);
    }
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
          'Restaurant Policies',
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: 'Cancellation Policy',
                children: [
                  const Text(
                    'Select a cancellation policy or create a custom one:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._cancellationPolicies.map((policy) {
                    return RadioListTile<String>(
                      title: Text(
                        policy,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: policy,
                      groupValue: _selectedCancellationPolicy,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCancellationPolicy = value ?? '';
                          _cancellationController.clear();
                        });
                      },
                      activeColor: AppColors.accent,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                  const Text(
                    'Or write a custom policy:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cancellationController,
                    decoration: InputDecoration(
                      hintText: 'Enter your custom cancellation policy',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    maxLines: 2,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _selectedCancellationPolicy = '';
                        });
                      }
                    },
                    validator: (value) {
                      if (_selectedCancellationPolicy.isEmpty && (value?.isEmpty == true)) {
                        return 'Please select or enter a cancellation policy';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Reservation Settings',
                children: [
                  _buildSliderSetting(
                    title: 'Grace Period',
                    subtitle: 'How long to wait for late arrivals',
                    value: _gracePeriod.toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 11,
                    label: '$_gracePeriod minutes',
                    onChanged: (double value) {
                      setState(() {
                        _gracePeriod = value.round();
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSliderSetting(
                    title: 'Maximum Party Size',
                    subtitle: 'Largest group size you can accommodate',
                    value: _maxPartySize.toDouble(),
                    min: 2,
                    max: 20,
                    divisions: 18,
                    label: '$_maxPartySize people',
                    onChanged: (double value) {
                      setState(() {
                        _maxPartySize = value.round();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Special Requests',
                children: [
                  const Text(
                    'Additional policies or special requests information:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _specialRequestsController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Dietary restrictions accommodated, Birthday celebrations welcome, etc.',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Policy Summary',
                children: [
                  _buildPolicyItem(
                    Icons.cancel_schedule_send,
                    'Cancellation',
                    _selectedCancellationPolicy.isNotEmpty 
                        ? _selectedCancellationPolicy 
                        : (_cancellationController.text.isNotEmpty 
                            ? _cancellationController.text 
                            : 'Not set'),
                  ),
                  _buildPolicyItem(
                    Icons.access_time,
                    'Grace Period',
                    '$_gracePeriod minutes for late arrivals',
                  ),
                  _buildPolicyItem(
                    Icons.groups,
                    'Max Party Size',
                    '$_maxPartySize people maximum',
                  ),
                  if (_specialRequestsController.text.isNotEmpty)
                    _buildPolicyItem(
                      Icons.note_add,
                      'Special Requests',
                      _specialRequestsController.text,
                    ),
                ],
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
                    'Save Policies',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                label: label,
                activeColor: AppColors.accent,
                onChanged: onChanged,
              ),
            ),
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPolicyItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
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
    );
  }
}
