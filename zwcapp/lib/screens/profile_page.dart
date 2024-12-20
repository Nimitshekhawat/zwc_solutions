import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwcapp/main.dart';
import 'package:zwcapp/screens/change%20password.dart';
import 'package:zwcapp/screens/customwidgets.dart';
import 'package:zwcapp/screens/login.dart';
import 'package:zwcapp/screens/splash_screen.dart';

import '../Model/profile_page.dart';
import '../services/profile_page.dart';
import 'Edit_profile_page.dart';
import 'Forget_password.dart';
import 'new_dashboard_design.dart';

class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  bool _notifications = false;
  bool _anotherFeature = false;
  ProfileModel? _profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Method to fetch profile data
  Future<void> _fetchProfileData() async {
    ProfileService profileService = ProfileService();
    ProfileModel? profile = await profileService.fetchProfileData();
    setState(() {
      _profileData = profile; // Update state with profile data
    });
  }

  // List<String> companiesAssigned = ["Tata", "Birla", "30 days", "Smarden", "Mahindra", "Jio"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(

          preferredSize: Size.fromHeight(60),
          child: Mainappbar(
              name: "Your Profile",
              iconpath: "assets/images/edit_pencil.png",
              context: context,
            ontap: _navigateAndRefresh,
            isback: false
          )
      ),


      body: _profileData == null // Check if profile data is null
          ? Center(child: CircularProgressIndicator()) // Show a loading spinner while data is being fetched
          : Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xFFdce6df),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Container(
                height: 230,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/profile_bg.png",
                      fit: BoxFit.fitWidth,
                    ),
                    Center(
                      child: Container(
                        height: 135,
                        width: 135,
                        child: CircleAvatar(
                          radius: 135,
                          backgroundImage: AssetImage("assets/images/profile_image.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextpoppinsExtraBold_18(text: "Personal Details"),
                    SizedBox(height: 9),
                    // Personal details rows
                    _buildDetailRow("Name", _profileData!.data.name),
                    _buildDetailRow("Mobile", _profileData!.data.phoneNum),
                    _buildDetailRow("Email id", _profileData!.data.email),
                    _buildDetailRow("Address", _profileData!.data.address),
                    SizedBox(height: 5),

                    // Divider line
                    Divider(thickness: 2, color: Color(0xFF00BD15)),
                    SizedBox(height: 10),


                    TextpoppinsExtraBold_18(text: "Account"),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>changepassword()));
                      },
                      child: Container(
                        height: 40,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.green.shade200,

                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Center(child: TextpoppinsMedium_16(text: "Change password")),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right:10),
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  child:Icon(Icons.chevron_right,color: Colors.black,size: 32,),
                                ),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>forgetpassword()));
                      },
                      child: Container(
                          height: 40,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.green.shade200,

                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Center(child: TextpoppinsMedium_16(text: "Forgot Password")),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right:10),
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  child:Icon(Icons.chevron_right,color: Colors.black,size: 32,),
                                ),
                              )
                            ],
                          )),
                    ),


                    SizedBox(height: 20),
                    Divider(thickness: 2, color: Color(0xFF00BD15)),
                    SizedBox(
                      height: 12,
                    ),

                    // General Settings
                    // _buildGeneralSettings(),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          NewDashboardDesignState.isloggedin=false;

                        });

                        var sharedPref = await SharedPreferences.getInstance();
                        sharedPref.setBool(SplashScreenState.KEYLOGIN, false);

                        // Navigate to the login page and clear all previous screens from the stack
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const Login();
                            },
                          ),
                              (_) => false,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Container(
                          height: 37,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFF1cad48),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 0.3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Textpoppinslight_16(
                              text: "Log out",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to navigate to EditProfilePage and refresh data on return
  Future<void> _navigateAndRefresh() async {
    // Wait for the EditProfilePage to pop
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
    // Fetch the updated profile data after popping the EditProfilePage
    _fetchProfileData();
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 1, child: TextpoppinsMedium_16(text: title)),
          Expanded(
            flex: 2,
            child: Textpoppinslight_16(
              text: value,
              textoverflow: TextOverflow.ellipsis, // Ensure your custom widget supports this
              maxline: 1, // Ensure your custom widget supports this
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildWorkDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           TextpoppinsExtraBold_18(text: "Work Details"),
  //           SizedBox(width: 8),
  //           Container(height: 19, child: Image.asset("assets/images/Work_beg.png")),
  //         ],
  //       ),
  //       SizedBox(height: 9),
  //       _buildDetailRow("Your Score", "7/10"),
  //       TextpoppinsMedium_16(text: "Companies Assigned"),
  //       // Container(
  //       //   height: 232,
  //       //   child: GridView.count(
  //       //     crossAxisCount: 3,
  //       //     crossAxisSpacing: 30.0,
  //       //     mainAxisSpacing: 14.0,
  //       //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
  //       //     children: List.generate(companiesAssigned.length, (index) {
  //       //       return Comapanies_box(Company_name: companiesAssigned[index]);
  //       //     }),
  //       //   ),
  //       // ),
  //       _buildDetailRow("Task pending", "7/10"),
  //     ],
  //   );
  // }

  // Widget _buildGeneralSettings() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           TextpoppinsExtraBold_18(text: "General Settings"),
  //           SizedBox(width: 8),
  //           Container(height: 19, child: Image.asset("assets/images/settings_icon.png")),
  //         ],
  //       ),
  //       SizedBox(height: 9),
  //       _buildSwitchRow("Notifications", _anotherFeature, (val) {
  //         setState(() {
  //           _anotherFeature = val;
  //         });
  //       }),
  //       _buildSwitchRow("Another Feature", _notifications, (val) {
  //         setState(() {
  //           _notifications = val;
  //         });
  //       }),
  //     ],
  //   );
  // }

  // Widget _buildSwitchRow(String title, bool value, Function(bool) onToggle) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         TextpoppinsMedium_16(text: title),
  //         FlutterSwitch(
  //           activeColor: Colors.green,
  //           value: value,
  //           onToggle: onToggle,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
