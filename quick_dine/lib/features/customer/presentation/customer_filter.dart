import 'package:flutter/material.dart';

class CustomerFilterPage extends StatefulWidget {
  const CustomerFilterPage({super.key});

  @override
  State<CustomerFilterPage> createState() => _CustomerFilterPageState();
}

class _CustomerFilterPageState extends State<CustomerFilterPage> {
  // Cuisine Types
  final List<String> cuisineTypes = [
    'Italian', 'Chinese', 'Japanese', 'Mexican', 'Thai', 'Indian',
    'French', 'American', 'Mediterranean', 'Korean', 'Vietnamese', 'Greek'
  ];
  Set<String> selectedCuisines = {};

  // Price Range
  String selectedPriceRange = '';
  final List<Map<String, String>> priceRanges = [
    {'label': '\$ - Budget Friendly', 'value': 'budget'},
    {'label': '\$\$ - Moderate', 'value': 'moderate'},
    {'label': '\$\$\$ - Upscale', 'value': 'upscale'},
    {'label': '\$\$\$\$ - Fine Dining', 'value': 'fine_dining'},
  ];

  // Distance
  double maxDistance = 5.0;

  // Minimum Rating
  String selectedRating = '';

  // Features & Amenities
  final List<Map<String, dynamic>> features = [
    {'label': 'Outdoor Seating', 'icon': Icons.deck_outlined, 'selected': false},
    {'label': 'Family Friendly', 'icon': Icons.family_restroom_outlined, 'selected': false},
    {'label': 'Wheelchair Accessible', 'icon': Icons.accessible_outlined, 'selected': false},
    {'label': 'Free WiFi', 'icon': Icons.wifi_outlined, 'selected': false},
    {'label': 'Live Music', 'icon': Icons.music_note_outlined, 'selected': false},
    {'label': 'Bar/Lounge', 'icon': Icons.local_bar_outlined, 'selected': false},
    {'label': 'Parking Available', 'icon': Icons.local_parking_outlined, 'selected': false},
    {'label': 'Private Dining', 'icon': Icons.meeting_room_outlined, 'selected': false},
  ];

  // Quick Filters
  bool openNow = false;
  bool acceptsReservations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter Restaurants',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'Reset',
              style: TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCuisineTypeSection(),
                  const SizedBox(height: 32),
                  _buildPriceRangeSection(),
                  const SizedBox(height: 32),
                  _buildDistanceSection(),
                  const SizedBox(height: 32),
                  _buildMinimumRatingSection(),
                  const SizedBox(height: 32),
                  _buildFeaturesSection(),
                  const SizedBox(height: 32),
                  _buildQuickFiltersSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildCuisineTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.restaurant_menu, color: Color(0xFF666666), size: 20),
            SizedBox(width: 8),
            Text(
              'Cuisine Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Select your preferred cuisines',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cuisineTypes.map((cuisine) {
            final isSelected = selectedCuisines.contains(cuisine);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedCuisines.remove(cuisine);
                  } else {
                    selectedCuisines.add(cuisine);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F4FD) : Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2196F3) : const Color(0xFFE0E0E0),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cuisine,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF666666),
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.attach_money, color: Color(0xFF666666), size: 20),
            SizedBox(width: 8),
            Text(
              'Price Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Choose your budget preference',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: priceRanges.map((range) {
            final isSelected = selectedPriceRange == range['value'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedPriceRange = isSelected ? '' : range['value']!;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F4FD) : Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2196F3) : const Color(0xFFE0E0E0),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      range['label']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF666666),
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_on_outlined, color: Color(0xFF666666), size: 20),
            SizedBox(width: 8),
            Text(
              'Distance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Maximum distance from your location',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              '1 mile',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
            Expanded(
              child: Slider(
                value: maxDistance,
                min: 1.0,
                max: 25.0,
                divisions: 24,
                activeColor: const Color(0xFF2196F3),
                inactiveColor: const Color(0xFFE0E0E0),
                onChanged: (value) {
                  setState(() {
                    maxDistance = value;
                  });
                },
              ),
            ),
            const Text(
              '25+ miles',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
          ],
        ),
        Center(
          child: Text(
            '${maxDistance.round()} ${maxDistance.round() == 1 ? 'mile' : 'miles'}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimumRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.star_outline, color: Color(0xFF666666), size: 20),
            SizedBox(width: 8),
            Text(
              'Minimum Rating',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Show restaurants with at least this rating',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildRatingOption('Any rating', ''),
            const SizedBox(width: 16),
            _buildRatingOption('Any rating', ''),
            const SizedBox(width: 16),
            _buildRatingOption('5 stars', '5'),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingOption(String label, String value) {
    final isSelected = selectedRating == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRating = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2196F3) : Colors.white,
            border: Border.all(
              color: isSelected ? const Color(0xFF2196F3) : const Color(0xFFE0E0E0),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.white : const Color(0xFFE0E0E0),
                  ),
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: Color(0xFF2196F3),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : const Color(0xFF666666),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.featured_play_list_outlined, color: Color(0xFF666666), size: 20),
            SizedBox(width: 8),
            Text(
              'Features & Amenities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Select desired restaurant features',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: features.map((feature) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  feature['selected'] = !feature['selected'];
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: feature['selected'] ? const Color(0xFFE8F4FD) : Colors.white,
                  border: Border.all(
                    color: feature['selected'] ? const Color(0xFF2196F3) : const Color(0xFFE0E0E0),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      feature['icon'],
                      color: feature['selected'] ? const Color(0xFF2196F3) : const Color(0xFF999999),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      feature['label'],
                      style: TextStyle(
                        fontSize: 14,
                        color: feature['selected'] ? const Color(0xFF2196F3) : const Color(0xFF666666),
                        fontWeight: feature['selected'] ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.access_time, color: Color(0xFF666666), size: 20),
            SizedBox(width: 8),
            Text(
              'Quick Filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Common filter preferences',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 16),
        _buildQuickFilterToggle(
          'Open Now',
          'Show only restaurants currently open',
          openNow,
          (value) => setState(() => openNow = value),
        ),
        const SizedBox(height: 12),
        _buildQuickFilterToggle(
          'Accepts Reservations',
          'Show only restaurants that take reservations',
          acceptsReservations,
          (value) => setState(() => acceptsReservations = value),
        ),
      ],
    );
  }

  Widget _buildQuickFilterToggle(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2196F3),
            inactiveThumbColor: const Color(0xFFE0E0E0),
            inactiveTrackColor: const Color(0xFFF5F5F5),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedCuisines.clear();
      selectedPriceRange = '';
      maxDistance = 5.0;
      selectedRating = '';
      for (var feature in features) {
        feature['selected'] = false;
      }
      openNow = false;
      acceptsReservations = false;
    });
  }

  void _applyFilters() {
    final selectedFeatures = features
        .where((feature) => feature['selected'])
        .map((feature) => feature['label'])
        .toList();

    Navigator.pop(context, {
      'cuisines': selectedCuisines.toList(),
      'priceRange': selectedPriceRange,
      'maxDistance': maxDistance,
      'minRating': selectedRating,
      'features': selectedFeatures,
      'openNow': openNow,
      'acceptsReservations': acceptsReservations,
    });
  }
}