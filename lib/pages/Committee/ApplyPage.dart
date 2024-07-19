import 'package:flutter/material.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/Apply.dart';
import 'package:proposal_app/data/EnumData.dart';
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
        const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Text(
                "*You are only able to manage the applications by students in the programs that you in charge of",
                style: TextStyle(fontSize: 12),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [

            Filter(
              defaultText: 'Apply Status',
              data: EnumData.ApplyStatus,
              anotherAction: (int? newValue) => parentKey.currentState!.setState(()=> applyStatus = newValue )),
          
          ],)
        ),
        Expanded(
          child: SimpleListPage(
            key: parentKey,
            fetchData: () => Apply.getApplications(applyState: applyStatus, committeeLecturerId: ApiService.id),
            onTap: changeStatusDialog,
            toListData: _applicationToListData,
          ),
        ),
      ],
    );
  }

  List<SimpleListData> _applicationToListData(List<dynamic> application) {
    return application.map((e) => SimpleListData(
      title: e['studentName'] + " " + e["matricId"],
      description: "year/semester/session:     ${e['year']}/ ${e['semester']}/ ${e['session']} \nstatus: ${ EnumData.ApplyStatus[ e['status'] ] }",
      id: e['id'],
      selectedId: e["status"] == 2 ?  e['id'] : "",
      subtitle: e["supervisorName"] + " " + e["supervisorId"] ,
      ids: {"applyStatus" : e["status"]}
    )).toList();
  }

  
  void changeStatusDialog(SimpleListData data) {


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text('Update Application Status'),
        content: const Text('Please update the application status'),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 5),
              MaterialButton(
                onPressed: () => updateStatus(data,  data.ids!["applyStatus"] == 0 ? 1 : 0  ),
                color: Colors.red,
                child: data.ids!["applyStatus"] == 0 ? const Text("Reject") : const Text("Pending")
              ),
              const SizedBox(width: 5),
              if(data.ids!["applyStatus"] != 2)
                MaterialButton(
                  onPressed: () => approve(data),
                  color: Colors.blue,
                  child: const Text("Approve")
                ),
              if(data.ids!["applyStatus"] == 2)
                const SizedBox(width: 5),
              if(data.ids!["applyStatus"] == 2)
                MaterialButton(
                  onPressed: () => updateStatus(data, 1),
                  color: Colors.red,
                  child: const Text("Reject")
                ),
            ],
          ),
        ],
      ),
    );
  }

  void updateStatus(SimpleListData data, int status){

    // Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message:
              Text('Are you sure to ${EnumData.ApplyStatus[status]} this application?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        Apply.updateApplyStatus(data.id, status).then((_) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Application ${EnumData.ApplyStatus[status]} successfully'),
            backgroundColor: Colors.green,
          ));
          parentKey.currentState!.setState(() {});
          Navigator.of(context).pop();
        }).catchError((error) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to ${EnumData.ApplyStatus[status]} application: $error'),
            backgroundColor: Colors.red,
          ));
          parentKey.currentState!.setState(() {});
          Navigator.of(context).pop();
        });
      }
    });
  }


  void approve(SimpleListData data){

    // Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message:
              const Text('Are you sure to approve this application?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        Apply.updateApplyStatus(data.id, 2).then((_) {

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Application approved successfully'),
            backgroundColor: Colors.green,
          ));
          parentKey.currentState!.setState(() {});
          Navigator.of(context).pop();
        }).catchError((error) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to approve application: $error'),
            backgroundColor: Colors.red,
          ));
          parentKey.currentState!.setState(() {});
          Navigator.of(context).pop();
        });
      }
    });
  }
}