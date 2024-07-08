import 'package:flutter/material.dart';

class FAQCard extends StatelessWidget {
  final faqTitle;
  final faqContent;

  FAQCard({required this.faqContent,required this.faqTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          collapsedTextColor: Colors.white,
          textColor: Colors.white,
          title: Text(faqTitle),
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(faqContent,style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
