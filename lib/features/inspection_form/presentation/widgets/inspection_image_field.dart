import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:offline_first_inspection/core/theme/app_pallete.dart';
import 'package:offline_first_inspection/core/utils/pick_image.dart';

class InspectionImageField extends StatefulWidget {
  const InspectionImageField({super.key});

  @override
  State<InspectionImageField> createState() => _InspectionImageFieldState();
}

class _InspectionImageFieldState extends State<InspectionImageField> {
  List<String> selectedTopics = [];
  File? image;

  @override
  Widget build(BuildContext context) {
    // ClipRRect(
    //               borderRadius: .circular(15),
    //               child: buildBlogImage(
    //                 NetworkImageSource(url: blog.imageUrl),
    //               ), // Image.network(blog.imageUrl),
    //             ),

    return image != null
        ? GestureDetector(
            onTap: selectImage,
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: ClipRRect(
                borderRadius: .circular(10),
                child: Image.file(image!, fit: .cover),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              selectImage();
            },
            child: const DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(10),
                color: AppPallete.greyColor,
                dashPattern: [10, 4],
                strokeCap: StrokeCap.round,
              ),

              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(Icons.folder_open, size: 40),
                    SizedBox(height: 15),
                    Text('Select your image', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
          );
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }
}
