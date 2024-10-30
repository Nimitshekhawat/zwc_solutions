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

class CompanyAreas extends StatefulWidget {
  const CompanyAreas({super.key, required this.userid});
  final String userid;

  @override
  State<CompanyAreas> createState() => _CompanyAreasState();
}

class _CompanyAreasState extends State<CompanyAreas> {
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
        child: dashboard_appbar(name: "ZWC", iconpath: "assets/images/profile_image.png", context: context),
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
                      child: TextpoppinsExtraBold_18(
                          text: "Areas",
                          color: Colors.black,
                          textalign: TextAlign.start,
                          fontsize: 20
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Check if _LocationData is null
                    _LocationData == null
                        ? Center(child: CircularProgressIndicator()) // Show loading indicator
                        : ListView.builder(
                      shrinkWrap: true, // Makes the ListView take only the needed height
                      itemCount: _LocationData!.data.length, // Access the length safely
                      itemBuilder: (context, index) {
                        var company = _LocationData!.data[index]; // Access company data safely
                        return Padding(
                          padding: const EdgeInsets.only(top: 10,left: 7,bottom: 10,right: 7),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreAuditScreen(locationId: company.id), // Pass company ID here
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
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 14, top: 2),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextpoppinsExtraBold_18(
                                              text: company.locationAreaName, // Access company name
                                              fontsize: 16.5,
                                              color: Colors.black,
                                              maxline: 1,
                                              textoverflow: TextOverflow.ellipsis
                                          ),
                                          SizedBox(height: 7,),
                                          TextpoppinsMedium_16(
                                              text: "Cont. Person : " + company.contactPerson, // Access company city
                                              fontsize: 15,
                                              color: Colors.black54,
                                              maxline: 1,
                                              textoverflow: TextOverflow.ellipsis
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  // Container to hold the ClipRRect and arrow image
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              "assets/images/green_btn_bg.png",
                                              fit: BoxFit.fill, // Ensure it fits the container
                                            ),

                                            Positioned(
                                              top:45,

                                              left: 30,

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
                                            ),
                                          ],
                                        ),
                                      ),
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
    );
  }
}
