import 'package:flutter/material.dart';

class UserTypeDropDown extends StatefulWidget {
  const UserTypeDropDown({super.key, required this.onchange});
  final Function(String?) onchange;
  @override
  State<UserTypeDropDown> createState() => _UserTypeDropDownState();
}

class _UserTypeDropDownState extends State<UserTypeDropDown> {
  String? type = 'Farmer';
  @override
  void initState() {
    super.initState();
    widget.onchange(type);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: type,
      decoration: const InputDecoration(
        labelText: "User Type",
        border: OutlineInputBorder(),
      ),
      hint: const Text("Select Type"),
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Transform.rotate(
          angle: -1.5708,
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      items: const [
        DropdownMenuItem(value: "Farmer", child: Text("Farmer")),
        DropdownMenuItem(value: "merchant", child: Text("merchant")),
      ],
      onChanged: (value) {
        setState(() {
          type = value;
        });

        widget.onchange(value);
      },
    );
  }
}
