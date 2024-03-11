import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'modernclass.dart';

class provider with ChangeNotifier {
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;


  List<BookmarkModel> bookMarkList = [];

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {

      return;
    }

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    notifyListeners();
  }

  bookMarkADD(BookmarkModel DATA){
    bookMarkList.add(DATA);
    notifyListeners();
  }

  deleteBookMark(index){
    bookMarkList.removeAt(index);
    notifyListeners();
  }

}
