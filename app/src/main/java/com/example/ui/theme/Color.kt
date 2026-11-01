package com.example.ui.theme

import androidx.compose.ui.graphics.Color

val Purple80 = Color(0xFFD0BCFF)
val PurpleGrey80 = Color(0xFFCCC2DC)
val Pink80 = Color(0xFFEFB8C8)

val Purple40 = Color(0xFF6366F1)
val PurpleGrey40 = Color(0xFF475569)
val Pink40 = Color(0xFFEC4899)

// Note Card Color Palettes - Soft pastel tinted backgrounds for modern card surfaces
val NoteAmberLight = Color(0xFFFEF3C7) // Amber 100
val NoteAmberBorder = Color(0xFFF59E0B)
val NoteAmberDark = Color(0xFF78350F)

val NoteBlueLight = Color(0xFFE0F2FE) // Sky 100
val NoteBlueBorder = Color(0xFF0284C7)
val NoteBlueDark = Color(0xFF0C4A6E)

val NoteGreenLight = Color(0xFFDCFCE7) // Emerald 100
val NoteGreenBorder = Color(0xFF10B981)
val NoteGreenDark = Color(0xFF064E3B)

val NoteOrangeLight = Color(0xFFFFEDD5) // Orange 100
val NoteOrangeBorder = Color(0xFFF97316)
val NoteOrangeDark = Color(0xFF7C2D12)

val NotePinkLight = Color(0xFFFCE7F3) // Pink 100
val NotePinkBorder = Color(0xFFEC4899)
val NotePinkDark = Color(0xFF831843)

val NoteTealLight = Color(0xFFCCFBF1) // Teal 100
val NoteTealBorder = Color(0xFF14B8A6)
val NoteTealDark = Color(0xFF134E4A)

data class NoteColorTheme(
    val id: Int,
    val name: String,
    val lightSurface: Color,
    val border: Color,
    val textPrimary: Color,
    val accent: Color
)

val NotePalettes = listOf(
    NoteColorTheme(0, "Amber", NoteAmberLight, NoteAmberBorder, Color(0xFF451A03), Color(0xFFD97706)),
    NoteColorTheme(1, "Blue", NoteBlueLight, NoteBlueBorder, Color(0xFF082F49), Color(0xFF0284C7)),
    NoteColorTheme(2, "Green", NoteGreenLight, NoteGreenBorder, Color(0xFF022C22), Color(0xFF059669)),
    NoteColorTheme(3, "Orange", NoteOrangeLight, NoteOrangeBorder, Color(0xFF431407), Color(0xFFEA580C)),
    NoteColorTheme(4, "Pink", NotePinkLight, NotePinkBorder, Color(0xFF500724), Color(0xFFDB2777)),
    NoteColorTheme(5, "Teal", NoteTealLight, NoteTealBorder, Color(0xFF042F2E), Color(0xFF0D9488))
)
