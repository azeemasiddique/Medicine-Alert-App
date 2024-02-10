import 'package:flutter/material.dart';
import 'package:medicinealert/Screens/startmed.dart';

class StartUp extends StatelessWidget {
  const StartUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              child: Image(
                image: AssetImage('images/doc.jpg'),
                fit: BoxFit.fill,
              ),
              color: Color(0xff548CA8),
              width: 360,
              height: 495,
            ),
            SizedBox(
              height: 60,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff548CA8),
                  fixedSize: Size(200,60),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GetStarted()));},
                child: Text('GET STARTED',style: TextStyle(color:Colors.white,fontSize: 19,fontWeight: FontWeight.bold))
            ),
          ],
        ),
      ),
    ));
  }
}
