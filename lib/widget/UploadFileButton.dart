import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:proposal_app/pages/Student/ProposalPage.dart';
import 'package:proposal_app/widget/IconTextButton.dart';

// ignore: must_be_immutable
class UploadFileButton extends StatefulWidget {
  FileController fileController;
  String text;
  UploadFileButton({super.key, required this.fileController, this.text = "Upload File" });

  @override
  State<UploadFileButton> createState() => _UploadFileButtonState();
}

class _UploadFileButtonState extends State<UploadFileButton> {
  @override
  Widget build(BuildContext context) {
    return IconTextButton(
        icon: Icons.upload_file,
        label: widget.fileController.file == null
            ? widget.text
            : widget.fileController.file!.path.split("\\").last,
        backgroundColor: Colors.blue,
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null) {
            widget.fileController.file = File(result.files.single.path!);
            setState((){});
          }
        });
  }
}
