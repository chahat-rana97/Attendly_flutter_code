import 'dart:async';
import 'package:flutter/material.dart';
import 'attendance_page.dart';
import 'api_service.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final int employeeId;
  final String employeeName;

  const EmployeeHomeScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  String _timeString = "";
  String _dateString = "";
  bool _isCheckedIn = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  double _dailyWorkingHours = 0.0;

  int _daysPresent = 0;
  double _totalHours = 0.0;
  int _pendingLeaveRequests = 0; // later from API

  @override
  void initState() {
    super.initState();
    _fetchUserStats();
    _updateDateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateDateTime());
  }

  Future<void> _fetchUserStats() async {
    try {
      final stats = await ApiService.getHistory(widget.employeeId);
      setState(() {
        _daysPresent = stats.length;
        _totalHours = stats.fold(0.0, (sum, record) {
          if (record["checkIn"] != null && record["checkOut"] != null) {
            DateTime inTime = DateTime.parse(record["checkIn"]);
            DateTime outTime = DateTime.parse(record["checkOut"]);
            return sum + outTime.difference(inTime).inMinutes / 60.0;
          }
          return sum;
        });
      });
    } catch (e) {
      // ignore
    }
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      _timeString =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      _dateString = "${_getWeekday(now.weekday)}, ${_getMonthDayYear(now)}";
    });
  }

  String _getWeekday(int weekday) {
    const days = [
      "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
    ];
    return days[weekday - 1];
  }

  String _getMonthDayYear(DateTime date) {
    const months = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  Future<void> _checkIn() async {
    final checkInTime = await ApiService.checkIn(widget.employeeId);
    if (checkInTime != null) {
      setState(() {
        _isCheckedIn = true;
        _checkInTime = checkInTime;
        _checkOutTime = null; // Reset checkout time on check-in
        _dailyWorkingHours = 0.0; // Reset daily working hours
        _daysPresent++;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("✅ Checked in successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("❌ Check-in failed")));
    }
  }

  Future<void> _checkOut() async {
    final checkOutTime = await ApiService.checkOut(widget.employeeId);
    if (checkOutTime != null && _checkInTime != null) {
      final hoursWorked = checkOutTime.difference(_checkInTime!).inMinutes / 60.0;

      setState(() {
        _isCheckedIn = false;
        _checkOutTime = checkOutTime;
        _dailyWorkingHours = hoursWorked;
        _totalHours += hoursWorked;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("✅ Checked out successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("❌ Check-out failed")));
    }
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700]))
          ],
        ),
      ),
    );
  }

  Widget _attendanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Attendance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _isCheckedIn ? Colors.green[100] : Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isCheckedIn ? "Checked In" : "Not Checked In",
                  style: TextStyle(
                      color: _isCheckedIn ? Colors.green : Colors.orange),
                ),
              ),
              const Spacer(),
              Text(
                _timeString,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isCheckedIn ? null : _checkIn,
                  icon: const Icon(Icons.login),
                  label: const Text("Check In"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isCheckedIn ? _checkOut : null,
                  icon: const Icon(Icons.logout),
                  label: const Text("Check Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _announcementCard() {
    if (_checkInTime == null) {
      return const SizedBox.shrink(); // Don't show if not checked in yet
    }

    return Container(
      width: double.infinity, // 👈 makes it full width
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Colors.blue, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Check-in: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45, // label in black
                  ),
                ),
                TextSpan(
                  text: _checkInTime != null
                      ? "${_checkInTime!.hour.toString().padLeft(2, '0')}:${_checkInTime!.minute.toString().padLeft(2, '0')}"
                      : "-",
                  style: const TextStyle(
                    color: Colors.grey, // time in grey
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          if (_checkOutTime != null)
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Check-out: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  TextSpan(
                    text: "${_checkOutTime!.hour.toString().padLeft(2, '0')}:${_checkOutTime!.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          if (_checkOutTime != null)
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Working Hours: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  TextSpan(
                    text: "${_dailyWorkingHours.toStringAsFixed(1)} hours",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),

    );
  }


  Future<void> _logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Dashboard Overview",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Center(
            child: Text(widget.employeeName,
                style: const TextStyle(color: Colors.black, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.blue),
            label: const Text("Logout", style: TextStyle(color: Colors.blue)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "AttendanceHub",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.blue),
              title: const Text("Overview", style: TextStyle(fontSize: 16)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.blue),
              title: const Text("Attendance", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AttendancePage(employeeId: widget.employeeId),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_available, color: Colors.blue),
              title: const Text("Leave Requests", style: TextStyle(fontSize: 16)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date and Time Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dateString,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(_timeString,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            // Stats Row
            Row(
              children: [
                _statCard("Days Present This Month", "$_daysPresent",
                    Icons.calendar_today, Colors.purple),
                const SizedBox(width: 12),
                _statCard("Total Hours This Month",
                    _totalHours.toStringAsFixed(1), Icons.access_time,
                    Colors.purple),
                const SizedBox(width: 12),
                _statCard("Pending Leave Requests",
                    "$_pendingLeaveRequests", Icons.event_available,
                    Colors.purple),
              ],
            ),
            const SizedBox(height: 16),
            // Today's Attendance Section
            _attendanceCard(),
            // Separated Announcement Card
            _announcementCard(),
          ],
        ),
      ),
    );
  }
}


