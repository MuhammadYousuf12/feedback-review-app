import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback_model.dart';

// Handles all Firestore operations for feedback data
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Submit feedback ---
  Future<void> submitFeedback(FeedbackModel feedback) async {
    await _firestore.collection('feedbacks').add(feedback.toFirestore());
  }

  // --- Get all feedback (admin) ---
  Stream<List<FeedbackModel>> getAllFeedback() {
    return _firestore
        .collection('feedbacks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => FeedbackModel.fromFirestore(d)).toList());
  }

  // --- Get user feedback ---
  Stream<List<FeedbackModel>> getUserFeedback(String userId) {
    return _firestore
        .collection('feedbacks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => FeedbackModel.fromFirestore(d)).toList());
  }

  // --- Delete feedback (admin) ---
  Future<void> deleteFeedback(String id) async {
    await _firestore.collection('feedbacks').doc(id).delete();
  }

  // --- Get user role ---
  Future<String> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc['role'] as String? ?? "user";
  }
}
