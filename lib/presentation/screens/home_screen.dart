import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/item_cubit.dart';
import '../../bloc/item_state.dart';
import '../../data/models/item_model.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3),
      body: Column(
        children: [
          _Header(cs: cs),
          _SearchAndFilter(cs: cs),
          Expanded(child: _ItemList(cs: cs)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditScreen()),
        ),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Report Item', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ColorScheme cs;
  const _Header({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white70, size: 20),
                  const SizedBox(width: 6),
                  Text('Campus Lost & Found',
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                  const Spacer(),
                  BlocBuilder<ItemCubit, ItemState>(
                    builder: (context, state) => IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      onPressed: () => context.read<ItemCubit>().getItems(),
                      tooltip: 'Refresh',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Find What\nYou\'ve Lost 🔍',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2)),
              const SizedBox(height: 16),
              BlocBuilder<ItemCubit, ItemState>(
                builder: (context, state) {
                  int total = 0, lost = 0, found = 0;
                  if (state is ItemLoaded) {
                    total = state.allItems.length;
                    lost = state.allItems.where((i) => i.type == 'Lost').length;
                    found = state.allItems.where((i) => i.type == 'Found').length;
                  }
                  return Row(
                    children: [
                      _StatChip(label: 'Total', value: total, icon: Icons.list_alt_rounded),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Lost', value: lost, icon: Icons.search_off_rounded),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Found', value: found, icon: Icons.check_circle_outline_rounded),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  const _StatChip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text('$value $label',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  final ColorScheme cs;
  const _SearchAndFilter({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by title or location...',
              prefixIcon: Icon(Icons.search_rounded, color: cs.primary),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            onChanged: (val) =>
                context.read<ItemCubit>().applyFilterAndSearch(search: val),
          ),
          const SizedBox(height: 12),
          BlocBuilder<ItemCubit, ItemState>(
            builder: (context, state) {
              String current = 'All';
              if (state is ItemLoaded) current = state.selectedFilter;
              return Row(
                children: ['All', 'Lost', 'Found'].map((type) {
                  final selected = current == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => context
                          .read<ItemCubit>()
                          .applyFilterAndSearch(filter: type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? cs.primary : const Color(0xFFF0F4F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  final ColorScheme cs;
  const _ItemList({required this.cs});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
      builder: (context, state) {
        if (state is ItemLoading) {
          return Center(child: CircularProgressIndicator(color: cs.primary));
        }
        if (state is ItemError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(state.message,
                    style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<ItemCubit>().getItems(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state is ItemLoaded) {
          if (state.filteredItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_rounded, size: 72, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('No items found',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Tap + to report a lost or found item',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ItemCubit>().getItems(),
            color: cs.primary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: state.filteredItems.length,
              itemBuilder: (context, index) =>
                  _ItemCard(item: state.filteredItems[index], cs: cs),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ItemCard extends StatelessWidget {
  final LostFoundItem item;
  final ColorScheme cs;
  const _ItemCard({required this.item, required this.cs});

  @override
  Widget build(BuildContext context) {
    final isLost = item.type == 'Lost';
    final isClaimed = item.status == 'Claimed';
    final typeColor = isLost ? const Color(0xFFE53935) : const Color(0xFF43A047);

    return Dismissible(
      key: Key(item.id ?? item.title),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Delete Item'),
            content: Text('Remove "${item.title}" from the board?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => context.read<ItemCubit>().removeItem(item.id!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left color bar + icon
              Container(
                width: 56,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isLost ? Icons.search_rounded : Icons.volunteer_activism_rounded,
                      color: typeColor,
                      size: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(item.type,
                        style: TextStyle(
                            color: typeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _StatusPill(isClaimed: isClaimed),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 13, color: Colors.grey[500]),
                          const SizedBox(width: 3),
                          Text(item.location,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 13, color: Colors.grey[400]),
                          const SizedBox(width: 3),
                          Text(item.contactInfo,
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 11)),
                          const Spacer(),
                          _ActionButton(
                            icon: Icons.edit_rounded,
                            color: cs.primary,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddEditScreen(item: item)),
                            ),
                          ),
                          const SizedBox(width: 4),
                          _ActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: Colors.red[400]!,
                            onTap: () =>
                                context.read<ItemCubit>().removeItem(item.id!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isClaimed;
  const _StatusPill({required this.isClaimed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isClaimed
            ? Colors.blueGrey.withOpacity(0.12)
            : Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isClaimed ? 'Claimed' : 'Active',
        style: TextStyle(
          color: isClaimed ? Colors.blueGrey : Colors.green[700],
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
