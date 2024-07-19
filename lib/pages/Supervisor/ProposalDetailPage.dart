// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/Proposal.dart';
import 'package:proposal_app/data/Comment.dart';
import 'package:proposal_app/data/EnumData.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';
import 'package:proposal_app/widget/DownloadButton.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';

class ProposalDetailPage extends StatefulWidget {
  final String proposalId;

  const ProposalDetailPage({super.key, required this.proposalId});

  @override
  _ProposalDetailPageState createState() => _ProposalDetailPageState();
}

class _ProposalDetailPageState extends State<ProposalDetailPage> {
  Map<String, dynamic> data = {};
  GlobalKey<State> commentKey = GlobalKey<State>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController matricIdController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController supervisorIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController domainController = TextEditingController();
  final TextEditingController createdAtController = TextEditingController();
  final TextEditingController markController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController supervisorNameController =
      TextEditingController();
  final TextEditingController firstEvaluatorIdController =
      TextEditingController();
  final TextEditingController firstEvaluatorNameController =
      TextEditingController();
  final TextEditingController secondEvaluatorIdController =
      TextEditingController();
  final TextEditingController secondEvaluatorNameController =
      TextEditingController();

  final TextEditingController commentController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future fetchProposal() async {
    data = await Proposal.getProposalInfo(widget.proposalId);

    if (data["supervisorId"] == null) {
      data["supervisorId"] = "Not Selected Yet";
      data["supervisorName"] = "Not Selected Yet";
    }

    if (data["mark"] == null) {
      data["mark"] = "Not Marked Yet";
    }

    if (data["mark"] != null) {
      data["mark"] = data["mark"].toString();
    }
  }

  List<SimpleListData> _commentToListData(List<dynamic> comment) {
    return comment
        .map((c) => SimpleListData(
              title: c['evaluatorName'],
              description: c["text"],
              id: c['id'],
              selectedId: '',
              subtitle: c['createdAt'],
            ))
        .toList();
  }

  Widget buildEvaluator(int who) {
    String whoStr = who == 0 ? "First" : "Second";
    String evaluatorId;
    String evaluatorName;
    TextEditingController evaluatorIdController = TextEditingController();
    TextEditingController evaluatorNameController = TextEditingController();

    
      if (data["${whoStr.toLowerCase()}EvaluatorId"] == null) {
        evaluatorId = "Not Selected Yet";
        evaluatorName = "Not Selected Yet";
      } else {
        evaluatorId = data["${whoStr.toLowerCase()}EvaluatorId"];
        evaluatorName = data["${whoStr.toLowerCase()}EvaluatorName"];
      }

      return Column(
        children: [
          InputWidget.buildTextField(
            evaluatorIdController,
            '$whoStr Evaluator ID',
            Icons.person,
            false,
            evaluatorId,
          ),
          InputWidget.buildTextField(
            evaluatorNameController,
            '$whoStr Evaluator Name',
            Icons.person,
            false,
            evaluatorName,
          )
        ],
      );
    

    
  }




  Future<bool> _requestPermission(Permission permission) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 30) {
        return await Permission.manageExternalStorage.request().isGranted;
      }

      return await permission.request().isGranted;
    } else if (Theme.of(context).platform == TargetPlatform.windows) {
      return await permission.request().isGranted;
    } else {
      return await permission.request().isGranted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proposal Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureWidget(
              fetchData: fetchProposal,
              widgetBuilder: _buildProposalDetails,
            ),
            const SizedBox(height: 20),
            _buildCommentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Proposal Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        InputWidget.buildTextField(
            titleController, 'Title', Icons.title, false, data['title']),
        InputWidget.buildTextField(
            statusController, 'Status', Icons.report, false, EnumData.ProposalStatus[ data['proposalStatus'] ]!),
        InputWidget.buildTextField(createdAtController, 'Created At',
            Icons.date_range, false, data['createdAt']),
        InputWidget.buildTextField(domainController, 'Domain', Icons.work,
            false, EnumData.Domain[data['domain']!]!),
        InputWidget.buildTextField(
            markController, 'Mark', Icons.score, false, data['mark']),
        InputWidget.buildTextField(userNameController, 'Student Name',
            Icons.person, false, data['studentName']),
        InputWidget.buildTextField(matricIdController, 'Matric ID',
            Icons.school, false, data['studentId']),
        InputWidget.buildTextField(yearController, 'Year', Icons.calendar_today,
            false, data['year'].toString()),
        InputWidget.buildTextField(sessionController, 'Session', Icons.event,
            false, data['session'].toString()),
        InputWidget.buildTextField(semesterController, 'Semester', Icons.school,
            false, data['semester'].toString()),
        InputWidget.buildTextField(supervisorIdController, 'Supervisor ID',
            Icons.person, false, data['supervisorId']),
        InputWidget.buildTextField(supervisorNameController, 'Supervisor Name',
            Icons.person, false, data['supervisorName']),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: DownloadButton(
              download: (String filepath) =>
                  Proposal.getProposalPdf(widget.proposalId, filepath),
              title: data['title'],
              name: "Download Proposal"),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: DownloadButton(
              download: (String filepath) =>
                  Proposal.getSignedFormPdf(widget.proposalId, filepath),
              title: data['title'],
              name: "Download Form"),
        ),
        const SizedBox(height: 10),
        const Text('Evaluator',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        buildEvaluator(0),
        const SizedBox(height: 10),
        buildEvaluator(1),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showAddCommentDialog(BuildContext context) {
    

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: SingleChildScrollView(
              child: Column(children: [
            InputWidget.buildTextField(
                commentController, 'Comment', Icons.comment, true, '', keyboardType: TextInputType.multiline, minLines: 5, maxLines: 10),
          
          ])),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () => _addComment(context),
            ),
          ],
        );
      },
    );
  }



  void _addComment(BuildContext context) async{

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text('Are you sure you want to submit this comment?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) 
      {
        Comment.createComment(
                widget.proposalId, ApiService.id!, commentController.text)
            .then((_) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Comment Submitted successfully'),
            backgroundColor: Colors.green,
          ));
          commentKey.currentState!.setState(() {});
        }).catchError((error) {
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to submit comment: $error'),
            backgroundColor: Colors.red,
          ));
        });
      }
    });
  }

  Widget _buildCommentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Comments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Button(
            onPressed: () => _showAddCommentDialog(context),
            text: "Add Comment",
            color: Colors.blue),
        ),
        const SizedBox(height: 20),
        SimpleListPage(
          key: commentKey,
          fetchData: () => Comment.getCommentsForProposal(widget.proposalId),
          onTap: (SimpleListData data) {},
          toListData: _commentToListData,
        ),
      ],
    );
  }
}
