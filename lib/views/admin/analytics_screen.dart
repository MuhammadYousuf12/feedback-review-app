import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../models/feedback_model.dart';
import '../../services/firestore_service.dart';

// Analytics screen - visualizes feedback trends with bar and pie charts
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.analytics)),
      body: StreamBuilder<List<FeedbackModel>>(
        stream: FirestoreService().getAllFeedback(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final feedbacks = snapshot.data!;
          if (feedbacks.isEmpty) {
            return Center(
              child: Text(
                "No data yet.",
                style: TextStyle(color: Colors.grey[500]),
              ),
            );
          }

          // Rating distribution
          final ratingCounts = List.generate(
            5,
            (i) => feedbacks.where((f) => f.rating == i + 1).length,
          );

          // Category distribution
          final categories = [
            "Course",
            "Platform",
            "Mentor",
            "Support",
            "Other",
          ];
          final categoryCounts = categories
              .map((c) => feedbacks.where((f) => f.category == c).length)
              .toList();
          final categoryColors = [
            AppColors.primary,
            const Color(0xFF6366F1),
            AppColors.accent,
            const Color(0xFFEC4899),
            Colors.grey,
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating bar chart
                _ChartCard(
                  title: "Rating Distribution",
                  isDark: isDark,
                  child: SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (ratingCounts.reduce((a, b) => a > b ? a : b) + 2)
                            .toDouble(),
                        barGroups: List.generate(5, (i) {
                          return BarChartGroupData(
                            x: i + 1,
                            barRods: [
                              BarChartRodData(
                                toY: ratingCounts[i].toDouble(),
                                color: AppColors.primary,
                                width: 20,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 12,
                                    color: AppColors.accent,
                                  ),
                                  Text(
                                    "${value.toInt()}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, _) => Text(
                                "${value.toInt()}",
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.grey.withValues(alpha: 0.15),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category pie chart
                _ChartCard(
                  title: "Feedback by Category",
                  isDark: isDark,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 45,
                            sections: List.generate(categories.length, (i) {
                              if (categoryCounts[i] == 0) return null;
                              return PieChartSectionData(
                                value: categoryCounts[i].toDouble(),
                                color: categoryColors[i],
                                title: "${categoryCounts[i]}",
                                radius: 50,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              );
                            }).whereType<PieChartSectionData>().toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: List.generate(categories.length, (i) {
                          if (categoryCounts[i] == 0) return const SizedBox();
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: categoryColors[i],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${categories[i]} (${categoryCounts[i]})",
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final bool isDark;
  final Widget child;
  const _ChartCard({
    required this.title,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
