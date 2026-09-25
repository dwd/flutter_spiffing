import 'package:flutter/material.dart';

/// Parses a colour as found in a SPIF (`classification color="..."` or
/// `#RRGGBB`/`#AARRGGBB` hex), falling back to `null` if [text] is empty or
/// not recognised.
///
/// SPIFs are free to use either CSS-style hex colours (e.g. `#FFAA00`) or
/// named colours (e.g. `red`, `white`, `gold`); a small set of the latter
/// commonly seen in the wild is supported here.
Color? parseSpifColor(String text) {
  final value = text.trim();
  if (value.isEmpty) return null;
  if (value.startsWith('#')) {
    final hex = value.substring(1);
    if (hex.length == 6) {
      final argb = int.tryParse('FF$hex', radix: 16);
      return argb != null ? Color(argb) : null;
    }
    if (hex.length == 8) {
      final argb = int.tryParse(hex, radix: 16);
      return argb != null ? Color(argb) : null;
    }
    return null;
  }
  return _namedColors[value.toLowerCase()];
}

const _namedColors = <String, Color>{
  'white': Color(0xFFFFFFFF),
  'black': Color(0xFF000000),
  'red': Color(0xFFFF0000),
  'green': Color(0xFF008000),
  'blue': Color(0xFF0000FF),
  'gold': Color(0xFFFFD700),
  'yellow': Color(0xFFFFFF00),
  'orange': Color(0xFFFFA500),
  'grey': Color(0xFF808080),
  'gray': Color(0xFF808080),
};

/// Returns black or white, whichever gives better contrast as a text
/// colour against [background].
Color contrastingTextColor(Color background) {
  return background.computeLuminance() > 0.5
      ? const Color(0xFF000000)
      : const Color(0xFFFFFFFF);
}
