-- ============================================================================
-- Tabla de resultados oficiales (issue #59)
--
-- Ejecutar en el SQL Editor de Supabase.
--
-- Almacena el resultado oficial de cada carrera para que el ranking pueda
-- calcularse únicamente con datos de la base de datos, sin consultar la API
-- de OpenF1 en cada visita. La app guarda aquí el resultado automáticamente
-- la primera vez que se consultan los resultados de una carrera.
-- ============================================================================

create table if not exists public.results (
  meeting_bet text primary key,
  alonso_position int not null,
  sainz_position int not null
);

-- RLS: la app (anon key) necesita leer para el ranking y escribir para
-- persistir el resultado al consultarlo. Sin política DELETE.
alter table public.results enable row level security;

create policy "cualquiera puede ver los resultados"
  on public.results
  for select
  to anon
  using (true);

create policy "la app puede guardar resultados"
  on public.results
  for insert
  to anon
  with check (true);

create policy "la app puede actualizar resultados"
  on public.results
  for update
  to anon
  using (true)
  with check (true);
