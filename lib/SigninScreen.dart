import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:opportune_mobile_app/SignupWidget.dart';
import 'package:opportune_mobile_app/customShape.dart';


class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late BuildContext scaffoldContext;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Get the user type from Firestore
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      String userType = userDoc['type'];

      // Navigate based on user type
      if (userType == 'job_seeker') {
        Navigator.of(scaffoldContext).pushReplacementNamed('/home');
      } else if (userType == 'hr_representative') {
        Navigator.of(scaffoldContext).pushReplacementNamed('/company_home');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Wrong password or user mail during sign in.';
      }

      // Show custom error message using Flushbar
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(


        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 110,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo[700],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome to Oppor\'tune!',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
              Image.asset(
                'assets/Asset1.png',
                width: 120,
                height: 120,
              ),
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
              SizedBox(height: 10),
              TextFieldContainer(
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.mail,
                      color: Colors.indigo[700],
                    ),
                    hintText: 'John.jone@gmail.com',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFieldContainer(
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.indigo[700],
                    ),
                    hintText: 'At least 6 characters',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      border: Border.all(
                        width: 0.5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Remember Me',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      // Handle "Forget Password" action here
                    },
                    child: Text(
                      'Forget Password',
                      style: TextStyle(
                        color: Colors.indigo[700],
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[700],
                  minimumSize: Size(500, 45),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle sign in with Google action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[200],
                  minimumSize: Size(500, 45),
                ),
                child: Text(
                  'Sign In With Google',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to Opportune? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.indigo[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      // Navigate to SignUpPage on "Sign Up" click
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupWidget()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple[300],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x3f000000),
            offset: Offset(0, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}
