import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';
import 'settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final savedDarkMode = prefs.getBool('dark_mode') ?? false;
  final savedLogin = prefs.getBool('logged_in') ?? false;
  final savedName = prefs.getString('student_name') ?? '';

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppSettings(
        isDarkMode: savedDarkMode,
        loggedIn: savedLogin,
        studentName: savedName,
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

          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),

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

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  bool internetAvailable = true;
  bool isLoading = false;

  List<String> tasks = [];
  List<String> cachedTasks = [];

  final List<String> allTasks = [
    'Maths - Trigonometry - 45 min',
    'Science - Physics - 60 min',
    'English - Grammar - 30 min',
    'Computer - Flutter - 60 min',
    'Gujarati - Reading - 30 min',
    'Social Science - History - 45 min',
  ];

  Future<void> fetchTasks() async {
    if (!internetAvailable) {
      setState(() {
        isLoading = false;

        if (cachedTasks.isNotEmpty) {
          tasks = List.from(cachedTasks);
        } else {
          tasks.clear();
        }
      });

      return;
    }

    setState(() {
      isLoading = true;
      tasks.clear();
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      tasks = List.from(allTasks);
      cachedTasks = List.from(tasks);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi, ${settings.studentName.isEmpty ? 'Student' : settings.studentName}',
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
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

            if (settings.loggedIn) ...[
              SwitchListTile(
                title: const Text('Internet available'),
                value: internetAvailable,
                onChanged: (value) {
                  setState(() {
                    internetAvailable = value;
                    tasks.clear();
                  });
                },
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : fetchTasks,
                  child: const Text('Fetch my tasks'),
                ),
              ),

              const SizedBox(height: 20),

              if (isLoading)
                const CircularProgressIndicator(),

              if (!isLoading &&
                  !internetAvailable &&
                  cachedTasks.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No internet and no saved data',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

              if (!isLoading &&
                  !internetAvailable &&
                  cachedTasks.isNotEmpty &&
                  tasks.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.orange,
                  child: const Text(
                    'Offline: showing last copy',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: buildTaskList(),
                ),
              ],

              if (!isLoading &&
                  internetAvailable &&
                  tasks.isNotEmpty)
                Expanded(
                  child: buildTaskList(),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildTaskList() {
    return ListView.builder(
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
    );
  }
}
