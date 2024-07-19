import 'package:flutter/material.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/EnumData.dart';
import 'package:proposal_app/pages/Login.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';
import 'package:proposal_app/data/Letcurer.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String staffId = ApiService.id!;

  Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _isEditing = false;
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
    
    // .then((data) {
    //   setState(() {
    //     _lecturerData = data;
    //     _userNameController.text = _lecturerData['userName'] ?? '';
    //     _phoneNumberController.text = _lecturerData['phoneNumber'] ?? '';
    //     _emailController.text = _lecturerData['email'] ?? '';
    //   });
    // }).catchError((error) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch lecturer data: $error')));
    // });
  }

  Future<void> Logout() async {
    // Call the API to delete the student
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text('Are you sure to logout?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        ApiService.logout().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Logout successfully'),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to Logout: $error'),
            backgroundColor: Colors.red,
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
      Column(
        children: [
          SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:15, vertical: 8.0),
                  child: Button(
                    onPressed: Logout,
                    text: "Logout",
                    color: Colors.red,
                  ),
                )),
          const SizedBox(height: 10),
          Expanded(
              child: FutureWidget(
            
            key: detailKey,
            fetchData: _fetchLecturerData,
            widgetBuilder: _buildDetailPage,
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Button(
                  text: _isEditing ? 'Save' : 'Edit',
                  onPressed: _isEditing
                      ? _updateLecturer
                      : () => setState(() => _isEditing = true),
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                if (_isEditing)
                  Button(
                    text: 'Cancel',
                    onPressed: () => setState(() => _isEditing = false),
                    color: Colors.green,
                  ),
                if (_isEditing) const SizedBox(height: 20),
              ],
            ),
          ),
        ],
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
              Icons.phone, _isEditing, _lecturerData['phoneNumber'] ?? ''),
          InputWidget.buildTextField(_emailController, 'Email', Icons.email,
              _isEditing, _lecturerData['email'] ?? ''),
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

  void _updateLecturer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text('Are you sure you want to update this lecturer?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        Lecturer.updateLecturer(
          widget.staffId,
          _userNameController.text,
          _phoneNumberController.text,
          _emailController.text,
          domain!,
        ).then((_) {
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Lecturer updated successfully'),
              backgroundColor: Colors.green));
          _fetchLecturerData();

          detailKey.currentState!.setState(() {});
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to update lecturer: $error'),
            backgroundColor: Colors.red,
          ));
        });
      }
    });
  }

  
}
