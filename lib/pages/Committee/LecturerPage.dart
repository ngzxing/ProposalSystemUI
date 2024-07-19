import 'package:flutter/material.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/Letcurer.dart';
import 'package:proposal_app/pages/Committee/LecturerDetailPage.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';

class LecturerPage extends StatefulWidget {
  const LecturerPage({Key? key}) : super(key: key);

  @override
  _LecturerPageState createState() => _LecturerPageState();
}

class _LecturerPageState extends State<LecturerPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Text(
                "*You are only able to manage the lecturers in the programs that you in charge of",
                style: TextStyle(fontSize: 12),
              ),
            )),
        Expanded(
          child: SimpleListPage(
            fetchData: () => Lecturer.getAllLecturers(committeeLecturerId: ApiService.id),
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
      ],
    );
  }

  

  void _navigateToLecturerDetail(BuildContext context, String staffId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LecturerDetailPage(staffId: staffId),
      ),
    ).then((_) => setState(() {}));
  }
}