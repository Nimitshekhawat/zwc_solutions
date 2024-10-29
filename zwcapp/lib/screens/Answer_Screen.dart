import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zwcapp/screens/Question_screen.dart';
import 'package:zwcapp/screens/customwidgets.dart';

var arr_Questions = [
  {
    'id': '1',
    'Question': 'Type of waste produced ?',
  },
  {
    'id': '2',
    'Question': 'Waste produced weekly / monthly / yearly ?',
  },
];



class Answer_Screen extends StatefulWidget {
  const Answer_Screen({super.key});

  @override
  State<Answer_Screen> createState() => _Answer_ScreenState();
}

class _Answer_ScreenState extends State<Answer_Screen> {
  TextEditingController answer = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  Future<void> _pickImagesFromGallery() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> _takeImageWithCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Hr Section", context: context),
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
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextpoppinsExtraBold_18(
                        text: "Question",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 20,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            arr_Questions[1]['Question'] ?? "",
                            style: TextStyle(fontSize: 20),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextpoppinsExtraBold_18(
                        text: "Your Answer",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 18,
                      ),
                    ),
                    SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: answertext_field(
                          context: context,
                          controller: answer,
                          height: 200,
                          hintText: "Fill your answer here ",
                          keyboardType: TextInputType.text,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextpoppinsExtraBold_18(
                        text: "Images",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImagesFromGallery,
                          icon: Icon(Icons.photo_library,color: Colors.green,),
                          label: Textpoppinslight_16(text: "Upload Image"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _takeImageWithCamera,
                          icon: Icon(Icons.camera_alt,color: Colors.green,),
                          label: Text("Take a Photo"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _images.isNotEmpty
                        ? GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            // Display image
                            Positioned.fill(
                              child: Image.file(
                                _images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Delete button
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 12,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                        : Center(child: Text("No images selected")),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white, // Set to white color
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12, // Optional shadow for elevation effect
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, -3), // Shadow above the container
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [


            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Question_Screen()));
                },
                child: Savebtn(text: "Continue")),
          ],
        ),
      ),
    );
  }
}
