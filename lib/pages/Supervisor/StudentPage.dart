import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/Student.dart';
import 'package:proposal_app/pages/Supervisor/StudentDetailPage.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/Filter.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  GlobalKey<State> parentKey = GlobalKey<State>();
  TextEditingController sessionController = TextEditingController();
  TextEditingController semesterController = TextEditingController();

  Future<List<dynamic>> fetchStudents() async {
    return await Student.getAllStudents(
        supervisorId: ApiService.id,
        session: sessionController.text == "" ? null : int.parse(sessionController.text),
        semester: semesterController.text == "" ? null : int.parse(semesterController.text));
  }

  List<SimpleListData> toListData(List<dynamic> data) {
    return data.map((student) {
      return SimpleListData(
        title: student['userName'],
        description: student['email'],
        id: student['matricId'],
        selectedId: '',
        subtitle: student['phoneNumber'],
      );
    }).toList();
  }

  void handleTileTap(BuildContext context, SimpleListData student) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          StudentDetailPage(parentKey: parentKey, studentId: student.id),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: InputWidget.buildTextField(
                  sessionController,
                  "Session",
                  Icons.people,
                  true,
                  "",
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Expanded(
                child: InputWidget.buildTextField(
                  semesterController,
                  "Semester",
                  Icons.people,
                  true,
                  "",
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Button(
              onPressed: () => parentKey.currentState!.setState(() {}),
              text: "Search",
              color: Colors.blue),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SimpleListPage(
            key: parentKey,
            fetchData: fetchStudents,
            onTap: (student) => handleTileTap(context, student),
            toListData: toListData,
          ),
        ),
      ],
    );
  }
}
