import 'package:flutter/material.dart';
import 'package:proposal_app/data/AcademicProgram.dart';
import 'package:proposal_app/pages/Admin/AcademicProgramDetailPage.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/InputWidget.dart';
import 'package:proposal_app/widget/ConfirmDialog.dart';

class AcademicProgramPage extends StatefulWidget {
  const AcademicProgramPage({Key? key}) : super(key: key);

  @override
  _AcademicProgramPageState createState() => _AcademicProgramPageState();
}

class _AcademicProgramPageState extends State<AcademicProgramPage> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Button(
            onPressed: _showAddProgramDialog,
            text: 'Add Program',
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: SimpleListPage(
            fetchData: AcademicProgram.getAllPrograms,
            onTap: _showProgramDetails,
            toListData: _programsToListData,
          ),
        ),
      ],
    );
  }

  List<SimpleListData> _programsToListData(List<dynamic> programs) {
    return programs.map((program) => SimpleListData(
      title: program['name'],
      description: program['description'],
      id: program['id'],
      selectedId: '',
      subtitle: '',
    )).toList();
  }

  void _showAddProgramDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text('Add New Program'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputWidget.buildTextField(nameController, 'Program Name', Icons.school, true, ''),
              InputWidget.buildTextField(descriptionController, 'Description', Icons.description, true, ''),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => ConfirmDialog(
                  message: const Text('Are you sure you want to add this program?'),
                ),
              );

              if (confirm == true) {
                try {
                  await AcademicProgram.createProgram(nameController.text, descriptionController.text);
                  Navigator.pop(context);
                  setState(() {}); // Refresh the list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Program added successfully'), backgroundColor: Colors.green),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add program: ${e.toString()}'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showProgramDetails(SimpleListData data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcademicProgramDetailPage(programId: data.id),
      ),
    );
  }
}