import 'package:flutter/material.dart';
import 'package:spiffing/spiffing.dart';

/// Shows whether a [Label] would be releasable to the holder of a given
/// [Clearance], via [Spif.acdf], along with any categories still required
/// by the label's current classification.
class ClearanceIndicator extends StatelessWidget {
  const ClearanceIndicator({
    super.key,
    required this.spif,
    required this.label,
    required this.clearance,
    this.langTag = '',
  });

  final Spif spif;
  final Label label;
  final Clearance clearance;
  final String langTag;

  @override
  Widget build(BuildContext context) {
    final allowed = spif.acdf(label, clearance);
    final missing = label.missingCategoriesFor(label.classification);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              allowed ? Icons.check_circle : Icons.cancel,
              color: allowed ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              allowed
                  ? 'Releasable to holder\'s clearance'
                  : 'Not releasable to holder\'s clearance',
            ),
          ],
        ),
        if (missing.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Missing required categories: '
              '${missing.map((c) => c.displayName(langTag)).join(', ')}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
