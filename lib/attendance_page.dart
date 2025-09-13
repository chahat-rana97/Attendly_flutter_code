import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  final int employeeId;
  const AttendancePage({super.key, required this.employeeId});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<dynamic> attendanceData = [];
  List<dynamic> filteredData = [];
  String searchQuery = "";
  bool isLoading = true;

  int presentCount = 0;
  int absentCount = 0;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  void _fetchAttendance() async {
    try {
      final data = await ApiService.getHistory(widget.employeeId);
      setState(() {
        attendanceData = data;
        filteredData = data;
        _calculateSummary();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
      setState(() => isLoading = false);
    }
  }

  void _search(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredData = attendanceData.where((row) {
        return row.values
            .any((v) => v.toString().toLowerCase().contains(searchQuery));
      }).toList();
    });
  }

  /// ✅ Format date into "Aug 23, 2025"
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("MMM d, yyyy").format(date);
    } catch (e) {
      return dateStr;
    }
  }

  /// ✅ Format check-in/check-out time
  String formatTime(dynamic timeValue) {
    if (timeValue == null) return "-";
    final timeString = timeValue.toString();
    if (timeString.isEmpty || timeString == "-") return "-";
    return timeString;
  }

  /// ✅ Calculate total hours between check-in and check-out
  String calculateTotalHours(String? checkIn, String? checkOut) {
    if (checkIn == null || checkOut == null) return "-";
    try {
      final format = DateFormat("hh:mm a");
      final inTime = format.parse(checkIn);
      final outTime = format.parse(checkOut);
      final diff = outTime.difference(inTime);
      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);
      return "${hours}h ${minutes}m";
    } catch (e) {
      return "-";
    }
  }

  /// ✅ Calculate summary for top card
  void _calculateSummary() {
    int present = 0;
    int absent = 0;
    Duration total = Duration.zero;

    final format = DateFormat("hh:mm a");

    for (var row in attendanceData) {
      final status = row["status"];
      if (status == "Present") {
        present++;
        try {
          if (row["checkIn"] != null && row["checkOut"] != null) {
            final inTime = format.parse(row["checkIn"]);
            final outTime = format.parse(row["checkOut"]);
            total += outTime.difference(inTime);
          }
        } catch (_) {}
      } else {
        absent++;
      }
    }

    setState(() {
      presentCount = present;
      absentCount = absent;
      totalDuration = total;
    });
  }

  String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // ✅ Summary Card
          Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("$presentCount",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      const Text("Present"),
                    ],
                  ),
                  Column(
                    children: [
                      Text("$absentCount",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      const Text("Absent"),
                    ],
                  ),
                  Column(
                    children: [
                      Text(formatDuration(totalDuration),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                      const Text("Total Hours"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search by date or status",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _search,
            ),
          ),

          // Attendance Cards
          Expanded(
            child: filteredData.isEmpty
                ? const Center(
              child: Text("No attendance records found"),
            )
                : ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final row = filteredData[index];
                final date = formatDate(row["date"]);
                final status = row["status"] ?? "-";
                final checkIn = formatTime(row["checkIn"]);
                final checkOut = formatTime(row["checkOut"]);
                final total = calculateTotalHours(
                    row["checkIn"], row["checkOut"]);

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date + Status
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 18,
                                    color: Colors.blueAccent),
                                const SizedBox(width: 6),
                                Text(
                                  date,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: status == "Present"
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: status == "Present"
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),

                        // Check In / Check Out / Total Hours
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("In",
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold)),
                                Text(checkIn),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Out",
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold)),
                                Text(checkOut),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Total",
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold)),
                                Text(total),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
