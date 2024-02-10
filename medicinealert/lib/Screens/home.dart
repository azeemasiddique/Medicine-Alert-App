import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medicinealert/Screens/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/remindermodel.dart';
import '../Services/localnotifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _pages = [
    AddedMedicine(),
    MedList(),
    Reminder(),
  ];
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Medication',
      style: optionStyle,
    ),
    Text(
      'Index 2: Reminder',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xff548CA8)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_rounded, color: Color(0xff548CA8)),
            label: 'Medication',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert_sharp, color: Color(0xff548CA8)),
            label: 'Reminder',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff548CA8),
        onTap: _onItemTapped,
      ),
    );
  }
}

class MedList extends StatefulWidget {
  const MedList({Key? key}) : super(key: key);

  @override
  State<MedList> createState() => _MedListState();
}

class _MedListState extends State<MedList> {
  Future<List<ReminderData>> getSavedReminderDataList() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    final jsonStringList = sharedPrefs.getStringList('reminders');
    print(jsonStringList);
    if (jsonStringList != null) {
      final reminderDataList = jsonStringList
          .map((jsonString) => ReminderData.fromJson(jsonDecode(jsonString)))
          .toList();
      print(reminderDataList);
      return reminderDataList;
    } else {
      return [];
    }
  }

  Widget buidCards(ReminderData reminderData, int index) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(reminderData.title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: AssetImage('images/rem.jpg'),
                  ),
                  SizedBox(
                    width: 21,
                  ),
                  Text('Reminders',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              color: Color(0xff548CA8),
              height: 270,
              width: 380,
            ),
            SizedBox(
              height: 18,
            ),

            FutureBuilder<List<ReminderData>>(
              future: getSavedReminderDataList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final reminderDataList = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reminderDataList.length,
                    itemBuilder: (context, index) {
                      final reminderData = reminderDataList[index];
                      return buidCards(reminderData, index);
                    },
                  );
                } else {
                  return Text('No saved reminder data');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddedMedicine extends StatefulWidget {
  const AddedMedicine({Key? key}) : super(key: key);

  @override
  State<AddedMedicine> createState() => _AddedMedicineState();
}

class _AddedMedicineState extends State<AddedMedicine> {
  @override
  void initState() {
    super.initState();
    FlutterLocalNotificationsPlugin().initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) async {
        await handleNotificationAction(response.payload!);
      },
    );
  }

  Future<void> handleNotificationAction(String payload) async {
    if (payload != null) {
      int reminderIndex = int.parse(payload);
      final reminderDataList = await getSavedReminderDataList();
      if (reminderIndex >= 0 && reminderIndex < reminderDataList.length) {
        final reminderData = reminderDataList[reminderIndex];
        _showNotificationAlert(context, reminderData, reminderIndex);
      }
    }
  }

  Future<void> _showNotificationAlert(
      BuildContext context, ReminderData reminderData, int index) async {
    print('Showing alert for reminder at index $index');
    print('Reminder data: $reminderData');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reminder'),
        content: Text('Time to take ${reminderData.name}'),
        actions: [
          TextButton(
            onPressed: () async {
              // Remove the reminder from the list and cancel the notification
               _removeReminder(index);
              //_removeReminders(reminderData,index);
              Navigator.pop(context); // Close the alert dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Future<List<ReminderData>> getSavedReminderDataList() async {
  //   final sharedPrefs = await SharedPreferences.getInstance();
  //
  //   final jsonStringList = sharedPrefs.getStringList('reminders');
  //   print(jsonStringList);
  //   if (jsonStringList != null) {
  //     final jsonDataList = jsonStringList.map((jsonString) => jsonDecode(jsonString)).toList();
  //     final reminderDataList = jsonDataList.map((jsonData) => ReminderData.fromJson(jsonData)).toList();
  //     print(reminderDataList);
  //     return reminderDataList;
  //   } else {
  //     return [];
  //   }
  // }

  Future<List<ReminderData>> getSavedReminderDataList() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    final jsonStringList = sharedPrefs.getStringList('reminders');
    print(jsonStringList);
    if (jsonStringList != null) {
      final reminderDataList = jsonStringList
          .map((jsonString) => ReminderData.fromJson(jsonDecode(jsonString)))
          .toList();
      print(reminderDataList);
      return reminderDataList;
    } else {
      return [];
    }
  }

  void _removeReminder(int index) async {
    // Remove the reminder from the list
    final sharedPrefs = await SharedPreferences.getInstance();
    final jsonStringList = sharedPrefs.getStringList('reminders');
    jsonStringList?.removeAt(index);
    sharedPrefs.setStringList('reminders', jsonStringList!);

    // Cancel the corresponding notification
    LocalNotification.flutterLocalNotificationsPlugin.cancel(index);
    setState(() {}); // Refresh the UI
  }

  void _removeReminders(ReminderData reminderData,int index) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final jsonStringList = sharedPrefs.getStringList('reminders');
    final removedReminderJson = jsonStringList?.removeAt(index);

    if (removedReminderJson != null) {

      // Calculate the new scheduled date for the next day
      DateTime nextDay = DateTime.now().add(Duration(days: 1));
      DateTime newScheduledDate = DateTime(
        nextDay.year,
        nextDay.month,
        nextDay.day,
        reminderData.time.hour,
        reminderData.time.minute,
      );
      reminderData.date = newScheduledDate;
      jsonStringList?.add(jsonEncode(reminderData.toJson()));
      sharedPrefs.setStringList('reminders', jsonStringList!);
      print('savedd!!');
      LocalNotification.flutterLocalNotificationsPlugin.cancel(index);
      LocalNotification.scheduleNotification(
        id: index,
        title: reminderData.title,
        body: 'Time to take your medicine',
        scheduledDate: reminderData.date,
        scheduledTime: TimeOfDay.fromDateTime(reminderData.date),
        repeatDaily: 'Yes',
      );
      setState(() {}); // Refresh the UI
    }
  }

  void _navigateToReminderPage(ReminderData reminderData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Reminder(
          initialReminder: reminderData,
        ),
      ),
    );
  }

  Widget _buildReminderCard(ReminderData reminderData, int index) {
    return GestureDetector(
      onTap: () {
        _navigateToReminderPage(reminderData);
        // handleNotificationAction(index.toString());
      },
      child: Card(
        child: ListTile(
          title: Text(reminderData.title),
          subtitle: Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(reminderData.date)}\n'
              'Time: ${reminderData.time.format(context)}'),
          trailing: GestureDetector(
            onTap: () {
              _removeReminder(index);
            },
            child: Icon(Icons.delete),
          ),
          // trailing: Text(reminderData.name),
        ),
      ),
    );
  }

  DateTime _convertToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: AssetImage('images/rem.jpg'),
                  ),
                  SizedBox(
                    width: 21,
                  ),
                  Text('Set Reminder',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              color: Color(0xff548CA8),
              height: 270,
              width: 380,
            ),
            /*FutureBuilder<List<ReminderData>>(
              future: getSavedReminderDataList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  List<ReminderData> reminderDataList = snapshot.data!;

                  // Sort the reminderDataList based on the selected time
                  reminderDataList.sort((a, b) => _convertToDateTime(a.time).compareTo(_convertToDateTime(b.time)));

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reminderDataList.length,
                    itemBuilder: (context, index) {
                      final reminderData = reminderDataList[index];
                      return _buildReminderCard(reminderData, index);
                    },
                  );
                } else {
                  return Text('No saved reminder data');
                }
              },
            ),*/

            FutureBuilder<List<ReminderData>>(
              future: getSavedReminderDataList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final reminderDataList = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reminderDataList.length,
                    itemBuilder: (context, index) {
                      final reminderData = reminderDataList[index];
                      return _buildReminderCard(reminderData, index);
                    },
                  );
                } else {
                  return Text('No saved reminder data');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
