import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key, required this.placeHolder})
      : super(key: key);

  final String placeHolder;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      placeholder: placeHolder,
      autofocus: false,
      style: const TextStyle(color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      itemColor: Colors.black,
      prefixInsets: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      onChanged: (value) {},
      onSubmitted: (value) {},
    );
  }
}
