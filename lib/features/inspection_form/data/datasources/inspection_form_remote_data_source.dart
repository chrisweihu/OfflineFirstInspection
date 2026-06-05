import 'package:offline_first_inspection/core/error/exceptions.dart';
import 'package:offline_first_inspection/features/inspection_form/data/datasources/inspection_form_local_data_source.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class IInspectionFormRemoteDataSource {
  Future<List<InspectionFormDto>> syncInspectionForms();
}

class InspectionFormRemoteDataSourceImpl
    implements IInspectionFormRemoteDataSource {
  final SupabaseClient supabaseClient;
  final IInspectionFormLocalDataSource localDataSource;
  InspectionFormRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.localDataSource,
  });

  @override
  Future<List<InspectionFormDto>> syncInspectionForms() async {
    try {
      //upload offline edits first
      final offlineEdits = (await localDataSource.getAllInspections())
          .where((e) => e.dirty)
          .toList();
      var edits = offlineEdits.map((dto) => dto.toJson()).toList();
      if (edits.isNotEmpty) {
        await supabaseClient.from('inspection_forms').upsert(edits).select();
      }

      final latest = await supabaseClient
          .from('inspection_forms')
          .select()
          .timeout(const Duration(seconds: 15));

      final List<InspectionFormDto> results = latest
          .map((json) => InspectionFormDto.fromJson(json))
          .toList();

      //write latest server result into local db
      for (final dto in results) {
        await localDataSource.submitInspectionForm(dto: dto, markDirty: false);
      }

      return results;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
