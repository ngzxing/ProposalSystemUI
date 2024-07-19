import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget {

  static Widget buildTextField(TextEditingController controller, String hintText, IconData icon, bool editable, String value,
      {bool obscureText = false, bool cantChange = false, TextInputType? keyboardType, int? minLines, int maxLines = 1, List<TextInputFormatter>? inputFormatters, String? defaultText }) {


    controller.text = value.toString();
    defaultText = defaultText ?? hintText;

    bool enabled = cantChange ? false : editable;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.start,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 14,
          color: Color(0xff000000),
        ),
        decoration: InputDecoration(
          labelText: hintText,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: const BorderSide(color: Color(0x00ffffff), width: 1),
          ),
          hintText: defaultText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 14,
            color: Color(0xff000000),
          ),
          filled: true,
          fillColor: !editable ? const Color(0xfff2f2f3) : Colors.white,
          isDense: false,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          prefixIcon: Icon(icon, color: const Color(0xff3a57e8), size: 24),
        ),
      ),
    );
  }

  static Widget buildDropdown(
      void Function(int) controller, String hintText, IconData icon, Map<int, String> items, bool editable, int value) {
    
    controller(value);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: DropdownButtonFormField<int>(
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide:
                  const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide:
                  const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide:
                  const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14,
              color: Color(0xff000000),
            ),
            filled: true,
            fillColor: !editable ? const Color(0xfff2f2f3) : Colors.white,
            isDense: false,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            prefixIcon: Icon(icon, color: const Color(0xff3a57e8), size: 24),
          ),
          value: value,
          onChanged: (int? newValue) {
            if (!editable) {
              return;
            }
            controller(newValue!);
          },
          items: editable
              ? items.entries
                  .map<DropdownMenuItem<int>>((e) => DropdownMenuItem<int>(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList()
              : [
                  DropdownMenuItem<int>(
                    value: value,
                    child: Text(items[value]!),
                  )
                ]),
    );
  }

  static Widget buildStringDropdown(
      void Function(String) controller, String hintText, IconData icon, Map<String, String> items, bool editable, String value) {
    
    controller(value);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide:
                  const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide:
                  const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide:
                  const BorderSide(color: Color(0x00ffffff), width: 1),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14,
              color: Color(0xff000000),
            ),
            filled: true,
            fillColor: !editable ? const Color(0xfff2f2f3) : Colors.white,
            isDense: false,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            prefixIcon: Icon(icon, color: const Color(0xff3a57e8), size: 24),
          ),
          value: value,
          onChanged: (String? newValue) {
            if (!editable) {
              return;
            }
            controller(newValue!);
          },
          items: editable
              ? items.entries
                  .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList()
              : [
                  DropdownMenuItem<String>(
                    value: value,
                    child: Text(items[value]!),
                  )
                ]),
    );
  }
}
