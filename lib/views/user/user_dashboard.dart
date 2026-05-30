import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../models/feedback_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/firestore_service.dart';
import 'feedback_form_screen.dart';

// User dashboard - shows submitted feedback history.
class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late Stream<List<FeedbackModel>> _feedbackStream;
  late String _uid;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _uid = auth.user!.uid;
    _feedbackStream = FirestoreService().getUserFeedback(_uid);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myFeedback),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                ),
                onPressed: () => themeProvider.setTheme(
                  isDark ? ThemeMode.light : ThemeMode.dark,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FeedbackFormScreen()),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          AppStrings.submitFeedback,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<FeedbackModel>>(
        stream: _feedbackStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final feedbacks = snapshot.data!;
          if (feedbacks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.feedback_outlined,
                    size: 52,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.noFeedbackYet,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: feedbacks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _FeedbackCard(feedback: feedbacks[index], isDark: isDark),
          );
        },
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;
  final bool isDark;
  const _FeedbackCard({required this.feedback, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.grey.withValues(alpha: 0.15)
              : Colors.grey.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  feedback.category,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < feedback.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            feedback.feedback,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${feedback.createdAt.day}/${feedback.createdAt.month}/${feedback.createdAt.year}",
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
