// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proposal_app/data/AcademicProgram.dart';
import 'package:proposal_app/data/Committee.dart';
import 'package:proposal_app/data/EnumData.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';

class AcademicProgramDetailPage extends StatefulWidget {
  final String programId;

  const AcademicProgramDetailPage({super.key, required this.programId});

  @override
  _AcademicProgramDetailPageState createState() =>
      _AcademicProgramDetailPageState();
}

class _AcademicProgramDetailPageState extends State<AcademicProgramDetailPage> {
  
  Map<String, dynamic> programData = {};
  GlobalKey<State> committeeKey = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
  }

  Future fetchProgram() async{

    programData = await AcademicProgram.getSpecificProgram(widget.programId);
  }

  List<SimpleListData> _committeeToListData(List<dynamic> committees) {
    
    return committees.map((c) => SimpleListData(
      title: c['lecturerName'],
      description: EnumData.Domain[ c['lecturerDomain'] ]!,
      id: c['id'],
      selectedId: '',
      subtitle: '',
    )).toList();
  }

  List<SimpleListData> _lecturerToListData(List<dynamic> lecturers) {
    
    return lecturers.map((c) => SimpleListData(
      title: c['userName'],
      description: c['phoneNumber'],
      id: c['staffId'],
      selectedId: '',
      subtitle: c['email'],
    )).toList();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Program Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureWidget(fetchData: fetchProgram, widgetBuilder: _buildProgramDetails,),
            const SizedBox(height: 20),
            _buildCommitteeList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramDetails() {
    
    final nameController = TextEditingController(text: programData['name']);
    final descriptionController =
        TextEditingController(text: programData['description']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Program Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        InputWidget.buildTextField(nameController, 'Program Name',
            Icons.school, false, programData['name'] ?? ''),
        InputWidget.buildTextField(descriptionController, 'Description',
            Icons.description, false, programData['description'] ?? ''),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCommitteeList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Committees',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Button(
                onPressed: _showAddCommitteeDialog,
                text: 'Add Committee',
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SimpleListPage(
            key: committeeKey,
            fetchData: () => Committee.getCommitteesForProgram(widget.programId),
            onTap: _deleteCommittee,
            toListData: _committeeToListData,
          ),

      ],
    );
  }

  void _showAddCommitteeDialog() async {
  

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text('Add Committee'),
        content: SizedBox(
          width: double.maxFinite,
          child: SimpleListPage(
            fetchData: () => AcademicProgram.getNotInvolvedCommittee(widget.programId),
            onTap: _addCommittee,
            toListData: _lecturerToListData,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addCommittee(SimpleListData data) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        message:
            const Text('Are you sure you want to add this committee member?'),
      ),
    );

    if (confirm == true) {
      try {
        await Committee.createCommittee(widget.programId, data.id);
        Navigator.pop(context);
        committeeKey.currentState!.setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Committee member added successfully'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add committee member: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _deleteCommittee(SimpleListData data) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        message: const Text(
            'Are you sure you want to remove this committee member?'),
      ),
    );

    if (confirm == true) {
      try {
        await Committee.deleteCommittee(data.id);
        committeeKey.currentState!.setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Committee member removed successfully'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to remove committee member: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    }
  }
}
