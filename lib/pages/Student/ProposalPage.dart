import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/data/EnumData.dart';
import 'package:proposal_app/data/Proposal.dart';
import 'package:proposal_app/pages/Student/ProposalDetailPage.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';
import 'package:proposal_app/widget/DownloadButton.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';

import '../../widget/UploadFileButton.dart';

class ProposalPage extends StatefulWidget {
  const ProposalPage({Key? key}) : super(key: key);

  @override
  _ProposalPageState createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  final TextEditingController titleController = TextEditingController();
  int domain = 0;
  FileController proposalController = FileController();
  FileController formController = FileController();
  GlobalKey<State> parentKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Button(
                text: "Submit Proposal",
                onPressed: () => _showAddProposalDialog(context),
                color: Colors.blue),
          ),
        ),
        Expanded(
          child: SimpleListPage(
            key: parentKey,
            fetchData: () =>
                Proposal.getProposalsList(studentId: ApiService.id),
            onTap: _showProposalDetails,
            toListData: _proposalsToListData,
          ),
        ),
      ],
    );
  }

  List<SimpleListData> _proposalsToListData(List<dynamic> proposals) {
    return proposals
        .map((e) => SimpleListData(
              title: e['title'],
              description: e['createdAt']
                  .toString()
                  .split(".")
                  .first
                  .replaceAll("T", " "),
              id: e['id'],
              selectedId: e['proposalStatus'] == 1 ? e['id'] : '',
              subtitle: EnumData.ProposalStatus[e['proposalStatus']]!,
            ))
        .toList();
  }

  void _showAddProposalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Proposal'),
          content: SingleChildScrollView(
              child: Column(children: [
            InputWidget.buildTextField(
                titleController, 'Title', Icons.title, true, ''),
            InputWidget.buildDropdown((value) => domain = value, "Domain",
                Icons.work, EnumData.Domain, true, 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: DownloadButton(
                    download: (String filepath) =>
                        Proposal.getFormPdf(filepath),
                    title: "proposal_form",
                    name: "Download Form",
                    color: Colors.green ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: UploadFileButton(
                  text: "Upload Proposal",
                  fileController: proposalController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: UploadFileButton(
                  text: "Upload Form",
                  fileController: formController,
                ),
              ),
            ),
          ])),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () => _submitProposal(context),
            ),
          ],
        );
      },
    );
  }

  void _submitProposal(BuildContext context) {
    if (proposalController.file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit proposal: No proposal selected'),
        backgroundColor: Colors.red,
      ));
    }

    if (formController.file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit proposal: No form selected'),
        backgroundColor: Colors.red,
      ));
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: const Text('Are you sure you want to submit this proposal?'),
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Your proposal is uploading...'),
          backgroundColor: Colors.grey,
        ));

        Proposal.createProposal(ApiService.id!, proposalController.file!, formController.file!,
                titleController.text, domain)
            .then((_) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Proposal Submitted successfully'),
            backgroundColor: Colors.green,
          ));
          setState(() {});
        }).catchError((error) {
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to submit proposal: $error'),
            backgroundColor: Colors.red,
          ));
        });
      }
    });
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

class FileController {
  File? file;
}
