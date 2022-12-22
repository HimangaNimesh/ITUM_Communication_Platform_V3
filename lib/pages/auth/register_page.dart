import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:itum_communication_platform/helper/helper_function.dart';
import 'package:itum_communication_platform/pages/groups/groups_home_page.dart';
import 'package:itum_communication_platform/service/auth_service.dart';

import '../../widgets/widegets.dart';
import 'Login_Page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String itumMailLast = "@itum.mrt.ac.lk";
  String itumMail = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Images/Sign in.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: _isLoading? Center(child: CircularProgressIndicator(),) :Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 370,),
                  const Text('Create your Acount to Chat and Explore',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff4D88EB)),),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "User Name",
                      prefixIcon: const Icon(Icons.person, color: Color(0xff649EFF),),
                    ),
                    onChanged: (val){
                      setState(() {
                        fullName = val;
                      });
                    },
                    validator: (val){
                      if(val!.isNotEmpty){
                        return null;
                      }else{
                        return "Name cannot be empty";
                      }
                    },
                  ),
                  SizedBox(height: 10,),
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
                      if(val!.contains(itumMailLast)){
                        val = itumMail;
                      }else{
                        return "Please enter ITUM email address";
                      }
                      // return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(itumMail) ? null: "Please enter a valid email";
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
                      register();
                    },
                    child: Text('Register'),
                  ),
                  const SizedBox(height: 10,),
                  Text.rich(TextSpan(
                      text: "Already have an account? ",
                      children: <TextSpan>[
                        TextSpan(
                            text: "Login now",
                            style: TextStyle(color: Colors.blueAccent),
                            recognizer: TapGestureRecognizer()..onTap=(){
                              nextScreen(context, LoginPage());
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
  register()async{
    if (formkey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value) async{
        if(value==true){

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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
