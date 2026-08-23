# f1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Seguridad (aviso conocido)

- **Contraseñas en texto plano (crítico, issue #1):** el login compara la
  contraseña directamente contra la columna `password` de `users_f1`, que se
  almacena sin hashear. Si la base de datos se ve comprometida, todas las
  credenciales quedan expuestas. La solución recomendada es migrar a Supabase
  Auth o almacenar hashes (bcrypt/argon2); ambas requieren migrar las filas
  existentes. Pendiente de implementar.
- **Row Level Security (issue #8):** verificar que las tablas `bets` y
  `users_f1` tengan RLS habilitado con políticas adecuadas; con solo la clave
  anónima pública, sin RLS cualquiera puede leer/modificar todos los datos.

