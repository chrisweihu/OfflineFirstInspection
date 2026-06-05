import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/core/utils/format_date.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/blocs/inspection_table/inspection_table_bloc.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/pages/inspection_form_page.dart';
import 'package:uuid/uuid.dart';

class InspectionsTablePage extends StatefulWidget {
  const InspectionsTablePage({super.key});

  @override
  State<InspectionsTablePage> createState() => _InspectionsTablePageState();
}

class _InspectionsTablePageState extends State<InspectionsTablePage> {
  int selectedRowIndex = -1;
  InspectionFormDto? selectedRow;
  @override
  void initState() {
    super.initState();
    context.read<InspectionTableBloc>().add(InspectionTableSyncEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: .centerStart,
          child: Text('Inspections List'),
        ),
        actions: selectedRowIndex >= 0
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      InspectionFormPage.route(
                        formData: selectedRow!,
                        mode: 'Edit',
                      ),
                    );
                  },
                  icon: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      InspectionFormPage.route(
                        formData: selectedRow!,
                        mode: 'View',
                      ),
                    );
                  },
                  icon: const Icon(CupertinoIcons.eye),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    //sync
                    context.read<InspectionTableBloc>().add(
                      InspectionTableSyncEvent(),
                    );
                  },
                  icon: const Icon(Icons.sync),
                ),
              ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            InspectionFormPage.route(
              formData: InspectionFormDto(
                id: const Uuid().v1(),
                date: DateTime.now(),
              ),
              mode: 'Create',
            ),
          );
        },
        child: const Icon(Icons.add), // Add icon
      ),
      body: BlocBuilder<InspectionTableBloc, InspectionTableState>(
        builder: (context, state) {
          return switch (state) {
            InspectionTableInitialState() => const Center(
              child: Text('Load data to start'),
            ),
            InspectionTableLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            InspectionTableLoadedState(data: final rows) => SingleChildScrollView(
              scrollDirection: .vertical,
              child: SingleChildScrollView(
                scrollDirection: .horizontal,
                child: DataTable(
                  // Logic for oscillating background colors
                  dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) => null, // Use the row's specific color
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Inspector',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Summary',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    rows.length,
                    (index) => DataRow(
                      selected:
                          selectedRowIndex ==
                          index, // Check if this row is selected
                      onSelectChanged: (value) {
                        setState(() {
                          selectedRowIndex = value == true ? index : -1;
                          selectedRow = selectedRowIndex < 0
                              ? null
                              : rows[selectedRowIndex];
                        });
                      },
                      // $ index % 2 == 0 $ logic for oscillating grey/dark grey
                      color: WidgetStateProperty.all(
                        selectedRowIndex == index
                            ? Colors.black
                            : index % 2 == 0
                            ? Colors.grey[900]
                            : Colors.grey[800],
                      ),
                      cells: [
                        DataCell(
                          Text(
                            formatDateBydMMMYYYY(rows[index].date?.toLocal()),
                          ),
                        ),
                        DataCell(Text(rows[index].inspector)),
                        DataCell(Text(rows[index].status?.name ?? '')),
                        DataCell(Text(rows[index].summary)),
                        DataCell(Text(rows[index].id.toString())),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            InspectionTableFailureState() => const Text(
              'Failed to load table!',
            ),
          };
        },
      ),
    );
  }
}
