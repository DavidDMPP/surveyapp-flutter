import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxBool isLoggedIn = false.obs;
  final RxInt userId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getInt('userId');
    if (token != null && id != null) {
      isLoggedIn.value = true;
      userId.value = id;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final result = await _apiService.login(email, password);
      isLoggedIn.value = true;
      userId.value = result['userId'];
      Get.offAllNamed('/surveys');
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    isLoggedIn.value = false;
    userId.value = 0;
    Get.offAllNamed('/login');
  }
}