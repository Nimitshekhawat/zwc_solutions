import 'package:flutter/material.dart';
import 'package:zwcapp/screens/Comanies_locations.dart';
import 'package:zwcapp/screens/Sections_Screen.dart';
import 'package:zwcapp/screens/customwidgets.dart';

import '../Model/All_comaniesdata.dart';
import '../services/Companies_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Getallcompaniesmodel? _AssignedCompanies;
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchCompanydata();
  }

  // Get all companies data
  Future<void> _fetchCompanydata() async {
    CompaniesServices profileService = CompaniesServices();
    try {
      Getallcompaniesmodel? profile = await profileService.Gerallcompanies();
      setState(() {
        _AssignedCompanies = profile; // Update state with profile data
        _isLoading = false; // Set loading to false once data is fetched
      });
    } catch (error) {
      // Handle error if needed
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      print("Error fetching companies data: $error");
    }
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
                        text: "Assigned Companies",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Show loading indicator or companies list
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true, // Makes the ListView take only the needed height
                        physics: NeverScrollableScrollPhysics(), // Disables scrolling for the ListView
                        itemCount: _AssignedCompanies?.data.length ?? 0,
                        itemBuilder: (context, index) {
                          var company = _AssignedCompanies?.data[index];
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CompaniesLocation(userid: company!.id)),
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 14, top: 2, bottom: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextpoppinsExtraBold_18(
                                              text: company!.companyName,
                                              fontsize: 15.5,
                                              color: Colors.black,
                                              maxline: 2,
                                              textoverflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.5),
                                            TextpoppinsMedium_16(
                                              text: "Place: " + company.companyCity,
                                              fontsize: 14,
                                              color: Colors.black54,
                                              maxline: 1,
                                              textoverflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
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
                                        children: [
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
                                            top: 28,
                                            child: Container(
                                              height: 20,
                                              width: 16,
                                              child: Image.asset("assets/images/right_btn_arrow.png"),
                                            ),
                                          ),
                                        ],
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
