import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de diseño "Grid Dynamic" (ver DESIGN.md).
///
/// Estética de cabina de F1: base carbón, acentos neón (lima Aston / rojo
/// corsa), tipografía técnica y esquinas estrictamente rectas.
abstract final class GridColors {
  // Superficies (carbón / asfalto)
  static const Color surface = Color(0xFF131313);
  static const Color surfaceDim = Color(0xFF131313);
  static const Color surfaceBright = Color(0xFF393939);
  static const Color containerLowest = Color(0xFF0E0E0E);
  static const Color containerLow = Color(0xFF1C1B1B);
  static const Color container = Color(0xFF201F1F);
  static const Color containerHigh = Color(0xFF2A2A2A);
  static const Color containerHighest = Color(0xFF353534);

  // Contenido sobre superficie
  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFC4C9AE);

  // Bordes
  static const Color outline = Color(0xFF8E937A);
  static const Color outlineVariant = Color(0xFF444934);

  // Primario: blanco con acentos lima Aston
  static const Color primary = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFF283500);
  static const Color primaryContainer = Color(0xFFC4F42B);
  static const Color onPrimaryContainer = Color(0xFF556D00);

  // Secundario: rojo corsa
  static const Color secondary = Color(0xFFFFB4A8);
  static const Color onSecondary = Color(0xFF680100);
  static const Color secondaryContainer = Color(0xFFFF5540);
  static const Color onSecondaryContainer = Color(0xFF5C0100);

  // Error
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Alias semánticos usados en los componentes
  static const Color lime = primaryContainer;
  static const Color limeDim = Color(0xFFA9D600);
  static const Color rossoCorsa = secondaryContainer;
}

/// Tipografías del sistema (Anybody / Hanken Grotesk / JetBrains Mono).
abstract final class GridTypography {
  static TextStyle displayRace({Color color = GridColors.onSurface}) =>
      GoogleFonts.anybody(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: 2.4,
        fontStyle: FontStyle.italic,
        color: color,
      );

  static TextStyle headlineLg({Color color = GridColors.onSurface}) =>
      GoogleFonts.anybody(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.64,
        fontStyle: FontStyle.italic,
        color: color,
      );

  static TextStyle headlineLgMobile({Color color = GridColors.onSurface}) =>
      GoogleFonts.anybody(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
        fontStyle: FontStyle.italic,
        color: color,
      );

  static TextStyle bodyMd({Color color = GridColors.onSurface}) =>
      GoogleFonts.hankenGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: color,
      );

  static TextStyle dataMono({Color color = GridColors.onSurface}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: 0.28,
        color: color,
      );

  static TextStyle oddsLg({Color color = GridColors.onSurface}) =>
      GoogleFonts.anybody(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.0,
        color: color,
      );

  /// Etiquetas en mayúsculas; el texto debe pasarse ya en mayúsculas.
  static TextStyle labelCaps({Color color = GridColors.onSurfaceVariant}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 1.2,
        color: color,
      );
}

/// Espaciado en incrementos de 4px.
abstract final class GridSpacing {
  static const double unit = 4;
  static const double gutter = 16;
  static const double margin = 24;
  static const double containerMax = 1280;
}

/// Formas: perfil afilado (0px), sin curvas.
abstract final class GridShapes {
  static const double radius = 0;
  static const BorderRadius borderRadius = BorderRadius.zero;
  static const BorderSide thinSide = BorderSide(color: GridColors.outlineVariant);
}

/// ThemeData global de la app según el diseño "Grid Dynamic".
ThemeData getGridTheme() {
  const scheme = ColorScheme.dark(
    surface: GridColors.surface,
    onSurface: GridColors.onSurface,
    surfaceContainerLowest: GridColors.containerLowest,
    surfaceContainerLow: GridColors.containerLow,
    surfaceContainer: GridColors.container,
    surfaceContainerHigh: GridColors.containerHigh,
    surfaceContainerHighest: GridColors.containerHighest,
    onSurfaceVariant: GridColors.onSurfaceVariant,
    outline: GridColors.outline,
    outlineVariant: GridColors.outlineVariant,
    primary: GridColors.primaryContainer,
    onPrimary: GridColors.onPrimary,
    primaryContainer: GridColors.primaryContainer,
    onPrimaryContainer: GridColors.onPrimaryContainer,
    secondary: GridColors.rossoCorsa,
    onSecondary: GridColors.onSecondaryContainer,
    secondaryContainer: GridColors.secondaryContainer,
    onSecondaryContainer: GridColors.onSecondary,
    error: GridColors.error,
    onError: GridColors.onError,
    errorContainer: GridColors.errorContainer,
    onErrorContainer: GridColors.onErrorContainer,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: GridColors.surface,
    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
    textTheme: TextTheme(
      displayLarge: GridTypography.displayRace(),
      headlineLarge: GridTypography.headlineLg(),
      headlineMedium: GridTypography.headlineLgMobile(),
      bodyMedium: GridTypography.bodyMd(),
      labelSmall: GridTypography.labelCaps(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: GridColors.surface,
      foregroundColor: GridColors.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GridTypography.headlineLgMobile(),
      shape: const Border(bottom: BorderSide(color: GridColors.outlineVariant)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GridColors.lime,
        foregroundColor: GridColors.onPrimary,
        textStyle: GridTypography.labelCaps(color: GridColors.onPrimary),
        padding: const EdgeInsets.symmetric(
          horizontal: GridSpacing.gutter,
          vertical: 14,
        ),
        shape: const RoundedRectangleBorder(borderRadius: GridShapes.borderRadius),
        side: const BorderSide(color: GridColors.limeDim),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GridColors.containerLow,
      hintStyle: GridTypography.dataMono(color: GridColors.outline),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: GridColors.outlineVariant),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: GridColors.lime, width: 2),
      ),
      labelStyle: GridTypography.labelCaps(),
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStatePropertyAll(GridColors.containerHigh),
      dataRowColor: WidgetStatePropertyAll(GridColors.container),
      headingTextStyle: GridTypography.labelCaps(color: GridColors.lime),
      dataTextStyle: GridTypography.dataMono(),
      border: TableBorder.all(color: GridColors.outlineVariant, width: 1),
    ),
    cardTheme: CardThemeData(
      color: GridColors.container,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: GridShapes.borderRadius,
        side: const BorderSide(color: GridColors.outlineVariant),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: GridColors.containerHigh,
      contentTextStyle: GridTypography.bodyMd(),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: GridShapes.borderRadius),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: GridColors.lime,
      linearTrackColor: GridColors.containerHighest,
    ),
    refreshIndicatorTheme: const RefreshIndicatorThemeData(
      color: GridColors.lime,
      backgroundColor: GridColors.containerHigh,
    ),
    dividerTheme: const DividerThemeData(color: GridColors.outlineVariant),
  );
}
