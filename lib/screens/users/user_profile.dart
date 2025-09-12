import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:rimes_flutter/blocs/user/users_bloc.dart';
import 'package:rimes_flutter/blocs/user/users_event.dart';
import 'package:rimes_flutter/blocs/user/users_state.dart';
import 'package:rimes_flutter/models/user_model.dart';
import 'package:rimes_flutter/repositories/user_repository.dart';
import 'package:rimes_flutter/utils/api_constants.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  Map<DateTime, int> getHeatMapData(UserModel user) {
    return {
      for (var item in user.postingFrequency) item.date: item.count,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserProfileBloc(UserRepository(baseUrl: APiConstants.baseURL))
            ..add(FetchUserProfile(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileLoaded) {
              final user = state.user;
              final heatMapData = getHeatMapData(user);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.teal,
                              child: Text(
                                user.username[0].toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.username,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                Text('Total Posts: ${user.totalPosts}',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Posting Frequency',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    HeatMapCalendar(
                      datasets: heatMapData,
                      colorMode: ColorMode.color,
                      defaultColor: Colors.white,
                      textColor: Colors.black,
                      flexible: true,
                      showColorTip: false,
                      colorsets: {
                        1: Colors.red[100]!,
                        2: Colors.red[300]!,
                        3: Colors.red[500]!,
                        4: Colors.red[700]!,
                        5: Colors.red[900]!,
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Posts',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: user.posts.length,
                      itemBuilder: (context, index) {
                        final post = user.posts[index];
                        final formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                            .format(post.createdAt);

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(post.body,
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(formattedDate,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is UserProfileError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
