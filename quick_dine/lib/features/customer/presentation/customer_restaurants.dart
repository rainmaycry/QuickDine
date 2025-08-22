import 'package:flutter/material.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurantes')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // TODO: conectar con backend
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Restaurante ${index + 1}"),
              subtitle: const Text("Descripción breve"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(
                context,
                '/client/restaurant/${index + 1}',
              ),
            ),
          );
        },
      ),
    );
  }
}
