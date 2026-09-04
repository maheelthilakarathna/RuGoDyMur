import 'package:flutter/material.dart';

import '../utils/theme.dart';

class CategoryChipData {
  final String id;
  final String label;
  const CategoryChipData(this.id, this.label);
}

class CategoryChipRow extends StatelessWidget {
  final List<CategoryChipData> chips;
  final String selectedId;
  final ValueChanged<String> onSelect;

  const CategoryChipRow({
    super.key,
    required this.chips,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          final selected = chip.id == selectedId;
          return ChoiceChip(
            label: Text(chip.label),
            selected: selected,
            onSelected: (_) => onSelect(chip.id),
            selectedColor: AppColors.navy,
            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.chipBg,
            labelStyle: TextStyle(
              color: selected ? Colors.white : (isDark ? Colors.white70 : AppColors.navy),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
