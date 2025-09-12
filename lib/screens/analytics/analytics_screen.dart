import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rimes_flutter/blocs/analytics/analytics_bloc.dart';
import 'package:rimes_flutter/blocs/analytics/analytics_event.dart';
import 'package:rimes_flutter/blocs/analytics/analytics_state.dart';
import 'package:rimes_flutter/repositories/analytics_repository.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  final primaryColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsBloc(repository: AnalyticsRepository())
        ..add(LoadAnalytics()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          backgroundColor: primaryColor,
          elevation: 2,
        ),
        body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AnalyticsError) {
              return Center(
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is AnalyticsLoaded) {
              final letters = state.analyticsData.letters;
              final users = state.analyticsData.users;
              final letterKeys = letters.toJson().keys.toList();
              final letterValues = letters.toJson().values.toList();
              final lastUpdated = state.analyticsData.lastUpdated;
              final totalUsers = state.analyticsData.totalUsers;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.group, size: 40, color: primaryColor),
                            const SizedBox(width: 16),
                            Text(
                              "Total Users: $totalUsers",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        shadowColor: Colors.grey.withOpacity(0.2),
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(16),
                          child: Text(
                            "Last Updated: $lastUpdated",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        )),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Letter Frequency",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 200,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: letterValues
                                          .reduce((a, b) => a > b ? a : b)
                                          .toDouble() +
                                      20,
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, _) {
                                          final idx = value.toInt();
                                          if (idx >= 0 &&
                                              idx < letterKeys.length) {
                                            return Text(
                                              letterKeys[idx],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: true)),
                                  ),
                                  barGroups:
                                      List.generate(letterKeys.length, (index) {
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: letterValues[index].toDouble(),
                                          gradient: LinearGradient(
                                            colors: [
                                              primaryColor.shade700,
                                              primaryColor.shade400
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                          width: 20,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "Users",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    ),
                    const Divider(),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final user = users[i];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          shadowColor: Colors.grey.withOpacity(0.2),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: primaryColor.shade100,
                              child: Text(
                                user.username[0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                            ),
                            title: Text(
                              user.username,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor.shade800),
                            ),
                            subtitle: Text(user.email),
                            trailing: Icon(Icons.chat_bubble_outline,
                                color: primaryColor),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/userData',
                                arguments: user.id,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
