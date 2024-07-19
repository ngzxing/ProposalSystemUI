import 'package:flutter/material.dart';
import 'package:proposal_app/data/Student.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:proposal_app/widget/InputWidget.dart';

// ignore: must_be_immutable
class StudentDetailPage extends StatefulWidget {
  final String studentId;
  GlobalKey<State> parentKey;

  StudentDetailPage(
      {super.key, required this.studentId, required this.parentKey});

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  late Future<dynamic> studentFuture;
  late Map<String, dynamic> student;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matricIdController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController supervisorIdController = TextEditingController();
  final TextEditingController supervisorNameController =
      TextEditingController();
  final TextEditingController firstEvaluatorIdController =
      TextEditingController();
  final TextEditingController firstEvaluatorNameController =
      TextEditingController();
  final TextEditingController secondEvaluatorIdController =
      TextEditingController();
  final TextEditingController secondEvaluatorNameController =
      TextEditingController();

  final TextEditingController _programController = TextEditingController();

  @override
  void initState() {
    super.initState();
    studentFuture = fetchStudentDetails();
  }

  Future fetchStudentDetails() async {
    // Replace with your API call to fetch a specific student's details
    student = await Student.getSpecificStudent(widget.studentId);

    if (student["supervisorId"] == null) {
      student["supervisorId"] = "Not Selected Yet";
      student["supervisorName"] = "Not Selected Yet";
    }

    if (student["firstEvaluatorId"] == null) {
      student["firstEvaluatorId"] = "Not Selected Yet";
      student["firstEvaluatorName"] = "Not Selected Yet";
    }

    if (student["secondEvaluatorId"] == null) {
      student["secondEvaluatorId"] = "Not Selected Yet";
      student["secondEvaluatorName"] = "Not Selected Yet";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Detail")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FutureWidget(
          fetchData: fetchStudentDetails,
          widgetBuilder: () {
            return SingleChildScrollView(
              child: Column(
                children: [
                  InputWidget.buildTextField(userNameController, 'User Name',
                      Icons.person, false, student['userName']),
                  InputWidget.buildTextField(
                      phoneNumberController,
                      'Phone Number',
                      Icons.phone,
                      false,
                      student['phoneNumber']),
                  InputWidget.buildTextField(emailController, 'Email',
                      Icons.email, false, student['email']),
                  InputWidget.buildTextField(matricIdController, 'Matric ID',
                      Icons.school, false, student['matricId']),
                  InputWidget.buildTextField(
                      _programController,
                      'Program',
                      Icons.schedule,
                      false,
                      student['academicProgramName'] ?? ''),
                  InputWidget.buildTextField(yearController, 'Year',
                      Icons.calendar_today, false, student['year'].toString()),
                  InputWidget.buildTextField(sessionController, 'Session',
                      Icons.event, false, student['session'].toString()),
                  InputWidget.buildTextField(semesterController, 'Semester',
                      Icons.school, false, student['semester'].toString()),
                  InputWidget.buildTextField(
                      supervisorIdController,
                      'Supervisor ID',
                      Icons.person,
                      false,
                      student['supervisorId']),
                  InputWidget.buildTextField(
                      supervisorNameController,
                      'Supervisor Name',
                      Icons.person,
                      false,
                      student['supervisorName']),
                  InputWidget.buildTextField(
                      firstEvaluatorIdController,
                      'First Evaluator ID',
                      Icons.person,
                      false,
                      student['firstEvaluatorId']),
                  InputWidget.buildTextField(
                      firstEvaluatorNameController,
                      'First Evaluator Name',
                      Icons.person,
                      false,
                      student['firstEvaluatorName']),
                  InputWidget.buildTextField(
                      secondEvaluatorIdController,
                      'Second Evaluator ID',
                      Icons.person,
                      false,
                      student['secondEvaluatorId']),
                  InputWidget.buildTextField(
                      secondEvaluatorNameController,
                      'Second Evaluator Name',
                      Icons.person,
                      false,
                      student['secondEvaluatorName']),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
