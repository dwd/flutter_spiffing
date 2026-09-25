import 'package:flutter/material.dart';
import 'package:spiffing/spiffing.dart';

import 'label_helpers.dart';

/// A single selectable chip for one [Category] within a [Tag].
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.enabled,
    required this.onChanged,
    this.langTag = '',
  });

  final Category category;
  final bool selected;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final String langTag;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(category.displayName(langTag)),
      selected: selected,
      onSelected: enabled ? onChanged : null,
    );
  }
}

/// Renders all [Category] chips for a single [Tag], under a heading with
/// the tag's own display name.
class TagCategoryPicker extends StatelessWidget {
  const TagCategoryPicker({
    super.key,
    required this.spif,
    required this.tag,
    required this.label,
    required this.onChanged,
    this.langTag = '',
  });

  final Spif spif;
  final Tag tag;
  final Label label;

  /// Called after [label] has been mutated by adding/removing a category.
  final VoidCallback onChanged;
  final String langTag;

  @override
  Widget build(BuildContext context) {
    final categories = tag.categories();
    if (categories.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tag.displayName(langTag),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final category in categories) _buildChip(category)],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(Category category) {
    final selected = label.hasCategory(category);
    final enabled = canToggleCategory(
      spif,
      label,
      category,
      selected: selected,
    );
    return CategoryChip(
      category: category,
      selected: selected,
      enabled: enabled,
      langTag: langTag,
      onChanged: (value) {
        if (value) {
          label.addCategory(category);
        } else {
          label.removeCategory(category);
        }
        onChanged();
      },
    );
  }
}

/// Renders a [TagCategoryPicker] for every [Tag] within a [TagSet], under a
/// card headed with the tag set's own display name.
class TagSetPicker extends StatelessWidget {
  const TagSetPicker({
    super.key,
    required this.spif,
    required this.tagSet,
    required this.label,
    required this.onChanged,
    this.langTag = '',
  });

  final Spif spif;
  final TagSet tagSet;
  final Label label;
  final VoidCallback onChanged;
  final String langTag;

  @override
  Widget build(BuildContext context) {
    final tags = tagSet.tags();
    if (tags.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tagSet.displayName(langTag),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            for (final tag in tags)
              TagCategoryPicker(
                spif: spif,
                tag: tag,
                label: label,
                onChanged: onChanged,
                langTag: langTag,
              ),
          ],
        ),
      ),
    );
  }
}
