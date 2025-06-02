import 'package:dict_foot_traffic/Model/user.dart';
import 'package:dict_foot_traffic/Providers/user_provider.dart';
import 'package:dict_foot_traffic/Widgets/autocomplete.dart';
import 'package:dict_foot_traffic/Widgets/searchbar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddUserScreen extends ConsumerStatefulWidget {
  AddUserScreen({
    super.key,
  }) : ddval = User(
          brgy: "",
          contact: "",
          use: Uses.inquire.name,
          fullName: "",
          age: 15,
          gender: "",
          duplicate: 1,
        );

  User ddval;

  @override
  ConsumerState<AddUserScreen> createState() {
    return _AddUserScreenState();
  }
}

final textStyle = TextStyle(fontSize: 25);

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  //late String _enteredName, _bgry, _contact, _gender;
  String? _enteredName, _bgry, _contact, _gender;
  Uses use = Uses.internet;
  late int age;
  List<User>? vals = [];
  late final TextEditingController _nameController = TextEditingController(),
      _brgyController = TextEditingController(),
      _contactController = TextEditingController(),
      _genderController = TextEditingController(),
      _ageController = TextEditingController();
  int onlyUpdating = 0;

  String getVal() {
    return '';
  }

  void getInput(String val) {
    setState(() {
      _enteredName = val;
    });
  }

  void saveInputs() async {
    if (_enteredName == 'clearDBYurr') {
      ref.read(usersProvider.notifier).removeUser();
      Navigator.of(context).pop(true);
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _formKey.currentState!.save();
      });
    }

    if (_enteredName == null ||
        _bgry == null ||
        _contact == null ||
        _gender == null) {
      return;
    }

    final refer = ref.read(usersProvider.notifier);
    //refer.openDB();
    await refer.createUser(
      User(
        brgy: _bgry!,
        contact: _contact!,
        use: use.name,
        fullName: _enteredName!,
        age: age,
        gender: _gender!,
        duplicate: onlyUpdating,
      ),
    );
    //print(await refer.listed());
    // ref.read(usersProvider.notifier).addUser(
    //     _bgry!, _contact!, use, _enteredName!, age, _gender!, onlyUpdating);
    Navigator.of(context).pop(true);
  }

  void getUsersForVals() async {
    vals = await ref.read(usersProvider.notifier).getUsers();
    vals ??= [];
  }

  @override
  void initState() {
    super.initState();
    getUsersForVals();
  }

  void _optionClicked(User user) {
    //will get all values from the database and displays in the fields provided
    onlyUpdating = 1;
    setState(() {
      _enteredName = user.fullName;
      _nameController.text = _enteredName!;
      _bgry = user.brgy;
      _brgyController.text = _bgry!;
      _contact = user.contact;
      _contactController.text = _contact!;
      _gender = user.gender;
      age = user.age!;
      _genderController.text = _gender!;
      _ageController.text = age.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final vals = ref.read(usersProvider);
    // if (vals.isNotEmpty) {
    //   widget.ddval = vals.first;
    // }
    // final users = ref.watch(usersProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Searchbar(
                    nameController: _nameController,
                    getInput: getInput,
                    vals: vals!,
                    optionClicked: _optionClicked,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: DropdownButtonFormField(
                //       decoration: const InputDecoration(
                //         label: Text(
                //             "Barangay"), //TODO: Instead of DropDown make it searchable
                //       ),
                //       dropdownColor: Theme.of(context).colorScheme.onPrimary,
                //       value: barangays.Barangays.ZoneIVPoblacion,
                //       items: barangays.Barangays.values
                //           .map(
                //             (e) => DropdownMenuItem(
                //               value: e,
                //               child: Text(e.name.toUpperCase()),
                //             ),
                //           )
                //           .toList(),
                //       onChanged: (val) {}),
                // child: TextFormField(
                //   style: TextStyle(fontSize: 25),
                //   controller: _brgyController,
                //   decoration:
                //       const InputDecoration(label: Text("Barangay")),
                //   validator: (value) {
                //     if (value == null ||
                //         value.isEmpty ||
                //         value.trim().length <= 1 ||
                //         value.trim().length > 50) {
                //       return 'Please input your barangay';
                //     }
                //     return null; //no errors in the input
                //   },
                //   onSaved: (newValue) {
                //     _bgry = newValue!;
                //   },
                // ),
                // ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      style: textStyle,
                      controller: _contactController,
                      //keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text(
                        "Contact Number (0912 345 6789)",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return 'Please input your phone number';
                        }
                        return null; //no errors in the input
                      },
                      onSaved: (newValue) {
                        _contact = newValue!;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      style: textStyle,
                      controller: _genderController,
                      decoration: const InputDecoration(
                          label: Text(
                        "Gender (M/F)",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                      validator: (value) {
                        if (value == 'clear') {
                          _enteredName = value;
                          return null;
                        }
                        if (value == null ||
                            value.isEmpty ||
                            value.isEmpty ||
                            value.trim().length > 1) {
                          return 'Please input your Gender';
                        }
                        return null; //no errors in the input
                      },
                      onSaved: (newValue) {
                        _gender = newValue!;
                      },
                    )),
                const SizedBox(
                  width: 8,
                ),
                AutoCompleteCustom(
                  gotInitialVal: _bgry,
                  onSelected: (String val) {
                    _bgry = val;
                    print(_bgry);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            label: Text("Purpose of Visit"),
                          ),
                          padding: const EdgeInsets.only(top: 14),
                          alignment: Alignment.bottomCenter,
                          dropdownColor: Colors.black26,
                          value: use,
                          items: Uses.values
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name.toUpperCase()),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              use = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFormField(
                          style: textStyle,
                          controller: _ageController,
                          decoration: const InputDecoration(
                              label: Text(
                            "Age",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null) {
                              return 'Please input a valid age';
                            }
                            final val = int.tryParse(value);
                            if (value.isEmpty ||
                                value.trim().length <= 1 ||
                                value.trim().length >= 3 ||
                                val! <= 0) {
                              return 'Please input your Age';
                            }
                            return null; //no errors in the input
                          },
                          onSaved: (newValue) {
                            age = int.parse(newValue!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: saveInputs,
                      child: const Text('Log In'),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
