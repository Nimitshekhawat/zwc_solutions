import 'package:flutter/material.dart';

import '../Model/profile_page.dart';
import '../services/profile_page.dart';
import 'customwidgets.dart';

class forgetpassword extends StatefulWidget {
  const forgetpassword({super.key});

  @override
  State<forgetpassword> createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {
  ProfileModel? _profileData;

  // Text controllers for form fields
  TextEditingController emailid = TextEditingController();


  @override
  void initState() {
    super.initState();
    // _fetchProfileData();
  }

  // Fetch profile data from API and update form fields

  // Method to send updated name and address to the API
  Future<void> _forgetpassword() async {
    String Email_id = emailid.text;


    if (Email_id.isEmpty) {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Enter the Email id first')));
      return;
    }

    ProfileService profileService = ProfileService();
    bool success = await profileService.forgetpasswordservice(Email_id);

    if (success) {
      // Show success message and optionally navigate back or refresh data
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password sent successfully')));
      // Navigator.pop(context); // Go back after successful update
    } else {
      // Show error message if profile update failed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Mainappbar(
          name: "Forgot Password",
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70,),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),

                        // Personal details rows
                        Center(child: _buildDetailRow( "Email id ",emailid, "Enter email id ", TextInputType.emailAddress)),
                        SizedBox(
                          height: 22,
                        ),
                        Center(
                            child:InkWell(
                              onTap: _forgetpassword,
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

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 10,right: 10),
                        //   child: Divider(thickness: 2, color: Color(0xFF00BD15)),
                        // ),
                        SizedBox(height: 10),
                        SizedBox(height: 50),
                      ],
                    ),
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
            child: TextpoppinsMedium_16(text: title,fontsize: 16,color: Colors.white,fontweight: FontWeight.w600),
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
