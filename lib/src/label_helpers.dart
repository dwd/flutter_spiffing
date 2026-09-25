import 'package:spiffing/spiffing.dart';

/// Whether removing [category] from [label] would still leave it valid
/// against [spif]'s policy.
///
/// [Label] only exposes [Label.canAddCategory]/[Label.canSetClassification]
/// (checking whether an *addition*/classification change would keep it
/// valid); this mirrors that logic for *removal*, built entirely on top of
/// the public `spiffing` API (no private state is touched).
bool canRemoveCategory(Spif spif, Label label, Category category) {
  final candidate = Label.forClassification(spif, label.classification.lacv);
  for (final cat in label.categories) {
    if (cat != category) candidate.addCategory(cat);
  }
  return spif.valid(candidate);
}

/// Whether toggling [category] on/off (following [selected]) would keep
/// [label] valid, i.e. the chip for [category] should be enabled.
bool canToggleCategory(
  Spif spif,
  Label label,
  Category category, {
  required bool selected,
}) {
  return selected
      ? canRemoveCategory(spif, label, category)
      : label.canAddCategory(category);
}
