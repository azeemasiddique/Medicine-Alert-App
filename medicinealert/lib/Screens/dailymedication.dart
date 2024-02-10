import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicinealert/Screens/timelymedication.dart';
import '../Services/localnotifications.dart';
import 'home.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DailyMedication extends StatefulWidget {
  final String? name;
  final String? description;
  final String? title;


  const DailyMedication({Key? key, required this.name, required this.description, required this.title}) : super(key: key);

  @override
  State<DailyMedication> createState() => _DailyMedicationState();
}

class _DailyMedicationState extends State<DailyMedication> {
  late  String? repeatDaily;
  final _formkey = GlobalKey<FormState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    LocalNotification.initialize(flutterLocalNotificationsPlugin);
  }


  Future<void> _scheduleDailyReminder() async {
    const int notificationId = 1; // Unique ID for the notification

    final TimeOfDay notificationTime = TimeOfDay(hour: 8, minute: 0); // Replace with the desired time

    final DateTime now = DateTime.now();
    final DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    ).add(Duration(days: 1));

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'ReminderApp',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    final DarwinNotificationDetails iosPlatformChannelSpecifics =
    DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Take your medication', // Notification title
      'It\'s time to take your medication!', // Notification body
      tz.TZDateTime.from(scheduledDate, tz.local), // Schedule time in your local timezone
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ReminderApp',
          'channel_name',// Change this to your channel name
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
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
                'Do you need to take this medicine every day?',
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
                          _scheduleDailyReminder(); // Call the function to schedule the reminder
                        },
                        child: Text('Yes',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.normal
                          ),
                        ),
                      ),

                      // ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       elevation: 4.0,
              //       backgroundColor: Colors.white,
              //       fixedSize: Size(125, 50),
              //     ),
              //     onPressed: () {
              //
              //     },
              //     child: Text('Yes',
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

                      },
                      child: Text('No',
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
