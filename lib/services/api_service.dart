import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/survey.dart';

class ApiService {
  final String baseUrl = 'https://daviddmpp.com/surveyapp/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      final userId = data['user']['id'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('userId', userId);
      return {'token': token, 'userId': userId};
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<Survey>> getSurveys() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/surveys'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> surveysJson = jsonDecode(response.body);
      return surveysJson.map((json) => Survey.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load surveys');
    }
  }

  Future<void> createSurvey(Survey survey) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/surveys'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(survey.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create survey');
    }
  }
}