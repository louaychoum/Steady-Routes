import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File> settingModalBottomSheet(BuildContext context) {
  File imageFile;
  return showModalBottomSheet<File>(
    context: context,
    builder: (BuildContext bc) {
      return SizedBox(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Capture receipt image'),
              onTap: () async {
                imageFile =
                    await _onImageButtonPressed(ImageSource.camera, context);
                Navigator.pop(context, imageFile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Upload receipt image from gallery'),
              onTap: () async {
                imageFile =
                    await _onImageButtonPressed(ImageSource.gallery, context);
                Navigator.pop(context, imageFile);
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<File> _onImageButtonPressed(
    ImageSource source, BuildContext context) async {
  final ImagePicker _picker = ImagePicker();
  try {
    final pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    //! This is to upload image
    // if (pickedFile != null) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       backgroundColor: Colors.teal,
    //       behavior: SnackBarBehavior.floating,
    //       content: Text('Uploading receiptpackage:steadyroutes.')));

    //   String jwt = Provider.of<AuthService>(context, listen: false).user.jwt;
    //   final SteadyApiService api =
    //       Provider.of<SteadyApiService>(context, listen: false);
    //   final bool uploadRes =
    //       await api.receiptsService.upload('jwt', File(pickedFile.path));

    //   if (uploadRes) {
    //     NavigationService.popUntilRoot();
    //     NavigationService.navigateTo(UploadReceiptScreen.routeName);
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         backgroundColor: Colors.red[900],
    //         content: const Text('Upload failed.'),
    //       ),
    //     );
    //   }
    // }
  } catch (e) {
    debugPrint(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[900],
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
  return null;
}
