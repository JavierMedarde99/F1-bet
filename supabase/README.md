# Guía de base de datos (Supabase)

## Tablas

- **`users_f1`**: `id`, `user_name`, `password`
- **`bets`**: `user_id`, `meeting_bet`, `alonso_position`, `sainz_position`

## Contraseñas hasheadas (issue #1)

Las contraseñas de `users_f1.password` deben almacenarse como **hash bcrypt**, nunca en texto plano.

### Crear un usuario nuevo

Genera el hash y ejecuta el INSERT con el resultado:

```sh
dart run tool/hash_password.dart miContraseña
# $2b$10$... (hash generado)
```

```sql
INSERT INTO users_f1 (user_name, password) VALUES ('usuario', '<hash-generado>');
```

### Usuarios existentes en texto plano

No es necesario migrar manualmente: la app detecta contraseñas legacy en texto
plano al iniciar sesión, las verifica y las actualiza automáticamente a hash
bcrypt. Tras el primer login de cada usuario, la tabla quedará migrada.

## Row Level Security (issue #8)

Consulta [`rls_policies.sql`](./rls_policies.sql) para habilitar RLS con las
políticas necesarias para el funcionamiento actual de la app.
