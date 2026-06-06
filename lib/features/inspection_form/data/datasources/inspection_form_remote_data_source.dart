import 'package:offline_first_inspection/core/error/exceptions.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class IInspectionFormRemoteDataSource {
  Future<List<InspectionFormDto>> syncInspectionForms(List<InspectionFormDto> offlineEdits);
}

class InspectionFormRemoteDataSourceImpl implements IInspectionFormRemoteDataSource {
  final SupabaseClient supabaseClient;
  InspectionFormRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<InspectionFormDto>> syncInspectionForms(List<InspectionFormDto> offlineEdits) async {
    try {
      //upload offline edits first
      var edits = offlineEdits.map((dto) => dto.toJson()).toList();
      if (edits.isNotEmpty) {
        await supabaseClient.from('inspection_forms').upsert(edits).select();
      }
      //retrieve latest
      final latest = await supabaseClient.from('inspection_forms').select().timeout(const Duration(seconds: 15));
      final List<InspectionFormDto> results = latest.map((json) => InspectionFormDto.fromJson(json)).toList();
      return results;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
