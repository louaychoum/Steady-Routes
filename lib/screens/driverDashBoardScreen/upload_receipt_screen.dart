import 'dart:io';

import 'package:flutter/material.dart';

import 'package:steadyroutes/widgets/upload_image.dart';
import 'package:steadyroutes/widgets/upload_receipt_info.dart';

class UploadReceiptScreen extends StatefulWidget {
  static const routeName = '/upload-receipt';

  @override
  _UploadReceiptScreenState createState() => _UploadReceiptScreenState();
}

class _UploadReceiptScreenState extends State<UploadReceiptScreen> {
  File? _images;
  final _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 20,
                  child: InteractiveViewer(
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                      child: _images == null
                          ? Image.asset(
                              'assets/images/receipt-placeholder.png',
                            )
                          : Image.file(
                              _images!,
                            ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _images == null
                        ? IconButton(
                            iconSize: 100,
                            tooltip: 'Upload Image',
                            color: iconColor,
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                            onPressed: () async {
                              _images ??=
                                  await settingModalBottomSheet(context);
                              setState(() {});
                            },
                          )
                        : IconButton(
                            iconSize: 100,
                            tooltip: 'Remove Image',
                            color: iconColor,
                            icon: const Icon(
                              Icons.close,
                            ),
                            onPressed: () {
                              _images = null;
                              setState(() {});
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: UploadedReceiptInfo(
              images: _images!,
              controller: _controller,
            ),
            // UploadReceiptInfo(formKey: _formKey, images: _images),
          ),
        ],
      ),
    );
  }
}
