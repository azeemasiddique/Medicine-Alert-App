import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/remindermodel.dart';
import '../Services/localnotifications.dart';
import 'home.dart';
import 'package:timezone/timezone.dart' as tz;


class TimelyMedication extends StatefulWidget {
  final String? name;
  final String? description;
  final String? title;
  final String? repeatDaily;

  const TimelyMedication({Key? key, this.name, this.description, this.title, this.repeatDaily}) : super(key: key);

  @override
  State<TimelyMedication> createState() => _TimelyMedicationState();
}


class _TimelyMedicationState extends State<TimelyMedication> {
  List<ReminderData> reminders = [];

  TextEditingController name = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    LocalNotification.initialize(flutterLocalNotificationsPlugin);
  }

  Future<void> saveReminderData(TimeOfDay selectedTime) async {
    final prefs = await SharedPreferences.getInstance();

    final newReminder = ReminderData(
      name: widget.name ?? '',
      description: widget.description ?? '',
      title: widget.title ?? '',
      repeatDaily: widget.repeatDaily ?? '',
      date: DateTime.now(), // Set the appropriate date based on your logic
      time: selectedTime,   // Set the selected time
    );

    // Add the new reminder to the list
    reminders.add(newReminder);

    // Save the updated list of reminders to shared preferences
    final remindersJson = reminders.map((reminder) => reminder.toJson()).toList();
    prefs.setString('reminder', jsonEncode(remindersJson));
    print('successfully saved');
    print(reminders);
  }


  void _scheduleDailyReminder(TimeOfDay time) async {
    final now = DateTime.now();
    final selectedTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (selectedTime.isBefore(now)) {
      selectedTime.add(Duration(days: 1));
    }

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'ReminderApp',
      'channel_name',
      importance: Importance.high,
    );
    final iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Medication Reminder', // Title
      'Remember to take your medication', // Body
      tz.TZDateTime.from(selectedTime, tz.local), // Trigger time in local timezone
      platformChannelSpecifics,
      payload: 'daily_medicine', // Optional payload
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formkey,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(9.0),
            child: SingleChildScrollView(
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 11,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomePage()));
                            // LocalNotification.showBigTextNotification(title: 'Message title', body: 'body', fln: flutterLocalNotificationsPlugin);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                    color: Color(0xff548CA8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                        Center(
                            child: Text(
                              'Add MEDICATION',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                            child: Text(
                              'At what time of day do you take your dose?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17),
                            )),
                        SizedBox(
                          height:  40,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4.0,
                            backgroundColor: Colors.white,
                            fixedSize: Size(125, 50),
                          ),
                          onPressed: () {
                            _scheduleDailyReminder(TimeOfDay(hour: 8, minute: 0));
                            saveReminderData(TimeOfDay(hour: 8, minute: 0));// Set morning time
                          },
                          child: Text('Morning',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal)),
                        ),
// ... Repeat for Noon, Evening, and Night buttons

                        // ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       elevation: 4.0,
                        //       backgroundColor: Colors.white,
                        //       fixedSize: Size(125, 50),
                        //     ),
                        //     onPressed: () {
                        //
                        //     },
                        //     child: Text('Morning',
                        //         style: TextStyle(
                        //             color: Colors.black,
                        //             fontSize: 17,
                        //             fontWeight: FontWeight.normal))),
                        SizedBox(
                          height: 18,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor: Colors.white,
                              fixedSize: Size(125, 50),
                            ),
                            onPressed: () {
                              _scheduleDailyReminder(TimeOfDay(hour: 12, minute: 0));
                              saveReminderData(TimeOfDay(hour: 12, minute: 0));// Set morning time
                            },
                            child: Text('Noon',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal))),
                        SizedBox(
                          height:  18,
                        ),

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 4.0,
                              backgroundColor: Colors.white,
                              fixedSize: Size(125, 50),
                            ),
                            onPressed: () {
                              _scheduleDailyReminder(TimeOfDay(hour: 15, minute: 0));
                              saveReminderData(TimeOfDay(hour: 15, minute: 0));// Set morning time
                            },
                            child: Text('Evening',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal))),
                        SizedBox(
                          height: 18,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor: Colors.white,
                              fixedSize: Size(125, 50),
                            ),
                            onPressed: () {
                              _scheduleDailyReminder(TimeOfDay(hour: 19, minute: 0));
                              saveReminderData(TimeOfDay(hour: 19, minute: 0));// Set morning time
                            },
                            child: Text('Night',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal))),
                      ])),

            ),
          ),
          bottomNavigationBar:  Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  // top:Radius.circular(20),
                  bottom: Radius.circular(40),
                ),
                color: Color(0xff548CA8)),
            height: 100,
            width: 360,

            child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff548CA8),
                  fixedSize: Size(70,10),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(200),
                  // ),
                  //   side: const BorderSide(
                  //     width: 2.0,
                  //     color: Colors.white,
                  //   )
                ),
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => TimelyMedication()));},
                child: Text('Next',style: TextStyle(color:Colors.white,fontSize: 17,fontWeight: FontWeight.bold))
            ),
          ),
        ),
      ),
    );
  }
}
