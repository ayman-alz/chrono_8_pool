import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String? hint;
  final TextEditingController savecontroller;
  final String? Function(String?) valid ;

  const CustomTextForm({Key? key, required this.valid ,  required this.hint , required this.savecontroller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator:valid,
        controller: savecontroller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            hintText: hint,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
