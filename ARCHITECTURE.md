# ARCHITECTURE.md — F1-Bet

## Visión general

**F1-Bet** es una aplicación móvil (Flutter/Dart) para apostar de forma no monetaria sobre las posiciones de **Fernando Alonso (ID 14)** y **Carlos Sainz (ID 55)** en cada Gran Premio de Fórmula 1 del año en curso.

La app es un frontend que combina **tres fuentes de datos**:
- **OpenF1 API** (HTTP público): calendario de carreras y resultados reales de la temporada.
- **Supabase** (PostgreSQL, vía *anon key* sin Supabase Auth): usuarios, autenticación por contraseña y apuestas.
- **Assets locales**: imágenes de pilotos, iconos y la configuración `.env`.

El diseño visual sigue la especificación **"Grid Dynamic"** definida en `DESIGN.md` e implementada en `lib/utils/theme.dart`.

---

## Diagrama de flujo

```
                    ┌─────────────────┐
                    │   main.dart     │
                    │ (bootstrap)     │
                    └────────┬────────┘
                             │ connectiondatabase()
                             ▼
                    ┌─────────────────┐
                    │   LoginPage     │──► Formlogin ──► validateLogin() ──► Supabase `users_f1`
                    └────────┬────────┘                          (bcrypt)
                             │ userId
                             ▼
                    ┌─────────────────┐
                    │   F1page        │──► ListRaces ──► getCircuits() ──► OpenF1 `/meetings`
                    │ "F1 ALL RACES"  │        │  (futura / apostar / resultados)
                    └─────────────────┘        │
                             │                 ├─► Betpage ──► FormBet ──► sendBet() ──► Supabase `bets`
                             │                 └─► Resultpage ──► ListResults
                             │                         │  getResults() ──► OpenF1 `/sessions` + `/session_result`
                             │                         │  getBetsForMeeting() ──► Supabase `bets`
                             │                         ▼
                             │                  TableResults (cálculo de diferencias + ranking)
                             │
                             ▼
                  (cada tarjeta de carrera decide su acción según CircuitsState)
```

---

## Estructura de directorios

```
lib/
├── main.dart                     # Bootstrap: init Supabase + tema; LoginPage
├── f1Page.dart                   # Página principal: lista de carreras (AppBar + ListRaces)
├── betPage.dart                  # Página de apuesta de una carrera
├── resultPage.dart               # Página de resultados de una carrera
├── components/                   # Widgets reutilizables
│   ├── FormLogin.dart            #   Formulario de login
│   ├── FormBet.dart              #   Formulario de apuesta (Alonso/Sainz)
│   ├── ListRaces.dart            #   Lista de circuitos + navegación por estado
│   ├── cardPage.dart             #   Tarjeta de carrera (imagen + texto + acción)
│   ├── ListResults.dart          #   Orquestador de la página de resultados
│   ├── resultF1.dart             #   Módulos de telemetría (posición real de pilotos)
│   ├── tableResults.dart         #   Tabla de apuestas/diferencias
│   └── error_retry.dart          #   Vista de error reutilizable con botón REINTENTAR
├── models/                       # Clases de datos (DTO sin lógica)
│   ├── circuits.dart             #   Circuit + enum CircuitsState
│   ├── results.dart              #   Results (aggera races + users)
│   ├── resultsRaces.dart         #   Posiciones reales de la carrera
│   ├── resultsUser.dart          #   Apuesta de un usuario
│   └── resultTable.dart          #   Fila de la tabla de resultados
└── utils/                        # Lógica de negocio y acceso a datos
    ├── connectionDataBase.dart   #   Cliente Supabase (toda la capa de BD)
    ├── f1Api.dart                #   Cliente HTTP OpenF1
    ├── constants.dart            #   IDs de pilotos + URLs
    └── theme.dart                #   Tokens "Grid Dynamic" + getGridTheme()
```

---

## Capas de la arquitectura

### 1. Bootstrap (`lib/main.dart`)
- `main()` llama a `connectiondatabase()` **antes** de `runApp`, inicializando Supabase (lee `.env` o variables de entorno compiladas).
- `MyApp` construye el `MaterialApp` con `getGridTheme()`.
- `LoginPage` es el arranque real de la sesión (no usa Auth de Supabase).

