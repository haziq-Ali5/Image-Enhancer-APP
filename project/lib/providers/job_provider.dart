import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:project/constants/enums.dart';
import 'package:project/models/job.dart';
import 'package:project/services/api_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class JobProvider with ChangeNotifier {
  final ApiService _apiService;
  JobStatus _status = JobStatus.idle;
  List<ProcessingJob> _jobs = [];
  WebSocketChannel? _channel;
  io.Socket? _socket;
  JobProvider(this._apiService);

  JobStatus get status => _status;
  List<ProcessingJob> get jobs => _jobs;

  Future<void> uploadImage(File image) async {
    try {
      _status = JobStatus.uploading;
      notifyListeners();

      final jobId = await _apiService.uploadImage(image);
      
      _status = JobStatus.processing;
      // Add createdAt and use JobStatus enum
      _jobs.add(ProcessingJob(
        jobId: jobId,
        status: JobStatus.processing, // Use enum, not String
        createdAt: DateTime.now(),
      ));
      notifyListeners();

      _channel = WebSocketChannel.connect(
        Uri.parse('ws://your-backend/status/$jobId'),
      );

      _channel!.stream.listen(
        (data) {
          // Parse status string to JobStatus enum
          final newStatus = _parseStatusFromString(data);
          final updatedJob = ProcessingJob(
            jobId: jobId,
            status: newStatus,
            resultUrl: newStatus == JobStatus.completed 
                ? 'http://your-backend/result/$jobId' 
                : null,
            createdAt: _jobs.last.createdAt, // Preserve original timestamp
            error: newStatus == JobStatus.failed ? "Job failed" : null,
          );
          _jobs[_jobs.length - 1] = updatedJob;
          _status = newStatus;
          notifyListeners();
        },
        onError: (error) {
          _status = JobStatus.failed;
          notifyListeners();
        },
      );
    } catch (e) {
      _status = JobStatus.failed;
      notifyListeners();
    }
  }

  // Helper to convert WebSocket string to JobStatus
  JobStatus _parseStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return JobStatus.completed;
      case 'failed':
        return JobStatus.failed;
      case 'processing':
        return JobStatus.processing;
      default:
        return JobStatus.failed;
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}