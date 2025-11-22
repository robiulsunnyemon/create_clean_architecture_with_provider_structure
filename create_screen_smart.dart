//create_screen_smart.dart

import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('❌ Please provide a screen name. Usage:');
    print('   dart run tool/create_screen_smart.dart ScreenName');
    print('   dart run tool/create_screen_smart.dart HomeScreen');
    print('   dart run tool/create_screen_smart.dart HomeScreen -l');
    return;
  }

  final screenName = arguments.first;
  final isList = arguments.length > 1 && arguments[1] == '-l';
  final featureName = _convertToFeatureName(screenName);

  print('🚀 Creating feature: $featureName for screen: $screenName');
  print('📦 Response type: ${isList ? 'List' : 'Single'}');

  _createFeatureStructure(featureName, screenName);
  _createFeatureFiles(featureName, screenName, isList);
  _updateAppRouter(featureName, screenName);
  _updateMainDart(featureName, screenName, isList);

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

void _createFeatureFiles(String featureName, String screenName, bool isList) {
  final className = screenName.replaceAll('Screen', '');
  final snakeCaseName = _convertToSnakeCase(featureName);

  // Domain Layer - Entity (প্রথমে Entity তৈরি হবে)
  _createFile(
    'lib/features/$featureName/domain/entities/${snakeCaseName}_entity.dart',
    '''
class ${className}Entity {
  final int userId;
  final int id;
  final String title;
  final String body;

  const ${className}Entity({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  // Copy with method for easy updates
  ${className}Entity copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return ${className}Entity(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  String toString() {
    return '${className}Entity(userId: \$userId, id: \$id, title: \$title, body: \$body)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ${className}Entity &&
      other.userId == userId &&
      other.id == id &&
      other.title == title &&
      other.body == body;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      id.hashCode ^
      title.hashCode ^
      body.hashCode;
  }
}
''',
  );

  // Data Layer - Model (Entity কে extends করে)
  _createFile(
    'lib/features/$featureName/data/models/${snakeCaseName}_model.dart',
    '''
import '../../domain/entities/${snakeCaseName}_entity.dart';

class ${className}Model extends ${className}Entity {
  ${className}Model({
    required super.userId,
    required super.id,
    required super.title,
    required super.body,
  });

  // JSON → Dart object
  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      userId: json['userId'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  // Entity → Model
  factory ${className}Model.fromEntity(${className}Entity entity) {
    return ${className}Model(
      userId: entity.userId,
      id: entity.id,
      title: entity.title,
      body: entity.body,
    );
  }

  // Model → Entity (automatically available due to inheritance)
  ${className}Entity toEntity() {
    return ${className}Entity(
      userId: userId,
      id: id,
      title: title,
      body: body,
    );
  }

  // Copy with method
  @override
  ${className}Model copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return ${className}Model(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
''',
  );

  // Data Layer - Remote Data Source
  final responseType = isList ? 'List<${className}Model>' : '${className}Model';
  final apiResponse = isList
      ? '[${className}Model(userId: 1, id: 1, title: "$className Title 1", body: "This is the body of $className 1"), ${className}Model(userId: 1, id: 2, title: "$className Title 2", body: "This is the body of $className 2")]'
      : '${className}Model(userId: 1, id: 1, title: "$className Title", body: "This is the body of $className")';

  _createFile(
    'lib/features/$featureName/data/datasources/${snakeCaseName}_remote_data_source.dart',
    '''
import '../../../../core/errors/exceptions.dart';
import '../models/${snakeCaseName}_model.dart';

abstract class ${className}RemoteDataSource {
  Future<$responseType> get${className}Data();
}

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  @override
  Future<$responseType> get${className}Data() async {
    try {
      // Implement your API call here
      await Future.delayed(const Duration(milliseconds: 500));
      return $apiResponse;
    } catch (e) {
      throw ServerException('Failed to fetch $featureName data');
    }
  }
}
''',
  );

  // Data Layer - Repository Implementation
  final entityResponseType = isList
      ? 'List<${className}Entity>'
      : '${className}Entity';
  final repositoryMethodBody = isList
      ? '''
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.get${className}Data();
        // Models automatically are Entities (due to inheritance)
        return Right(models);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  '''
      : '''
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.get${className}Data();
        // Model automatically is Entity (due to inheritance)
        return Right(model);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  ''';

  _createFile(
    'lib/features/$featureName/data/repositories/${snakeCaseName}_repository_impl.dart',
    '''
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
  Future<Either<Failure, $entityResponseType>> get${className}Data() async {
    $repositoryMethodBody
  }
}
''',
  );

  // Domain Layer - Repository Interface
  _createFile(
    'lib/features/$featureName/domain/repositories/${snakeCaseName}_repository.dart',
    '''
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/${snakeCaseName}_entity.dart';

abstract class ${className}Repository {
  Future<Either<Failure, ${isList ? 'List<${className}Entity>' : '${className}Entity'}>> get${className}Data();
}
''',
  );

  // Domain Layer - Use Cases
  _createFile(
    'lib/features/$featureName/domain/usecases/get_${snakeCaseName}_usecase.dart',
    '''
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/${snakeCaseName}_repository.dart';
import '../entities/${snakeCaseName}_entity.dart';

class Get${className}UseCase {
  final ${className}Repository repository;

  Get${className}UseCase(this.repository);

  Future<Either<Failure, ${isList ? 'List<${className}Entity>' : '${className}Entity'}>> call() {
    return repository.get${className}Data();
  }
}
''',
  );

  // Presentation Layer - State
  final stateType = isList ? 'List<${className}Entity>' : '${className}Entity';
  final stateLoaded = isList ? '${className}ListLoaded' : '${className}Loaded';

  _createFile(
    'lib/features/$featureName/presentation/state/${snakeCaseName}_state.dart',
    '''
import 'package:flutter/material.dart';
import '../../domain/entities/${snakeCaseName}_entity.dart';

@immutable
abstract class ${className}State {
  const ${className}State();
}

class ${className}Initial extends ${className}State {}

class ${className}Loading extends ${className}State {}

class ${stateLoaded} extends ${className}State {
  final $stateType data;

  const ${stateLoaded}(this.data);
}

class ${className}Error extends ${className}State {
  final String message;

  const ${className}Error(this.message);
}
''',
  );

  // Presentation Layer - Provider
  _createFile(
    'lib/features/$featureName/presentation/providers/${snakeCaseName}_provider.dart',
    '''
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../domain/usecases/get_${snakeCaseName}_usecase.dart';
import '../../domain/entities/${snakeCaseName}_entity.dart';
import '../state/${snakeCaseName}_state.dart';

class ${className}Provider with ChangeNotifier {
  final Get${className}UseCase get${className}UseCase;
  ${className}State _state = ${className}Initial();
  ${isList ? 'List<${className}Entity> _items = [];' : '${className}Entity? _item;'}

  ${className}Provider({required this.get${className}UseCase});

  ${className}State get state => _state;
  ${isList ? 'List<${className}Entity> get items => _items;' : '${className}Entity? get item => _item;'}

  Future<void> get${className}Data() async {
    _state = ${className}Loading();
    notifyListeners();

    final result = await get${className}UseCase();

    result.fold(
      (failure) {
        _state = ${className}Error(failure.toString());
      },
      (${isList ? 'entities' : 'entity'}) {
        ${isList ? '_items = entities;' : '_item = entity;'}
        _state = ${stateLoaded}(${isList ? 'entities' : 'entity'});
      },
    );

    notifyListeners();
  }

  ${isList ? '''
  // Additional methods for list operations
  void addItem(${className}Entity item) {
    _items.add(item);
    _state = ${className}ListLoaded(_items);
    notifyListeners();
  }

  void removeItem(int itemId) {
    _items.removeWhere((item) => item.id == itemId);
    _state = ${className}ListLoaded(_items);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    _state = ${className}ListLoaded(_items);
    notifyListeners();
  }
  ''' : '''
  // Additional methods for single item operations
  void updateItem(${className}Entity updatedItem) {
    _item = updatedItem;
    _state = ${className}Loaded(updatedItem);
    notifyListeners();
  }

  void clearItem() {
    _item = null;
    _state = ${className}Initial();
    notifyListeners();
  }
  '''}
}
''',
  );

  // Presentation Layer - Page
  _createFile(
    'lib/features/$featureName/presentation/pages/${snakeCaseName}_page.dart',
    '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/${snakeCaseName}_provider.dart';
import '../state/${snakeCaseName}_state.dart';
import '../../domain/entities/${snakeCaseName}_entity.dart';

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
          } else if (state is ${stateLoaded}) {
            return _buildContent(state.data${isList ? ', provider' : ''});
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

Widget _buildContent(${isList ? 'List<${className}Entity> data, ${className}Provider provider' : '${className}Entity data'}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ${isList ? '''
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Items: \${data.length}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: \${item.id}'),
                      Text('User ID: \${item.userId}'),
                      Text('Body: \${item.body.length <= 50 ? item.body : '\${item.body.substring(0, 50)}...'}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.removeItem(item.id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    )
    ''' : '''
    Column(
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
                Text('User ID: \${data.userId}'),
                const SizedBox(height: 8),
                Text(
                  data.body,
                  style: const TextStyle(fontSize: 16),
                ),
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
    )
    '''}
  );
}
}
''',
  );

  // Dependency Injection
  _createFile(
    'lib/features/$featureName/domain/providers/${snakeCaseName}_providers.dart',
    '''
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> ${featureName}Providers = [
  // These providers are automatically added to main.dart
];
''',
  );

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

  final importStatement =
      "import '../../features/$featureName/presentation/pages/${_convertToSnakeCase(featureName)}_page.dart';";

  if (!content.contains(importStatement)) {
    final importSectionEnd = content.lastIndexOf("import '");
    if (importSectionEnd != -1) {
      final nextLine = content.indexOf('\n', importSectionEnd);
      content =
          content.substring(0, nextLine + 1) +
          '$importStatement\n' +
          content.substring(nextLine + 1);
    } else {
      content = '$importStatement\n$content';
    }
  }

  final routesStart = content.indexOf('routes: [');
  if (routesStart != -1) {
    final routesContentStart = content.indexOf('[', routesStart) + 1;
    final routeCode =
        '''
      GoRoute(
        path: '$routePath',
        name: '$routeName',
        builder: (context, state) => const $screenName(),
      ),''';

    content =
        content.substring(0, routesContentStart) +
        '\n$routeCode' +
        content.substring(routesContentStart);
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
      final newConstant =
          '  static const String $constantName = \'$routePath\';\n';
      content =
          content.substring(0, lastBrace) +
          newConstant +
          content.substring(lastBrace);
      constantsFile.writeAsStringSync(content);
      print('✅ Added route constant: $constantName = $routePath');
    }
  }
}

// নতুন ফাংশন: main.dart এ প্রোভাইডার অটোমেটিকally এড করা
void _updateMainDart(String featureName, String screenName, bool isList) {
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
        content =
            content.substring(0, nextLine + 1) +
            '$import\n' +
            content.substring(nextLine + 1);
      } else {
        final firstLineEnd = content.indexOf('\n') + 1;
        content =
            content.substring(0, firstLineEnd) +
            '$import\n' +
            content.substring(firstLineEnd);
      }
    }
  }

  // Find MultiProvider - more flexible search
  final multiProviderPattern = RegExp(r'MultiProvider\s*\(');
  final match = multiProviderPattern.firstMatch(content);

  if (match == null) {
    print('⚠️  Could not find MultiProvider in main.dart');
    print('💡 Creating new MultiProvider setup...');
    _createMultiProviderSetup(featureName, screenName, content, isList);
    return;
  }

  final multiProviderStart = match.start;

  // Find providers list
  final providersPattern = RegExp(r'providers:\s*\[');
  final providersMatch = providersPattern.firstMatch(
    content.substring(multiProviderStart),
  );

  if (providersMatch == null) {
    print('⚠️  Could not find providers list in main.dart');
    return;
  }

  final providersStart = multiProviderStart + providersMatch.start;
  final providersContentStart = content.indexOf('[', providersStart) + 1;

  final newProviders =
      '''

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

  content =
      content.substring(0, providersContentStart) +
      newProviders +
      content.substring(providersContentStart);

  mainFile.writeAsStringSync(content);
  print('✅ Added $className providers to main.dart');
}

// নতুন ফাংশন: MultiProvider setup তৈরি করা যদি না থাকে
void _createMultiProviderSetup(
  String featureName,
  String screenName,
  String originalContent,
  bool isList,
) {
  final className = screenName.replaceAll('Screen', '');

  // Check if runApp exists
  final runAppPattern = RegExp(r'runApp\s*\(([^)]+)\)');
  final runAppMatch = runAppPattern.firstMatch(originalContent);

  if (runAppMatch == null) {
    print('❌ Could not find runApp in main.dart. Manual setup required.');
    return;
  }

  // Create new content with MultiProvider
  final newContent =
      '''
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
      child: const MyApp(),
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
    (match) => match.start == 0
        ? match.group(0)!.toLowerCase()
        : '_${match.group(0)!.toLowerCase()}',
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
