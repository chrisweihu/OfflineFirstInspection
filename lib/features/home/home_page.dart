import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/pages/inspections_table_page.dart';
import 'package:offline_first_inspection/features/large_listview/presentation/cubit/image_list/image_list_cubit.dart';
import 'package:offline_first_inspection/features/large_listview/presentation/large_performant_list.dart';
import 'package:offline_first_inspection/features/large_listview/presentation/optimized_image_list.dart';
import 'package:offline_first_inspection/init_dependencies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool wideScreen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.sizeOf(context).width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          //How do you prevent a TabBarView from re-initializing its children every time the user swipes back and forth?
          //Answer: must use the AutomaticKeepAliveClientMixin on the state of the tab's child widget and override wantKeepAlive to return true. This instructs the RenderObject tree to keep the specific child in memory even when it's not visible.
          body: Row(
            children: [
              // The Vertical TabBar Container
              !wideScreen
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: 50, // Set the width of your "Rail"
                      child: Column(
                        children: [
                          const SizedBox(height: 10), //
                          const Icon(Icons.menu),
                          const SizedBox(), // Optional spacing for status bar
                          Expanded(
                            child: RotatedBox(
                              quarterTurns: 1, // Rotates the TabBar vertically
                              child: TabBar(
                                //padding: .only(bottom: 15), //leave room for safe space
                                tabs: [
                                  _buildVerticalTab(Icons.home, "Home"),
                                  _buildVerticalTab(Icons.list, "Repaint"),
                                  _buildVerticalTab(Icons.image, "Images"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

              // The Main Content Area
              Expanded(
                child: TabBarView(
                  children: [
                    const InspectionsTablePage(),
                    const OptimizedListScreen(),
                    BlocProvider(create: (BuildContext context) => getIt<ImageListCubit>(), child: const OptimizedImageListScreen()),
                  ],
                ),
              ),
            ],
          ),

          bottomNavigationBar: wideScreen
              ? null
              : const TabBar(
                  //padding: .only(bottom: 15), //leave room for safe space
                  tabs: [
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.list)),
                    Tab(icon: Icon(Icons.image)),
                  ],
                ),
        ),
      ),
    );
  }

  // The parent RotatedBox uses quarterTurns: 1 and the children use quarterTurns: 3 to stay upright.
  Tab _buildVerticalTab(IconData icon, String label) {
    return Tab(
      child: RotatedBox(
        quarterTurns: 3, // Counter-rotate to make content upright
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
