import 'package:injectable/injectable.dart';
import '../../../../data/network/api_services.dart';
import '../models/adoption_form_request_model.dart';
import '../models/adoption_options_model.dart';

abstract class AdoptionRemoteDataSource {
  Future<AdoptionOptionsModel> getAdoptionOptions();
  Future<void> submitAdoptionForm(AdoptionFormRequestModel request);
}

@LazySingleton(as: AdoptionRemoteDataSource)
class AdoptionRemoteDataSourceImpl implements AdoptionRemoteDataSource {
  final ApiService _apiService;

  AdoptionRemoteDataSourceImpl(this._apiService);

  @override
  Future<AdoptionOptionsModel> getAdoptionOptions() async {
    final response = await _apiService.get(
      endPoint: 'AdoptionForms/options',
    );
    return AdoptionOptionsModel.fromJson(response.result);
  }

  @override
  Future<void> submitAdoptionForm(AdoptionFormRequestModel request) async {
    await _apiService.post(
      endPoint: 'AdoptionForms',
      data: request.toJson(),
    );
  }
}
