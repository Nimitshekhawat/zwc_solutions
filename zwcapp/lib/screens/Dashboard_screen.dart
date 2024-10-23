import 'package:flutter/material.dart';
import 'package:zwcapp/screens/customwidgets.dart';

// Icon paths
List<String> iconPaths = [
  "assets/images/camera_icon.png",
  "assets/images/calculator.png",
  "assets/images/camera_icon.png",
  "assets/images/camera_icon.png",
  "assets/images/camera_icon.png",
  "assets/images/camera_icon.png",
];

// Text list
List<String> iconTexts = [
  "Capture Images",
  "Calculations",
  "Capture Images",
  "Capture Images",
  "Capture Images",
  "Capture Images",
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(

          preferredSize: Size.fromHeight(60),
          child: dashboard_appbar(name: "ZWC", iconpath: "assets/images/profile_image.png", context: context)
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white, // Set the background color for the entire page
        child: SafeArea(

          child: Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  // Company logo and profile

                  SizedBox(height: 20),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:5),
                          child: Textpoppins400_16(
                            fontsize: 20,
                            text: "Hi ,",
                            fontweight: FontWeight.w500,
                            color: Colors.black
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Textpoppins400_16(
                            fontsize: 20,
                            text: "Nimit Shekhawat",
                            fontweight: FontWeight.w500,
                            color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      color: Colors.green[50],
                      // color: Color(0xFFDCF9DF),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    height: 240,
                    child: GridView.count(
                      crossAxisCount: 3, // Number of columns
                      mainAxisSpacing: 10, // Space between rows
                      crossAxisSpacing: 30,
                      children: List.generate(iconPaths.length, (index) {
                        return iconandtext(
                          icon_image: iconPaths[index],
                          icon_text: iconTexts[index],
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Textpoppins400_16(
                    fontsize: 19,
                    text: "About Me",
                    color: Colors.black,
                    fontweight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,

                    decoration:BoxDecoration(
                      color: Colors.brown[100],
                      border: Border.all(
                        color: Colors.black12
                      ),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10,top: 5),
                          child: Textpoppins400_16(fontsize: 22, text: "Today's Score",color: Colors.brown,textalign: TextAlign.left),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
                          child: Row(
                            children: [
                              Textpoppins400_16(fontsize: 25, text: "71 %",color: Colors.black,fontweight: FontWeight.w600),
                              SizedBox(width: 10,),

                              Icon(Icons.check_circle,color: Colors.black,size: 30,),
                              SizedBox(width: 90,),
                              Textpoppins400_16(fontsize: 25, text: "29%",color: Colors.black,fontweight: FontWeight.w600),
                              SizedBox(width: 4,),
                              Icon(Icons.close,color: Colors.black,size: 30,),
                              SizedBox(width: 4,),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,

                    decoration:BoxDecoration(
                        color: Colors.brown[100],
                        border: Border.all(
                            color: Colors.black12
                        ),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10,top: 5),
                          child: Textpoppins400_16(fontsize: 22, text: "Today's Score",color: Colors.brown,textalign: TextAlign.left),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
                          child: Row(
                            children: [
                              Textpoppins400_16(fontsize: 25, text: "71 %",color: Colors.black,fontweight: FontWeight.w600),
                              SizedBox(width: 10,),

                              Icon(Icons.check_circle,color: Colors.black,size: 30,),
                              SizedBox(width: 90,),
                              Textpoppins400_16(fontsize: 25, text: "29%",color: Colors.black,fontweight: FontWeight.w600),
                              SizedBox(width: 4,),
                              Icon(Icons.close,color: Colors.black,size: 30,),
                              SizedBox(width: 4,),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Textpoppins400_16(
                    fontsize: 19,
                    text: "News",
                    color: Colors.black,
                    fontweight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,

                    decoration:BoxDecoration(
                        color: Colors.deepPurpleAccent[100],
                        border: Border.all(
                            color: Colors.black12
                        ),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10,top: 5),
                          child: Textpoppins400_16(fontsize: 22, text: "Today's Score",color: Colors.white,textalign: TextAlign.left),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
                          child: Row(
                            children: [
                              Textpoppins400_16(fontsize: 25, text: "71 %",color: Colors.black,fontweight: FontWeight.w600),
                              SizedBox(width: 10,),

                              Icon(Icons.check_circle,color: Colors.black,size: 30,),
                              SizedBox(width: 90,),
                              Textpoppins400_16(fontsize: 25, text: "29%",color: Colors.black,fontweight: FontWeight.w600),
                              SizedBox(width: 4,),
                              Icon(Icons.close,color: Colors.black,size: 30,),
                              SizedBox(width: 4,),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,

                    decoration:BoxDecoration(
                        color: Color(0xFFb9b26c),
                        border: Border.all(
                            color: Colors.black12
                        ),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10,top: 5),
                          child: Textpoppins400_16(fontsize: 22, text: "Today's Score",color: Colors.white,textalign: TextAlign.left),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
                          child: Row(
                            children: [
                              Textpoppins400_16(fontsize: 25, text: "71 %",color: Colors.black,fontweight: FontWeight.w600),
                              SizedBox(width: 10,),

                              Icon(Icons.check_circle,color: Colors.black,size: 30,),
                              SizedBox(width: 90,),
                              Textpoppins400_16(fontsize: 25, text: "29%",color: Colors.black,fontweight: FontWeight.w600),
                              SizedBox(width: 4,),
                              Icon(Icons.close,color: Colors.black,size: 30,),
                              SizedBox(width: 4,),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                  SizedBox(
                    height: 600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
