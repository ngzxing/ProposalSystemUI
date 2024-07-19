import 'package:flutter/material.dart';
import 'package:proposal_app/data/Admin.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/pages/Login.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String staffId = ApiService.id!;

  Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late Map<String, dynamic> _lecturerData;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  GlobalKey<State> detailKey = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    _fetchLecturerData();
  }

  Future _fetchLecturerData() async{
    _lecturerData = await Admin.getSpecificAdmin(widget.staffId);
    
  }

  Future<void> Logout() async {
    
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
          InputWidget.buildTextField(_adminIdController, 'Admin ID',
              Icons.phone, false, _lecturerData['adminId'] ?? ''),
          InputWidget.buildTextField(_emailController, 'Email', Icons.email,
              false, _lecturerData['email'] ?? ''),
        ],
      ),
    );
  }

  

  
}
