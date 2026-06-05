import 'dart:math';
import 'package:flutter/material.dart';

/// Domain Layer Model
sealed class ListItem {
  final String id;
  final String content;

  ListItem({required this.id, required this.content});
}

class TaskItem extends ListItem {
  TaskItem({required super.id, required super.content});
}

/// Presentation Layer
class ReorderableListViewKeyDemo extends StatefulWidget {
  static MaterialPageRoute<ReorderableListViewKeyDemo> route() =>
      MaterialPageRoute(builder: (_) => const ReorderableListViewKeyDemo());

  const ReorderableListViewKeyDemo({super.key});

  @override
  State<ReorderableListViewKeyDemo> createState() =>
      _ReorderableListViewKeyDemoState();
}

class _ReorderableListViewKeyDemoState
    extends State<ReorderableListViewKeyDemo> {
  // Mocking our Data Source
  final List<ListItem> _items = List.generate(
    1000,
    (i) => TaskItem(id: 'id_$i', content: 'Item ${i + 1}'),
  );

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The Importance of ValueKey')),
      body: ReorderableListView.builder(
        itemCount: _items.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          final item = _items[index];

          // SENIOR ARCHITECT NOTE:
          // We use ValueKey(item.id) here.
          // Try key: ValueKey(index) and reordering.
          // You will see the colors stay in place while the text moves!
          /*
          How to "See" the Failure (Technically)
          If you want to witness the disaster without the compiler yelling at you, since every item of ReorderableListview must have a key
          try this: 
          Keep the key: ValueKey(index).
          Start dragging "Item 1" (index 0) (which has a Random Color) to the 2nd place in the list.
          You will see the Color stay at the top while the Text moves down.
          This happens because the Element (holding the _color state) is keyed to "Index 0". 
          As long as there is a widget with "Index 0" at the top, that Element (and its color) stays put, 
          regardless of what text is inside the widget.
          Senior Interview Tip: 
          Key Stability 
          Interviewer: "Why is ValueKey(item.id) preferred over ValueKey(item.hashCode) or UniqueKey() in a list?"
          The Internal Answer:Keys must be stable, predictable, and persistent.
          item.hashCode can change if the object's properties change (if it's a data class/record), causing the framework to think it's a brand new widget.
          UniqueKey() generates a new identity on every build() call, forcing a full RenderObject retirement and recreation ($O(n)$ work for a simple $O(1)$ move).
          item.id (from your database/backend) is the only value that maps 1:1 with the business logic's definition of "Identity."
          */
          //return StatefulColorItem(key: ValueKey(index), item: item);
          return StatefulColorItem(key: ValueKey(item.id), item: item);
        },
      ),
    );
  }
}

/// A Widget that holds "Internal State" (a random color)
class StatefulColorItem extends StatefulWidget {
  final ListItem item;

  const StatefulColorItem({super.key, required this.item});

  @override
  State<StatefulColorItem> createState() => _StatefulColorItemState();
}

class _StatefulColorItemState extends State<StatefulColorItem> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    // This state is initialized ONCE when the Element is created.
    _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: _color.withAlpha(50),
      title: Text(widget.item.content),
      subtitle: Text('ID: ${widget.item.id}'),
      leading: const Icon(Icons.drag_handle),
      trailing: CircleAvatar(backgroundColor: _color),
    );
  }
}
