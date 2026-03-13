// import 'package:car_wash/models/master_address.dart';
// import 'package:flutter/material.dart';
//
// class SearchableDropdownField extends StatefulWidget {
//   final String label;
//   final Future<List<MasterAddress>> Function(String query) fetchItems;
//   final Function(MasterAddress) onSelected;
//
//   const SearchableDropdownField({
//     super.key,
//     required this.label,
//     required this.fetchItems,
//     required this.onSelected,
//   });
//
//   @override
//   State<SearchableDropdownField> createState() => _SearchableDropdownFieldState();
// }
//
// class _SearchableDropdownFieldState extends State<SearchableDropdownField> {
//   List<MasterAddress> suggestions = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return RawAutocomplete<MasterAddress>(
//       optionsBuilder: (TextEditingValue textEditingValue) async {
//         if (textEditingValue.text.length < 2) {
//           return const Iterable<MasterAddress>.empty();
//         }
//
//         suggestions = await widget.fetchItems(textEditingValue.text);
//         return suggestions;
//       },
//
//       displayStringForOption: (option) => option,
//
//       onSelected: (value) {
//         widget.onSelected(value);
//       },
//
//       fieldViewBuilder: (
//           context,
//           controller,
//           focusNode,
//           onFieldSubmitted,
//           ) {
//         return TextField(
//           controller: controller,
//           focusNode: focusNode,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             labelText: widget.label,
//             labelStyle: const TextStyle(color: Colors.white),
//             enabledBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//           ),
//         );
//       },
//
//       optionsViewBuilder: (context, onSelected, options) {
//         return Align(
//           alignment: Alignment.topLeft,
//           child: Material(
//             color: Colors.black,
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.9,
//               constraints: const BoxConstraints(maxHeight: 200),
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: options.length,
//                 itemBuilder: (context, index) {
//                   final option = options.elementAt(index);
//
//                   return ListTile(
//                     title: Text(
//                       option.societyName,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     onTap: () {
//                       onSelected(option);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }