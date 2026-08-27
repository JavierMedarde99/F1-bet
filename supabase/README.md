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

La app actual usa la anon key (sin Supabase Auth). Para que el login y las
apuestas funcionen, en `users_f1` y `bets` debe haber RLS activado **y** el rol
`anon` debe tener los privilegios base de la tabla:

```sql
-- users_f1: solo lectura (login)
alter table public.users_f1 enable row level security;
grant select on public.users_f1 to anon;
create policy "login puede leer usuarios"
  on public.users_f1 for select to anon using (true);

-- bets: SELECT / INSERT / UPDATE (apostar y consultar)
alter table public.bets enable row level security;
grant select, insert, update on public.bets to anon;
create policy "cualquiera puede ver las apuestas"
  on public.bets for select to anon using (true);
create policy "cualquiera puede apostar"
  on public.bets for insert to anon with check (true);
create policy "cualquiera puede actualizar su apuesta"
  on public.bets for update to anon using (true) with check (true);
```

Nota: sin el `grant` sobre la tabla, aunque exista política RLS, Postgres
devuelve `permission denied for table ... (42501)`.
