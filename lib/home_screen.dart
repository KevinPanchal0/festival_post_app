import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:festival_post_app/screen/history_screen.dart';
import 'package:festival_post_app/utils/editor_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_image_editor/modules/main_editor/main_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ExampleHelperState<HomeScreen> {
  List carouselSlider = [
    'assets/post/post_1.jpg',
    'assets/post/post_2.jpg',
    'assets/post/post_3.jpg',
    'assets/post/post_4.jpeg'
  ];

  List<Map<String, dynamic>> festivalImage = [
    {
      'title': 'Diwali',
      'image': 'assets/images/diwali.png',
    },
    {
      'title': 'Navratri',
      'image': 'assets/images/dandiya-raas.png',
    },
    {
      'title': 'Holi',
      'image': 'assets/images/holi.png',
    },
    {
      'title': 'Uttarayan',
      'image': 'assets/images/kite.png',
    },
    {
      'title': 'Christmas',
      'image': 'assets/images/xmastree.png',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 12,
        shadowColor: Colors.grey,
        centerTitle: true,
        title: const Text('Festival Editor App'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(
            height: 50,
          ),
          CarouselSlider.builder(
            itemCount: carouselSlider.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return Image.asset(
                carouselSlider[itemIndex],
                fit: BoxFit.cover,
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              height: 250.h,
              viewportFraction: 0.7,
              // aspectRatio: 3.0,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: List.generate(festivalImage.length, (index) {
                  return InkWell(
                    onTap:  kIsWeb
                        ? null
                        : () async {
                      // Navigator.pop(context);

                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(type: FileType.image);

                      if (result != null && context.mounted) {
                        File file = File(result.files.single.path!);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProImageEditor.file(
                              file,
                              onImageEditingComplete:
                              onImageEditingComplete,
                              onCloseEditor: onCloseEditor,
                              allowCompleteWithEmptyEditing: true,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      // width: 180.h,
                      // height: 210,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: Offset(4, 4))
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            festivalImage[index]['image'],
                            height: 70.h,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            festivalImage[index]['title'],
                            style: TextStyle(color: Colors.black,fontSize: 25.sp),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                })),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[300],
        shadowColor: Colors.blue,
        surfaceTintColor: Colors.orange,
        child: ListView(

          children:  [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DrawerHeader(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(50),
                  child: Text('Festival Editor App',style: TextStyle(color: Colors.black,),),
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.transparent
                  ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HistoryScreen()));
                    },
                    child: const Text('History',style: TextStyle(color: Colors.black,fontSize: 30),)
                ),
               ],
            ),
          ],
        ),
      ),
    );
  }
}
