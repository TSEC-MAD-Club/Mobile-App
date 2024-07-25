import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class MaintainanceScreen extends StatefulWidget {

  @override
  State<MaintainanceScreen> createState() => _MaintainanceScreenState();
}

class _MaintainanceScreenState extends State<MaintainanceScreen> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              height: size.height*0.3,
              width:size.width*0.8,
              child: Lottie.asset("assets/animation/maintainance.json",fit: BoxFit.fill),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(text:"Sorry App Under Maintainance ",style: TextStyle(color: Colors.white),),
                WidgetSpan(child: Icon(Icons.warning,color: Colors.yellow,),),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
