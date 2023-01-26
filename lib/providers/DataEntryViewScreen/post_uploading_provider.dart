import 'package:flutter/material.dart';

//Provider for monitoring when post is uploading or is uploading slow
class PostUploadProvider extends ChangeNotifier {

  //Used for displaying CircularProgressIndicator
  bool _isPostUploadDelayed = false;
  
  //Used for preventing duplicate sending and changing button text and container colors
  bool _isPostUploading = false;

  bool get isPostUploadDelayed => _isPostUploadDelayed;
  bool get isPostUploading => _isPostUploading;


  set isPostUploadDelayed(bool isPostUploadDelayed) {
    _isPostUploadDelayed = isPostUploadDelayed;
    notifyListeners();
  }
    set isPostUploading(bool isPostUploading) {
    _isPostUploading = isPostUploading;
    notifyListeners();
  }
}
