import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implementar navegación a configuración
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/100',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nombre Usuario',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'usuario@email.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileOption(
              icon: Icons.person,
              title: 'Editar Perfil',
              onTap: () {
                // TODO: Implementar edición de perfil
              },
            ),
            _buildProfileOption(
              icon: Icons.notifications,
              title: 'Notificaciones',
              onTap: () {
                // TODO: Implementar configuración de notificaciones
              },
            ),
            _buildProfileOption(
              icon: Icons.security,
              title: 'Privacidad y Seguridad',
              onTap: () {
                // TODO: Implementar configuración de privacidad
              },
            ),
            _buildProfileOption(
              icon: Icons.help,
              title: 'Ayuda y Soporte',
              onTap: () {
                // TODO: Implementar sección de ayuda
              },
            ),
            const SizedBox(height: 16),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Cerrar Sesión',
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
