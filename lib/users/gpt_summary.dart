import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GPTSummaryScreen extends StatefulWidget {
  const GPTSummaryScreen({
    super.key,
  });

  @override
  State<GPTSummaryScreen> createState() => _GPTSummaryScreenState();
}

class _GPTSummaryScreenState extends State<GPTSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPT Summary"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            ],
          ),
        ),
      ),
    );
  }
}