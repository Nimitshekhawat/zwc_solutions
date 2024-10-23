import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwcapp/screens/Assigned_Companies.dart';
import 'package:zwcapp/screens/Edit_profile_page.dart';
import 'package:zwcapp/screens/profile_page.dart';

Widget Textpoppins400_16({
  required double fontsize,
  Color? color,
  required String? text,
  FontWeight? fontweight,
  TextOverflow? textoverflow,
  TextAlign? textalign,
  int? maxline
}) {
  return Text(
    text!,
    textAlign: textalign ??TextAlign.center,
    maxLines: maxline ?? 2,
    style: GoogleFonts.poppins(

        textStyle: TextStyle(
            fontSize: fontsize ?? 16,
            color: color ?? Color(0xFF6A6A6A),
            fontWeight: fontweight ?? FontWeight.w400,
            overflow: textoverflow ?? TextOverflow.ellipsis,

        ),
    ),
  );
}


Widget TextpoppinsExtraBold_18({
  double? fontsize,
  Color? color,
  required String? text,
  FontWeight? fontweight,
  TextOverflow? textoverflow,
  TextAlign? textalign,
  int? maxline
}) {
  return Text(
    text!,

    maxLines: maxline ?? 2,
    style: GoogleFonts.poppins(

      textStyle: TextStyle(
        fontSize: fontsize ??18,
        color: color ?? Color(0xFF40A047),
        fontWeight: fontweight ?? FontWeight.w700,
        overflow: textoverflow ?? TextOverflow.ellipsis,

      ),
    ),
  );
}

Widget TextpoppinsMedium_16({
  double? fontsize,
  Color? color,
  required String? text,
  FontWeight? fontweight,
  TextOverflow? textoverflow,
  TextAlign? textalign,
  int? maxline
}) {
  return Text(
    text!,

    maxLines: maxline ?? 2,
    style: GoogleFonts.poppins(

      textStyle: TextStyle(
        fontSize:  16 ?? fontsize,
        color: color ?? Colors.black,
        fontWeight: fontweight ?? FontWeight.w500,
        overflow: textoverflow ?? TextOverflow.ellipsis,

      ),
    ),
  );
}

class Textpoppinslight_16 extends StatelessWidget {
  final String text;
  final TextOverflow? textoverflow;
  final int? maxline;
  final Color color;


  const Textpoppinslight_16({
    Key? key,
    required this.text,
    this.color=Colors.black,
    this.textoverflow,
    this.maxline
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textoverflow??TextOverflow.clip,
      maxLines: maxline??1,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        color: color,// Adjust to your font family
      ),
    );
  }
}


//textfield
Widget text_field({
  required BuildContext context,
  required TextEditingController controller,
  required String? hintText,
  bool eye = true,
  double? width,
  double? height,
  double? fontSize,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  Color? color,
  int? maxlength,
  Border? border,
  Color? backColor,
  double? paddingSize,
  bool readOnly = false,
  required TextInputType keyboardType,
  bool obsecureText1 = true,
  TextInputType? inputType,
  String? font,
  EdgeInsetsGeometry? margin,
  List<TextInputFormatter>? inputFormatters,
  // bool enabled = true,
  VoidCallback? onTap,
  // VoidCallback? onDone,
}) {
  return Container(
    height: height ?? 50,
    width: width ?? MediaQuery.of(context).size.width * 0.80,
    // margin:  margin ??  EdgeInsets.only(left: paddingSize?? 10, top: paddingSize?? 10, bottom:paddingSize?? 10,right:paddingSize?? 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      // border: Border.all(color: const Color(0xffB3BBCB)),
      color: backColor ?? Colors.white,
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,

          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: fontSize ?? 14,
                    color: Color(0xFF898989),
                    fontWeight: fontWeight ?? FontWeight.w400)),

            // // focusedBorder: OutlineInputBorder(
            // //   borderRadius: BorderRadius.circular(10),
            // //   borderSide: BorderSide(
            // //       color: Color(0xFF7CAB05),
            // //       width: 2
            // //   ),
            //
            //
            // ),

            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 13.0),
            isDense: true,
          ),

          // style: ,
        ),
      ),
    ),
  );
}
Widget iconandtext({
  required String icon_image,
  required String icon_text,
}) {
  return Container(
    height: 90,
    width: 90,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      children: [
        SizedBox(height: 2),
        Container(
          height: 40,
          width: 40,
          child: Image.asset(icon_image),
        ),
        SizedBox(height: 4), // Add some spacing between the icon and text
        Center( // Center the text horizontally
          child: Textpoppins400_16(
            fontsize: 14,
            text: icon_text,
            color: Colors.black,
            fontweight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2),
      ],
    ),
  );
}


//custom app bar

Widget dashboard_appbar({
  required String name,
  required String iconpath,
  required BuildContext context,
}){
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Color(0xFFB1EAB5),
    shadowColor: Colors.black ,
    elevation: 3,

    title:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Textpoppins400_16(
          fontsize: 30,
          text: "ZWC",
          fontweight: FontWeight.w900,
          color: Colors.black,
        ),
        Row(
          children: [
            InkWell(
              onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AssignedCompanies()));
              },
              child: Container(
                  height: 36,
                  width: 45,
                  child: Image.asset("assets/images/Companies_icon.png")),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>profilepage()));
              },
              child: CircleAvatar(
                minRadius: 25,
                maxRadius: 26,
                backgroundImage:
                AssetImage("assets/images/profile_image.png"),
                backgroundColor: Colors.black,
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget Mainappbar({
  required String name,
  String? iconpath,
   Widget? wheretogo,
  VoidCallback? ontap,
  required BuildContext context,

}){
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor:  Color(0xFFB1EAB5),
    shadowColor:Colors.black,
    elevation: 3,
    title:Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                    height:20 ,
                    width:16,
                    child: Image.asset("assets/images/back_icon.png"))),
            Expanded(
                flex: 2,
                child: Container(child: Textpoppins400_16(fontsize: 20, text:name,fontweight: FontWeight.bold,maxline: 1,color: Colors.black))),
            if (iconpath != null)
              InkWell(
                onTap: ontap,
                child: Container(
                  height: 22,
                  width: 16,
                  child: Image.asset(iconpath),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}


Widget Comapanies_box({
  required String Company_name,
}){
  return Container(
    height: 70,
    width: 90,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color(0xFFA9E9A6)
    ),
    child: Center(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(child: Textpoppins400_16(fontsize: 14, text: Company_name,maxline: 3,fontweight: FontWeight.w500,textoverflow: TextOverflow.ellipsis)),
    )),
  );

}

