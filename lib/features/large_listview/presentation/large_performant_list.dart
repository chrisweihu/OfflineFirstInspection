/*
The most crucial step is to use ListView.builder (or SliverList within a CustomScrollView), 
which only builds the widgets that are currently visible on the screen or slightly off-screen. 
This prevents the excessive memory and CPU consumption that occurs when a default ListView builds all its children at once

Advanced Optimization Techniques
Beyond ListView.builder, several techniques can further boost performance for very large or complex lists:
1. 'Specify itemExtent': 
    If all list items have the same height, use the itemExtent property. 
    This allows Flutter to pre-calculate item sizes without measuring each one during scrolling, 
    leading to significantly smoother performance.
2. 'Use const Widgets': 
    Mark list item widgets and their static children with the const keyword whenever possible to 
    prevent unnecessary rebuilds.
3. 'Provide Keys': 
    For dynamic lists where items are added, removed, or reordered, use ValueKey or ObjectKey to 
    give Flutter stable item identities. This ensures elements are reused correctly and prevents state (like form data or animations) 
    from jumping to the wrong row.
4. 'Adjust cacheExtent': 
    Increase the cacheExtent property to pre-render more items off-screen. 
    This can reduce jank (stuttering) when scrolling quickly past complex items, at the cost of slightly higher memory usage.
5. 'Isolate Complex Widgets': 
    Wrap complex or rapidly updating list items in a RepaintBoundary to isolate their repainting from 
    the rest of the list, reducing overall GPU load.
6. 'Optimize Images': 
    Use efficient image handling, such as using CachedNetworkImage for network images, and specifying cacheWidth 
    and cacheHeight to control decoding size.
7. 'Use Pagination/Lazy Loading': 
    For extremely large datasets, implement pagination (e.g., using the [infinite_scroll_pagination package]
    or a custom ScrollController listener) to fetch data in chunks rather than all at once.
8. 'Avoid shrinkWrap: true unnecessarily': 
    Using shrinkWrap: true makes the ListView calculate and render all children at once, 
    negating the performance benefits of lazy loading.
9. 'Offload Heavy Computation': 
    Perform CPU-heavy tasks like large JSON parsing or database queries in a separate isolate 
    using Dart's compute() function to prevent blocking the main UI thread (isolate) and causing the UI to freeze.
*/

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// DATA MODEL
class Item {
  final int id;
  final String title;
  Item(this.id, this.title);
}

class OptimizedListScreen extends StatefulWidget {
  const OptimizedListScreen({super.key});

  @override
  State<OptimizedListScreen> createState() => _OptimizedListScreenState();
}

class _OptimizedListScreenState extends State<OptimizedListScreen> {
  // Initial dataset
  final List<Item> _items = List.generate(20, (i) => Item(i, 'Initial Item $i'));

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // PAGINATION / LAZY LOADING: Listener to trigger data fetch
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Threshold check (200px before end)
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      /// This 'Fire and Forget' pattern is standard Flutter practice
      /// and is the correct way to trigger asynchronous work in a listener sychronous method
      _loadMoreAsync();
    }
  }

  Future<void> _loadMoreAsync() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    if (kDebugMode) {
      debugPrint('${_scrollController.position.pixels} >= ${_scrollController.position.maxScrollExtent} - 200');
    }
    // Simulate an async network or database call
    await Future.delayed(const Duration(seconds: 1));

    final newItems = List.generate(20, (i) => Item(_items.length + i, 'Fetched Item ${_items.length + i}'));

    /// IMPORTANT: ALWAYS check if the widget is still "mounted" before calling setState
    /// Because the _loadMoreAsync() method continues running after _scrollListener is triggered,
    /// the user might navigate away from the screen before the data finishes loading.
    /// If you call setState() on a widget that is no longer in the tree, your app will crash.
    if (mounted) {
      setState(() {
        _items.addAll(newItems);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turn on RepaintBoundary to See Diff')),
      body: ListView.builder(
        controller: _scrollController,
        // 3. ITEM EXTENT: Tells Flutter exactly how high each item is (prevents layout math)
        itemExtent: 60.0,
        // 4. CACHE EXTENT: Pre-renders 5 items off-screen for smoother scrolling
        cacheExtent: 300.0,
        itemCount: _items.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = _items[index];

          // 5. KEYS: Ensures the widget tree stays synced if the list changes
          return OptimizedTile(key: ValueKey(item.id), item: item);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// 6. REPAINT BOUNDARY: Isolates this tile's paint layer from the rest of the list
class OptimizedTile extends StatelessWidget {
  final Item item;

  // 7. CONST CONSTRUCTOR: Allows Flutter to skip rebuilding this entire widget if params don't change
  const OptimizedTile({required Key key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // 8. CONST CHILD: Static widgets marked as const are never rebuilt
      leading: switch (item.id % 2) {
        0 => const RepaintBoundary(child: SizedBox.square(dimension: 25, child: CircularProgressIndicator())),
        1 => const SizedBox.square(dimension: 25, child: CircularProgressIndicator()),
        _ => const CircleAvatar(child: Icon(Icons.person)),
      },

      title: Text(item.title),
      subtitle: switch (item.id % 2) {
        0 => const Text('With RepaintBoundary'),
        1 => const Text('Without RepaintBoundary'),
        int() => const Text('Error'),
      },
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
