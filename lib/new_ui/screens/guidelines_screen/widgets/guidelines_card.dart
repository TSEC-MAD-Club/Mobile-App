import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';

class GuidelinesCard extends StatelessWidget {
  final Map inputGuideline;
  const GuidelinesCard({super.key, required this.inputGuideline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: commonbgLightblack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: timePickerBorder, width: 1.0,),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  inputGuideline['title'],
                  style: TextStyle(fontSize: 16, color: Color(0xFFFFFFDE), fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if(inputGuideline['content'].runtimeType == String)
                Text(inputGuideline['content'], style: TextStyle(fontSize: 12, color: Colors.grey),),
                if(inputGuideline.containsKey('points'))
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: inputGuideline['points'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(inputGuideline['points'][index], style: TextStyle(fontSize: 12, color: Colors.grey),),
                      );
                    },
                  )
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: inputGuideline['content'].length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    //print(inputGuideline['content'][index]);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //sub title and then list of points
                        if(inputGuideline['content'].runtimeType != String)
                          Text(inputGuideline['content'][index]['subtitle'],
                            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold,
                            ),
                          ),
                        if(inputGuideline['content'].runtimeType != String)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: inputGuideline['content'][index]['subPoints'].length,
                            itemBuilder: (context, subindex){
                              if(inputGuideline['content'][index]['subPoints'][subindex].containsKey("words")) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    inputGuideline['content'][index]['subPoints'][subindex]["words"],
                                    style: TextStyle(fontSize: 12, color: Colors.grey),),);
                              }
                              else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.grey, // Box background color
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0), // Image corner radius
                                        child: Image.network(inputGuideline['content'][index]['subPoints'][subindex]["image"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                      ],
                    );
                  },
                )
            ]
          ),
        ),
      ),
    );
  }
}
