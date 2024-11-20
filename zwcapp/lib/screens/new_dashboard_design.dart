import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_ccc/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:persistent_bottom_nav_bar_ccc/persistent_tab_view.dart';
import 'package:zwcapp/screens/Comanies_locations.dart';
import 'package:zwcapp/screens/Sections_Screen.dart';
import 'package:zwcapp/screens/about_us.dart';
import 'package:zwcapp/screens/customwidgets.dart';
import 'package:zwcapp/screens/profile_page.dart';
import 'package:zwcapp/screens/splash_screen.dart';

import '../Model/All_comaniesdata.dart';
import '../Model/profile_page.dart';
import '../services/Companies_services.dart';
import '../services/profile_page.dart';

class NewDashboardDesign extends StatefulWidget {
  const NewDashboardDesign({super.key});

  @override
  State<NewDashboardDesign> createState() => NewDashboardDesignState();
}

class NewDashboardDesignState extends State<NewDashboardDesign> {
  Getallcompaniesmodel? _AssignedCompanies;
  static bool isloggedin=true;
  bool _isLoading = true;
  ProfileModel? _profileData;

  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _fetchCompanydata();
  }

  Future<void> _fetchCompanydata() async {
    CompaniesServices profileService = CompaniesServices();
    ProfileService profileServices = ProfileService();
    try {
      Getallcompaniesmodel? profile = await profileService.Gerallcompanies();
      ProfileModel? profiles = await profileServices.fetchProfileData();
      setState(() {
        _AssignedCompanies = profile;
        _profileData = profiles;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching companies data: $error");
    }
  }

  List<Widget> _buildScreens() {
    return [
      _buildDashboard(),
      AboutUs(),
      profilepage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        textStyle: TextStyle(color: Colors.white), // This will ensure the default text color is white
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white, // This will set the title color to white when active
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.people_alt_outlined),
        title: ("About us"),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white, // This will set the title color to white when active
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.white, // This will set the title color to white when active
      ),
    ];
  }

  Widget _buildDashboard() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: dashboard_appbar_bgimg(
          name: "ZWC",
          iconpath: "assets/images/profile_image.png",
          context: context,
          height: 94,
          backgroundImage: "assets/images/app_bg_img.png",
        ),
      ),
      body: _isLoading
          ? Container(
        height: 500,
        child: Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
      )
          : Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/dashboard_background.png',
              fit: BoxFit.fill,
            ),
          ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          TextpoppinsMedium_16(
                            text: "Assigned Companies",
                            color: Colors.black,
                            textalign: TextAlign.start,
                            fontsize: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 1, right: 1),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics:NeverScrollableScrollPhysics(),// This ensures that the list takes only the space it needs
                        itemCount: _AssignedCompanies?.data.length ?? 0,
                        itemBuilder: (context, index) {
                          final Company = _AssignedCompanies?.data[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 12, left: 7, right: 7),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(5, 5),
                                        color: Colors.black26,
                                        spreadRadius: 1,
                                        blurRadius: 2
                                    )
                                  ]
                              ),
                              height: 200,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF48965a), Color(0xFF9fad4e)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TextpoppinsMedium_16(
                                              text: Company!.companyName,
                                              maxline: 3,
                                              textoverflow: TextOverflow.visible,
                                              color: Colors.white,
                                              fontsize: 17,
                                              fontweight: FontWeight.w700
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13, top: 8, bottom: 1),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        TextpoppinsMedium_16(
                                            text: "E-mail :  ",
                                            fontsize: 14.5,
                                            color: Colors.black),
                                        TextpoppinsMedium_16(
                                            text: Company.companyEmail,
                                            fontsize: 14.5,
                                            color: Colors.black54,
                                            maxline: 1,
                                            textoverflow: TextOverflow.visible),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13, bottom: 2),
                                    child: Row(
                                      children: [
                                        TextpoppinsMedium_16(
                                            text: "State   :   ",
                                            fontsize: 14.5,
                                            color: Colors.black),
                                        TextpoppinsMedium_16(
                                            text: Company.state,
                                            fontsize: 14.5,
                                            color: Colors.black54),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    height: 34,
                                    width: 110,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(0xFF1cad48)),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CompaniesLocation(
                                              userid: Company!.id,
                                              companyname: Company.companyName,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Center(
                                          child: TextpoppinsMedium_16(
                                              text: "Enter", color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

  @override
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : 60.0,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(8.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style7,
    );
        // Or any screen for non-logged-in users
  }


}
