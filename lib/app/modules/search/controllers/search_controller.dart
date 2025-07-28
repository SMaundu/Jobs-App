import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/search/search_out_dto.dart';
import '../../../data/remote/repositories/search/search_repository.dart';
import '../../../di/locator.dart';

class SearchController extends GetxController {
  static SearchController get to => Get.find();
  final _searchRepository = getIt.get<SearchRepository>();
  final searchController = TextEditingController();

  // Corrected initialization: Status.idle() does not exist in the current Status class.
  // Initializing with Status.loading() or an empty success state is more appropriate.
  final Rx<Status<List<SearchOutDto>>> _rxResults =
      Rx<Status<List<SearchOutDto>>>(Status.loading());

  Status<List<SearchOutDto>> get rxResults => _rxResults.value;

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }

  getSearchResult() async {
    if (!searchController.text.isBlank!) {
      // Set status to loading before making the API call
      _rxResults.value = Status<List<SearchOutDto>>.loading();

      final Status<List<SearchOutDto>> results =
          await _searchRepository.getAll(q: searchController.text.trim());
      _rxResults.value = results;
    } else {
      // If search query is blank, set to an empty success state
      _rxResults.value = Status.success([]);
    }
  }

  clearSearch() {
    searchController.clear();
    // When clearing search, set to an empty success state
    _rxResults.value = Status.success([]);
  }

  void onRetry() {
    getSearchResult();
  }
}
