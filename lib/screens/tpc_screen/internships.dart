import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/main_screen/widgets/common_basic_appbar.dart';

class InternShips extends StatelessWidget {
  const InternShips({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        title: Text("Internships",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontSize: 15, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.fade,),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: 5,
          itemBuilder: (context, index) {
          return InternshipCard();
        }
      ),
    );
  }
}

class InternshipCard extends StatelessWidget {
  const InternshipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          collapsedTextColor: Colors.white,
          collapsedIconColor: Colors.white,
          childrenPadding: EdgeInsets.symmetric(horizontal: 15),
          textColor: Colors.white,
          title: Text("Title",style: TextStyle(fontWeight: FontWeight.bold),),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Message can be longer so just writing it long enough to get an over view kitna lamba hoga",style: TextStyle(color: Colors.white),),
            SizedBox(
              height: 5,
            ),
            Container(alignment: Alignment.centerRight,child: Text("- Zeeshan",style: TextStyle(color: Colors.white),),),

            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf,),
                  title: Text("Document Attached"),
                  trailing: Icon(Icons.link),
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

