class StringSearch {
  StringSearch(this.input, this.searchTerm);
  final List<String> input;

  final String searchTerm;

  List<String> relevantResults() {
    // Search term should be of length 2 or more
    if (searchTerm.isEmpty) {
      return [];
    }

    return input
        .where((item) => item.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }
}