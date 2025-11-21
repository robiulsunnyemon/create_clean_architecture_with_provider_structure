
# Flutter Provider + Clean Architecture Generator

Automate your Flutter project structure with Clean Architecture & Provider state management. Generate complete feature screens with proper separation of concerns, automatic routing, and dependency injection.

## 🎯 Features

- ✅ **Clean Architecture** - Data, Domain, Presentation layers
- ✅ **Provider State Management** - Efficient state management
- ✅ **Automatic Routing** - Auto-updates app router
- ✅ **Dependency Injection** - Auto-registers providers in main.dart
- ✅ **Ready-to-Use Code** - Working templates with error handling
- ✅ **Either Pattern** - Proper error handling with Dartz
- ✅ **Hot Restart Ready** - Works immediately after generation

## 📁 Generated Structure

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── themes/
│   ├── utils/
│   └── widgets/
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── providers/
│           ├── pages/
│           ├── widgets/
│           └── state/
├── app/
│   ├── routes/
│   └── providers/
└── main.dart
```

## 🚀 Quick Start

### 1. Setup Project Structure

```bash
# Create basic project structure
dart run tool/create_provider_clean_architecture.dart
```

### 2. Create Your First Screen

```bash
# Generate complete feature screen
dart run tool/create_screen_smart.dart HomeScreen
dart run tool/create_screen_smart.dart ProfileScreen
dart run tool/create_screen_smart.dart ProductScreen
```

### 3. Add Dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  dartz: ^0.10.1
  connectivity_plus: ^5.0.1
  go_router: ^13.0.0
```

### 4. Run Your App

```bash
flutter pub get
flutter run
```

## 📋 Prerequisites

- Flutter SDK 3.0+
- Dart 2.17+
- Basic understanding of Clean Architecture

## 🛠 Installation

### Step 1: Create Script Files

Create a `tool` folder in your Flutter project root and add these scripts:

**File 1:** `tool/create_provider_clean_architecture.dart`

```dart
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

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      // Add your routes here
      GoRoute(
        path: '/',
        builder: (context, state) => const Placeholder(), // Replace with your home screen
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

  // Create a sample feature structure
  _createFile('lib/features/README.md', '''
# Features Directory

This directory contains all the features of your application.

Each feature should follow this structure:
- data/ (Data layer)
- domain/ (Domain layer) 
- presentation/ (Presentation layer)

To create a new feature, run:
dart run tool/create_screen_smart.dart FeatureName
''');
}

void _createFile(String path, String content) {
  File(path).writeAsStringSync(content);
  print('📄 Created: $path');
}
```

**File 2:** `tool/create_screen_smart.dart`

