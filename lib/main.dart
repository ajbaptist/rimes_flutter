import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rimes_flutter/repositories/article_repository.dart';
import 'package:rimes_flutter/screens/article/article_details.dart';
import 'package:rimes_flutter/screens/users/user_profile.dart';
import 'package:rimes_flutter/services/notification_service.dart';
import 'package:rimes_flutter/utils/api_constants.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/article/article_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/article/home_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/article/article_editor.dart';
import 'screens/analytics/analytics_screen.dart';
import 'services/api_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.init();

  final api = ApiService(baseUrl: APiConstants.baseURL);

  runApp(MyApp(api: api));
}

class MyApp extends StatelessWidget {
  final ApiService api;

  const MyApp({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: api,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(apiService: api)..add(CheckAuthStatus()),
          ),
          BlocProvider(
              create: (_) => ArticleBloc(repo: ArticleRepository(api: api))),
        ],
        child: MaterialApp(
          key: NotificationService.navigatorKey,
          title: 'Mobile Task',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: AppBarTheme(
                centerTitle: true,
              )),
          home: AuthWrapper(),
          onGenerateRoute: (settings) {
            if (settings.name == '/userData') {
              final userId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => UserProfileScreen(userId: userId),
              );
            }
            return null;
          },
          routes: {
            '/login': (_) => LoginScreen(),
            '/register': (_) => RegistrationScreen(),
            '/compose': (_) => ArticleEditorScreen(),
            '/analytics': (_) => AnalyticsScreen(),
            '/articleDetail': (_) => ArticleDetailScreen(),
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is AuthSuccess) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
