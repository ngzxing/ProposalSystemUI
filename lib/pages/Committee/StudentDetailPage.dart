import 'package:flutter/material.dart';
import 'package:proposal_app/data/Student.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';
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
  bool isEditing = false;
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

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> saveChanges() async {
    // Call the API to save changes

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text('Are you sure you want to update this student?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        Student.updateStudent(matricIdController.text, userNameController.text,
                phoneNumberController.text, emailController.text)
            .then((_) {
          setState(() => isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Student updated successfully'),
              backgroundColor: Colors.green));
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to update lecturer: $error'),
            backgroundColor: Colors.red,
          ));
        });
      }
    });
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
    });
  }

  Future<void> deleteStudent() async {
    // Call the API to delete the student
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text('Are you sure you want to delete this student?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        Student.deleteStudent(widget.studentId).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Student deleted successfully'),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
          widget.parentKey.currentState!.setState(() {});
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to delete lecturer: $error'),
            backgroundColor: Colors.red,
          ));
        });
      }
    });
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
                      Icons.person, isEditing, student['userName']),
                  InputWidget.buildTextField(
                      phoneNumberController,
                      'Phone Number',
                      Icons.phone,
                      isEditing,
                      student['phoneNumber']),
                  InputWidget.buildTextField(emailController, 'Email',
                      Icons.email, isEditing, student['email']),
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
                  if (isEditing)
                    Button(
                      onPressed: saveChanges,
                      text: 'Save',
                      color: Colors.green,
                    ),
                  if (isEditing) const SizedBox(height: 10),
                  if (isEditing)
                    Button(
                      onPressed: cancelEdit,
                      text: 'Cancel',
                      color: Colors.grey,
                    ),
                  if (isEditing) const SizedBox(height: 10),
                  if (!isEditing)
                    Button(
                      onPressed: toggleEdit,
                      text: 'Edit',
                      color: Colors.blue,
                    ),
                  if (!isEditing) const SizedBox(height: 10),
                  Button(
                    onPressed: deleteStudent,
                    text: 'Delete',
                    color: Colors.red,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
