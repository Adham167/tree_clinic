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
      isExpanded: true,
      menuMaxHeight: 250,
      borderRadius: BorderRadius.circular(16),
      dropdownColor: Colors.white,

      decoration: const InputDecoration(labelText: "User Type"),

      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.green),

      items: const [
        DropdownMenuItem(
          value: "Farmer",
          child: Row(
            children: [
              Icon(Icons.agriculture_sharp, color: Colors.green),
              SizedBox(width: 12),
              Text("Farmer"),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "Merchant",
          child: Row(
            children: [
              Icon(Icons.store_rounded, color: Colors.green),
              SizedBox(width: 12),
              Text("Merchant"),
            ],
          ),
        ),
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
