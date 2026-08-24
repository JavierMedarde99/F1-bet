# F1-Bet 🏁

Aplicación móvil hecha en Flutter para apostar entre amigos por las posiciones finales de **Fernando Alonso** y **Carlos Sainz** en los Grandes Premios de Fórmula 1.

## Cómo funciona

1. **Inicio de sesión**: el usuario accede con sus credenciales, validadas contra la tabla `users_f1` de Supabase.
2. **Lista de carreras**: se obtienen los Grandes Premios del año actual desde la API de [OpenF1](https://openf1.org) (excluyendo los Pre-Season). Cada carrera muestra un botón según su estado:
   - `Apostar`: la carrera termina en menos de 7 días.
   - `Resultados`: la carrera ya finalizó.
   - Deshabilitado: carrera futura (a más de 7 días).
3. **Apostar**: se introduce la posición final (1-20) que se cree que logrará Alonso y Sainz. La apuesta se guarda en Supabase y puede actualizarse hasta que termine la carrera.
4. **Resultados**: al finalizar la carrera, la app consulta las posiciones reales en OpenF1 y genera una clasificación: gana quien tenga la **menor diferencia total** entre sus posiciones apostadas y las reales.

## Tecnologías

- [Flutter](https://flutter.dev) / Dart
- [Supabase](https://supabase.com): autenticación de usuarios y almacenamiento de apuestas
- [OpenF1 API](https://openf1.org): datos de reuniones, sesiones y resultados de carreras
- `flutter_dotenv`: gestión de variables de entorno

## Estructura del proyecto

```
lib/
├── main.dart                  # Punto de entrada: inicializa Supabase y muestra el login
├── f1Page.dart                # Pantalla principal con el listado de carreras
├── betPage.dart               # Pantalla de apuesta
├── resultPage.dart            # Pantalla de resultados
├── components/
│   ├── FormLogin.dart         # Formulario de inicio de sesión
│   ├── FormBet.dart           # Formulario de apuesta (validación 1-20)
│   ├── listRaces.dart         # Listado de circuitos con pull-to-refresh
│   ├── listResults.dart       # Carga y lógica de resultados
│   ├── cardPage.dart          # Tarjeta reutilizable (imagen + texto + acción)
│   ├── tableResults.dart      # Tabla de clasificación de apuestas
│   ├── resultF1.dart          # Cabecera con resultados reales
│   └── error_retry.dart       # Widget reutilizable de error con reintento
├── models/                    # Modelos de datos (Circuit, ResultsRaces, ResultsUser...)
└── utils/
    ├── f1Api.dart             # Cliente de la API OpenF1
    ├── connectionDataBase.dart# Conexión Supabase y consultas (apuestas, login)
    └── constants.dart         # IDs de pilotos (Alonso=14, Sainz=55) y URLs
```

## Base de datos (Supabase)

- **`users_f1`**: `id`, `user_name`, `password`
- **`bets`**: `user_id`, `meeting_bet`, `alonso_position`, `sainz_position`

## Puesta en marcha

### Requisitos

- Flutter SDK (el proyecto usa `sdk: ^3.10.8` de Dart)

### Configuración

Crea un archivo `.env` en la raíz del proyecto con las credenciales de Supabase (puedes usar `.env.example` como plantilla):

```env
DATABASE_URL=https://tu-proyecto.supabase.co
ANON_KEY=tu-anon-key
```

> Nota: `.env` está en `.gitignore` para no publicar credenciales.

### Ejecutar

```sh
flutter pub get
flutter run
```

### Compilar APK release

```sh
flutter build apk --release
```

El APK se genera en `build/app/outputs/flutter-apk/app-release.apk`.

## CI/CD

El proyecto usa GitHub Actions:

- **Build Flutter APK** (`.github/workflows/build.yml`): compila el APK release en cada push a `main` y lo sube como artefacto. Genera el `.env` automáticamente a partir de los secrets `DATABASE_URL` y `ANON_KEY`.
- **Flutter CI** (`.github/workflows/ci.yml`): análisis estático, formato y tests en pushes y PRs a `main`.