```dart
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('❌ Please provide a screen name. Usage:');
    print('   dart run tool/create_screen_smart.dart ScreenName');
    print('   dart run tool/create_screen_smart.dart HomeScreen');
    return;
  }

  final screenName = arguments.first;
  final featureName = _convertToFeatureName(screenName);

  print('🚀 Creating feature: $featureName for screen: $screenName\n');

  _createFeatureStructure(featureName, screenName);
  _createFeatureFiles(featureName, screenName);
  _updateAppRouter(featureName, screenName);
  _updateMainDart(featureName, screenName);

  print('\n✅ Feature "$featureName" created successfully!');
  print('\n📝 Next steps:');
  print('   1. Run: flutter pub get');
  print('   2. Perform HOT RESTART (not hot reload)');
  print('   3. Start developing your feature!');
}

String _convertToFeatureName(String screenName) {
  var name = screenName.replaceAll('Screen', '').toLowerCase();
  return name;
}

void _createFeatureStructure(String featureName, String screenName) {
  final directories = [
    'lib/features/$featureName/data/datasources',
    'lib/features/$featureName/data/models',
    'lib/features/$featureName/data/repositories',
    'lib/features/$featureName/domain/entities',
    'lib/features/$featureName/domain/repositories',
    'lib/features/$featureName/domain/usecases',
    'lib/features/$featureName/domain/providers',
    'lib/features/$featureName/presentation/providers',
    'lib/features/$featureName/presentation/pages',
    'lib/features/$featureName/presentation/widgets',
    'lib/features/$featureName/presentation/state',
  ];

  for (final dir in directories) {
    try {
      Directory(dir).createSync(recursive: true);
      print('📁 Created: $dir');
    } catch (e) {
      print('⚠️  Failed to create directory: $dir - $e');
    }
  }
}

void _createFeatureFiles(String featureName, String screenName) {
  final className = screenName.replaceAll('Screen', '');
  final snakeCaseName = _convertToSnakeCase(featureName);

  // Data Layer
  _createFile('lib/features/$featureName/data/models/${snakeCaseName}_model.dart', '''
class ${className}Model {
  final String id;
  final String title;
  
  const ${className}Model({
    required this.id,
    required this.title,
  });

  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
''');

  _createFile('lib/features/$featureName/data/datasources/${snakeCaseName}_remote_data_source.dart', '''
import '../../../../core/errors/exceptions.dart';
import '../models/${snakeCaseName}_model.dart';

abstract class ${className}RemoteDataSource {
  Future<${className}Model> get${className}Data();
}

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  @override
  Future<${className}Model> get${className}Data() async {
    try {
      // Implement your API call here
      await Future.delayed(const Duration(milliseconds: 500));
      return ${className}Model(
        id: '1',
        title: '$className Data',
      );
    } catch (e) {
      throw ServerException('Failed to fetch $featureName data');
    }
  }
}
''');

  _createFile('lib/features/$featureName/data/repositories/${snakeCaseName}_repository_impl.dart', '''
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/${snakeCaseName}_entity.dart';
import '../../domain/repositories/${snakeCaseName}_repository.dart';
import '../datasources/${snakeCaseName}_remote_data_source.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ${className}RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ${className}Entity>> get${className}Data() async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.get${className}Data();
        final entity = ${className}Entity(
          id: model.id,
          title: model.title,
        );
        return Right(entity);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
''');

  // Domain Layer
  _createFile('lib/features/$featureName/domain/entities/${snakeCaseName}_entity.dart', '''
class ${className}Entity {
  final String id;
  final String title;
  
  const ${className}Entity({
    required this.id,
    required this.title,
  });
}
''');

  _createFile('lib/features/$featureName/domain/repositories/${snakeCaseName}_repository.dart', '''
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/${snakeCaseName}_entity.dart';

abstract class ${className}Repository {
  Future<Either<Failure, ${className}Entity>> get${className}Data();
}
''');

  _createFile('lib/features/$featureName/domain/usecases/get_${snakeCaseName}_usecase.dart', '''
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/${snakeCaseName}_repository.dart';
import '../entities/${snakeCaseName}_entity.dart';

class Get${className}UseCase {
  final ${className}Repository repository;

  Get${className}UseCase(this.repository);

  Future<Either<Failure, ${className}Entity>> call() {
    return repository.get${className}Data();
  }
}
''');

  // Presentation Layer
  _createFile('lib/features/$featureName/presentation/state/${snakeCaseName}_state.dart', '''
import 'package:flutter/material.dart';

@immutable
abstract class ${className}State {
  const ${className}State();
}

class ${className}Initial extends ${className}State {}

class ${className}Loading extends ${className}State {}

class ${className}Loaded extends ${className}State {
  final ${className}Entity data;

  const ${className}Loaded(this.data);
}

class ${className}Error extends ${className}State {
  final String message;

  const ${className}Error(this.message);
}
''');

  _createFile('lib/features/$featureName/presentation/providers/${snakeCaseName}_provider.dart', '''
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../domain/usecases/get_${snakeCaseName}_usecase.dart';
import '../../domain/entities/${snakeCaseName}_entity.dart';
import '../state/${snakeCaseName}_state.dart';

class ${className}Provider with ChangeNotifier {
  final Get${className}UseCase get${className}UseCase;
  ${className}State _state = ${className}Initial();

  ${className}Provider({required this.get${className}UseCase});

  ${className}State get state => _state;

  Future<void> get${className}Data() async {
    _state = ${className}Loading();
    notifyListeners();

    final result = await get${className}UseCase();

    result.fold(
      (failure) {
        _state = ${className}Error(failure.toString());
      },
      (entity) {
        _state = ${className}Loaded(entity);
      },
    );

    notifyListeners();
  }
}
''');

  _createFile('lib/features/$featureName/presentation/pages/${snakeCaseName}_page.dart', '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/${snakeCaseName}_provider.dart';
import '../state/${snakeCaseName}_state.dart';

class ${screenName} extends StatefulWidget {
  const ${screenName}({super.key});

  @override
  State<${screenName}> createState() => _${screenName}State();
}

class _${screenName}State extends State<${screenName}> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<${className}Provider>(context, listen: false);
      provider.get${className}Data();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$screenName'),
      ),
      body: Consumer<${className}Provider>(
        builder: (context, provider, child) {
          final state = provider.state;

          if (state is ${className}Initial || state is ${className}Loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            );
          } else if (state is ${className}Loaded) {
            return _buildContent(state.data);
          } else if (state is ${className}Error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.get${className}Data(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildContent(${className}Entity data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('ID: \${data.id}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Feature Information'),
                  subtitle: const Text('This screen was automatically generated'),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Clean Architecture'),
                  subtitle: const Text('Follows Provider + Clean Architecture pattern'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
''');

  // Dependency Injection
  _createFile('lib/features/$featureName/domain/providers/${snakeCaseName}_providers.dart', '''
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> ${featureName}Providers = [
  // These providers are automatically added to main.dart
];
''');

  print('\n📋 Created all files for $featureName feature');
}

void _updateAppRouter(String featureName, String screenName) {

  final routePath = '/$featureName';
  final routeName = featureName;

  final routerFile = File('lib/app/routes/app_router.dart');
  String content = '';

  if (routerFile.existsSync()) {
    content = routerFile.readAsStringSync();
  } else {
    Directory('lib/app/routes').createSync(recursive: true);
    content = '''
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Routes will be added automatically here
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: \${state.uri}'),
      ),
    ),
  );
}
''';
    routerFile.writeAsStringSync(content);
    print('📄 Created: lib/app/routes/app_router.dart');
  }

  if (content.contains("path: '$routePath'")) {
    print('⚠️  Route $routePath already exists in app_router.dart');
    return;
  }

  final importStatement = "import '../../features/$featureName/presentation/pages/${_convertToSnakeCase(featureName)}_page.dart';";

  if (!content.contains(importStatement)) {
    final importSectionEnd = content.lastIndexOf("import '");
    if (importSectionEnd != -1) {
      final nextLine = content.indexOf('\n', importSectionEnd);
      content = content.substring(0, nextLine + 1) + '$importStatement\n' + content.substring(nextLine + 1);
    } else {
      content = '$importStatement\n$content';
    }
  }

  final routesStart = content.indexOf('routes: [');
  if (routesStart != -1) {
    final routesContentStart = content.indexOf('[', routesStart) + 1;
    final routeCode = '''
      GoRoute(
        path: '$routePath',
        name: '$routeName',
        builder: (context, state) => const $screenName(),
      ),''';

    content = content.substring(0, routesContentStart) + '\n$routeCode' + content.substring(routesContentStart);
  }

  routerFile.writeAsStringSync(content);
  print('✅ Added route: $routePath -> $screenName in app_router.dart');
  _updateRouteConstants(featureName, routePath);
}

void _updateRouteConstants(String featureName, String routePath) {
  final constantsFile = File('lib/core/constants/route_constants.dart');

  if (!constantsFile.existsSync()) {
    Directory('lib/core/constants').createSync(recursive: true);
    _createFile('lib/core/constants/route_constants.dart', '''
class RouteConstants {
  static const String home = '/';
}
''');
  }

  String content = constantsFile.readAsStringSync();
  final constantName = featureName.toUpperCase();

  if (!content.contains('static const String $constantName =')) {
    final lastBrace = content.lastIndexOf('}');
    if (lastBrace != -1) {
      final newConstant = '  static const String $constantName = \'$routePath\';\n';
      content = content.substring(0, lastBrace) + newConstant + content.substring(lastBrace);
      constantsFile.writeAsStringSync(content);
      print('✅ Added route constant: $constantName = $routePath');
    }
  }
}

// নতুন ফাংশন: main.dart এ প্রোভাইডার অটোমেটিকally এড করা
void _updateMainDart(String featureName, String screenName) {
  final className = screenName.replaceAll('Screen', '');
  final mainFile = File('lib/main.dart');

  if (!mainFile.existsSync()) {
    print('⚠️  main.dart not found. Creating basic main.dart...');
    _createBasicMainDart();
    return;
  }

  String content = mainFile.readAsStringSync();

  // Check if providers are already added
  final providerCheck = 'ChangeNotifierProvider<${className}Provider>';
  if (content.contains(providerCheck)) {
    print('⚠️  $className providers already exist in main.dart');
    return;
  }

  // Add imports if not exists
  final importsToAdd = [
    "import 'features/$featureName/data/datasources/${_convertToSnakeCase(featureName)}_remote_data_source.dart';",
    "import 'features/$featureName/data/repositories/${_convertToSnakeCase(featureName)}_repository_impl.dart';",
    "import 'features/$featureName/domain/repositories/${_convertToSnakeCase(featureName)}_repository.dart';",
    "import 'features/$featureName/domain/usecases/get_${_convertToSnakeCase(featureName)}_usecase.dart';",
    "import 'features/$featureName/presentation/providers/${_convertToSnakeCase(featureName)}_provider.dart';",
  ];

  for (final import in importsToAdd) {
    if (!content.contains(import)) {
      final lastImport = content.lastIndexOf("import '");
      if (lastImport != -1) {
        final nextLine = content.indexOf('\n', lastImport);
        content = content.substring(0, nextLine + 1) + '$import\n' + content.substring(nextLine + 1);
      } else {
        final firstLineEnd = content.indexOf('\n') + 1;
        content = content.substring(0, firstLineEnd) + '$import\n' + content.substring(firstLineEnd);
      }
    }
  }

  // Find MultiProvider - more flexible search
  final multiProviderPattern = RegExp(r'MultiProvider\s*\(');
  final match = multiProviderPattern.firstMatch(content);

  if (match == null) {
    print('⚠️  Could not find MultiProvider in main.dart');
    print('💡 Creating new MultiProvider setup...');
    _createMultiProviderSetup(featureName, screenName, content);
    return;
  }

  final multiProviderStart = match.start;

  // Find providers list
  final providersPattern = RegExp(r'providers:\s*\[');
  final providersMatch = providersPattern.firstMatch(content.substring(multiProviderStart));

  if (providersMatch == null) {
    print('⚠️  Could not find providers list in main.dart');
    return;
  }

  final providersStart = multiProviderStart + providersMatch.start;
  final providersContentStart = content.indexOf('[', providersStart) + 1;

  final newProviders = '''

        // $screenName Feature Providers
        Provider<${className}RemoteDataSource>(
          create: (context) => ${className}RemoteDataSourceImpl(),
        ),
        Provider<${className}Repository>(
          create: (context) => ${className}RepositoryImpl(
            remoteDataSource: context.read<${className}RemoteDataSource>(),
            networkInfo: context.read<NetworkInfo>(),
          ),
        ),
        Provider<Get${className}UseCase>(
          create: (context) => Get${className}UseCase(
            context.read<${className}Repository>(),
          ),
        ),
        ChangeNotifierProvider<${className}Provider>(
          create: (context) => ${className}Provider(
            get${className}UseCase: context.read<Get${className}UseCase>(),
          ),
        ),''';

  content = content.substring(0, providersContentStart) + newProviders + content.substring(providersContentStart);

  mainFile.writeAsStringSync(content);
  print('✅ Added $className providers to main.dart');
}

// নতুন ফাংশন: MultiProvider setup তৈরি করা যদি না থাকে
void _createMultiProviderSetup(String featureName, String screenName, String originalContent) {
  final className = screenName.replaceAll('Screen', '');

  // Check if runApp exists
  final runAppPattern = RegExp(r'runApp\s*\(([^)]+)\)');
  final runAppMatch = runAppPattern.firstMatch(originalContent);

  if (runAppMatch == null) {
    print('❌ Could not find runApp in main.dart. Manual setup required.');
    return;
  }


  // Create new content with MultiProvider
  final newContent = '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Core
import 'core/network/network_info.dart';

// Features
import 'features/$featureName/data/datasources/${_convertToSnakeCase(featureName)}_remote_data_source.dart';
import 'features/$featureName/data/repositories/${_convertToSnakeCase(featureName)}_repository_impl.dart';
import 'features/$featureName/domain/repositories/${_convertToSnakeCase(featureName)}_repository.dart';
import 'features/$featureName/domain/usecases/get_${_convertToSnakeCase(featureName)}_usecase.dart';
import 'features/$featureName/presentation/providers/${_convertToSnakeCase(featureName)}_provider.dart';

// App
import 'app/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Core providers
        Provider<NetworkInfo>(
          create: (context) => NetworkInfoImpl(Connectivity()),
        ),

        // $screenName Feature Providers
        Provider<${className}RemoteDataSource>(
          create: (context) => ${className}RemoteDataSourceImpl(),
        ),
        Provider<${className}Repository>(
          create: (context) => ${className}RepositoryImpl(
            remoteDataSource: context.read<${className}RemoteDataSource>(),
            networkInfo: context.read<NetworkInfo>(),
          ),
        ),
        Provider<Get${className}UseCase>(
          create: (context) => Get${className}UseCase(
            context.read<${className}Repository>(),
          ),
        ),
        ChangeNotifierProvider<${className}Provider>(
          create: (context) => ${className}Provider(
            get${className}UseCase: context.read<Get${className}UseCase>(),
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
''';

  File('lib/main.dart').writeAsStringSync(newContent);
  print('✅ Created new MultiProvider setup in main.dart');
}

void _createBasicMainDart() {
  _createFile('lib/main.dart', '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Core
import 'core/network/network_info.dart';

// App
import 'app/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core providers
        Provider<NetworkInfo>(
          create: (context) => NetworkInfoImpl(Connectivity()),
        ),

        // Add your feature providers here
      ],
      child: const App(),
    );
  }
}
''');
}

String _convertToSnakeCase(String text) {
  return text.replaceAllMapped(
    RegExp(r'[A-Z]'),
        (match) => match.start == 0 ? match.group(0)!.toLowerCase() : '_${match.group(0)!.toLowerCase()}',
  );
}

void _createFile(String path, String content) {
  try {
    final file = File(path);
    final directory = file.parent;
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    file.writeAsStringSync(content);
    print('📄 Created: $path');
  } catch (e) {
    print('❌ Failed to create file: $path - $e');
  }
}
```

