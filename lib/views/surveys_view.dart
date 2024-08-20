import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/survey_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/survey.dart';

class SurveysView extends GetView<SurveyController> {
  SurveysView({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surveys'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Unsynced surveys: ${controller.unsyncedCount}'),
          )),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.surveys.length,
              itemBuilder: (context, index) {
                Survey survey = controller.surveys[index];
                return ListTile(
                  title: Text(survey.name),
                  subtitle: Text('Lat: ${survey.latitude}, Long: ${survey.longitude}'),
                  trailing: Icon(survey.isSynced ? Icons.cloud_done : Icons.cloud_off),
                );
              },
            )),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () => Get.toNamed('/create-survey'),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: null,
            onPressed: controller.syncSurveys,
            child: const Icon(Icons.sync),
          ),
        ],
      ),
    );
  }
}