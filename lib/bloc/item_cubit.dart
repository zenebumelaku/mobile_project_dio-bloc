import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/item_repository.dart';
import '../data/models/item_model.dart';
import 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final ItemRepository repository;

  ItemCubit(this.repository) : super(ItemInitial());

  // Fetch Items (Read)
  Future<void> getItems() async {
    emit(ItemLoading());
    try {
      final items = await repository.fetchItems();
      emit(ItemLoaded(allItems: items, filteredItems: items));
    } catch (e) {
      emit(ItemError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Filter and Search Logic
  void applyFilterAndSearch({String? filter, String? search}) {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;
      final activeFilter = filter ?? currentState.selectedFilter;
      final activeSearch = search ?? currentState.searchQuery;

      final updatedList = currentState.allItems.where((item) {
        final matchesSearch = item.title
                .toLowerCase()
                .contains(activeSearch.toLowerCase()) ||
            item.location.toLowerCase().contains(activeSearch.toLowerCase());
        final matchesFilter =
            activeFilter == 'All' || item.type == activeFilter;
        return matchesSearch && matchesFilter;
      }).toList();

      emit(currentState.copyWith(
        filteredItems: updatedList,
        selectedFilter: activeFilter,
        searchQuery: activeSearch,
      ));
    }
  }

  // Create
  Future<void> addItem(LostFoundItem item) async {
    try {
      final newItem = await repository.createItem(item);
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;
        final updatedAll = List<LostFoundItem>.from(currentState.allItems)
          ..insert(0, newItem);
        emit(currentState.copyWith(allItems: updatedAll, filteredItems: updatedAll));
        applyFilterAndSearch();
      }
    } catch (e) {
      emit(ItemError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Update
  Future<void> editItem(LostFoundItem updatedItem) async {
    try {
      await repository.updateItem(updatedItem.id!, updatedItem);
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;
        final updatedAll = currentState.allItems.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();
        emit(currentState.copyWith(allItems: updatedAll));
        applyFilterAndSearch();
      }
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }

  // Delete
  Future<void> removeItem(String id) async {
    try {
      await repository.deleteItem(id);
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;
        final updatedAll =
            currentState.allItems.where((item) => item.id != id).toList();
        emit(currentState.copyWith(allItems: updatedAll));
        applyFilterAndSearch();
      }
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }
}
