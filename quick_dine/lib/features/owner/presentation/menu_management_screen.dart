import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  static const primary = Color(0xFF0C1B2A);
  static const accent = Color(0xFFD4AF6A);
  static const borderColor = Color(0xFFE5E5E5);

  String _searchQuery = '';
  String _selectedCategory = 'all';
  Map<String, dynamic>? _editingItem;

  // Categories
  final List<Map<String, dynamic>> categories = [
    {'id': 'appetizers', 'name': 'Appetizers', 'icon': Icons.restaurant_outlined},
    {'id': 'mains', 'name': 'Main Courses', 'icon': Icons.dinner_dining_outlined},
    {'id': 'pasta', 'name': 'Pasta', 'icon': Icons.ramen_dining_outlined},
    {'id': 'desserts', 'name': 'Desserts', 'icon': Icons.cake_outlined},
    {'id': 'beverages', 'name': 'Beverages', 'icon': Icons.local_cafe_outlined},
  ];

  // Mock menu items
  List<Map<String, dynamic>> menuItems = [
    {
      'id': '1',
      'name': 'Bruschetta Trio',
      'description': 'Three varieties of our famous bruschetta with fresh tomatoes, basil, and garlic',
      'price': 12.99,
      'category': 'appetizers',
      'isAvailable': true,
      'isPopular': true,
      'allergens': ['gluten'],
      'preparationTime': 10,
    },
    {
      'id': '2',
      'name': 'Margherita Pizza',
      'description': 'Classic pizza with fresh mozzarella, tomato sauce, and basil',
      'price': 18.99,
      'category': 'mains',
      'isAvailable': true,
      'isPopular': true,
      'allergens': ['gluten', 'dairy'],
      'preparationTime': 15,
    },
    {
      'id': '3',
      'name': 'Spaghetti Carbonara',
      'description': 'Traditional Roman pasta with eggs, pecorino cheese, pancetta, and black pepper',
      'price': 22.99,
      'category': 'pasta',
      'isAvailable': true,
      'isPopular': false,
      'allergens': ['gluten', 'dairy', 'eggs'],
      'preparationTime': 12,
    },
    {
      'id': '4',
      'name': 'Tiramisu',
      'description': 'Classic Italian dessert with coffee-soaked ladyfingers and mascarpone',
      'price': 8.99,
      'category': 'desserts',
      'isAvailable': false,
      'isPopular': true,
      'allergens': ['gluten', 'dairy', 'eggs'],
      'preparationTime': 5,
    },
  ];

  // Form data for new item
  Map<String, dynamic> newItem = {
    'name': '',
    'description': '',
    'price': 0.0,
    'category': '',
    'isAvailable': true,
    'isPopular': false,
    'allergens': <String>[],
    'preparationTime': 15,
  };

  final List<String> allergenOptions = [
    'gluten', 'dairy', 'eggs', 'nuts', 'peanuts', 'soy', 'fish', 'shellfish'
  ];

  List<Map<String, dynamic>> get filteredItems {
    return menuItems.where((item) {
      final matchesSearch = item['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           item['description'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'all' || item['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _addItem() {
    if (newItem['name'].isNotEmpty && newItem['price'] > 0 && newItem['category'].isNotEmpty) {
      setState(() {
        menuItems.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': newItem['name'],
          'description': newItem['description'],
          'price': newItem['price'],
          'category': newItem['category'],
          'isAvailable': newItem['isAvailable'],
          'isPopular': newItem['isPopular'],
          'allergens': List<String>.from(newItem['allergens']),
          'preparationTime': newItem['preparationTime'],
        });
        newItem = {
          'name': '',
          'description': '',
          'price': 0.0,
          'category': '',
          'isAvailable': true,
          'isPopular': false,
          'allergens': <String>[],
          'preparationTime': 15,
        };
      });
    }
  }

  void _editItem() {
    if (_editingItem != null) {
      setState(() {
        final index = menuItems.indexWhere((item) => item['id'] == _editingItem!['id']);
        if (index != -1) {
          menuItems[index] = Map<String, dynamic>.from(_editingItem!);
        }
        _editingItem = null;
      });
    }
  }

  void _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: const Text('Are you sure you want to delete this menu item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                menuItems.removeWhere((item) => item['id'] == id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleItemAvailability(String id) {
    setState(() {
      final index = menuItems.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        menuItems[index]['isAvailable'] = !menuItems[index]['isAvailable'];
      }
    });
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
                  'Menu Management',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddItemDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: primary,
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                  ),
                ),
              ],
            ),
          ),

          // Search and Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search menu items...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Category Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip('all', 'All Items (${menuItems.length})', Icons.restaurant),
                      ...categories.map((category) {
                        final count = menuItems.where((item) => item['category'] == category['id']).length;
                        return _buildCategoryChip(
                          category['id'],
                          '${category['name']} ($count)',
                          category['icon'],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items List
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildMenuItemCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String categoryId, String label, IconData icon) {
    final isSelected = _selectedCategory == categoryId;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? primary : accent),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = categoryId;
          });
        },
        selectedColor: accent.withOpacity(0.2),
        checkmarkColor: primary,
        labelStyle: TextStyle(
          color: isSelected ? primary : accent,
          fontSize: 12,
        ),
        side: BorderSide(color: accent.withOpacity(0.3)),
      ),
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.5)),
        boxShadow: !item['isAvailable'] ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and badges
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                ),
                if (item['isPopular'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.orange),
                        const SizedBox(width: 4),
                        const Text(
                          'Popular',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!item['isAvailable'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Unavailable',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              item['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 12),

            // Price, time, allergens
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 16, color: Colors.green),
                    Text(
                      item['price'].toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Text(
                  '${item['preparationTime']} min',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (item['allergens'].isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Allergens: ${item['allergens'].join(', ')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _toggleItemAvailability(item['id']),
                    style: TextButton.styleFrom(
                      foregroundColor: item['isAvailable'] ? Colors.red : Colors.green,
                      side: BorderSide(
                        color: item['isAvailable'] ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      item['isAvailable'] ? 'Mark Unavailable' : 'Mark Available',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showEditItemDialog(item),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  color: accent,
                  style: IconButton.styleFrom(
                    side: BorderSide(color: accent.withOpacity(0.3)),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _deleteItem(item['id']),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  color: Colors.red,
                  style: IconButton.styleFrom(
                    side: BorderSide(color: Colors.red.withOpacity(0.3)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: 64,
            color: accent.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'all'
                ? 'Try adjusting your search or filter criteria'
                : 'Start building your menu by adding your first item',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddItemDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add First Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxWidth: 500),
          child: _buildItemForm(
            item: newItem,
            title: 'Add Menu Item',
            subtitle: 'Create a new item for your menu',
            onSave: _addItem,
            onCancel: () {
              setState(() {
                newItem = {
                  'name': '',
                  'description': '',
                  'price': 0.0,
                  'category': '',
                  'isAvailable': true,
                  'isPopular': false,
                  'allergens': <String>[],
                  'preparationTime': 15,
                };
              });
              Navigator.pop(context);
            },
            onUpdate: (field, value) {
              setState(() {
                newItem[field] = value;
              });
            },
          ),
        ),
      ),
    );
  }

  void _showEditItemDialog(Map<String, dynamic> item) {
    setState(() {
      _editingItem = Map<String, dynamic>.from(item);
      _editingItem!['allergens'] = List<String>.from(item['allergens']);
    });

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxWidth: 500),
          child: _buildItemForm(
            item: _editingItem!,
            title: 'Edit Menu Item',
            subtitle: 'Update your menu item details',
            onSave: _editItem,
            onCancel: () {
              setState(() {
                _editingItem = null;
              });
              Navigator.pop(context);
            },
            onUpdate: (field, value) {
              setState(() {
                _editingItem![field] = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemForm({
    required Map<String, dynamic> item,
    required String title,
    required String subtitle,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    required Function(String, dynamic) onUpdate,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Item Name
            TextField(
              decoration: const InputDecoration(
                labelText: 'Item Name *',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: item['name']),
              onChanged: (value) => onUpdate('name', value),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: item['description']),
              maxLines: 3,
              onChanged: (value) => onUpdate('description', value),
            ),
            const SizedBox(height: 16),

            // Price and Prep Time
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Price *',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: item['price'].toString()),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => onUpdate('price', double.tryParse(value) ?? 0.0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Prep Time (min)',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: item['preparationTime'].toString()),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => onUpdate('preparationTime', int.tryParse(value) ?? 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
  decoration: const InputDecoration(
    labelText: 'Category *',
    border: OutlineInputBorder(),
  ),
  value: item['category'].isEmpty ? null : item['category'],
  items: categories.map<DropdownMenuItem<String>>((category) {
    return DropdownMenuItem<String>(
      value: category['id'],
      child: Text(category['name']),
    );
  }).toList(),
  onChanged: (value) => onUpdate('category', value ?? ''),
),
            const SizedBox(height: 16),

            // Allergens
            const Text(
              'Allergens',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: primary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allergenOptions.map((allergen) {
                final isSelected = item['allergens'].contains(allergen);
                return FilterChip(
                  selected: isSelected,
                  label: Text(allergen),
                  onSelected: (selected) {
                    final allergens = List<String>.from(item['allergens']);
                    if (selected) {
                      allergens.add(allergen);
                    } else {
                      allergens.remove(allergen);
                    }
                    onUpdate('allergens', allergens);
                  },
                  selectedColor: accent.withOpacity(0.2),
                  checkmarkColor: primary,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Checkboxes
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Available'),
                    value: item['isAvailable'],
                    onChanged: (value) => onUpdate('isAvailable', value ?? true),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Popular Item'),
                    value: item['isPopular'],
                    onChanged: (value) => onUpdate('isPopular', value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: accent,
                      side: BorderSide(color: accent.withOpacity(0.3)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onSave();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Item'),
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
