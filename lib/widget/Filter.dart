import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Filter extends StatefulWidget {

  int? value;
  String defaultText;
  late Map<int, dynamic> data;
  void Function(int?)? anotherAction;

  Filter(
      {super.key,
      this.anotherAction,
      required this.defaultText,
      required this.data,
      this.value
      }
  );

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    var items = widget.data.entries
        .map<DropdownMenuItem<int>>((e) => DropdownMenuItem<int>(
              value: e.key,
              child: Text(e.value),
            ))
        .toList();

    
    items.insert(
          0,
          DropdownMenuItem<int>(
            value: null,
            child: Text(widget.defaultText),
    ));
    

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff3a57e8), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
            value: widget.value,
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xff3a57e8)),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Color(0xff3a57e8), overflow: TextOverflow.ellipsis),
            onChanged: (int? newValue) {
              setState(() {
                widget.value = newValue;
              });

              widget.anotherAction?.call(newValue);
            },
            items: items),
      ),
    );
  }
}
