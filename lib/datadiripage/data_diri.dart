import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';  

class Datadiri extends StatefulWidget {
  const Datadiri({ Key? key }) : super(key: key);

  @override
  State<Datadiri> createState() => _DatadiriState();
  
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const Datadiri(),
    );
  }
}

class CustomWidgets {
  static Widget textField(String title,
      {
      bool isNumber = false,
      int? length,
      TextEditingController? textController,
      int lines = 1,
      var cornerRadius = 0.0}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.normal, 
              fontFamily: 'Oppen-sans',
              color: Color(0xff355070),
              fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: lines,
            controller: textController,
            maxLength: length,
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ],
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cornerRadius),
                      ),
                fillColor: Colors.transparent,
                ),
          )
        ],
      ),
    );
  }
}

class CustomSizedbox {
  static Widget box(String title,
      {
      var cornerRadius = 0.0}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.normal, 
              fontFamily: 'Oppen-sans',
              color: Color(0xff355070),
              fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class _DatadiriState extends State<Datadiri> {
  File? _image;
  File? _foto;
  final picker = ImagePicker();

  Future uploadImageToFirebase1(BuildContext context) async {
    String fileName = basename(_image!.path);
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance
        .ref().child('KTP').child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_image!.path), metadata);
    firebase_storage.UploadTask task= await Future.value(uploadTask);
    Future.value(uploadTask).then((value) => {
    print("Upload file path ${value.ref.fullPath}")
    }).onError((error, stackTrace) => {
      print("Upload file path error ${error.toString()} ")
    });
  }
  // Future<List<Map<String, dynamic>>> _loadImages() async {
  //   List<Map<String, dynamic>> files = [];

  //   final ListResult result = await value.ref().list();
  //   final List<Reference> allFiles = result.items;

  //   await Future.forEach<Reference>(allFiles, (file) async {
  //     final String fileUrl = await file.getDownloadURL();
  //     final FullMetadata fileMeta = await file.getMetadata();
  //     files.add({
  //       "url": fileUrl,
  //       "path": file.fullPath,
  //       "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
  //       "description":
  //           fileMeta.customMetadata?['description'] ?? 'No description'
  //     });
  //   });

  //   return files;
  // }

   Future getImageFromGallery1() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 800,
      imageQuality: 100,
      );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera1() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 800,
      imageQuality: 100,);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      getImageFromGallery1();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImageFromCamera1();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Isi Data Pribadi', 
        style: TextStyle(
          color: Color.fromRGBO(53, 80, 112, 1),
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              CustomWidgets.textField('NIK',isNumber: true, length: 16, cornerRadius: 10.0),
              CustomWidgets.textField('Alamat', cornerRadius: 10.0),
              CustomWidgets.textField('Tanggal Lahir',isNumber: true, length: 10, cornerRadius: 10.0),
              CustomWidgets.textField('Kota Lahir', cornerRadius: 10.0),
              Row(children: [
                CustomSizedbox.box('Upload KTP'),
              ],) ,
              InkWell(
              onTap: () {
                _showPicker(context);
              },
              child: _image == null ? Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      width: 400,
                      height: 200,
                      child: const Icon(
                        CupertinoIcons.camera,
                        color: Colors.grey,
                      ),
                    )
                  : Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      width: 400,
                      height: 170,
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(children: [
                CustomSizedbox.box('Upload Swafoto dengan KTP'),
              ],) ,
              InkWell(
              onTap: () {
                _showPicker2(context);
              },
              child: _foto == null ? Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      width: 400,
                      height: 200,
                      child: const Icon(
                        CupertinoIcons.camera,
                        color: Colors.grey,
                      ),
                    )
                  : Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      width: 400,
                      height: 170,
                      child: Image.file(
                        _foto!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
              buildButton(context),
              const SizedBox(height: 20,)
          ],
        ),
      ),
    )
    );
  }
  Widget buildButton(BuildContext context){
    return RawMaterialButton(
                onPressed: () {
                 uploadImageToFirebase1(context);
                 uploadImageToFirebase2(context);
                }, 
                fillColor: const Color.fromRGBO(53, 80, 112, 1), 
                constraints: const BoxConstraints(minHeight: 49, minWidth: 128),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: 
                  const TextStyle(
                  color: Colors.white, 
                  fontFamily: 'Poppins',
                  fontSize: 15, 
                  fontWeight: FontWeight.w500, 
                ),
                child: const Text(
                  'Simpan'),
              );
  }
  Future uploadImageToFirebase2(BuildContext context) async {
    String fileName = basename(_foto!.path);
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance
        .ref().child('SwafotoKTP').child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_foto!.path), metadata);
    firebase_storage.UploadTask task= await Future.value(uploadTask);
    Future.value(uploadTask).then((value) => {
    print("Upload file path ${value.ref.fullPath}")
    }).onError((error, stackTrace) => {
      print("Upload file path error ${error.toString()} ")
    });
  }
   //Image Picker function to get image from gallery
   Future getImageFromGallery2() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 800,
      imageQuality: 100,
      );

    setState(() {
      if (pickedFile != null) {
        _foto = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera2() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 800,
      imageQuality: 100,);

    setState(() {
      if (pickedFile != null) {
        _foto = File(pickedFile.path);
      }
    });
  }

  void _showPicker2(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      getImageFromGallery2();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImageFromCamera2();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}