import 'package:flutter/material.dart';
import 'package:zwcapp/screens/Answer_Screen.dart';
import 'package:zwcapp/screens/customwidgets.dart';

var arr_Questions = [
  {
    'id': '1',
    'Question': 'Type of waste produced ?',
  },
  {
    'id': '2',
    'Question': 'Waste produced weekly / monthly / yearly ?',
  },
];

class Question_Screen extends StatefulWidget {
  const Question_Screen({super.key});

  @override
  State<Question_Screen> createState() => _Question_ScreenState();
}

class _Question_ScreenState extends State<Question_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Hr Section", context: context),
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
                      padding: const EdgeInsets.only(left: 12),
                      child: TextpoppinsExtraBold_18(
                        text: "Question",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 20,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15), // Add padding for the text
                          child: Text(
                            arr_Questions[1]['Question'] ?? "", // Use ?? to prevent null errors
                            style: TextStyle(fontSize: 20), // Set font size
                            maxLines: 3, // Limit the text to 3 lines
                            overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextpoppinsExtraBold_18(
                        text: "Do you want to answer this ?",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 27,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Answer_Screen()));
                                },
                                child: yes_skip(text: "Yes",textcolor: Colors.black)),
                            yes_skip(text: "Skip",bgcolor: Color(0xFFCDFFD2),textcolor: Colors.black),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
