import 'package:flutter/material.dart';
import 'package:proposal_app/data/AcademicProgram.dart';
import 'package:proposal_app/data/Letcurer.dart';
import 'package:proposal_app/pages/Admin/LecturerDetailPage.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';

class LecturerPage extends StatefulWidget {
  const LecturerPage({Key? key}) : super(key: key);

  @override
  _LecturerPageState createState() => _LecturerPageState();
}

class _LecturerPageState extends State<LecturerPage> {
  GlobalKey<State> parentKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Button(
              text: "Add Lecturer",
              onPressed: () => _showAddLecturerDialog(context),
              color: Colors.blue),
        ),
        Expanded(
          child: SimpleListPage(
            key: parentKey,
            fetchData: Lecturer.getAllLecturers,
            onTap: (data) => _navigateToLecturerDetail(context, data.id),
            toListData: (List<dynamic> data) => data
                .map((item) => SimpleListData(
                      title: item['userName'] ?? '',
                      description: item['email'] ?? '',
                      id: item['staffId'] ?? '',
                      selectedId: '',
                      subtitle: item['phoneNumber'] ?? '',
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  void _showAddLecturerDialog(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController staffIdController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String? programId;
    Map<String, String> programList = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Lecturer'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                InputWidget.buildTextField(
                    userNameController, 'User Name', Icons.person, true, ''),
                InputWidget.buildTextField(
                    staffIdController, 'Staff ID', Icons.badge, true, ''),
                InputWidget.buildTextField(phoneNumberController,
                    'Phone Number', Icons.phone, true, ''),
                InputWidget.buildTextField(
                    emailController, 'Email', Icons.email, true, ''),
                InputWidget.buildTextField(
                    passwordController, 'Password', Icons.lock, true, '',
                    obscureText: true),
                FutureWidget(
                    fetchData: () async {
                      var data = await AcademicProgram.getAllPrograms();

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
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () => _addLecturer(
                  context,
                  userNameController.text,
                  staffIdController.text,
                  phoneNumberController.text,
                  emailController.text,
                  passwordController.text,
                  programId!),
            ),
          ],
        );
      },
    );
  }

  void _addLecturer(BuildContext context, String userName, String staffId,
      String phoneNumber, String email, String password, String programId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text('Are you sure you want to add this lecturer?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        Lecturer.createLecturer(userName, staffId, phoneNumber, email, password, programId)
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Lecturer added successfully'),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
          setState(() {});
        }).catchError((error) {
          
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add lecturer: $error'),
            backgroundColor: Colors.red,
          ));
          Navigator.of(context).pop();
        });
      }
    });
  }

  void _navigateToLecturerDetail(BuildContext context, String staffId) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) =>
                LecturerDetailPage(parentKey: parentKey, staffId: staffId),
          ),
        )
        .then((_) => setState(() {}));
  }
}
