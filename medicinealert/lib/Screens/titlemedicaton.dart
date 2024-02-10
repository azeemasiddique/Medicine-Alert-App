import 'package:flutter/material.dart';
import 'package:medicinealert/Screens/reminder.dart';
import 'dailymedication.dart';
import 'home.dart';

class TitleMedication extends StatefulWidget {
  TitleMedication({Key? key, required this.description,required this.name}) : super(key: key);
  String? description;
  String? name;

  @override
  State<TitleMedication> createState() => _TitleMedicationState();
}

class _TitleMedicationState extends State<TitleMedication> {

  TextEditingController title = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formkey,
        child: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(

                    child:Column(
                        children:[
                          SizedBox(height: 11,),
                          GestureDetector(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                              // LocalNotification.showBigTextNotification(title: 'Message title', body: 'body', fln: flutterLocalNotificationsPlugin);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Skip',
                                  style: TextStyle(color: Color(0xff548CA8),fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 60),

                          Center(child: Text('Add MEDICATION',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 23),)),
                          SizedBox(height: 50,),
                          Center(child: Text('What\'s the reason ?',style: TextStyle(color:Colors.black,fontWeight: FontWeight.normal,fontSize: 17),)),
                          SizedBox(height: 15,),
                          TextFormField(
                              controller: title,
                              decoration: InputDecoration(
                                labelText: 'Title',
                              ),
                              validator:(value){
                                if(value?.isEmpty ?? true){
                                  return 'Please enter the  title';
                                }
                                return null;
                              }
                          ),
                          SizedBox(height: 30,),
                          Container(
                            color: Colors.black,
                            height: 270,
                            width: 330,
                            child:Image(image: AssetImage('images/med2.jpg'),fit:BoxFit.fill),

                          ),
                          SizedBox(height: 20,),
                          Container(
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

                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => DailyMedication(name:widget.name,description:widget.description,title: title.text,)));
                                  },
                                child: Text('Next',style: TextStyle(color:Colors.white,fontSize: 17,fontWeight: FontWeight.bold))
                            ),
                          ),
                        ]
                    )
                ),
              ),
            ),

        ),

      ),
    );

  }
}

