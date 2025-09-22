import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  /// ⚡ Updated to your live backend URL
  static const String baseUrl = "https://attendance-backend-h8gp.onrender.com";

  // -------------------- AUTH --------------------

  /// Register new employee
  static Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    String department = "IT", // default if not provided
  }) async {
    final url = Uri.parse("$baseUrl/register");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "department": department,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["success"] == true;
    }
    return false;
  }

  /// Login: saves employeeId, name, token if returned
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      if (data["success"] == true && data["user"] != null) {
        final user = data["user"];
        final token = data["token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("employeeId", user["id"]);
        await prefs.setString("employeeName", user["name"]);
        if (token != null) await prefs.setString("token", token);

        return true;
      }
    }

    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("employeeId");
  }

  static Future<int?> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("employeeId");
  }

  static Future<String?> getEmployeeName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("employeeName");
  }

  // -------------------- ATTENDANCE --------------------

  static Future<DateTime?> checkIn(int employeeId) async {
    final url = Uri.parse("$baseUrl/checkin");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"employee_id": employeeId}),
    );
    if (res.statusCode == 200) {
      return DateTime.now();
    }
    return null;
  }

  static Future<DateTime?> checkOut(int employeeId) async {
    final url = Uri.parse("$baseUrl/checkout");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"employee_id": employeeId}),
    );
    if (res.statusCode == 200) {
      return DateTime.now();
    }
    return null;
  }

  /// Fetch attendance history and normalize keys
  static Future<List<Map<String, dynamic>>> getHistory(int employeeId) async {
    final url = Uri.parse("$baseUrl/history/$employeeId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> rawData = jsonDecode(res.body);

      return rawData.map((item) {
        return {
          "date": item["date"] ?? "-",
          "status": item["status"] ?? "-",
          "checkIn": item["checkIn"] ?? "-",
          "checkOut": item["checkOut"] ?? "-",
        };
      }).toList();
    } else {
      throw Exception("Failed to load history: ${res.body}");
    }
  }

  // -------------------- LEAVE REQUEST --------------------

  static Future<bool> requestLeave({
    required int employeeId,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    final url = Uri.parse("$baseUrl/leave-request");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "employee_id": employeeId,
        "start_date": startDate,
        "end_date": endDate,
        "reason": reason,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["success"] == true;
    }
    return false;
  }

  static Future<List<Map<String, dynamic>>> getLeaveRequests(int employeeId) async {
    final url = Uri.parse("$baseUrl/leave-requests/$employeeId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> rawData = jsonDecode(res.body);
      return rawData.map((item) {
        return {
          "id": item["id"],
          "startDate": item["start_date"],
          "endDate": item["end_date"],
          "reason": item["reason"],
          "status": item["status"], // Pending, Approved, Rejected
        };
      }).toList();
    } else {
      throw Exception("Comming soon -- leave requests: ${res.body}");
    }
  }

}


