import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:social_media/colors/app_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:social_media/screens/authentication/login_screen.dart';
import 'package:social_media/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  bool _showPassRegister = true;

  register() async {
    try {
      String respons = await AuthMethods().signUp(
        email: emailController.text,
        password: passWordController.text,
        userName: userNameController.text,
        displayName: displayNameController.text,
      );
      if (respons == "Success") {
      } else {
        print(respons);
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
                    const Gap(20),
                    Text(
                      'Creat your account',
                      style: TextStyle(
                          fontSize: 35,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    //Email

                    const Gap(20),
                    TextField(
                      controller: displayNameController,
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
                        hintText: 'display Name  ',
                        prefixIcon: const Icon(Icons.person_outlined),
                      ),
                    ),
                    const Gap(20),

                    TextField(
                      controller: userNameController,
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
                        hintText: 'username',
                        prefixIcon: const Icon(LineIcons.at),
                      ),
                    ),
                    const Gap(20),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
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
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.mail_outlined),
                      ),
                    ),
                    const Gap(20),
                    //password
                    TextField(
                      controller: passWordController,
                      obscureText: _showPassRegister,
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
                          prefixIcon: const Icon(LineIcons.key),
                          suffixIcon: GestureDetector(
                            child: const Icon(LineIcons.eye),
                            onTap: () {
                              setState(() {
                                _showPassRegister = !_showPassRegister;
                              });
                            },
                          )),
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
                              register();
                              displayNameController.text = '';
                              userNameController.text = '';
                              emailController.text = '';
                              passWordController.text = '';
                            },
                            child: const Text(
                              'Register',
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
                        ' Already have an account?',
                      ),
                      const Gap(7),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false);
                        },
                        child: const Text(
                          'Login',
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
