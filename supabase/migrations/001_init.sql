-- Migración inicial: esquema de la base de datos
-- Ejecutar manualmente en el SQL Editor de Supabase.

-- users_f1: usuarios de la app
create table if not exists public.users_f1 (
  id serial primary key,
  user_name text unique not null,
  password text not null
);

-- bets: apuestas de cada usuario por sesión
create table if not exists public.bets (
  user_id integer references public.users_f1(id) on delete cascade,
  meeting_bet text not null,
  alonso_position integer not null check (alonso_position between 1 and 20),
  sainz_position integer not null check (sainz_position between 1 and 20),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (user_id, meeting_bet)
);

-- results: resultados oficiales por sesión
create table if not exists public.results (
  meeting_bet text primary key,
  alonso_position integer not null check (alonso_position >= 1),
  sainz_position integer not null check (sainz_position >= 1)
);