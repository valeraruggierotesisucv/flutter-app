import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: ListView.builder(
        itemCount: 10, // Número de ejemplo de notificaciones
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.notifications),
              ),
              title: Text('Notificación ${index + 1}'),
              subtitle: Text(
                  'Esta es una descripción de ejemplo para la notificación ${index + 1}'),
              trailing: Text('${DateTime.now().hour}:${DateTime.now().minute}'),
              onTap: () {
                // Acción al tocar la notificación
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Notificación ${index + 1} seleccionada')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
