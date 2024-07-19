import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/Committee.dart';
import 'package:proposal_app/data/Student.dart';
import 'package:proposal_app/pages/Committee/CreateStudentWidget.dart';
import 'package:proposal_app/pages/Committee/StudentDetailPage.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  GlobalKey<State> parentKey = GlobalKey<State>();

  Future<List<dynamic>> fetchStudents() async {
    return await Student.getAllStudents(committeeLecturerId: ApiService.id);
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
        const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Text(
                "*You are only able to manage the students in the programs that you in charge of",
                style: TextStyle(fontSize: 12),
              ),
            )),
        const SizedBox(height: 10),
        Button(
          onPressed: _showAddDialog,
          text: 'Register Student',
          color: Colors.blue,
        ),
        const SizedBox(height: 20),
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

  void _showAddDialog() {
    CreateStudentWidget createStudentWidget = CreateStudentWidget(
        fetchPrograms: () async => await Committee.getPrograms(ApiService.id!));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text('Add New Student'),
        content: SingleChildScrollView(child: createStudentWidget),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                createStudentWidget.add(context, () => setState(() {})),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
