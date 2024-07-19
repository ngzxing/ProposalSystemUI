import 'package:flutter/material.dart';
import 'package:proposal_app/widget/SimpleListPage.dart';


// ignore: must_be_immutable
class SimpleListTile extends StatelessWidget{

  SimpleListData data;
  void Function(SimpleListData) onTap;

  SimpleListTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    
    return Card(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                color: data.id == data.selectedId
                    ? const Color(0xff3a57e8)
                    : const Color(0xffffffff),
                shadowColor: const Color(0x4d939393),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                ),
                child: ListTile(
                  onTap: () {
                    
                    onTap(data);
                  },
                  title: Text(
                    data.title,
                    style: TextStyle(
                      color: data.selectedId == data.id
                          ? const Color(0xffffffff)
                          : const Color(0xff000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.subtitle,
                        style: TextStyle(
                          color: data.selectedId == data.id
                              ? const Color(0xffffffff)
                              : const Color(0xff6c6c6c),
                        ),
                      ),
                      Text(
                        data.description,
                        style: TextStyle(
                          color: data.selectedId == data.id
                              ? const Color(0xffffffff)
                              : const Color(0xff6c6c6c),
                        ),
                      ),
                    ],
                  ),
                  trailing: data.selectedId == data.id
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xffffffff),
                        )
                      : const Icon(
                          Icons.check_circle_outline,
                          color: Color(0xff6c6c6c),
                        ),
                ),
              );
  }

  
}