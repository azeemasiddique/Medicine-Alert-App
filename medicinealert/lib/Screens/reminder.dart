import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/remindermodel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Services/localnotifications.dart';
class Reminder extends StatefulWidget {
  final ReminderData? initialReminder;
  const Reminder({Key? key,this.initialReminder}) : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  List<ReminderData> reminders = [];
  String? _repeatDaily;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController _date = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {

    super.initState();
    LocalNotification.initialize(flutterLocalNotificationsPlugin);
    if (widget.initialReminder != null) {
      _nameController.text = widget.initialReminder!.name;
      _descriptionController.text = widget.initialReminder!.description;
      _titleController.text = widget.initialReminder!.title;
      _selectedDate = widget.initialReminder!.date;
      _selectedTime = widget.initialReminder!.time;
      _repeatDaily = widget.initialReminder!.repeatDaily;
    }

  }



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _date.text = DateFormat('dd-MM-yyyy').format(_selectedDate!);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _time.text = _selectedTime!.format(context);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_selectedDate != null && _selectedTime != null) {
      final reminderData = ReminderData(
        name: _nameController.text,
        description: _descriptionController.text,
        title: _titleController.text,
        date: _selectedDate!,
        time: _selectedTime!,
        repeatDaily: _repeatDaily!,
      );

      reminders.add(reminderData);
      final sharedPrefs = await SharedPreferences.getInstance();
      final remindersJson = sharedPrefs.getStringList('reminders') ?? [];
      remindersJson.add(jsonEncode(reminderData.toJson()));
      sharedPrefs.setStringList('reminders', remindersJson);
      final id = reminders.length - 1;

      if(reminderData.repeatDaily == 'Yes') {
        LocalNotification.setDailyNotification(
          id: id,
          title: reminderData.title,
          body: 'Time to take ${reminderData.name}',
          time: reminderData.time,
          repeatDaily: reminderData.repeatDaily,
          payload: id.toString(), // Convert 'Yes' to true
        );
      }
      // Schedule the notification at the selected date and time
      LocalNotification.scheduleNotification(
        id: id,
        title: reminderData.title,
        body: 'Time to take ${reminderData.name}',
        scheduledDate: _selectedDate!,
        scheduledTime: _selectedTime!,
        repeatDaily: _repeatDaily!,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reminder saved successfully!'),
      ));

      print('successfully saved');
      print('Notification scheduled for ID: $id');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all the fields'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
              Container(
                child: Row(
                  children:[ CircleAvatar(
                    radius: 75,
                    backgroundImage: AssetImage('images/rem.jpg'),
                    //child: Image(image:AssetImage('images/rem.jpg')),
                  ),
                    SizedBox(width: 21,),
                    Text('Set Reminder', style:TextStyle(color:Colors.white,fontSize: 28,fontWeight: FontWeight.bold)),
                  ],
                ),

                color: Color(0xff548CA8),
                height: 270,
                width: 380,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter the description';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter the title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(

                      controller: _date,
                      decoration: InputDecoration(labelText: 'Select Date',
                          suffixIcon: IconButton(onPressed: () {
                            _selectDate(context);
                          }, icon: Icon(Icons.calendar_month),

                          )
                      ),
                      readOnly: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter the title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _time,
                      decoration: InputDecoration(labelText: 'Select time',
                          suffixIcon: IconButton(onPressed: () {
                            _selectTime(context);
                          }, icon: Icon(Icons.access_time),

                          )),
                      readOnly: true, // Prevent manual editing
                      // onTap: () => _selectTime(context),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter the date';
                        }
                        return null;
                      },
                    ),


                    DropdownButtonFormField<String>(
                      value: _repeatDaily,
                      onChanged: (value) {
                        setState(() {
                          _repeatDaily = value!;
                        });
                      },
                      items: ['Yes', 'No']
                          .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      ).toList(),
                      decoration: InputDecoration(labelText: 'Repeat Daily'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select one option';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        await _submitForm();
                        //showNotification(reminders.length - 1);
                      },
                      child: Text('Submit'),
                    ),

                  ],
                ),
              ),
            ])));
  }
}

