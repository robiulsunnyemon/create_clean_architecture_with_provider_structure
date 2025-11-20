import 'dart:io';

void main() {
  final projectRoot = Directory.current;

  // Check if pubspec.yaml exists (ensure root folder)
  final pubspec = File('${projectRoot.path}/pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('❌ ERROR: pubspec.yaml not found.');
    print('➡️ Run this command from your Flutter project ROOT.');
    exit(1);
  }

  final libDir = Directory('${projectRoot.path}/lib');
  if (!libDir.existsSync()) {
    print('❌ ERROR: lib/ directory not found.');
    exit(1);
  }

  print('🚀 Creating MVVM + Provider folder structure...\n');

  final folders = [
    'lib/src/core',
    'lib/src/core/utils',
    'lib/src/core/constants',
    'lib/src/core/services',

    'lib/src/models',

    'lib/src/viewmodels',

    'lib/src/views',
    'lib/src/views/pages',
    'lib/src/views/widgets',

    'lib/src/providers', // optional
  ];

  for (var path in folders) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('📁 Created: $path');
    }
  }

  // Create template files
  createFile('lib/src/core/constants/app_strings.dart', stringsFile);
  createFile('lib/src/core/constants/app_colors.dart', colorsFile);
  createFile('lib/src/core/services/api_service.dart', apiFile);
  createFile('lib/src/viewmodels/example_viewmodel.dart', viewmodelFile);
  createFile('lib/src/views/pages/example_page.dart', pageFile);
  createFile('lib/src/providers/example_provider.dart', providerFile);

  print('\n✅ MVVM + Provider structure created successfully.');
}

void createFile(String path, String content) {
  final file = File(path);
  if (!file.existsSync()) {
    file.writeAsStringSync(content);
    print('✍️ Created file: $path');
  }
}


// -------- Template Files ----------

String stringsFile = """
class AppStrings {
  static const appName = 'Food Zone App';
}
""";

String colorsFile = """
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Colors.deepOrange;
  static const accent = Colors.orangeAccent;
}
""";

String apiFile = """
class ApiService {
  Future<String> fetchData() async {
    return 'Sample API Result';
  }
}
""";

String viewmodelFile = """
import 'package:flutter/material.dart';
import '../core/services/api_service.dart';

class ExampleViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();

  String data = 'Loading...';

  Future<void> loadData() async {
    data = await apiService.fetchData();
    notifyListeners();
  }
}
""";

String pageFile = """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/example_viewmodel.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExampleViewModel()..loadData(),
      child: Consumer<ExampleViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: Text('Example Page')),
            body: Center(child: Text(vm.data)),
          );
        },
      ),
    );
  }
}
""";

String providerFile = """
import 'package:flutter/material.dart';

class ExampleProvider with ChangeNotifier {
  String text = 'Hello Provider';

  void updateText(String newText) {
    text = newText;
    notifyListeners();
  }
}
""";
