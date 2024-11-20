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

class newCompanyAreas extends StatefulWidget {
  const newCompanyAreas({
    super.key,
    required this.userid,
    required this.companyname,
    required this.companyLocationname,
  });
  final String userid;
  final String companyname;
  final String companyLocationname;

  @override
  State<newCompanyAreas> createState() => _newCompanyAreasState();
}

class _newCompanyAreasState extends State<newCompanyAreas> {
  GetAllAreas? _LocationData;

  @override
  void initState() {
    super.initState();
    _fetchCompanyareabyid();
  }

  // Get all companies data
  Future<void> _fetchCompanyareabyid() async {
    CompaniesServices profileService = CompaniesServices();
    GetAllAreas? profile = await profileService.Getallareasbyid(widget.userid);
    setState(() {
      _LocationData = profile; // Update state with profile data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Areas", context: context),
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
                    const SizedBox(height: 27),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: TextpoppinsMedium_16(
                        text: widget.companyname,
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 16.5,
                        fontweight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: TextpoppinsMedium_16(
                        text: "Location : " + widget.companyLocationname,
                        color: Colors.black87,
                        textalign: TextAlign.start,
                        fontsize: 14,
                        fontweight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Check if _LocationData is null
                    _LocationData == null
                        ? Container(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                        ),
                      ),
                    ) // Show loading indicator
                        : ListView.builder(
                      shrinkWrap: true, // Makes the ListView take only the needed height
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _LocationData!.data.length,
                      itemBuilder: (context, index) {
                        var company = _LocationData!.data[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 7, bottom: 14, right: 7),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.17,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.0806,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF48965a), Color(0xFF9fad4e)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.topRight,
                                        ),
                                    ),
                                    child:  Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(11.0),
                                              child: TextpoppinsMedium_16(
                                                text: company.locationAreaName,
                                                color: Colors.white,
                                                fontsize: 17.5,
                                                fontweight: FontWeight.w600,
                                                maxline: 2,
                                                textoverflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              
                                    // child: Column(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   crossAxisAlignment: CrossAxisAlignment.center,
                                    //   children: [
                                    //     const SizedBox(height: 10),
                                    //
                                    //     const SizedBox(height: 10),
                                    //     // Padding(
                                    //     //   padding: const EdgeInsets.only(
                                    //     //       left: 8, right: 10, top: 2),
                                    //     //   child: Container(
                                    //     //     height: 27,
                                    //     //     child: Row(
                                    //     //       mainAxisAlignment:
                                    //     //       MainAxisAlignment
                                    //     //           .spaceBetween,
                                    //     //       children: [
                              
                                    //     //         Container(
                                    //     //           width: 110,
                                    //     //           child: Row(
                                    //     //             mainAxisAlignment:
                                    //     //             MainAxisAlignment
                                    //     //                 .spaceAround,
                                    //     //             children: [
                                    //     //               Container(
                                    //     //                 height: 20,
                                    //     //                 child: Image.asset(
                                    //     //                     "assets/images/location_img.png"),
                                    //     //               ),
                                    //     //               TextpoppinsMedium_16(
                                    //     //                 text: "Location",
                                    //     //                 color: Colors.white,
                                    //     //               ),
                                    //     //             ],
                                    //     //           ),
                                    //     //         ),
                                    //     //         Padding(
                                    //     //           padding:
                                    //     //           const EdgeInsets.only(
                                    //     //               right: 20),
                                    //     //           child: Container(
                                    //     //             height: 21,
                                    //     //             width: 60,
                                    //     //             decoration: BoxDecoration(
                                    //     //               color: Colors.white,
                                    //     //               borderRadius:
                                    //     //               BorderRadius
                                    //     //                   .circular(20),
                                    //     //               boxShadow: [
                                    //     //                 BoxShadow(
                                    //     //                     color: Colors
                                    //     //                         .black12,
                                    //     //                     spreadRadius: 3,
                                    //     //                     blurRadius: 2),
                                    //     //               ],
                                    //     //             ),
                                    //     //             child: Center(
                                    //     //               child:
                                    //     //               TextpoppinsMedium_16(
                                    //     //                 text: "Add",
                                    //     //                 color: Color(
                                    //     //                     0xFF0B8A14),
                                    //     //                 fontweight:
                                    //     //                 FontWeight.w700,
                                    //     //               ),
                                    //     //             ),
                                    //     //           ),
                                    //     //         )
                                    //     //       ],
                                    //     //     ),
                                    //     //   ),
                                    //     // )
                                    //   ],
                                    // ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     TextpoppinsMedium_16(
                                  //       text: "Task progress : ",
                                  //       fontsize: 16,
                                  //     ),
                                  //     SizedBox(
                                  //       width: 9,
                                  //     ),
                                  //     SimpleAnimationProgressBar(
                                  //       height: 19,
                                  //       width: MediaQuery.of(context)
                                  //           .size
                                  //           .width *
                                  //           0.30,
                                  //       backgroundColor:
                                  //       Color(0xFFFF5858),
                                  //       foregrondColor:
                                  //       Color(0xFF34F771),
                                  //       ratio: 0,
                                  //       direction: Axis.horizontal,
                                  //       curve:
                                  //       Curves.fastLinearToSlowEaseIn,
                                  //       duration:
                                  //       const Duration(seconds: 3),
                                  //       borderRadius:
                                  //       BorderRadius.circular(10),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PreAuditScreen(
                                                locationId: company.id,
                                              ), // Pass company ID here
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(11),
                                        color: Color(0xFF1cad48),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          TextpoppinsMedium_16(
                                              text: "Complete Servey",
                                              color: Colors.white,
                                              fontweight: FontWeight.w700,
                                          fontsize: 15),
                                          Container(
                                              height: 28,
                                              width: 29,
                                              child: Image.asset(
                                                  "assets/images/right_arrow_complete.png",fit: BoxFit.fill,)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
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
