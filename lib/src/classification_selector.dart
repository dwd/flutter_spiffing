import 'package:flutter/material.dart';
import 'package:spiffing/spiffing.dart';

import 'color_utils.dart';

/// A horizontal picker for choosing a [Label]'s [Classification] out of
/// all the classifications defined by a [Spif].
///
/// Classifications that [isSelectable] reports as not currently selectable
/// (e.g. because switching to them would leave the label invalid) are
/// rendered disabled rather than hidden, so the user can see the full
/// range of the policy.
class ClassificationSelector extends StatelessWidget {
  const ClassificationSelector({
    super.key,
    required this.classifications,
    required this.selected,
    required this.onSelected,
    this.isSelectable,
    this.langTag = '',
  });

  /// All classifications to offer, typically `spif.classifications()`.
  final List<Classification> classifications;

  /// The currently selected classification, if any.
  final Classification? selected;

  /// Called when the user picks a different classification.
  final ValueChanged<Classification> onSelected;

  /// Whether [classifications] entry can currently be selected; `null`
  /// means every classification is selectable.
  final bool Function(Classification classification)? isSelectable;

  /// Language tag used to look up localised display names.
  final String langTag;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final classification in classifications)
          _ClassificationChoiceChip(
            classification: classification,
            selected: classification == selected,
            enabled: isSelectable?.call(classification) ?? true,
            langTag: langTag,
            onTap: () => onSelected(classification),
          ),
      ],
    );
  }
}

class _ClassificationChoiceChip extends StatelessWidget {
  const _ClassificationChoiceChip({
    required this.classification,
    required this.selected,
    required this.enabled,
    required this.onTap,
    required this.langTag,
  });

  final Classification classification;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;
  final String langTag;

  @override
  Widget build(BuildContext context) {
    final background = parseSpifColor(classification.fgcolour);
    return ChoiceChip(
      label: Text(classification.displayName(langTag)),
      selected: selected,
      onSelected: enabled ? (_) => onTap() : null,
      selectedColor: background,
      labelStyle: selected && background != null
          ? TextStyle(color: contrastingTextColor(background))
          : null,
      disabledColor: Theme.of(context).disabledColor.withValues(alpha: 0.1),
    );
  }
}
