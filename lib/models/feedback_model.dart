import 'package:cloud_firestore/cloud_firestore.dart';

// Represents a single feedback entry stored in Firestore.
class FeedbackModel {
  final String id;
  final String userId;
  final String userName;
  final String category;
  final int rating;
  final String feedback;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.category,
    required this.rating,
    required this.feedback,
    required this.createdAt,
  });

  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackModel(
      id: doc.id,
      userId: data["userId"] ?? "",
      userName: data["userName"] ?? "",
      category: data["category"] ?? "",
      rating: data["rating"] ?? 0,
      feedback: data["feedback"] ?? "",
      createdAt: (data["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    "userId": userId,
    "userName": userName,
    "category": category,
    "rating": rating,
    "feedback": feedback,
    "createdAt": createdAt,
  };
}
