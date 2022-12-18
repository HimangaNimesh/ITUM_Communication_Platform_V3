import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:itum_communication_platform/pages/auth/register_page.dart';
import 'package:itum_communication_platform/pages/groups/groups_home_page.dart';
import 'package:itum_communication_platform/service/auth_service.dart';
import 'package:itum_communication_platform/service/database_service.dart';

import '../../helper/helper_function.dart';
import '../../widgets/widegets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Images/Sign in.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(

        backgroundColor: Colors.transparent,
        body: _isLoading ? Center(child: CircularProgressIndicator(),) : Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 400,),
                  const Text('Welcome to the NDTchat',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff4D88EB)),),
                  SizedBox(height: 3,),
                  const Text('Get Connect with you Friends',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff4D88EB)),),
                  SizedBox(height: 15,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "ITUM Email",
                      prefixIcon: const Icon(Icons.mail, color: Color(0xff649EFF),),
                    ),
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ? null: "Please enter a valid email";
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock, color: Color(0xff649EFF),),
                    ),
                    validator: (val){
                      if(val!.length <6){
                        return "Password must be at least 6 charactors";
                      }else{
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: (){
                      login();
                    },
                    child: Text('Log In'),
                  ),
                  const SizedBox(height: 10,),
                  Text.rich(TextSpan(
                      text: "Don't have an account? ",
                      children: <TextSpan>[
                        TextSpan(
                            text: "Register here",
                            style: TextStyle(color: Colors.blueAccent),
                            recognizer: TapGestureRecognizer()..onTap=(){
                              nextScreen(context, RegisterPage());
                            }
                        )
                      ]
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  login() async{
    if (formkey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameandPassword(email, password).then((value) async{
        if(value==true){
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

          nextScreenReplace(context, GroupHome());

        }else{
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading= false;
          });
        }
      });
    }
  }
}


