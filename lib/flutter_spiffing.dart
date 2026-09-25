/// Flutter widgets for building security-label editor/picker UIs on top of
/// the `spiffing` (SPIF/Label/Clearance) library.
///
/// Given a parsed `Spif` and a `Label` to edit, [LabelEditor] renders a
/// complete editor: a live marking preview, a classification selector, and
/// a category picker for every tag set defined by the policy. The smaller
/// building blocks it's composed from are also exported individually, so
/// apps can assemble their own layout instead.
library;

export 'src/category_picker.dart'
    show CategoryChip, TagCategoryPicker, TagSetPicker;
export 'src/classification_selector.dart' show ClassificationSelector;
export 'src/clearance_indicator.dart' show ClearanceIndicator;
export 'src/color_utils.dart' show contrastingTextColor, parseSpifColor;
export 'src/label_editor.dart' show LabelEditor;
export 'src/label_helpers.dart' show canRemoveCategory, canToggleCategory;
export 'src/marking_preview.dart' show MarkingPreview;
