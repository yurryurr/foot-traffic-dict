import 'package:flutter/material.dart';
import 'package:dict_foot_traffic/Model/user.dart';

// ignore: must_be_immutable
class Searchbar extends StatelessWidget {
  Searchbar(
      {super.key,
      required this.nameController,
      required this.getInput,
      required this.vals,
      required this.optionClicked});
  TextEditingController nameController;
  final void Function(String) getInput;
  final List<User?> vals;
  final void Function(User user) optionClicked;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<User>(displayStringForOption: (option) {
      return option.fullName;
    }, optionsViewBuilder: (context, onSelected, options) {
      return ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              optionClicked(options.elementAt(index));
              nameController.text = options.elementAt(index).fullName;
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: 34,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 8),
              color: Theme.of(context).primaryColorDark,
              child: Text(
                options.elementAt(index).fullName,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          );
        },
      );
    }, optionsBuilder: (textEditingValue) {
      getInput(textEditingValue.text);
      if (textEditingValue.text.isEmpty) {
        return List.empty();
      }
      final showAutoComplete = vals.where(
        (element) {
          return element!.fullName
              .toUpperCase()
              .startsWith(textEditingValue.text.toUpperCase());
        },
      ).toList();
      List<User> checkDups = [];
      bool addOrNot = true;
      for (final x in showAutoComplete) {
        for (final y in checkDups) {
          if (x!.fullName == y.fullName) {
            addOrNot = false;
            break;
          }
          addOrNot = true;
        }
        if (addOrNot) {
          checkDups.add(x!);
        }
      }

      //return showAutoComplete.map((e) => e!,);
      return checkDups.map(
        (e) => e,
      );
    }, onSelected: (option) {
      optionClicked(option);
    }, fieldViewBuilder:
        (context, textEditingController, focusNode, onFieldSubmitted) {
      nameController = textEditingController;
      return TextFormField(
        style: TextStyle(fontSize: 25),
        controller: nameController,
        focusNode: focusNode,
        decoration: const InputDecoration(
          label: Text(
            'Input your name: ex. DELA CRUZ, JUAN L. (LAST NAME FIRST)',
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        onSaved: (newValue) {
          if (newValue == null) {
            return;
          }
          getInput(newValue);
        },
        validator: (value) {
          if (value == null) {
            return 'Please input your name:';
          }
          if (value.isEmpty ||
              value.trim().length <= 1 ||
              value.trim().length > 75) {
            return 'Please input your name:';
          }
          return null;
        },
      );
    });
  }
}
