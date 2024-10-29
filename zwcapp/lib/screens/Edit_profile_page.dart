import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwcapp/screens/splash_screen.dart';

import '../Model/profile_page.dart';
import '../services/profile_page.dart';
import 'customwidgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  ProfileModel? _profileData;

  // Text controllers for form fields
  TextEditingController Name = TextEditingController();
  // TextEditingController Mobile = TextEditingController();
  // TextEditingController Emailid = TextEditingController();
  TextEditingController Address = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Fetch profile data from API and update form fields
  Future<void> _fetchProfileData() async {
    ProfileService profileService = ProfileService();
    ProfileModel? profile = await profileService.fetchProfileData();
    setState(() {
      _profileData = profile;
      // Populate the form fields with existing data
      Name.text = _profileData?.data.name ?? '';
      // Mobile.text = _profileData?.data.phoneNum ?? '';
      // Emailid.text = _profileData?.data.email ?? ''; // Example if you want to update email
      Address.text = _profileData?.data.address ?? ''; // Assuming address exists in the data model
    });
  }

  // Method to send updated name and address to the API
  Future<void> _submitProfile() async {
    String updatedName = Name.text;
    String updatedAddress = Address.text;

    if (updatedName.isEmpty || updatedAddress.isEmpty) {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    ProfileService profileService = ProfileService();
    bool success = await profileService.editProfile(updatedName, updatedAddress);

    if (success) {
      // Show success message and optionally navigate back or refresh data
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      // Navigator.pop(context); // Go back after successful update
    } else {
      // Show error message if profile update failed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Mainappbar(
          name: "Edit Profile",
          context: context,

        ),
      ),
      body: _profileData == null // Check if profile data is null
          ? Center(child: CircularProgressIndicator()) // Show a loading spinner while data is being fetched
          : Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xFFD4EAD6),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextpoppinsExtraBold_18(text: "Personal Details"),
                    SizedBox(height: 9),
                    // Personal details rows
                    _buildDetailRow("Name", Name, "Enter Name", TextInputType.text),
                    // _buildDetailRow("Mobile", Mobile, "Enter Mobile", TextInputType.number),
                    _buildDetailRow("Address", Address, "Enter Address", TextInputType.text),
                    SizedBox(
                      height: 18,
                    ),
                    Center(
                      child:InkWell(
                        onTap: _submitProfile,
                        child: Container(
                          height: 40,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Color(0xFF37B943),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow:[
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 1.3,
                                spreadRadius: 1.2
                              )
                            ]

                          ),
                          child: Center(child: TextpoppinsMedium_16(text: "Submit",color: Colors.white,)),
                        ),
                      )
                    ),
                    SizedBox(height: 18),

                    Divider(thickness: 2, color: Color(0xFF00BD15)),
                    SizedBox(height: 10),
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

  // Method to build input fields with labels
  Widget _buildDetailRow(String title, TextEditingController controller, String hintText, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 1, child: TextpoppinsMedium_16(text: title)),
          Expanded(
            flex: 2,
            child: text_field(
              context: context,
              controller: controller,
              hintText: hintText,
              keyboardType: keyboardType,
            ),
          ),
        ],
      ),
    );
  }
}
