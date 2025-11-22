// create_structure.dart file




import 'dart:io';

void main() {
  print('🚀 Creating Provider + Clean Architecture project structure...\n');

  // Core directories
  final directories = [
    'lib/core/constants',
    'lib/core/errors',
    'lib/core/network',
    'lib/core/themes',
    'lib/core/utils',
    'lib/core/widgets',
    'lib/features',
    'lib/app/routes',
    'lib/app/providers',
    'test/features',
    'test/core',
  ];

  // Create all directories
  for (final dir in directories) {
    Directory(dir).createSync(recursive: true);
    print('📁 Created: $dir');
  }

  // Create core files
  _createCoreFiles();

  // Create main files
  _createMainFiles();

  print('\n✅ Project structure created successfully!');
  print('\n📝 Next steps:');
  print('   1. Add dependencies in pubspec.yaml');
  print('   2. Run: dart run tool/create_screen_smart.dart HomeScreen');
  print('   3. Start developing your features!');
}

void _createCoreFiles() {
  // Core constants
  _createFile('lib/core/constants/app_constants.dart', '''
class AppConstants {
  static const String appName = 'My Flutter App';
  static const String appVersion = '1.0.0';
  
  // Add your app constants here
}
''');

  _createFile('lib/core/constants/api_constants.dart', '''
class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // API endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
}
''');

  _createFile('lib/core/constants/route_constants.dart', '''
class RouteConstants {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  
  // Add your route constants here
}
''');

  // Core errors
  _createFile('lib/core/errors/exceptions.dart', '''
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AppException(this.message, [this.stackTrace]);
}

class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection']) : super(message);
}

class ServerException extends AppException {
  const ServerException([String message = 'Server error']) : super(message);
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache error']) : super(message);
}
''');

  _createFile('lib/core/errors/failures.dart', '''
abstract class Failure {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection']) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}
''');

  // Core network
  _createFile('lib/core/network/network_info.dart', '''
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
''');

  // Core themes
  _createFile('lib/core/themes/app_theme.dart', '''
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
  }
}
''');

  // Core utils
  _createFile('lib/core/utils/extensions.dart', '''
import 'package:flutter/material.dart';

extension StringExtensions on String {
  bool get isNullOrEmpty => isEmpty;

  String get capitalize {
    if (isEmpty) return this;
    return '\${this[0].toUpperCase()}\${substring(1)}';
  }
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
''');

  // Core widgets
  _createFile('lib/core/widgets/loading_indicator.dart', '''
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color color;

  const LoadingIndicator({
    super.key,
    this.size = 24.0,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
''');
}

void _createMainFiles() {
  // Main app files
  _createFile('lib/main.dart', '''
import 'package:flutter/material.dart';
import 'app/app.dart';

void main() {
  runApp(const MyApp());
}
''');

  _createFile('lib/app/app.dart', '''
import 'package:flutter/material.dart';
import 'routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
''');

  _createFile('lib/app/routes/app_router.dart', '''
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      // Add your routes here
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Welcome to My Flutter App'),
          ),
        ), // Replace with your home screen
      ),
    ],
  );
}
''');

  _createFile('lib/app/providers/app_provider.dart', '''
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
''');

}

void _createFile(String path, String content) {
  File(path).writeAsStringSync(content);
  print('📄 Created: $path');
}
