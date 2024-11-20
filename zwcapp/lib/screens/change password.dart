import 'package:flutter/material.dart';

import '../Model/profile_page.dart';
import '../services/profile_page.dart';
import 'customwidgets.dart';

class changepassword extends StatefulWidget {
  const changepassword({super.key});

  @override
  State<changepassword> createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {
  ProfileModel? _profileData;

  // Text controllers for form fields
  TextEditingController old_password = TextEditingController();
  // TextEditingController Mobile = TextEditingController();
  // TextEditingController Emailid = TextEditingController();
  TextEditingController newpass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _fetchProfileData();
  }

  // Fetch profile data from API and update form fields

  // Method to send updated name and address to the API
  Future<void> _changepassword() async {
    String Old_password = old_password.text;
    String New_pass = newpass.text;
    String Confirm_pass = confirmpass.text;

    if (Old_password.isEmpty || New_pass.isEmpty ||Confirm_pass.isEmpty) {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    ProfileService profileService = ProfileService();
    bool success = await profileService.changepassword(Old_password,New_pass,Confirm_pass);

    if (success) {
      // Show success message and optionally navigate back or refresh data
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password Changed Successfully')));
      // Navigator.pop(context); // Go back after successful update
    } else {
      // Show error message if profile update failed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Enter the Correct Old password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Mainappbar(
          name: "Change Password",
          context: context,

        ),
      ),
      body:Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xFFD4EAD6),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      // Personal details rows
                      Center(child: _buildDetailRow( "Old Password",old_password, "Old password", TextInputType.text)),
                      // _buildDetailRow("Mobile", Mobile, "Enter Mobile", TextInputType.number),
                      Center(child: _buildDetailRow("New Password",newpass, "Enter new password", TextInputType.text)),
                      Center(child: _buildDetailRow( "Confirm Password",confirmpass, "Enter new password", TextInputType.text)),
                      SizedBox(
                        height: 22,
                      ),
                      Center(
                          child:InkWell(
                            onTap: _changepassword,
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
                  
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Divider(thickness: 2, color: Color(0xFF00BD15)),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 50),
                    ],
                  ),
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
      padding: const EdgeInsets.all(8.0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: TextpoppinsMedium_16(text: title,fontsize: 13.5),
          ),
                       SizedBox(height: 8,),
          text_field(
            context: context,
            controller: controller,
            hintText: hintText,
            keyboardType: keyboardType,
          ),
        ],
      ),
    );
  }
}
