import 'package:flutter/material.dart';
import 'package:track_person/widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(117, 158, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(117, 158, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Track",
                        style: TextStyle(
                          fontSize: 45,
                          color: Color.fromRGBO(236, 222, 222, 1),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Icon(
                        Icons.location_on ,
                        size: 45,
                        color: Color.fromRGBO(197, 41, 41, 0.699),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Center(
                      child: AuthForm()
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  
}