### 2. Páginas / Pantallas (`widgets` de nivel superior)
- **`F1page`** (`f1Page.dart`): recibe `userId`; AppBar con título + chip de año; cuerpo = `ListRaces`.
- **`Betpage`** (`betPage.dart`): recibe `userId` y `meetingId`; cuerpo = `FormBet`.
- **`Resultpage`** (`resultPage.dart`): recibe `meetingId`; cuerpo = `ListResults`.

Todas son `StatelessWidget`s que **no contienen lógica de datos**: delegan en los componentes y en la capa `utils`.

### 3. Componentes (lógica de UI + estado local)
- **`ListRaces`** (`StatefulWidget`): mantiene el `Future<List<Circuit>>`, llama a `getCircuits()` y decide, según `CircuitsState`, si el botón de la tarjeta navega a `Betpage` o `Resultpage`.
- **`Formlogin`** y **`FormBet`**: controlan inputs (`TextEditingController`), validan en cliente y llaman a las funciones de `utils`.
- **`ListResults`** (`StatefulWidget`): orquesta `Future.wait([getResults, getBetsForMeeting])`, maneja estados de carga/error/datos.
- **`tableResults`**: calcula la diferencia de cada apuesta y ordena el ranking localmente.

### 4. Modelos (`lib/models/`)
DTOs inmutables, sin comportamiento. `CircuitsState` es un `enum` que define el estado de la carrera y gobierna la navegación:
- `future`: carrera futura → botón deshabilitado.
- `bet`: ventana de apuesta → botón "APOSTAR".
- `result`: carrera finalizada → botón "RESULTADOS".

### 5. Acceso a datos y servicios (`lib/utils/`)

| Archivo | Responsabilidad | Fuente |
|---------|-----------------|--------|
| `connectionDataBase.dart` | Todo el acceso a Supabase: login (bcrypt), get/send de apuestas, nombres de usuario | Supabase |
| `f1Api.dart` | Cliente HTTP OpenF1: circuitos, sesiones y resultados | OpenF1 API |
| `constants.dart` | Constantes: `ALONSO_ID`, `SAINZ_ID`, URLs | — |

---

## Flujo de datos detallado

### Autenticación (Supabase, anon key, bcrypt)
1. `Formlogin` envía usuario+contraseña a `validateLogin(username, password)`.
2. `validateLogin` (`connectionDataBase.dart`) consulta `users_f1` filtrando por `user_name`, obtiene `id` y `password`.
3. Si la contraseña almacenada es bcrypt (`$2a$/$2b$/$2y$`) → `BCrypt.checkpw`.
4. Si es **legacy en texto plano** → se verifica y se **migra automáticamente** a hash (`_upgradeStoredPasswordToHash`).
5. Devuelve el `userId` (0 si falla). `Formlogin` navega a `F1page(userId)`.

### Calendario de carreras (OpenF1)
1. `getCircuits()` (`f1Api.dart`) consulta `/meetings?year=YYYY` (año actual desde `constants.dart`).
2. Calcula el **jueves de la semana de carrera** (`date_end - 3 días`) mediante `_daysFromToday`.
3. Clasifica cada circuito en `CircuitsState` según los días restantes hasta el jueves:
   - `< 0` → `result`
   - `< 7` → `bet`
   - resto → `future`
4. Filtra carreras `Pre-Season` (`filterCircuits`).
5. Devuelve `List<Circuit>` con `name`, `imagen` (bandera), `meetingId`, `state` y `dateEnd`.

### Resultados de carrera (OpenF1)
1. `getResults(meetingKey)` obtiene el `session_id` de la carrera vía `getRace()` (`/sessions?meeting_key=`).
2. Llama a `getResultsByDriver()` para Alonso (14) y Sainz (55) vía `/session_result`.
3. Códigos especiales de retorno:
   - `-1`: sin resultados para el piloto.
   - `-2`: el piloto no terminó o no tiene posición asignada.
