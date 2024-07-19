// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:proposal_app/data/ApiService.dart';
import 'package:proposal_app/pages/Login.dart';
import 'package:proposal_app/pages/Student/ApplyPage.dart';
import 'package:proposal_app/pages/Student/Profile.dart';
import 'package:proposal_app/pages/Student/ProposalPage.dart';
import 'package:proposal_app/widget/Button.dart';
import 'package:proposal_app/widget/FutureWidget.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomSidebarX extends StatefulWidget {
  GlobalKey pageKey = GlobalKey();

  CustomSidebarX({
    Key? key,
    required this.pageKey,
    required SidebarXController controller,
    required this.onItemSelected,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;
  final ValueChanged<int> onItemSelected;

  @override
  State<CustomSidebarX> createState() => CustomSidebarXState();
}

class CustomSidebarXState extends State<CustomSidebarX> {
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: widget._controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: lightCanvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: lightHoverColor,
        textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.black),
        hoverTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 15),
        selectedItemTextPadding: const EdgeInsets.only(left: 15),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: lightCanvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: lightActionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [lightAccentCanvasColor, lightCanvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.7),
          size: 15,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.black,
          size: 15,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 150,
        decoration: BoxDecoration(
          color: lightCanvasColor,
        ),
      ),
      footerDivider: lightDivider,
      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            // child: Image.asset('assets/images/avatar.png'),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.list,
          label: 'Applications',
          onTap: () {
            widget.onItemSelected(0);
            widget.pageKey.currentState!.setState(() {});
            setState(() {});
          },
        ),
        SidebarXItem(
          icon: Icons.document_scanner,
          label: 'Proposals',
          onTap: () {
            widget.onItemSelected(1);
            widget.pageKey.currentState!.setState(() {});
            setState(() {});
          },
        ),
        SidebarXItem(
          icon: Icons.person,
          label: 'My Profile',
          onTap: () {
            widget.onItemSelected(2);
            widget.pageKey.currentState!.setState(() {});
            setState(() {});
          },
        )
      ],
    );
  }
}

class Pages extends StatefulWidget {
  Widget Function() getPage;
  String Function() getTitle;

  Pages({super.key, required this.getPage, required this.getTitle});

  @override
  State<Pages> createState() => PagesState();
}

class PagesState extends State<Pages> {
  bool authorized = false;

  @override
  Widget build(BuildContext context) {
    return FutureWidget(
      fetchData: () async => authorized = await ApiService.checkConnection(),
      widgetBuilder: () {
        if (authorized) {
          return Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 0, top: 10, bottom: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Text(
                    widget.getTitle(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 25,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: widget.getPage())
          ]);
        }

        return Scaffold(
            body: Center(
                child: Column(
          children: [
            const Text("Session Expired, Please Login Again"),
            Button(
                text: "Login",
                onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    ),
                color: Colors.blue)
          ],
        )));
      },
    );
  }
}

class SidebarWithPages extends StatefulWidget {
  SidebarWithPages({Key? key}) : super(key: key);

  @override
  _SidebarWithPagesState createState() => _SidebarWithPagesState();
}

class _SidebarWithPagesState extends State<SidebarWithPages> {
  SidebarXController sidebarXController = SidebarXController(selectedIndex: 0);
  GlobalKey pageKey = GlobalKey();

  void _onItemSelected(int index) {
    sidebarXController.selectIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        CustomSidebarX(
          pageKey: pageKey,
          controller: sidebarXController,
          onItemSelected: _onItemSelected,
        ),
        Expanded(
          child: Pages(
            key: pageKey,
            getPage: () => _getPageByIndex(sidebarXController.selectedIndex),
            getTitle: () => _getTitleIndex(sidebarXController.selectedIndex),
          ),
        )
      ]),
    );
  }

  Widget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const ApplyPage();
      case 1:
        return const ProposalPage();
      case 2:
        return Profile();
      default:
        return const Center(child: Text("Error Page"));
    }
  }

  String _getTitleIndex(int index) {
    switch (index) {
      case 0:
        return "Applications";
      case 1:
        return "Proposals";
      case 2:
        return "My Profile";
      default:
        return "Not Found";
    }
  }
}

// Light Theme Colors
const lightCanvasColor = Color(0xFFF5F5F5);
const lightHoverColor = Color(0xFFD9D9D9);
const lightAccentCanvasColor = Color(0xFFE0E0E0);
final lightActionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final lightDivider = Divider(color: Colors.black.withOpacity(0.3), height: 1);
