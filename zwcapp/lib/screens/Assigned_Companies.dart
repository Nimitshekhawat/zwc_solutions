import 'package:flutter/material.dart';
import 'package:zwcapp/screens/profile_page.dart';
import 'customwidgets.dart';

List<Map<String, String>> assignedCompaniesList = [
  {
    'Company_name': 'Tata',
    'desc': 'Here short information about company can be displayed, later we add the company location as well.',
  },
  {
    'Company_name': 'Smarden',
    'desc': 'Here short information about company can be displayed, later we add the company location as well.',
  },
  {
    'Company_name': 'Mahindra',
    'desc': 'Here short information about company can be displayed, later we add the company location as well.',
  },
];

class AssignedCompanies extends StatefulWidget {
  const AssignedCompanies({super.key});

  @override
  State<AssignedCompanies> createState() => _AssignedCompaniesState();
}

class _AssignedCompaniesState extends State<AssignedCompanies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Mainappbar(
          name: "Companies",
          context: context,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xFFD9EADA),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 37),
              TextpoppinsMedium_16(text: "Assigned Companies", fontsize: 18),
              SizedBox(height: 20),
              Expanded( // Use Expanded or Flexible here
                child: ListView.builder(
                  itemCount: assignedCompaniesList.length,
                  itemBuilder: (context, index) {
                    var company = assignedCompaniesList[index];
                    return Column(
                      children: [
                        Assigned_Companies_card(
                          Companyname: company['Company_name']!,
                          Companydescription: company['desc']!,
                          Navigate_path: profilepage(),
                          context: context,
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget Assigned_Companies_card({
  required String Companyname,
  required String Companydescription,
  required Widget Navigate_path,
  required BuildContext context,
}) {
  return Card(
    elevation: 4,
    child: Container(
      height: 155,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Left side
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  TextpoppinsMedium_16(text: Companyname),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 7),
                    child: SizedBox(
                      width: 260,
                      child: Textpoppinslight_16(
                        text: Companydescription,
                        maxline: 4,
                        color: Color(0xFF979797),
                        textoverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Navigate_path));
            },
            child: Container(
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Color(0xFF86C981),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    child: Image.asset("assets/images/right_arrow.png"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
