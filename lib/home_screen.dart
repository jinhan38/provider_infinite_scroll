import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_infinite_scroll/app_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AjaxProvider>(context, listen: false).fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("provider scrolling"),
        ),
        body: _renderListView());
  }

  _renderListView() {
    final provider = Provider.of<AjaxProvider>(context);
    final cache = provider.cache;

    final loading = provider.loading;

    //로딩중이면서 데이터 없는 경우
    if (loading && cache.length == 0) {
      return Center(child: CircularProgressIndicator());
    }

    if (!loading && cache.length == 0) {
      return Center(child: Text("데이터가 없습니다"));
    }

    return ListView.builder(
        itemCount: cache.length + 1,
        itemBuilder: (context, index) {
          if (index < cache.length) {
            return ListTile(
              title: Text(cache[index].toString()),
            );
          }

          if (!provider.loading && provider.hasMore) {
            Future.microtask(() {
              provider.fetchItems(nextId: index);
            });
          }

          if (provider.hasMore) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text("더이상 아이템이 없습니다."));
          }

        });
  }
}
