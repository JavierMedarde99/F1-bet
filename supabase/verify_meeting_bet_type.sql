-- Issue #13: verificar el tipo real de la columna meeting_bet.
--
-- El código Dart trata meeting_bet como String en todas las llamadas
-- (getBetsForMeeting, getBetForMeetingAndUser, sendBet). Ejecuta esta
-- consulta en el SQL Editor de Supabase para confirmar que la columna
-- es de texto; si fuera numérica, habría que alinear el código (o la
-- columna) para evitar errores silenciosos en las queries.

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'bets'
  AND column_name IN ('meeting_bet', 'user_id', 'alonso_position', 'sainz_position');

-- Si data_type NO es text/character varying para meeting_bet, dos opciones:
--
-- a) Alinear la BD con el código (columna a texto):
--    ALTER TABLE bets ALTER COLUMN meeting_bet TYPE text;
--
-- b) Alinear el código con la BD: cambiar String meetingBet por int en
--    connectionDataBase.dart, FromBet.dart y listRaces.dart.
