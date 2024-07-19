import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:path/path.dart' as path;
    
// ignore: must_be_immutable
class DownloadButton extends StatefulWidget {

  Future Function(String) download;
  String title;
  String name;
  Color color;


  DownloadButton({super.key, required this.download, required this.title, required this.name, this.color = Colors.blue});

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {

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
    return Button(
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "The File Is Loading, Please Wait Till Finish To Proceed This Operation")));

              if (!(await _requestPermission(Permission.storage))) {
                
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No Storage Permission"), backgroundColor: Colors.red,));
              }

              final folderPath = await FilePicker.platform.getDirectoryPath();

              if (folderPath == null) {
                return;
              }

              final filepath = path.join(folderPath,
                  "${widget.title}.pdf");

              try {
                
                
                await widget.download(filepath);
                
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Download Success"), backgroundColor: Colors.green,));
                await OpenFile.open(filepath);
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,));
              }
            },
            text: widget.name,
            color: widget.color,
          );
  }
}