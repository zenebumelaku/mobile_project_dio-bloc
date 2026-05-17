import '../data/models/item_model.dart';

abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<LostFoundItem> allItems;
  final List<LostFoundItem> filteredItems;
  final String selectedFilter;
  final String searchQuery;

  ItemLoaded({
    required this.allItems,
    required this.filteredItems,
    this.selectedFilter = 'All',
    this.searchQuery = '',
  });

  ItemLoaded copyWith({
    List<LostFoundItem>? allItems,
    List<LostFoundItem>? filteredItems,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return ItemLoaded(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ItemError extends ItemState {
  final String message;
  ItemError(this.message);
}