4. Se combina con `getBetsForMeeting()` en `ListResults`.

### Apuestas (Supabase)
1. `FormBet` carga la apuesta previa con `getBetForMeetingAndUser(userId, meetingId)`.
2. Valida en cliente: campos obligatorios y posiciones entre **1 y 20**.
3. `sendBet()` inserta (si no existe) o actualiza (si existe) la fila en `bets`.

### Tabla de resultados (cálculo local)
`tableResults` convierte cada `ResultsUser` a `ResultTable`, calcula
`dif = |posiciónAlonsoReal - apuestaAlonso| + |posiciónSainzReal - apuestaSainz|`,
y ordena de **mayor a menor diferencia** (mayor diferencia = último). Las filas con la diferencia máxima se resaltan en rojo corsa.

---

## Modelo de datos (Supabase)

Tablas gestionadas por la app:

- **`users_f1`**: `id`, `user_name`, `password` (hash bcrypt).
- **`bets`**: `user_id`, `meeting_bet`, `alonso_position`, `sainz_position`.
- **`results`**: tabla hoja poblada por la app (según `AGENTS.md`) con `meeting_bet`, `alonso_position`, `sainz_position`.

> Configuración RLS y GRANTs documentados en `supabase/README.md`. **Nota clave:** además de las políticas RLS, el rol `anon` necesita `GRANT` base sobre las tablas; sin él se produce `permission denied for table ... (42501)`.

---

## Diseño del sistema ("Grid Dynamic")

- Implementado en `lib/utils/theme.dart` como `getGridTheme()`.
- **Tipografía**: JetBrains Mono (14px `dataMono`), `labelCaps` (12px, letterSpacing 1.2), Google Fonts (Hanken Grotesk / Anybody).
- **Colores**: `rossoCorsa` (rojo), `lime`/`primaryContainer` (verde), escalas de superficie.
- **Espaciado**: `GridSpacing.gutter = 16`, `unit = 4`, `margin = 24`.
- **Responsividad móvil** (objetivo Galaxy A35 5G, 360dp):
  - `cardPage.dart`: `Row` con `flex` para imagen/contenido.
  - `tableResults.dart`: `SingleChildScrollView` horizontal + `maxWidth: 140` en la columna USUARIO.
  - Título del AppBar reducido para no solaparse con el chip del año (`f1Page.dart`).
- Puedes obtener el detalle completo en `DESIGN.md`.

---

## Configuración y despliegue

- **`.env`** (gitignored, generado por CI): `DATABASE_URL` + `ANON_KEY`. Fuente de respaldo: `--dart-define`.
- **CI**: `.github/workflows/` genera `.env` desde secrets antes de compilar.
- **Comandos útiles** (`AGENTS.md`):
  - `flutter pub get`
  - `flutter analyze` (0 errores/warnings; ~50 info-lints de archivo/print son baseline)
  - `dart format --output=none --set-exit-if-changed .`
  - `dart run tool/hash_password.dart <password>` (generar hash bcrypt).

---

## Convenciones del equipo

- **Ramas**: `fix/<issue>-<desc>`, `feat/<issue>-<desc>`, `chore/<issue>-<desc>`.
- **PRs** apuntan a `main`; los PRs de diseño se apilan (`feat/33` → `feat/35` → `feat/47`).
- No auto-mergear salvo indicación explícita.
- Tras un merge con SQL nuevo, ejecutar los scripts de `supabase/*.sql` manualmente en el SQL Editor.

---

## Limitaciones / deuda técnica conocida

- La autenticación se basa en contraseña bcrypt vía anon key **sin Supabase Auth**; no hay sesiones persistentes y cada pantalla propaga `userId` por constructor.
- La lógica de negocio de resultados y ranking reside en la **capa de componentes** (`tableResults`) en lugar de en una capa de dominio separada; el ranking se calcula en cliente, no en BD.
- `CircuitsState` se deriva de fechas en el cliente; depende de que la fecha `date_end` de OpenF1 esté disponible.
- El modelo `results` (poblado por la app) está definido en la BD pero no se consume activamente en UI en la versión actual.
