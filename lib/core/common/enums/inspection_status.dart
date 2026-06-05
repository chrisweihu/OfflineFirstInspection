import 'dart:collection';

import 'package:flutter/material.dart';

typedef InspectionStatusEntry = DropdownMenuEntry<InspectionStatus>;

enum InspectionStatus {
  wip('WIP', Colors.blue, Icons.work),
  draft('Draft', Colors.amber, Icons.drafts),
  authorized('Authorized', Colors.green, Icons.approval);

  const InspectionStatus(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;

  static final List<InspectionStatusEntry> entires =
      UnmodifiableListView<InspectionStatusEntry>(
        values.map<InspectionStatusEntry>(
          (em) => InspectionStatusEntry(
            value: em,
            label: em.label,
            style: MenuItemButton.styleFrom(foregroundColor: em.color),
            leadingIcon: Icon(em.icon),
          ),
        ),
      );
}
