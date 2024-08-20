import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/survey_controller.dart';
import 'views/login_view.dart';
import 'views/surveys_view.dart';
import 'views/create_survey_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Survey App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/surveys', page: () => SurveysView()),
        GetPage(name: '/create-survey', page: () => CreateSurveyView()),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(SurveyController());
      }),
    );
  }
}