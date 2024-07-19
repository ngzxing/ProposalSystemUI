import 'package:flutter/material.dart';
import 'package:proposal_app/pages/Committee/CreateStudentWidget.dart';
import 'package:proposal_app/pages/Login.dart';
import 'package:proposal_app/widget/Button.dart';


class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ParentRegistrationPage(),
    );
  }
}

class ParentRegistrationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController raceController = TextEditingController();
  final TextEditingController workAddressController = TextEditingController();
  final TextEditingController patnerEmailController = TextEditingController();
  final TextEditingController patnerIdController = TextEditingController();
  final TextEditingController patnerOccupationController =
      TextEditingController();
  final TextEditingController patnerAddressController = TextEditingController();
  final TextEditingController patnerWorkAddressController =
      TextEditingController();
  final TextEditingController patnerPhoneController = TextEditingController();
  final TextEditingController patnerRaceController = TextEditingController();
  final TextEditingController patnerNameController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    CreateStudentWidget registerWidget = CreateStudentWidget(returnToPrevious: false,);

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Student Registration",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      color: Color(0xffffffff),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      registerWidget,
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          text: "Register",
                          color: Colors.blue,
                          onPressed: () => registerWidget.add(context, () { }),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Already have an account?",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xffe2dcdc),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                  );
                                },
                                child: const Text(
                                  "Sign In",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}