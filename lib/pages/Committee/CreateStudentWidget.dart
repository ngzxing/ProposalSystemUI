// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:proposal_app/data/AcademicProgram.dart';

import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/pages/Login.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:proposal_app/widget/InputWidget.dart';

class CreateStudentWidget extends StatelessWidget {
  Map<String, String> programList = {};
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matricIdController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? programId;
  bool returnToPrevious;
  Future< List<Map<String, dynamic>>> Function() fetchPrograms;

  CreateStudentWidget({
    super.key,
    this.returnToPrevious = true,
    this.fetchPrograms = ApiService.getAllPrograms,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputWidget.buildTextField(
            userNameController, 'User Name', Icons.person, true, ""),
        InputWidget.buildTextField(
            phoneNumberController, 'Phone Number', Icons.phone, true, ""),
        InputWidget.buildTextField(
            emailController, 'Email', Icons.email, true, ""),
        InputWidget.buildTextField(
            matricIdController, 'Matric ID', Icons.school, true, ""),
        InputWidget.buildTextField(
            yearController, 'Year', Icons.calendar_today, true, ""),
        InputWidget.buildTextField(
            sessionController, 'Session', Icons.event, true, ""),
        InputWidget.buildTextField(
            semesterController, 'Semester', Icons.school, true, ""),
        InputWidget.buildTextField(
            passwordController, 'Password', Icons.lock, true, '',
            obscureText: true),
        FutureWidget(
            fetchData: () async {
              var data = await fetchPrograms();

              data.forEach((element) {
                programList[element["id"]] = element["name"];
              });
            },
            widgetBuilder: () => InputWidget.buildStringDropdown(
                (newValue) => programId = newValue,
                "Academic Program",
                Icons.work,
                programList,
                true,
                programList.entries.first.key)),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void add(BuildContext context, void Function() setParentState) async {
    ApiService.register(
            userNameController.text,
            phoneNumberController.text,
            matricIdController.text,
            emailController.text,
            passwordController.text,
            yearController.text,
            sessionController.text,
            semesterController.text,
            programId ?? "")
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Student added successfully'),
        backgroundColor: Colors.green,
      ));
      if (returnToPrevious) {
        Navigator.of(context).pop();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
      setParentState();
    }).catchError((error) {
      // Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add student: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}
