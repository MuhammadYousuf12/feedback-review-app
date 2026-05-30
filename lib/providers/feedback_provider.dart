import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import '../services/firestore_service.dart';

// Manages feedback submission state
class FeedbackProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> submitFeedback(FeedbackModel feedback) async {
    _setLoading(true);
    try {
      await _service.submitFeedback(feedback);
      _error = null;
      return true;
    } catch (e) {
      _error = "Failed to submit feedback.";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
