import 'package:flutter/material.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/Apply.dart';
import 'package:proposal_app/data/EnumData.dart';
import 'package:proposal_app/pages/Student/LecturerPage.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/Filter.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';

class ApplyPage extends StatefulWidget {
  const ApplyPage({Key? key}) : super(key: key);

  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  int? applyStatus;
  GlobalKey<State> parentKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: Button(
              text: "Apply",
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LecturerPage(parentKey: parentKey,),
              )),
              color: Colors.blue
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Filter(
                  defaultText: 'Status',
                  data: EnumData.ApplyStatus,
                  anotherAction: (int? newValue) => parentKey.currentState!
                      .setState(() => applyStatus = newValue)),
            )),
        Expanded(
          child: SimpleListPage(
            key: parentKey,
            fetchData: () => Apply.getApplications(
                matricId: ApiService.id!, applyState: applyStatus),
            onTap: confirm,
            toListData: _applicationToListData,
          ),
        ),
      ],
    );
  }

  List<SimpleListData> _applicationToListData(List<dynamic> application) {
    return application
        .map((e) => SimpleListData(
            title: e['studentName'] + " " + e["matricId"],
            description:
                "status: ${EnumData.ApplyStatus[e['status']]}",
            id: e['id'],
            selectedId: e["status"] == 2 ? e['id'] : "",
            subtitle: e["supervisorName"] + " " + e["supervisorId"],
            ids: {"applyStatus": e["status"]}))
        .toList();
  }

  void confirm(SimpleListData data) {
    if (data.ids!["applyStatus"] != 2) {
      return;
    }
    // Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text(
              """I understand and accept the guidance and support provided by supervisor throughout the duration of my proposal.

Terms and Conditions:
1. I will maintain regular communication with my supervisor and provide timely updates on the progress of my proposal.
2. I will adhere to all deadlines set by my supervisor and the institution.
3. I will be open to feedback and make necessary revisions as suggested by my supervisor.
4. I will ensure that my work is original and free from plagiarism.
5. I will attend scheduled meetings and consultations with my supervisor.
6. I will take responsibility for the completion and quality of my proposal."""),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        Apply.confirmApplication(data.id).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Application confirm successfully'),
            backgroundColor: Colors.green,
          ));
          parentKey.currentState!.setState(() {});
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to accept application: $error'),
            backgroundColor: Colors.red,
          ));
          parentKey.currentState!.setState(() {});
        });
      }
    });
  }
}
