import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';

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
      initialValue: type,
      isExpanded: true,
      menuMaxHeight: 250,
      borderRadius: BorderRadius.circular(16),
      dropdownColor: Colors.white,

      decoration: InputDecoration(labelText: context.tr('User Type')),

      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.green),

      items: [
        DropdownMenuItem(
          value: "Farmer",
          child: Row(
            children: [
              const Icon(Icons.agriculture_sharp, color: Colors.green),
              const SizedBox(width: 12),
              Text(context.tr("Farmer")),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "Merchant",
          child: Row(
            children: [
              const Icon(Icons.store_rounded, color: Colors.green),
              const SizedBox(width: 12),
              Text(context.tr("Merchant")),
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
