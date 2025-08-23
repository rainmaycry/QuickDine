import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0C1B2A);
    const accent = Color(0xFFD4AF6A);
    const cardBackground = Colors.white;
    const backgroundColor = Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('QuickDine'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido de vuelta!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Encuentra y reserva en los mejores restaurantes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Acciones Rápidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildActionCard(
                  context,
                  'Buscar Restaurantes',
                  Icons.restaurant,
                  accent,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función próximamente disponible')),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Mis Reservas',
                  Icons.event_note,
                  accent,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función próximamente disponible')),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Favoritos',
                  Icons.favorite_outline,
                  accent,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función próximamente disponible')),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Historial',
                  Icons.history,
                  accent,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función próximamente disponible')),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent Activity
            Text(
              'Actividad Reciente',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay actividad reciente',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comienza explorando restaurantes cerca de ti',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: cardBackground,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey[400],
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Búsqueda próximamente disponible')),
              );
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reservas próximamente disponible')),
              );
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0C1B2A),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}