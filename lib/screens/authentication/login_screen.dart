import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:social_media/colors/app_color.dart';
import 'package:social_media/layout.dart';
import 'package:social_media/screens/authentication/register_screen.dart';
import 'package:social_media/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  bool _showPass = true;

  login() async {
    try {
      String respone = await AuthMethods().signIn(
        email: emailController.text,
        password: passWordController.text,
      );
      if (respone == 'Success') {
        print('Done');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    Center(
                      child: SvgPicture.asset(
                        'assets/svg/n_logo.svg',
                        colorFilter: ColorFilter.mode(
                          kPrimaryColor,
                          BlendMode.srcIn,
                        ),
                        height: 150,
                        width: 150,
                      ),
                    ),

                    const Gap(20),
                    //AppName
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '06',
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          '16',
                          style: TextStyle(
                              fontSize: 35,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    //Email
                    const Text(
                      'To get started, first enters your email and password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const Gap(20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kSocunderyColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        hintText: 'Email  ',
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const Gap(20),
                    //password
                    TextField(
                      controller: passWordController,
                      obscureText: _showPass,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kSocunderyColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: GestureDetector(
                          child: const Icon(Icons.visibility),
                          onTap: () {
                            setState(() {
                              _showPass = !_showPass;
                            });
                          },
                        ),
                      ),
                    ),
                    //login
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: FloatingActionButton(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: kWhiteColor,
                            onPressed: () {
                              login();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LayOutScreen(),
                                  ),
                                  (route) => false);
                              emailController.text = "";
                              passWordController.text = '';
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),

                    //have account
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text(
                        'You don\'t have an account ?',
                      ),
                      const Gap(7),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                              (route) => false);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ]),
                    const Gap(20),
                    // const Row(
                    //   children: [
                    //     Center(
                    //         child: Text(
                    //             '----------------- Or login Options -----------------'))
                    //   ],
                    // )
                  ]),
            ),
          ),
        ));
  }
}
