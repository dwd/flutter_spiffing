import 'package:flutter/material.dart';
import 'package:spiffing/spiffing.dart';

import 'color_utils.dart';

/// A banner showing the live, human-readable display marking for [label],
/// coloured according to its current classification.
///
/// This is the kind of "marking banner" a label editor typically shows
/// alongside the editable classification/category fields, updating as the
/// user edits the label.
class MarkingPreview extends StatelessWidget {
  const MarkingPreview({
    super.key,
    required this.spif,
    required this.label,
    this.langTag = '',
  });

  final Spif spif;
  final Label label;
  final String langTag;

  @override
  Widget build(BuildContext context) {
    final marking = spif.displayMarking(label, langTag: langTag);
    final background =
        parseSpifColor(label.classification.fgcolour) ??
        Theme.of(context).colorScheme.primary;
    return Container(
      width: double.infinity,
      color: background,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      alignment: Alignment.center,
      child: Text(
        marking,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: contrastingTextColor(background),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
