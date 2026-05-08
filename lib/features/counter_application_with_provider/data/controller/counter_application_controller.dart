import 'package:flutter/material.dart';

class CounterApplicationController extends ChangeNotifier{
  List counterList = [0];


  void add(){
    int lastItemOfList = counterList.last;
    counterList.add(lastItemOfList + 1);
    notifyListeners();
  }
}