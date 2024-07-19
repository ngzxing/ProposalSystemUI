import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FutureDropDownList extends StatefulWidget{

  dynamic value;
  Future<List<dynamic>> Function() fetchData;
  bool refetch = true;
  String defaultText;
  late List<dynamic> data;
  void Function(dynamic)? anotherAction;


  FutureDropDownList({super.key, required this.fetchData, this.anotherAction, this.defaultText = "All Students", required this.value});

  @override
  State<StatefulWidget> createState() => _FutureDropDownListState();

}

class _FutureDropDownListState extends State<FutureDropDownList>{


  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
            future: () async{ 
              if(widget.refetch){
                return await widget.fetchData();
              }
              return widget.data;
            }(), 
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
                  
                  widget.refetch = false;
                  widget.data = snapshot.data!;

                  var items = snapshot.data!.map<DropdownMenuItem<String>>( (e) =>
                          DropdownMenuItem<String>(
                            value: e["key"],
                            child: Text(e["value"]),
                          )
                        ).toList();

                  if(widget.value == null){

                    items.insert(0,
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text(widget.defaultText) ,
                            )
                    );
                  }
                  
                
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff3a57e8), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: widget.value,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Color(0xff3a57e8)),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Color(0xff3a57e8)),
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.value = newValue!;
                          });


                          widget.anotherAction?.call(newValue);
                          
                        },
                        items: items
                        ),
                      ),
                  
                  );
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