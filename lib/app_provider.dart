import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AjaxProvider extends ChangeNotifier {
  //데이터
  List<int> cache = [];

  //로딩
  bool loading = false;

  //아이템이 더 있는지지
  bool hasMore = true;


  _makeRequest({required int nextId}) async {
    await Future.delayed(Duration(seconds: 2));

    if (nextId >= 100) return [];

    return List.generate(20, (index) {
      return nextId + index;
    });

  }


  fetchItems({int? nextId}) async {

    nextId ??= 0;

    loading = true;

    notifyListeners();

    final items = await _makeRequest(nextId: nextId);

    this.cache = [...this.cache, ...items];

    if (items.length == 0) hasMore = false;

    loading = false;

    notifyListeners();

  }

}
