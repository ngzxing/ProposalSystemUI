import 'package:flutter/material.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/pages/Admin/SidebarWithPages.dart' as AdminPage;
import 'package:proposal_app/pages/Committee/SidebarWithPages.dart' as CommitteePage;
import 'package:proposal_app/pages/Login.dart';
import 'package:proposal_app/pages/Student/SidebarWithPages.dart' as StudentPage;
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/FutureWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool authorized = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyProposal',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: FutureWidget(
          returnScaffold: true,
          fetchData: () async =>
              authorized = await ApiService.checkConnection(),
          widgetBuilder: () {


            if (authorized == false) {

              return const Login();

            }

            if(ApiService.role == "Admin"){

              return AdminPage.SidebarWithPages();
            }

            if(ApiService.role == "Student"){

              return StudentPage.SidebarWithPages();
            }

            if(ApiService.role == "Lecturer"){

              return CommitteePage.SidebarWithPages();
            }


            return Scaffold(
                  body: Center(
                      child: Column(
                              children: [

                                const Text("Wrong role, Please Refresh"),
                                Button(
                                  text: "Refresh",
                                  onPressed: () => setState((){}),
                                  color: Colors.blue
                                )
                              ],
              )));
          },
        ));
  }
}
