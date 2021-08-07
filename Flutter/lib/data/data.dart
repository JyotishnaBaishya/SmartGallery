// ignore: unused_import
import 'dart:ui';

import 'package:flutter/material.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel(
      {required this.imageAssetPath, required this.title, required this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  // ignore: deprecated_member_use
  // List<SliderModel> slides = new List<SliderModel>();
  List<SliderModel> slides = [];
  SliderModel sliderModel =
      new SliderModel(desc: '', imageAssetPath: '', title: '');

  //1
  sliderModel.setDesc("1. Sign Up using your Google ID.");
  sliderModel.setTitle("Sign Up");
  sliderModel.setImageAssetPath("assets/images/signin.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel(desc: '', imageAssetPath: '', title: '');

  //2
  sliderModel.setDesc("2. Upload your files.");
  sliderModel.setTitle("Upload");
  sliderModel.setImageAssetPath(
    "assets/images/upload.png",
  );
  slides.add(sliderModel);

  sliderModel = new SliderModel(desc: '', imageAssetPath: '', title: '');

  //3
  sliderModel.setDesc(
      "3. Start Searching your Required Image with relevant Keywords.");
  sliderModel.setTitle("Search");
  sliderModel.setImageAssetPath("assets/images/Search.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel(desc: '', imageAssetPath: '', title: '');

  return slides;
}
