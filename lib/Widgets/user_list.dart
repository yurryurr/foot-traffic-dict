import 'package:dict_foot_traffic/Model/user.dart';
import 'package:dict_foot_traffic/Providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserList extends ConsumerStatefulWidget {
  UserList({
    super.key,
  }) : ddval = User(
            age: 0,
            brgy: '',
            contact: '',
            fullName: 'NONE',
            gender: '',
            use: Uses.inquire.name,
            duplicate: 1);
  User ddval;
  @override
  ConsumerState<UserList> createState() => _UserListState();
}

class _UserListState extends ConsumerState<UserList> {
  // User ddval = User(
  //   brgy: '',
  //   contact: '',
  //   use: Uses.internet,
  //   fullName: 'NONE',
  //   age: 10,
  //   gender: 'm',
  // );
  @override
  Widget build(BuildContext context) {
    final vals = ref.read(usersProvider).toList();

    return DropdownButton(
      dropdownColor: Colors.black26,
      value: widget.ddval.fullName,

      items: [
        for (var v in vals)
          DropdownMenuItem(
            value: v,
            child: Text(
              v.fullName,
            ),
          ),
      ],
      // vals
      //     .map(
      //       (e) => DropdownMenuItem(
      //         value: e,
      //         child: Text(e.fullName),
      //       ),
      //     )
      //     .toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }
        setState(() {
          widget.ddval = value as User;
        });
      },
    );
    // return DropdownButton(
    //   dropdownColor: Colors.black26,
    //   value: ddval,
    //   items:
    //   vals
    //       .map(
    //         (e) => DropdownMenuItem(
    //           value: e,
    //           child: Text(e.fullName),
    //         ),
    //       )
    //       .toList(),
    //   onChanged: (value) {
    //     if (value == null) {
    //       return;
    //     }
    //     setState(() {
    //       ddval = value;
    //     });
    //   },
    // );
    //return SizedBox(child: DropdownButton(items: , onChanged: onChanged),);
  }
}
