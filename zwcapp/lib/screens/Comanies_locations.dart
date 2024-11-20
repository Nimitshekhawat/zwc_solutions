import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:zwcapp/screens/New_Areas_screen.dart';
import 'package:zwcapp/screens/Sections_Screen.dart';
import 'package:zwcapp/screens/customwidgets.dart';
import 'package:zwcapp/screens/preaudit_question.dart';

import '../Model/All_comaniesdata.dart';
import '../Model/Locationmodel.dart';
import '../services/Companies_services.dart';
import 'Company_Areas_screen.dart';

class CompaniesLocation extends StatefulWidget {
  const CompaniesLocation({super.key, required this.userid,required this.companyname});
  final String userid;
  final String companyname;

  @override
  State<CompaniesLocation> createState() => _CompaniesLocationState(

  );
}

class _CompaniesLocationState extends State<CompaniesLocation> {
  LocationModel? _LocationData;

  @override
  void initState() {
    super.initState();
    _fetchCompanydataLocation();
  }

  // Get all companies data
  Future<void> _fetchCompanydataLocation() async {
    CompaniesServices profileService = CompaniesServices();
    LocationModel? profile = await profileService.Getallcompaniesbyid(widget.userid);
    setState(() {
      _LocationData = profile; // Update state with profile data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Locations", context: context),
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
                          fontsize: 18
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Check if _LocationData is null
                    _LocationData == null
                        ? Container(
                        height: 500,
                        child: Center(child: CircularProgressIndicator(color: Colors.greenAccent,))) // Show loading indicator
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),// Makes the ListView take only the needed height
                      itemCount: _LocationData!.data.length, // Access the length safely
                      itemBuilder: (context, index) {
                        var company = _LocationData!.data[index]; // Access company data safely
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => newCompanyAreas(userid: company.id,companyname: widget.companyname,companyLocationname: company.locationName,), // Pass company ID here
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 14, top: 4),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextpoppinsExtraBold_18(
                                              text: company.locationName, // Access company name
                                              fontsize: 15,
                                              color: Colors.black,
                                              maxline: 1,
                                              textoverflow: TextOverflow.ellipsis
                                          ),
                                          SizedBox(height: 4.5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              TextpoppinsMedium_16(
                                                  text: "Cont. Person: " , // Access company city
                                                  fontsize: 14,
                                                  color: Colors.black,
                                                  maxline: 1,
                                                  textoverflow: TextOverflow.ellipsis
                                              ),
                                              Flexible(
                                                child: TextpoppinsMedium_16(
                                                    text: company.contactPerson, // Access company city
                                                    fontsize: 14,
                                                    color: Colors.black54,
                                                    maxline: 2,
                                                    textoverflow: TextOverflow.visible
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                child: TextpoppinsMedium_16(text: "Task progress : " ,fontsize: 14),
                                              ),
                                              Container(
                                                child: SimpleAnimationProgressBar(
                                                  height: 15,
                                                  width: MediaQuery.of(context).size.width * 0.30,
                                                  backgroundColor: Color(0xFFFF5858),
                                                  foregrondColor: Color(0xFF34F771),
                                                  ratio: company.preCompletionPercentage != null ? double.tryParse(company.preCompletionPercentage) ?? 0.0 : 0.0,
                                                  direction: Axis.horizontal,
                                                  curve: Curves.fastLinearToSlowEaseIn,
                                                  duration: const Duration(seconds: 3),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // company.preAuditSubmitted == "0"
                                          //     ? Row(
                                          //
                                          //       children: [
                                          //         TextpoppinsMedium_16(
                                          //           text: "Status ",
                                          //           fontsize: 14,
                                          //           color: Colors.black, // You can customize the color
                                          //         ),
                                          //         SizedBox(width: 5,),
                                          //         TextpoppinsMedium_16(
                                          //           text: "Not Submitted",
                                          //           fontsize: 14,
                                          //           color: Colors.red, // You can customize the color
                                          //         ),
                                          //       ],
                                          //     ) : TextpoppinsMedium_16(
                                          //   text: "Status : Submitted",
                                          //   fontsize: 14,
                                          //   color: Colors.green, // You can customize the color
                                          // ),

                                          Row(
                                            children: [
                                              TextpoppinsMedium_16(
                                                          text: "Status ",
                                                          fontsize: 14,
                                                          color: Colors.black, // You can customize the color
                                                        ),

                                              SizedBox(
                                                width: 10,
                                              ),
                                              
                                              if(company.preCompletionPercentage!="0.00")
                                              TextpoppinsMedium_16(text: company.preCompletionPercentage+"% Completed ")
                                              else
                                                Textpoppinslight_16(text: "Not Started",fontsize: 14,color: Colors.redAccent,)
                                            ],
                                          ),

                                          SizedBox(height: 6),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Container to hold the ClipRRect and arrow image
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 136,
                                        decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF48965a), Color(0xFF9fad4e)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.topRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                            "assets/images/right_btn_arrow.png",
                                            height: 20,
                                    
                                            // Set width according to your design// Adjust width as necessary
                                            // This will ensure the image scales with the height
                                          ),
                                        ),
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
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
