import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'customwidgets.dart';
import 'package:zwcapp/screens/preaudit_question.dart';

class SubmittedAnsTextVid extends StatelessWidget {
  final Answer answer;

  const SubmittedAnsTextVid({Key? key, required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Submitted Answers", context: context),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          TextpoppinsMedium_16(text: "Answered By :",fontsize: 14,color: Colors.black),
                          SizedBox(
                            width: 15,
                          ),
                          TextpoppinsMedium_16(text: "${answer.answeredBy}",fontsize: 14,color: Colors.black87),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8,left: 8,right: 8),
                      child: Row(
                        children: [
                          TextpoppinsMedium_16(text: "Time :",fontsize: 14,color: Colors.black),
                          SizedBox(
                            width: 15,
                          ),
                          TextpoppinsMedium_16(text: "${answer.time}",fontsize: 14,color: Colors.black87),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2,top: 1,left: 0,right: 8),
                              child: Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextpoppinsMedium_16(text: "Answer",fontsize: 13,color: Colors.grey),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      TextpoppinsMedium_16(text: answer.answerText,color: Colors.black87),
                                    ],
                                  )
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextpoppinsMedium_16(text: "Pictures and Videos"),
                    ),
                    const SizedBox(height: 16),
                    if (answer.answerMedia != null && answer.answerMedia!.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: answer.answerMedia!.length,
                        itemBuilder: (context, index) {
                          final mediaUrl = answer.answerMedia![index];
                          if (mediaUrl.endsWith('.jpg') ||
                              mediaUrl.endsWith('.jpeg') ||
                              mediaUrl.endsWith('.png')) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenGallery(
                                      images: answer.answerMedia!,
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                mediaUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text('Error loading image');
                                },
                              ),
                            );
                          } else if (mediaUrl.endsWith('.mp4') ||
                              mediaUrl.endsWith('.mov')) {
                            return CustomVideoPlayer(videoUrl: mediaUrl);
                          } else {
                            return  Container(
                              height: 20,
                                width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Textpoppinslight_16(text: "No data here",fontsize: 14,),
                              ),
                            );
                          }
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

class FullScreenGallery extends StatelessWidget {
  final List<String> images; // This can include both image and video URLs
  final int initialIndex;

  const FullScreenGallery({Key? key, required this.images, required this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Photos and Videos", context: context),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final mediaUrl = images[index];

          if (mediaUrl.endsWith('.jpg') || mediaUrl.endsWith('.jpeg') || mediaUrl.endsWith('.png')) {
            // Show image with PhotoView
            return PhotoView(
              imageProvider: NetworkImage(mediaUrl),
              heroAttributes: PhotoViewHeroAttributes(tag: mediaUrl),
            );
          } else if (mediaUrl.endsWith('.mp4') || mediaUrl.endsWith('.mov')) {
            // Show video using CustomVideoPlayer
            return Center(
              child: CustomVideoPlayer(videoUrl: mediaUrl),
            );
          } else {
            // Handle unsupported media
            return Center(
              child: const Text('Unsupported media type'),
            );
          }
        },
      ),
    );
  }
}

