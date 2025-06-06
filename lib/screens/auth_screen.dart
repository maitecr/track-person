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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
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
      )
    );
  }
  
}