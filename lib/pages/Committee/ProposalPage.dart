import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/EnumData.dart';
import 'package:proposal_app/data/Proposal.dart';
import 'package:proposal_app/pages/Committee/ProposalDetailPage.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/Filter.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';


class ProposalPage extends StatefulWidget {
  const ProposalPage({Key? key}) : super(key: key);

  @override
  _ProposalPageState createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {

  int? proposalStatus;
  TextEditingController sessionController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController matricIdController = TextEditingController();
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
                "*You are only able to manage the proposals by the students in the programs that you in charge of",
                style: TextStyle(fontSize: 12),
              ),
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                          width: double.infinity,
                          child: InputWidget.buildTextField(matricIdController,
                              "Student Id", Icons.people, true, "")),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: Button(
                          onPressed: () =>
                              parentKey.currentState!.setState(() {}),
                          text: "Search",
                          color: Colors.blue),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Filter(
                        data: EnumData.ProposalStatus,
                        defaultText: "Proposal Status",
                        anotherAction: (int? newValue) => parentKey.currentState!
                            .setState(() => proposalStatus = newValue)),
                  ),
                ),
                const SizedBox(height: 5),
                
              ],
            )),
        Expanded(
          child: SimpleListPage(
            key: parentKey,
            fetchData: () => Proposal.getProposalsList(
                committeeLecturerId: ApiService.id,
                proposalStatus: proposalStatus,
                studentId: matricIdController.text,
                semester: semesterController.text == ""
                    ? null
                    : int.parse(semesterController.text),
                session: sessionController.text == ""
                    ? null
                    : int.parse(sessionController.text),
            ),
            onTap: _showProposalDetails,
            toListData: _proposalsToListData,
          ),
        ),
      ],
    );
  }

  List<SimpleListData> _proposalsToListData(List<dynamic> proposals) {
    return proposals.map((e) => SimpleListData(
      title: e['title'],
      description: "${e['createdAt']}\nStatus: ${ EnumData.ProposalStatus[ e['proposalStatus'] ]}",
      id: e['id'],
      selectedId:  e['proposalStatus'] == 1 ? e['id'] : '',
      subtitle: e['studentId'] + "\nSession/Semester:   " +  e["session"].toString() + "/" + e["semester"].toString() ,
      ids: {"studentId" : e['studentId']}
    )).toList();
  }

  

  void _showProposalDetails(SimpleListData data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProposalDetailPage(proposalId: data.id),
      ),
    );
  }
}