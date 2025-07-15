import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart' as my_search;
import 'widgets/body.dart';

class SearchView extends GetView<my_search.SearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: true,
        body: const Body(),
      ),
    );
  }
}