### Step 2: Run the Scripts

```bash
# Create project structure
dart run tool/create_provider_clean_architecture.dart

# Generate screens
dart run tool/create_screen_smart.dart HomeScreen
dart run tool/create_screen_smart.dart ProfileScreen
```

## 📝 Usage Examples

### Generate Different Screens

```bash
# Home Feature
dart run tool/create_screen_smart.dart HomeScreen

# Profile Feature  
dart run tool/create_screen_smart.dart ProfileScreen

# Product Feature
dart run tool/create_screen_smart.dart ProductScreen

# Settings Feature
dart run tool/create_screen_smart.dart SettingsScreen

# Auth Feature
dart run tool/create_screen_smart.dart LoginScreen
```

### What Gets Generated

For `HomeScreen`, the script creates:

- `lib/features/home/data/models/home_model.dart`
- `lib/features/home/data/datasources/home_remote_data_source.dart`
- `lib/features/home/data/repositories/home_repository_impl.dart`
- `lib/features/home/domain/entities/home_entity.dart`
- `lib/features/home/domain/repositories/home_repository.dart`
- `lib/features/home/domain/usecases/get_home_usecase.dart`
- `lib/features/home/presentation/state/home_state.dart`
- `lib/features/home/presentation/providers/home_provider.dart`
- `lib/features/home/presentation/pages/home_page.dart`

