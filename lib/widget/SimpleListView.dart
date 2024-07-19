import 'package:flutter/material.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';
import 'package:proposal_app/widget/SimpleListTile.dart';


// ignore: must_be_immutable
class SimpleListView extends StatelessWidget{

  List<SimpleListData> data;
  void Function(SimpleListData) onTap;

  SimpleListView({super.key, required this.onTap, required this.data});

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (context, index) {
                
                return SimpleListTile(onTap: onTap, data: data[index]);
              },
            );
  }

  
}