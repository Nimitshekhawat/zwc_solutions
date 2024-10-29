import 'package:flutter/material.dart';
import 'package:zwcapp/screens/Question_screen.dart';
import 'package:zwcapp/screens/customwidgets.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

var AssignedSections = [
  {
    'name':'HR',
    'Location':'location',
    'progress_bar':'0.7'
  },
  {
    'name':'Toilet',
    'Location':'location',
    'progress_bar':'0.3'

  },
  {
    'name':'Painting',
    'Location':'location',
    'progress_bar':'0.0'
  },


];

class Section_Screen extends StatefulWidget {
  const Section_Screen({super.key});

  @override
  State<Section_Screen> createState() => _Section_ScreenState();
}

class _Section_ScreenState extends State<Section_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Company", context: context)
      ),
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/dashboard_background.png',
              fit: BoxFit.fill,
            ),
          ),

          // Positioned Container with scrollable list
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: TextpoppinsExtraBold_18(
                          text: "Sections",
                          color: Colors.black,
                          textalign: TextAlign.start,
                          fontsize: 20
                      ),
                    ),
                    const SizedBox(height: 7),
                    ListView.builder(
                      shrinkWrap: true, // Makes the ListView take only the needed height
                      // physics: NeverScrollableScrollPhysics(), // Disables scrolling for the ListView
                      itemCount: AssignedSections.length,
                      itemBuilder: (context, index) {
                        final value = AssignedSections[index];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>Question_Screen()));
                            },
                            child: Container(
                              height: 79,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                // boxShadow: [
                                //   BoxShadow(
                                //     spreadRadius: 1,
                                //     blurRadius: 1,
                                //     color: Colors.black12,
                                //   )
                                // ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 14,top: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextpoppinsExtraBold_18(text: value['name'].toString(),fontsize: 18,color: Colors.black),
                                          TextpoppinsMedium_16(text: value['Location'].toString(),fontsize: 16,color: Colors.black54),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: SimpleAnimationProgressBar(
                                      height: 23,
                                      width: MediaQuery.of(context).size.width*0.30,
                                      backgroundColor: Color(0xFFA4FCC0),
                                      foregrondColor: Color(0xFF34F771),
                                      ratio:value['progress_bar'] != null ? double.tryParse(value['progress_bar']!) ?? 0.0 : 0.0,
                                      direction: Axis.horizontal,
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      duration: const Duration(seconds: 3),
                                      borderRadius: BorderRadius.circular(10),
                                      // gradientColor: const LinearGradient(
                                      //     colors: [Color(0xFF34F771), Colors.greenAccent[200]]),
                                      //

                                      //   boxShadow: [
                                      //   // BoxShadow(
                                      //   //   color: Colors.lightGreen,
                                      //   //   // offset: const Offset(
                                      //   //   //   2.0,
                                      //   //   //   6.0,
                                      //   //   // ),
                                      //   //   blurRadius: 1.0,
                                      //   //   spreadRadius: 1.0,
                                      //   // ),
                                      // ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),

                                  Container(
                                    width: 63,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Stack(

                                        children:[
                                          ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                            child: Image.asset(
                                              "assets/images/green_btn_bg.png",
                                              fit: BoxFit.fitWidth,
                                            ),

                                          ),
                                          Positioned(
                                            left: 25,
                                            top:28,
                                            child: Container(
                                                height: 20,
                                                width: 16,
                                                child: Image.asset("assets/images/right_btn_arrow.png")),
                                          )
                                        ]
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white, // Set to white color
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12, // Optional shadow for elevation effect
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, -3), // Shadow above the container
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Savebtn(text: "Draft",bgcolor: Colors.white,border: 0.8,textcolor: Color(0xFF37B943)),

            Savebtn(text: "Save"),
          ],
        ),
      ),

    );

  }
}