## ⚡ Auto-Generated Features

### 🎯 Automatic Routing
- Updates `app_router.dart` with new routes
- Adds route constants to `route_constants.dart`
- Handles import statements automatically

### 🔧 Provider Registration
- Automatically registers providers in `main.dart`
- Sets up dependency injection with MultiProvider
- Configures all necessary dependencies

### 📱 Ready-to-Use UI
- Complete page with state management
- Loading, success, and error states
- Consumer widget for state observation
- Proper error handling with retry mechanism

## 🏗 Architecture Overview

### Data Layer
- **Models** - Data transfer objects
- **DataSources** - API and local data sources
- **Repositories** - Data repository implementations

### Domain Layer
- **Entities** - Business logic entities
- **Repositories** - Abstract repository contracts
- **UseCases** - Application business rules

### Presentation Layer
- **Providers** - State management with ChangeNotifier
- **Pages** - UI screens with state consumption
- **State** - State classes for different UI states
- **Widgets** - Reusable UI components

## 🔄 State Management Flow

```
UI Widget → Consumer → Provider → UseCase → Repository → DataSource
     ↑                                        ↓
     └─────────── State Update ←──────────────┘
```

## ⚠️ Important Notes

### Hot Restart Required
```bash
# ❌ Don't use hot reload
# ✅ Always use hot restart after generating new screens
flutter run --hot-restart
```

