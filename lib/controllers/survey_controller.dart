import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/survey.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import 'auth_controller.dart';

class SurveyController extends GetxController {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final AuthController _authController = Get.find<AuthController>();
  final RxList<Survey> surveys = <Survey>[].obs;
  final RxInt unsyncedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocalSurveys();
    updateUnsyncedCount();
  }

  Future<void> fetchLocalSurveys() async {
    final localSurveys = await _dbHelper.getSurveys(_authController.userId.value);
    surveys.assignAll(localSurveys);
  }

  Future<void> updateUnsyncedCount() async {
    unsyncedCount.value = await _dbHelper.getUnsyncedSurveysCount(_authController.userId.value);
  }

  Future<void> createSurvey(Survey survey) async {
    try {
      await _dbHelper.insertSurvey(survey, _authController.userId.value);
      await fetchLocalSurveys();
      await updateUnsyncedCount();
      Get.back();
      Get.snackbar('Success', 'Survey saved locally');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save survey: $e');
    }
  }

  Future<void> syncSurveys() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar('Error', 'No internet connection');
      return;
    }

    try {
      final unsyncedSurveys = await _dbHelper.getUnsyncedSurveys(_authController.userId.value);
      for (var survey in unsyncedSurveys) {
        try {
          await _apiService.createSurvey(survey);
          await _dbHelper.markSurveyAsSynced(survey.id!);
        } catch (e) {
          Get.snackbar('Error', 'Failed to sync survey ${survey.id}: $e');
          // Continue with the next survey
        }
      }
      await fetchLocalSurveys();
      await updateUnsyncedCount();
      Get.snackbar('Success', 'Surveys synced successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sync surveys: $e');
    }
  }
}