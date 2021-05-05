
import 'package:flutter/cupertino.dart';
import 'package:flutter_mask/model/store_list.dart';
import 'package:flutter_mask/repository/store_repository.dart';

class StoreModel with ChangeNotifier{
  List<Store> stores = [];

  final _storeRepository = StoreRepository();

  StoreModel() {
    fetch();
  }

  Future fetch() async {
    stores = await _storeRepository.fetch();
    notifyListeners();
  }
}