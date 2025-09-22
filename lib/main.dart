import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'auth_screens.dart';
import 'employee_home_screen.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp(
      title: "Hike Attendance",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthGate(),
    );

    // ✅ On Web: lock the app inside 9:16 aspect ratio (mobile-like)
    if (kIsWeb) {
      app = Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: app,
          ),
        ),
      );
    }

    return app;
  }
}

/// Decides whether to show SignIn/SignUp or the Home screen
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<bool>? _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snap.data == true) {
          return FutureBuilder(
            future: Future.wait([
              ApiService.getEmployeeId(),
              ApiService.getEmployeeName(),
            ]),
            builder: (context, AsyncSnapshot<List<dynamic>> info) {
              if (!info.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final int employeeId = (info.data![0] as int?) ?? 0;
              final String employeeName = (info.data![1] as String?) ?? "Employee";
              return EmployeeHomeScreen(
                employeeId: employeeId,
                employeeName: employeeName,
              );
            },
          );
        } else {
          return const SignInScreen();
        }
      },
    );
  }
}
