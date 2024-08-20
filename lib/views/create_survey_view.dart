import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/survey_controller.dart';
import '../models/survey.dart';

class CreateSurveyView extends GetView<SurveyController> {
  CreateSurveyView({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final RxString imagePath = ''.obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Survey')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Survey Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _takePicture,
              child: const Text('Take Picture'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Get Location'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createSurvey,
              child: const Text('Create Survey'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  Future<void> _getLocation() async {
    final position = await Geolocator.getCurrentPosition();
    latitude.value = position.latitude;
    longitude.value = position.longitude;
  }

  void _createSurvey() {
    if (nameController.text.isEmpty || imagePath.value.isEmpty || latitude.value == 0 || longitude.value == 0) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    final survey = Survey(
      name: nameController.text,
      photoPath: imagePath.value,
      latitude: latitude.value,
      longitude: longitude.value,
    );

    controller.createSurvey(survey);
  }
}