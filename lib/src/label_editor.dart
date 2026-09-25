import 'package:flutter/material.dart';
import 'package:spiffing/spiffing.dart';

import 'category_picker.dart';
import 'classification_selector.dart';
import 'clearance_indicator.dart';
import 'marking_preview.dart';

/// A complete security-label editor/picker: a live marking preview, a
/// [ClassificationSelector], and a [TagSetPicker] per tag set defined by
/// [spif], all wired up to mutate [label] in place.
///
/// [label] is mutated directly (it owns a live `Set<Category>`), and
/// [onChanged] is invoked after every edit so callers can persist the
/// result, re-run validation, etc. If [clearance] is supplied, a
/// [ClearanceIndicator] is shown so the user can see whether the label
/// they're building would actually be releasable to that holder.
class LabelEditor extends StatefulWidget {
  const LabelEditor({
    super.key,
    required this.spif,
    required this.label,
    this.clearance,
    this.langTag = '',
    this.onChanged,
  });

  final Spif spif;
  final Label label;
  final Clearance? clearance;
  final String langTag;
  final ValueChanged<Label>? onChanged;

  @override
  State<LabelEditor> createState() => _LabelEditorState();
}

class _LabelEditorState extends State<LabelEditor> {
  void _handleChanged() {
    setState(() {});
    widget.onChanged?.call(widget.label);
  }

  @override
  Widget build(BuildContext context) {
    final spif = widget.spif;
    final label = widget.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        MarkingPreview(spif: spif, label: label, langTag: widget.langTag),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ClassificationSelector(
            classifications: spif.classifications(),
            selected: label.classification,
            langTag: widget.langTag,
            isSelectable: (classification) =>
                label.canSetClassification(classification),
            onSelected: (classification) {
              label.setClassification(classification);
              _handleChanged();
            },
          ),
        ),
        for (final tagSet in spif.tagSets())
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TagSetPicker(
              spif: spif,
              tagSet: tagSet,
              label: label,
              langTag: widget.langTag,
              onChanged: _handleChanged,
            ),
          ),
        if (widget.clearance != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: ClearanceIndicator(
              spif: spif,
              label: label,
              clearance: widget.clearance!,
              langTag: widget.langTag,
            ),
          ),
      ],
    );
  }
}
