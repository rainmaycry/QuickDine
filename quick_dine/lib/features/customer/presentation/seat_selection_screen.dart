import 'package:flutter/material.dart';
import 'reservation_details_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String restaurantName;
  final String cuisine;
  final double rating;

  const SeatSelectionScreen({
    super.key,
    required this.restaurantName,
    required this.cuisine,
    required this.rating,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  String? selectedSeatingArea;
  String? selectedTable;

  final Map<String, List<String>> seatingAreas = {
    'Main Dining': ['Table 1', 'Table 2', 'Table 3', 'Table 4', 'Table 5'],
    'Window Side': ['Table 6', 'Table 7', 'Table 8'],
    'Private Room': ['Table 9', 'Table 10'],
    'Bar Area': ['Bar 1', 'Bar 2', 'Bar 3'],
  };

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
          'Select Your Seat',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Color(0xFF2196F3),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurantName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              widget.cuisine,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFC107),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Seating Areas
            const Text(
              'Choose Your Seating Area',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select your preferred dining area',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 16),

            ...seatingAreas.keys.map((area) => _buildSeatingAreaCard(area)),

            const SizedBox(height: 24),

            // Available Tables
            if (selectedSeatingArea != null) ...[
              const Text(
                'Available Tables',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a table in $selectedSeatingArea',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 16),
              _buildTableGrid(),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
        child: ElevatedButton(
          onPressed: selectedTable != null ? _proceedToReservation : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedTable != null 
                ? const Color(0xFF2196F3) 
                : const Color(0xFFE0E0E0),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Continue to Reservation',
            style: TextStyle(
              color: selectedTable != null ? Colors.white : const Color(0xFF999999),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeatingAreaCard(String area) {
    final isSelected = selectedSeatingArea == area;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedSeatingArea = area;
            selectedTable = null; // Reset table selection
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F4FD) : Colors.white,
            border: Border.all(
              color: isSelected ? const Color(0xFF2196F3) : const Color(0xFFE0E0E0),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                _getAreaIcon(area),
                color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF666666),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${seatingAreas[area]!.length} tables available',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2196F3),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableGrid() {
    final tables = seatingAreas[selectedSeatingArea!]!;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        final isSelected = selectedTable == table;
        final isAvailable = index != 2; // Make some tables unavailable for demo

        return InkWell(
          onTap: isAvailable ? () {
            setState(() {
              selectedTable = table;
            });
          } : null,
          child: Container(
            decoration: BoxDecoration(
              color: !isAvailable 
                  ? const Color(0xFFF5F5F5)
                  : isSelected 
                      ? const Color(0xFF2196F3) 
                      : Colors.white,
              border: Border.all(
                color: !isAvailable
                    ? const Color(0xFFE0E0E0)
                    : isSelected 
                        ? const Color(0xFF2196F3) 
                        : const Color(0xFFE0E0E0),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.table_restaurant,
                  color: !isAvailable
                      ? const Color(0xFF999999)
                      : isSelected 
                          ? Colors.white 
                          : const Color(0xFF666666),
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  table,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: !isAvailable
                        ? const Color(0xFF999999)
                        : isSelected 
                            ? Colors.white 
                            : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAvailable ? 'Available' : 'Occupied',
                  style: TextStyle(
                    fontSize: 10,
                    color: !isAvailable
                        ? const Color(0xFF999999)
                        : isSelected 
                            ? Colors.white 
                            : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getAreaIcon(String area) {
    switch (area) {
      case 'Main Dining':
        return Icons.restaurant_menu;
      case 'Window Side':
        return Icons.window;
      case 'Private Room':
        return Icons.meeting_room;
      case 'Bar Area':
        return Icons.local_bar;
      default:
        return Icons.table_restaurant;
    }
  }

  void _proceedToReservation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationDetailsScreen(
          restaurantName: widget.restaurantName,
          cuisine: widget.cuisine,
          rating: widget.rating,
          selectedDate: DateTime.now(),
          selectedTime: '6:00 PM',
          partySize: 2,
          selectedSeatingArea: selectedSeatingArea,
          selectedTable: selectedTable,
        ),
      ),
    );
  }
}
