import 'package:flutter/material.dart';
import 'package:proposal_app/data/Apply.dart';
import 'package:proposal_app/data/EnumData.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';
import 'package:proposal_app/data/Letcurer.dart';

// ignore: must_be_immutable
class LecturerDetailPage extends StatefulWidget {
  final String staffId;
  GlobalKey<State>? parentKey;
  LecturerDetailPage({super.key, required this.staffId, this.parentKey});

  @override
  _LecturerDetailPageState createState() => _LecturerDetailPageState();
}

class _LecturerDetailPageState extends State<LecturerDetailPage> {

  
  late Map<String, dynamic> _lecturerData;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _programController = TextEditingController();
  int? domain;

  GlobalKey<State> detailKey = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    _fetchLecturerData();
  }

  Future _fetchLecturerData() async{
    _lecturerData = await Lecturer.getSpecificLecturer(widget.staffId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecturer Details')),
      body: Column(
        children: [
          FutureWidget(
            key: detailKey,
            fetchData: _fetchLecturerData,
            widgetBuilder: _buildDetailPage,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Button(
                  text: 'Apply As Supervisor',
                  onPressed: _apply,
                  color: Colors.blue,
                )
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputWidget.buildTextField(_userNameController, 'User Name',
              Icons.person, false, _lecturerData['userName'] ?? ''),
          InputWidget.buildTextField(TextEditingController(), 'Staff ID',
              Icons.badge, false, _lecturerData['staffId'] ?? ''),
          InputWidget.buildTextField(_phoneNumberController, 'Phone Number',
              Icons.phone, false, _lecturerData['phoneNumber'] ?? ''),
          InputWidget.buildTextField(_emailController, 'Email', Icons.email,
              false, _lecturerData['email'] ?? ''),
          InputWidget.buildTextField(_programController, 'Program', Icons.schedule ,
              false, _lecturerData['academicProgramName'] ?? ''),
          InputWidget.buildDropdown(
            (value) {domain = value;},
            'Domain',
            Icons.domain,
            EnumData.Domain,
            false,
            _lecturerData["domain"],
          ),
        ],
      ),
    );
  }

  void _apply() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text('Are you sure you apply this lecturer as your supervisor?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        Apply.createApply(widget.staffId).then((_) {
          
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Apply successfully'),
              backgroundColor: Colors.green));

          Navigator.of(context).pop();
          Navigator.of(context).pop();
          widget.parentKey!.currentState!.setState(() {});

        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Apply Failed: $error'),
            backgroundColor: Colors.red,
          ));
        });
      }
    });
  }

  
}
