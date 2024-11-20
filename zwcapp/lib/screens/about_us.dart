import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:zwcapp/Model/Get_all_areas.dart';
import 'package:zwcapp/screens/Sections_Screen.dart';
import 'package:zwcapp/screens/customwidgets.dart';
import 'package:zwcapp/screens/preaudit_question.dart';

import '../Model/All_comaniesdata.dart';
import '../Model/Locationmodel.dart';
import '../services/Companies_services.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});


  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  GetAllAreas? _LocationData;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Mainappbar(name: "About Us", context: context,isback: false),
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
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child:
          // ),
        ],
      ),
    );
  }
}
