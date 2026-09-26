## Unreleased

* `TagSetPicker`/`TagCategoryPicker` now hide categories, tags, and whole
  tag sets that the current classification excludes outright (via the
  SPIF's `excludedClass` rule), instead of merely disabling their chips.
  A category that's only blocked by the label's *other* selected
  categories still shows up disabled, as before. This relies on the new
  `Category.excludesClassification` accessor added to `spiffing-dart`.

## 0.0.1

* Initial release: `LabelEditor` and its building-block widgets
  (`ClassificationSelector`, `TagSetPicker`/`TagCategoryPicker`/
  `CategoryChip`, `MarkingPreview`, `ClearanceIndicator`) for building a
  security-label editor/picker UI on top of the `spiffing` library.
