# Eventify - Flutter

## Descripción

Eventify es una plataforma móvil diseñada para la gestión de eventos e interacción entre usuarios. Incluye funcionalidades esenciales como la administración de eventos, la conexión entre usuarios y características sociales, tales como seguidores, notificaciones y comentarios.

## Tecnologías Utilizadas

- **Dart**: Lenguaje de programación optimizado para aplicaciones en múltiples plataformas.
- **Supabase**: Plataforma de backend como servicio (BaaS) para autenticación, base de datos y almacenamiento.
- **Firebase**: Utilizado para notificaciones push y análisis.
- **Flutter Localizations**: Solución de internacionalización integrada.

## Estructura del Proyecto

```
flutter-app/
├── lib/
│   ├── data/           # Capa de acceso a datos
│   │   ├── repositories/  # Repositorios para acceso a datos
│   │   └── services/      # Servicios de API
│   ├── models/         # Modelos de datos
│   ├── providers/      # Proveedores para gestión de estado
│   │   └── auth_provider.dart       # Proveedor de autenticación
│   │   └── notification_provider.dart  # Proveedor de notificaciones
│   ├── services/       # Servicios de la aplicación
│   │   └── auth_gate.dart           # 
│   │   └── auth_service.dart        # Servicio de autenticación
│   │   └── push_notifications.dart  # Servicio de notificaciones push
│   │   └── storage_service.dart     # Servicio de almacenamiento
│   ├── utils/          # Utilidades y helpers
│   ├── view_models/    # Modelos de vista (MVVM)
│   ├── views/          # Pantallas de la aplicación
│   ├── widgets/        # Componentes reutilizables
│   ├── l10n/           # Archivos de internacionalización
│   ├── navigation.dart # Sistema de navegación
│   ├── routes.dart     # Definición de rutas
│   └── main.dart       # Punto de entrada de la aplicación
├── assets/            # Recursos estáticos (imágenes, etc.)
├── fonts/             # Fuentes personalizadas
├── integration_test/  # Pruebas de integración
├── test/             # Pruebas unitarias
└── pubspec.yaml      # Dependencias y configuración
```

## Requisitos Previos

- Flutter SDK (última versión estable)
- Dart SDK
- Cuenta en Supabase

## Configuración del Entorno

1. Clona el repositorio:
   ```bash
   git clone https://github.com/valeraruggierotesisucv/flutter-app.git
   cd flutter-app
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Configura las variables de entorno:
   - Crea un archivo `.env` en la raíz del proyecto basado en `.env.example`
   - Añade las siguientes variables:
     ```
     SUPABASE_URL=tu_url_de_supabase
     SUPABASE_ANON_KEY=tu_clave_anonima_de_supabase
     FIREBASE_API_KEY=tu_clave_de_firebase
     API_URL=tu_api_url
     ```

## Ejecución de la Aplicación

### Desarrollo

Para iniciar la aplicación en modo desarrollo:

```bash
flutter run
```

Esto compilará y ejecutará la aplicación en el dispositivo/emulador conectado.

### Pruebas

Para ejecutar las pruebas unitarias:

```bash
flutter test
```

Para ejecutar las pruebas de integración:

```bash
flutter test integration_test
```

## Despliegue

### Generación de APK

Para generar el build:

```bash
flutter build apk --split-per-abi  # Para Android (APK)
```

## Contacto

Para preguntas o sugerencias, por favor contacta a valeraruggierotesisucv@gmail.com