### Dependencies Required
Make sure these dependencies are in your `pubspec.yaml`:

```yaml
dependencies:
  provider: ^6.1.1
  dartz: ^0.10.1
  connectivity_plus: ^5.0.1
  go_router: ^13.0.0
```

## 🐛 Troubleshooting

### ProviderNotFoundException
If you see this error, perform a **HOT RESTART**:

```bash
flutter run --hot-restart
```

### Missing Dependencies
Add the required packages to `pubspec.yaml` and run:

```bash
flutter pub get
```

### Route Not Found
Check if the route was added to `lib/app/routes/app_router.dart`:

```dart
GoRoute(
  path: '/home',
  name: 'home',
  builder: (context, state) => const HomeScreen(),
),
```

## 📚 Generated Code Example

### Provider Class
```dart
class HomeProvider with ChangeNotifier {
  final GetHomeUseCase getHomeUseCase;
  HomeState _state = HomeInitial();

  HomeProvider({required this.getHomeUseCase});

  HomeState get state => _state;

  Future<void> getHomeData() async {
    _state = HomeLoading();
    notifyListeners();

    final result = await getHomeUseCase();
    
    result.fold(
      (failure) => _state = HomeError(failure.toString()),
      (entity) => _state = HomeLoaded(entity),
    );
    
    notifyListeners();
  }
}
```

### Page Widget
```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeScreen')),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          // Handle different states
          return Container();
        },
      ),
    );
  }
}
```

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues and pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Clean Architecture concept by Robert C. Martin
- Flutter team for the amazing framework
- Provider package maintainers



