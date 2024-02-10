import 'package:flutter/material.dart';
import 'addmedication.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       // backgroundColor: Color(0xffDCE3E8),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(

            child:Column(
              children:[
                SizedBox(height: 80,),
                Center(child: Text('FIRST MEDICATION',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 23),)),
                SizedBox(height: 50,),
                Center(child: Text('Add your first medicine to get a reminder',style: TextStyle(color:Colors.black,fontWeight: FontWeight.normal,fontSize: 17),)),
                Container(
                  height: 400,
                  width: 330,
                  child:Image(image: AssetImage('images/med.png'),),

                ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MedName()));},
                    child: Text('ADD MEDICINE',style: TextStyle(color:Colors.white,fontSize: 17,fontWeight: FontWeight.bold))
                ),
              ),
              ]
            )
          ),
        )
      ),
    );
  }
}
