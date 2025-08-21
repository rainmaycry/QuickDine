import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BasicInfoFormScreen extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const BasicInfoFormScreen({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<BasicInfoFormScreen> createState() => _BasicInfoFormScreenState();
}

class _BasicInfoFormScreenState extends State<BasicInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedPriceRange = '';
  List<String> _selectedFeatures = [];
  
  final List<String> _priceRanges = [
    '\$ - Budget',
    '\$\$ - Moderate',
    '\$\$\$ - Expensive',
    '\$\$\$\$ - Very Expensive',
  ];
  
  final List<String> _availableFeatures = [
    'Family Friendly',
    'Reservations',
    'Wi-Fi',
    'Outdoor Seating',
    'Parking Available',
    'Wheelchair Accessible',
    'Live Music',
    'Bar/Lounge',
    'Private Dining',
    'Takeout',
    'Delivery',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _nameController.text = widget.initialData['name'] ?? '';
    _cuisineController.text = widget.initialData['cuisine'] ?? '';
    _addressController.text = widget.initialData['address'] ?? '';
    _phoneController.text = widget.initialData['phone'] ?? '';
    _websiteController.text = widget.initialData['website'] ?? '';
    _descriptionController.text = widget.initialData['description'] ?? '';
    _selectedPriceRange = widget.initialData['priceRange'] ?? '';
    _selectedFeatures = List<String>.from(widget.initialData['features'] ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cuisineController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _nameController.text.trim(),
        'cuisine': _cuisineController.text.trim(),
        'priceRange': _selectedPriceRange,
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'website': _websiteController.text.trim(),
        'description': _descriptionController.text.trim(),
        'features': _selectedFeatures,
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
          'Basic Information',
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
                title: 'Restaurant Details',
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Restaurant Name',
                    hint: 'Enter your restaurant name',
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Restaurant name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _cuisineController,
                    label: 'Cuisine Type',
                    hint: 'e.g., Italian, Mexican, Asian',
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Cuisine type is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPriceRangeSelector(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Brief description of your restaurant',
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Location & Contact',
                children: [
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    hint: 'Full restaurant address',
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: '(555) 123-4567',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _websiteController,
                    label: 'Website (Optional)',
                    hint: 'https://www.yourrestaurant.com',
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Features & Amenities',
                children: [
                  _buildFeaturesSelector(),
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
                    'Save Basic Information',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
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
        ),
      ],
    );
  }

  Widget _buildPriceRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPriceRange.isEmpty ? null : _selectedPriceRange,
              hint: const Text('Select price range'),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPriceRange = newValue ?? '';
                });
              },
              items: _priceRanges.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select features that apply to your restaurant:',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableFeatures.map((feature) {
            final isSelected = _selectedFeatures.contains(feature);
            return FilterChip(
              label: Text(feature),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedFeatures.add(feature);
                  } else {
                    _selectedFeatures.remove(feature);
                  }
                });
              },
              selectedColor: AppColors.accent.withOpacity(0.2),
              checkmarkColor: AppColors.accent,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.accent : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
