import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DayDetailScreen extends StatefulWidget {
  const DayDetailScreen({
    super.key,
    required this.info,
    required this.date
  });

  final Map info;
  final String date;

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.date),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.network(widget.info["picURL"]),
              const SizedBox(height: 20),
              Text(
                'Title: ${widget.info["title_for_today"]}',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize:25,
                  ),
                ),
              ),
              Text(
                'Mood of the day: \n ${widget.info["mood_of_the_day"]}',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize:25,
                  ),
                ),
              ),
              const Divider(),
              Text(
                'A bit of Advice: \n ${widget.info["AI_response"]}',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize:25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}