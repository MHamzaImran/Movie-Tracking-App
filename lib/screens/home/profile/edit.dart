import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_tracker/global_widgets/toast_block.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../../global_widgets/appbar_widget.dart';
import '../../../global_widgets/responsive.dart';
import '../../../global_widgets/text_widget.dart';
import '../../../models/theme.dart';
import '../../../theme/data.dart';

class EditProfile extends StatefulWidget {
  final String userId;
  final String name;
  final String email;
  final String profilePic;
  const EditProfile(
      {Key? key,
      required this.name,
      required this.profilePic,
      required this.userId,
      required this.email})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  File imageFile = File('');
  TextEditingController nameController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  bool isBase64ImageTooLarge(String base64Image, int maxLength) {
    try {
      final List<int> decodedBytes = base64Decode(base64Image);
      return decodedBytes.length < maxLength;
    } catch (e) {
      // Handle decoding errors if necessary
      return true;
    }
  }

  updateProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (imageFile.path.isNotEmpty) {
        if (isBase64ImageTooLarge(imageFile.path, 1048487)) {
          String tempPic = await convertImageToBase64(imageFile.path);
          await fireStore.collection('users').doc(widget.userId).set({
            'email': widget.email,
            'displayName':
                nameController.text.isEmpty ? widget.name : nameController.text,
            'photoURL': tempPic,
            // Add other user data as needed
          });
          toastBlock('Profile Updated Successfully');
          if(!mounted) return;
          Navigator.pop(context);
        } else {
          toastBlock('Image size is too large');
        }
      } else {
        await fireStore.collection('users').doc(widget.userId).set({
          'email': widget.email,
          'displayName': nameController.text,
          'photoURL': widget.profilePic,
          // Add other user data as needed
        });
        toastBlock('Profile Updated Successfully');
        if(!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      toastBlock(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getImageFromGallery(source) async {
    var image = await _imagePicker.pickImage(source: source);
    setState(() {
      imageFile = File(image!.path);
    });
  }

  showProfileImage() {
    if (imageFile.path.isNotEmpty) {
      return FileImage(imageFile,);
    } else if (widget.profilePic != '') {
      return MemoryImage(base64Decode(widget.profilePic));
    } else {
      return const AssetImage('assets/profile.png');
    }
  }

  Future<String> convertImageToBase64(String imagePath) async {
    try {
      List<int> imageBytes = await File(imagePath).readAsBytes();
      String base64String = base64Encode(imageBytes);
      return base64String;
    } catch (e) {
      return ''; // Handle the error as needed
    }
  }

  @override
  initState() {
    super.initState();
    nameController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Edit Profile',
            centerTitle: false,
            showBackButton: true,
          )),
      backgroundColor: themeController.backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: screenHeight(context) * 2,
          ),
          Center(
            child: Container(
              height: screenHeight(context) * 20,
              width: screenWidth(context) * 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: showProfileImage(),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: screenHeight(context) * 5,
                  width: screenWidth(context) * 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeController.textColor,
                  ),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: screenWidth(context) * 41,
                              padding: EdgeInsets.symmetric(
                                  vertical: screenWidth(context) * 3),
                              decoration: BoxDecoration(
                                color: themeController.backgroundColor,
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      getImageFromGallery(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                    leading: Icon(
                                      Icons.camera_alt,
                                      color: themeController.textColor,
                                      size: screenWidth(context) * 6,
                                    ),
                                    dense: true,
                                    title: text(
                                        title: 'Take a Picture',
                                        fontSize: screenWidth(context) * 3.2,
                                        color: AppTheme.darkTextColor),
                                  ),
                                  Container(
                                    height: .2,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth(context) * 7),
                                    width: double.infinity,
                                    color: AppTheme.lightTextColor,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      getImageFromGallery(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                    leading: Icon(
                                      Icons.image,
                                      color: themeController.textColor,
                                      size: screenWidth(context) * 6,
                                    ),
                                    dense: true,
                                    title: text(
                                        title: 'Choose from Gallery',
                                        fontSize: screenWidth(context) * 3.2,
                                        color: AppTheme.darkTextColor),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Icon(
                      Icons.camera_alt,
                      color: themeController.cardColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight(context) * 2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth(context) * 5,
                vertical: screenHeight(context) * 1),
            child: TextFormField(
              controller: nameController,
              style: TextStyle(
                color: themeController.textColor,
              ),
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(
                  color: themeController.textColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: themeController.textColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    
                    color: themeController.textColor,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          // update button
          Container(
            width: double.infinity,
            height: screenHeight(context) * 5,
            margin: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  toastBlock('Please enter your name');
                } else {
                  await updateProfile();
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? Padding(
                      padding: EdgeInsets.all(
                        screenWidth(context) * 1,
                      ),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    )
                  : text(
                      title: 'Update',
                      color: Colors.white,
                      fontSize: screenWidth(context) * 3,
                    ),
            ),
          ),
          SizedBox(
            height: screenHeight(context) * 8,
          ),
        ],
      ),
    );
  }
}
