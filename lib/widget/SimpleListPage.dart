import 'package:flutter/material.dart';
import 'package:proposal_app/widget/SimpleListView.dart';


// ignore: must_be_immutable
class SimpleListPage extends StatefulWidget{

  Future<List<dynamic>> Function() fetchData;
  void Function(SimpleListData) onTap;
  List<SimpleListData> Function( List<dynamic> ) toListData;

  SimpleListPage({super.key, required this.fetchData, required this.onTap, required this.toListData});

  @override
  State<SimpleListPage> createState() => SimpleListPageState();
}

class SimpleListPageState extends State<SimpleListPage>{
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
            future: widget.fetchData(), 
            builder: 
              (context, snapshot){

                if(snapshot.hasError){
                  
                  return Center(
                    child: 
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4 ,
                        child: 
                          Text( snapshot.error.toString() )
                      )
                  );
                }

                if(snapshot.connectionState == ConnectionState.done){
                  
                
                  if(snapshot.data!.isEmpty){

                    return const Center(child: Text("Opps, Nothing Here Yet"));
                  }
                  
                  return SimpleListView(onTap: widget.onTap, data: widget.toListData(snapshot.data!) );
                }

                return const Center(
                  child: SizedBox(
                    height: 50, 
                    width: 50, 
                    child: CircularProgressIndicator())
                );

              }

          );

    
  }

  
}

class SimpleListData{

  String title;
  String description;
  String id;
  String selectedId;
  String subtitle;
  Map<String, dynamic>? ids;

  SimpleListData({

    required this.title,
    required this.description,
    required this.id,
    required this.selectedId,
    required this.subtitle,
    this.ids
  });
}