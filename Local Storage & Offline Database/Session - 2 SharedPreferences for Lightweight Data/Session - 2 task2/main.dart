import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';
import 'settings_screen.dart';

Future<void> main() async {

  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Load saved dark mode
  final savedDarkMode =
      prefs.getBool('dark_mode') ?? false;

  // Load saved login status
  final savedLogin =
      prefs.getBool('logged_in') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppSettings(
        isDarkMode: savedDarkMode,
        loggedIn: savedLogin,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<AppSettings>(
      builder: (context, settings, child) {

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Light Theme
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),

          // Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.black,
          ),

          // Theme Mode
          themeMode: settings.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          home: const StudyPlannerScreen(),
        );
      },
    );
  }
}

class StudyPlannerScreen extends StatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  State<StudyPlannerScreen> createState() =>
      _StudyPlannerScreenState();
}

class _StudyPlannerScreenState
    extends State<StudyPlannerScreen> {

  bool internetAvailable = true;
  bool isLoading = false;

  List<String> tasks = [];

  // Temporary cache
  List<String> _cachedTasks = [];

  // Hard-coded tasks
  final List<String> allTasks = [
    'Maths - Trigonometry - 45 min',
    'Science - Physics - 60 min',
    'English - Grammar - 30 min',
    'Computer - Flutter - 60 min',
    'Gujarati - Reading - 30 min',
    'Social Science - History - 45 min',
  ];

  // Fetch tasks
  Future<void> fetchTasks() async {

    // Internet OFF
    if (!internetAvailable) {

      setState(() {
        isLoading = false;

        if (_cachedTasks.isNotEmpty) {
          tasks = List.from(_cachedTasks);
        } else {
          tasks.clear();
        }
      });

      return;
    }

    // Internet ON
    setState(() {
      isLoading = true;
      tasks.clear();
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      tasks = List.from(allTasks);

      // Store tasks in memory
      _cachedTasks = List.from(tasks);

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Read login status using Provider
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Planner'),
        centerTitle: true,

        actions: [

          // Settings Icon
          IconButton(
            icon: const Icon(Icons.settings),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // Logged Out
            if (!settings.loggedIn)
              const Expanded(
                child: Center(
                  child: Text(
                    'Please log in',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Logged In
            if (settings.loggedIn) ...[

              // Internet Switch
              SwitchListTile(
                title: const Text(
                  'Internet available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                value: internetAvailable,

                onChanged: (value) {
                  setState(() {
                    internetAvailable = value;
                    tasks.clear();
                  });
                },
              ),

              const SizedBox(height: 15),

              // Fetch Button
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: isLoading ? null : fetchTasks,

                  child: const Text(
                    'Fetch my tasks',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Loading Indicator
              if (isLoading)
                const CircularProgressIndicator(),

              // Offline Cached Tasks
              if (!internetAvailable &&
                  !isLoading &&
                  _cachedTasks.isNotEmpty) ...[

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: const Text(
                    'Offline: showing last copy',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,

                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.task_alt,
                            color: Colors.green,
                          ),
                          title: Text(tasks[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],

              // No Cached Tasks
              if (!internetAvailable &&
                  !isLoading &&
                  _cachedTasks.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No internet and no saved data',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              // Online Tasks
              if (internetAvailable &&
                  !isLoading &&
                  tasks.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,

                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.task_alt,
                            color: Colors.green,
                          ),
                          title: Text(tasks[index]),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
