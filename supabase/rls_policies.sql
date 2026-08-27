-- ============================================================================
-- Row Level Security para F1-Bet (issue #8)
--
-- Ejecutar en el SQL Editor de Supabase.
--
-- IMPORTANTE: la app actual NO usa Supabase Auth (login propio contra la tabla
-- users_f1 con la anon key). Por tanto, las políticas de abajo replican el
-- comportamiento que la app necesita hoy: lectura/escritura anónima en `bets`
-- y lectura de credenciales en `users_f1` solo para el login.
--
-- Con RLS activo se bloquea todo acceso no autorizado por defecto (incluida
-- la service_role fuera del servidor y accesos vía PostgREST sin política),
-- pero el anon sigue pudiendo leer/escribir apuestas mientras la app no se
-- migre a Supabase Auth. Al final del archivo hay un ejemplo de políticas
-- reales basadas en auth.uid() para cuando se haga esa migración.
-- ============================================================================

-- Habilitar RLS en todas las tablas
alter table public.users_f1 enable row level security;
alter table public.bets enable row level security;

-- Revoke por si acaso existieran grants públicos directos (defensa en profundidad)
revoke all on public.users_f1 from anon, authenticated;
revoke all on public.bets from anon, authenticated;

-- ---------------------------------------------------------------------------
-- users_f1
-- La app solo necesita: SELECT (id, password) para validar el login.
-- Sin política de SELECT para anon, el login devuelve vacío y falla
-- con "Credenciales incorrectas" (RLS activo sin acceso al rol anon).
-- ---------------------------------------------------------------------------

create policy "login puede leer usuarios"
  on public.users_f1
  for select
  to anon
  using (true);

-- Sin políticas INSERT/UPDATE/DELETE para anon:
-- los usuarios se crean desde el panel de administración de Supabase.

-- ---------------------------------------------------------------------------
-- bets
-- La app necesita: SELECT (resultados), INSERT y UPDATE (apostar/actualizar).
-- ---------------------------------------------------------------------------

create policy "cualquiera puede ver las apuestas"
  on public.bets
  for select
  to anon
  using (true);

create policy "cualquiera puede apostar"
  on public.bets
  for insert
  to anon
  with check (true);

create policy "cualquiera puede actualizar su apuesta"
  on public.bets
  for update
  to anon
  using (true)
  with check (true);

-- Sin política DELETE para anon: nadie puede borrar apuestas vía cliente.

-- ============================================================================
-- MIGRACIÓN FUTURA A SUPABASE AUTH (recomendado)
--
-- Cuando el login use Supabase.auth, elimina las políticas anteriores y usa
-- políticas ligadas al usuario autenticado. Ejemplo:
--
-- drop policy "..." on public.bets; -- (todas las de arriba)
--
-- create policy "apuestas visibles para usuarios autenticados"
--   on public.bets for select to authenticated using (true);
--
-- create policy "solo puedes crear tus apuestas"
--   on public.bets for insert to authenticated
--   with check (auth.uid()::text = user_id::text);
--
-- create policy "solo puedes editar tus apuestas"
--   on public.bets for update to authenticated
--   using (auth.uid()::text = user_id::text)
--   with check (auth.uid()::text = user_id::text);
--
-- La tabla users_f1 dejaría de ser necesaria: los perfiles pasarían a
-- depender de auth.users (p. ej. tabla profiles con id = auth.uid()).
-- ============================================================================
