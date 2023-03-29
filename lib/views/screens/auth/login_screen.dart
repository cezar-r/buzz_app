import 'package:buzz_app/views/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../widgets/text_input_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              Expanded(
                child: Image.asset(
                  'assets/icon/buzzicon.png',
                  width: 150,
                  height: 150,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.person,
                  )
              ),
              const SizedBox(height: 15,),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.lock,
                    isObscure: true,
                  )
              ),
              const SizedBox(height: 30,),
              Container(
                width: MediaQuery.of(context).size.width-40,
                height: 50,
                decoration: const BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.all(
                      Radius.circular(5)
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    authController.loginUser(
                        _emailController.text,
                        _passwordController.text
                    );
                  },
                  child: const Center(
                    child: Text(
                        'Login',
                        style: TextStyle(
                          color: black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 15,
                      color: white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
                    },
                    child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 15,
                          color: green,
                        )
                    ),
                  ),
                  const Text(
                    " here",
                    style: TextStyle(
                      fontSize: 15,
                      color: white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25,),
            ],
          )
      ),
    );
  }
}
