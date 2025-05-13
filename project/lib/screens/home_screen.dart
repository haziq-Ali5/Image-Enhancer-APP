import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/widgets/image_picker_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;

  Future<void> _submitImage() async {
    if (_selectedImageBytes == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var uri = Uri.parse('http://localhost:5000/enhance');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          _selectedImageBytes!,
          filename: 'image.jpg',
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Enhancer')),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _selectedImageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              _selectedImageBytes!,
                              fit: BoxFit.contain,
                              width: 300,
                              height: 300,
                            ),
                          )
                        : const Center(child: Text('No image selected')),
                  ),
                ),
                const SizedBox(height: 20),
                if (_selectedImageBytes != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit for Enhancement'),
                    onPressed: _isLoading ? null : _submitImage,
                  ),
                const SizedBox(height: 30),
                ImagePickerButton(
                  onImagePicked: (file, bytes) {
                    setState(() {
                      _selectedImageFile = file;
                      _selectedImageBytes = bytes;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
