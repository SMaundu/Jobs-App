import '../../base/status.dart';
import '../../dto/search/search_out_dto.dart';

/// Interface for search-related repository operations.
/// Defines the contract for retrieving search results.
abstract class ISearchRepository { // Removed generic <T> from the interface
  /// Retrieves a list of search results.
  /// The return type is explicitly defined as Status<List<SearchOutDto>>.
  Future<Status<List<SearchOutDto>>> getAll({ // Explicitly used SearchOutDto
    int? limit,
    int? offset,
    String? q,
  });
}
