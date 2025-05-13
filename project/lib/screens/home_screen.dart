import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:project/providers/job_provider.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/screens/result_screen.dart';
import 'package:project/widgets/image_picker_button.dart';
import 'package:project/widgets/status_indicator.dart';
import 'package:project/constants/enums.dart';
import 'package:project/widgets/custom.dart'; // Reuse CustomScaffold

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;

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

    return CustomScarffold(
      child: Column(
        children: [
          // Top space
          const Expanded(flex: 1, child: SizedBox()),

          // Main content container
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.all(25.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Image Enhancer',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (_selectedImage != null)
                      Column(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              jobProvider.uploadImage(_selectedImage!);
                            },
                            child: const Text('Submit for Enhancement'),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Upload an image to enhance',
                        style: TextStyle(color: Colors.black54),
                      ),

                    const SizedBox(height: 20),

                    StatusIndicator(),
                  ],
                ),
              ),
            ),
          ),

          // Upload image button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ImagePickerButton(
              onImagePicked: (File image) {
                setState(() {
                  _selectedImage = image;
                });
              },
            ),
          ),
        ],
      ),

      // Logout button (floating corner)
    floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Provider.of<AuthProvider>(context, listen: false).signOut(),
        child: const Icon(Icons.logout),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
