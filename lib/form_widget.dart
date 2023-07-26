import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

// class FormWidgetsDemo extends StatefulWidget {
//   const FormWidgetsDemo({super.key});

//   @override
//   State<FormWidgetsDemo> createState() => _FormWidgetsDemoState();
// }

// class _FormWidgetsDemoState extends State<FormWidgetsDemo> {
//   TextEditingController descriptionController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   String title = '';
//   String description = '';
//   DateTime date = DateTime.now();
//   double maxValue = 0;
//   bool? BrushedTeeth = false;
//   bool? FinishedHomework = false;
//   bool? PracticedTennis = false;
//   bool enableFeature = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // Clean up the controller when the widget is removed from the widget tree.
//     // This also removes the _printLatestValue listener.
//     descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stories of your day"),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Scrollbar(
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Card(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ...[
//                         TextFormField(
//                           decoration: const InputDecoration(
//                             filled: true,
//                             hintText: 'Reason...',
//                             labelText: 'Rate today /10',
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               title = value;
//                             });
//                           },
//                         ),
//                         TextFormField(
//                           controller: descriptionController,
//                           decoration: InputDecoration(
//                             border: const OutlineInputBorder(),
//                             filled: true,
//                             hintText:
//                                 'Write anything that happened today in 200 words...',
//                             labelText: 'Mood for the day',
//                             counterText:
//                                 "Word count: ${200 - descriptionController.text.length} ",
//                             // counter:
//                             //     Text("${descriptionController.text.length}"),
//                           ),
//                           maxLines: 5,
//                           maxLength: 200,
//                         ),
//                         _FormDatePicker(
//                           date: date,
//                           onChanged: (value) {
//                             setState(() {
//                               date = value;
//                             });
//                           },
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Approximate value',
//                                   style: Theme.of(context).textTheme.bodyLarge,
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               intl.NumberFormat.currency(
//                                       symbol: "\$", decimalDigits: 0)
//                                   .format(maxValue),
//                               style: Theme.of(context).textTheme.titleMedium,
//                             ),
//                             Slider(
//                               min: 0,
//                               max: 10,
//                               divisions: 10,
//                               value: maxValue,
//                               onChanged: (value) {
//                                 setState(() {
//                                   maxValue = value;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Checkbox(
//                               value: BrushedTeeth,
//                               onChanged: (checked) {
//                                 setState(() {
//                                   BrushedTeeth = checked;
//                                 });
//                               },
//                             ),
//                             Checkbox(
//                               value: FinishedHomework,
//                               onChanged: (checked) {
//                                 setState(() {
//                                   FinishedHomework = checked;
//                                 });
//                               },
//                             ),
//                             Checkbox(
//                               value: PracticedTennis,
//                               onChanged: (checked) {
//                                 setState(() {
//                                   PracticedTennis = checked;
//                                 });
//                               },
//                             ),
//                             Text('Brushed Teeth and Mouth',
//                                 style: Theme.of(context).textTheme.titleMedium),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text('Disable feature',
//                                 style: Theme.of(context).textTheme.bodyLarge),
//                             Switch(
//                               value: enableFeature,
//                               onChanged: (enabled) {
//                                 setState(() {
//                                   enableFeature = enabled;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ].expand(
//                         (widget) => [
//                           widget,
//                           const SizedBox(
//                             height: 24,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _FormDatePicker extends StatefulWidget {
//   final DateTime date;
//   final ValueChanged<DateTime> onChanged;

//   const _FormDatePicker({
//     required this.date,
//     required this.onChanged,
//   });

//   @override
//   State<_FormDatePicker> createState() => _FormDatePickerState();
// }

// class _FormDatePickerState extends State<_FormDatePicker> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               'Date',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             Text(
//               intl.DateFormat.yMd().format(widget.date),
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//           ],
//         ),
//         TextButton(
//           child: const Text('Edit'),
//           onPressed: () async {
//             var newDate = await showDatePicker(
//               context: context,
//               initialDate: widget.date,
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );

//             // Don't change the date if the date picker returns null.
//             if (newDate == null) {
//               return;
//             }

//             widget.onChanged(newDate);
//           },
//         )
//       ],
//     );
//   }
// }

// Define a custom Form widget.
// Define a custom Form widget.
class FormWidgetDemo extends StatefulWidget {
  const FormWidgetDemo({super.key});

  @override
  State<FormWidgetDemo> createState() => _FormWidgetDemoState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _FormWidgetDemoState extends State<FormWidgetDemo> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _printLatestValue();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    print('Second text field: ${myController.text.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              onChanged: (text) {
                print('First text field: $text');
              },
            ),
            TextField(
              controller: myController,
            ),
          ],
        ),
      ),
    );
  }
}
