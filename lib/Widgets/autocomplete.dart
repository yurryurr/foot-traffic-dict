import 'package:dict_foot_traffic/Data/barangays.dart';
import 'package:flutter/material.dart';

class AutoCompleteCustom extends StatefulWidget {
  const AutoCompleteCustom({
    super.key,
    required this.onSelected,
    this.gotInitialVal,
  });

  final Function(String selection) onSelected;
  final String? gotInitialVal;

  @override
  State<AutoCompleteCustom> createState() => _AutoCompleteCustomState();
}

class _AutoCompleteCustomState extends State<AutoCompleteCustom> {
  List<String> suggestions = barangays.map((e) => e).toList();

  @override
  Widget build(BuildContext context) {
    TextEditingController? textEditingController1 = widget.gotInitialVal != null
        ? TextEditingController(text: widget.gotInitialVal)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Autocomplete(
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) =>
                TextField(
          controller: textEditingController1 ?? textEditingController,
          focusNode: focusNode,
          onSubmitted: (value) => onFieldSubmitted(),
          decoration: InputDecoration(
            labelText: 'Search Barangay',
            labelStyle: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
            hintText: 'Type to search...',
            border: const OutlineInputBorder(),
          ),
        ),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return suggestions;
          }
          return suggestions.where((String option) {
            return option.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                );
          });
        },
        onSelected: widget.onSelected,
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Theme.of(context).primaryColorDark,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    tileColor: Theme.of(context).primaryColorDark,
                    title: Text(option, style: TextStyle(color: Colors.white)),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
