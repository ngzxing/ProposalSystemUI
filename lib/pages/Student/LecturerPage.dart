import 'package:flutter/material.dart';
import 'package:proposal_app/data/Letcurer.dart';
import 'package:proposal_app/pages/Student/LecturerDetailPage.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';


// ignore: must_be_immutable
class LecturerPage extends StatefulWidget {
  GlobalKey<State>? parentKey;
  LecturerPage({Key? key, this.parentKey}) : super(key: key);

  @override
  _LecturerPageState createState() => _LecturerPageState();
}

class _LecturerPageState extends State<LecturerPage> {

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          appBar: AppBar(title: const Text("Apply Supervisor"),),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SimpleListPage(
              fetchData: Lecturer.getAllLecturers,
              onTap: (data) => _navigateToLecturerDetail(context, data.id),
              toListData: (List<dynamic> data) => data.map((item) => SimpleListData(
                title: item['userName'] ?? '',
                description: item['email'] ?? '',
                id: item['staffId'] ?? '',
                selectedId: '',
                subtitle: item['phoneNumber'] ?? '',
              )).toList(),
            ),
          ),
        );
      
  }

  void _navigateToLecturerDetail(BuildContext context, String staffId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LecturerDetailPage(staffId: staffId, parentKey: widget.parentKey,),
      ),
    ).then((_) => setState(() {}));
  }
}