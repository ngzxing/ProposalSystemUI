// Packages
import 'package:flutter/material.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/pages/RegisterPage.dart';
import 'package:proposal_app/pages/Admin/SidebarWithPages.dart' as AdminPage;
import 'package:proposal_app/pages/Committee/SidebarWithPages.dart'
    as CommitteePage;
import 'package:proposal_app/pages/Student/SidebarWithPages.dart'
    as StudentPage;
import 'package:proposal_app/widget/Button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<Login> {
  late double _deviceHeight;
  late double _deviceWidth;

  String? _id;
  String? _password;

  TextEditingController idController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/proposal_logo.png'),
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: _deviceWidth * 0.6,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 16),
                        child: TextFormField(
                          controller: idController,
                          onSaved: (_value) {
                            setState(() {
                              _id = _value;
                            });
                          },
                          obscureText: false,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: const BorderSide(
                                color: Color(0xff3a57e8),
                                width: 2,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: const BorderSide(
                                color: Color(0xff3a57e8),
                                width: 2,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: const BorderSide(
                                color: Color(0xff3a57e8),
                                width: 2,
                              ),
                            ),
                            labelText: "User Id",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            hintText: "Enter Text",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff3a57e8),
                            ),
                            filled: true,
                            fillColor: const Color(0x00ffffff),
                            isDense: false,
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        onSaved: (_value) {
                          setState(() {
                            _password = _value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        obscureText: true,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          disabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xff3a57e8),
                              width: 2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xff3a57e8),
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xff3a57e8),
                              width: 2,
                            ),
                          ),
                          labelText: "PASSWORD",
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          hintText: "Enter Text",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff3a57e8),
                          ),
                          filled: true,
                          fillColor: const Color(0x00ffffff),
                          isDense: false,
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: _deviceWidth * 0.6,
                  height: _deviceHeight * 0.05,
                ),
                SizedBox(
                  width: _deviceWidth * 0.6,
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          try {
                            await ApiService.login(
                                idController.text, passwordController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => returnPageByRole()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Login Success"),
                                    backgroundColor: Colors.green));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Login Failed"),
                                    backgroundColor: Colors.red));
                          }
                        },
                        color: const Color(0xff3a57e8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        padding: const EdgeInsets.all(16),
                        textColor: Colors.white,
                        height: 45,
                        minWidth: MediaQuery.of(context).size.width,
                        child: const Text(
                          "SIGN IN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),

                      SizedBox(
                        width: _deviceWidth * 0.6,
                        height: _deviceHeight * 0.01,
                      ),
                      // New Register Now Button
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                          side: const BorderSide(color: Colors.white, width: 0),
                        ),
                        padding: const EdgeInsets.all(16),
                        textColor: const Color(0xff3a57e8),
                        height: 45,
                        minWidth: MediaQuery.of(context).size.width,
                        child: const Text(
                          "REGISTER NOW",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: _deviceWidth * 0.6,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ForgotPass()),
                          // );
                        },
                        child: const Text(
                          "Forgot Password ?",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff3a57e8),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget returnPageByRole() {
    if (ApiService.role == "Admin") {
      return AdminPage.SidebarWithPages();
    }

    if (ApiService.role == "Student") {
      return StudentPage.SidebarWithPages();
    }

    if (ApiService.role == "Lecturer") {
      return CommitteePage.SidebarWithPages();
    }

    return Scaffold(
        body: Center(
            child: Column(
      children: [
        const Text("Wrong role, Please Refresh"),
        Button(
            text: "Refresh",
            onPressed: () => setState(() {}),
            color: Colors.blue)
      ],
    )));
  }
}
