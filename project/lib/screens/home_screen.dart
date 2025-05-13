import 'package:flutter/material.dart';
import 'package:project/widgets/image_picker_button.dart';
import 'package:project/widgets/status_indicator.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/job_provider.dart';
import 'package:project/screens/result_screen.dart';
import 'package:project/providers/auth_provider.dart';
import 'dart:io';
import 'package:project/constants/enums.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

    if (jobProvider.status == JobStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(job: jobProvider.jobs.last),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).signOut(),
          ),
        ],
      ),
      
      body: Center(
        child: StatusIndicator(),
      ),
      floatingActionButton: ImagePickerButton(
        onImagePicked: (File image) => jobProvider.uploadImage(image),
      ),
    );
  }
}