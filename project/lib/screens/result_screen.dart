import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/models/job.dart';

class ResultScreen extends StatelessWidget {
  final ProcessingJob job;

  const ResultScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: job.resultUrl!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {/* Implement save */},
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {/* Implement share */},
                  child: const Text('Share'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}