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
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F5),
      body: Stack(
        children: [
          Column(
            children: [
              const _Header(),
              const _SearchBar(),
              const _FilterTabs(),
              const Expanded(child: _ItemList()),
            ],
          ),
        ],
      ),
      floatingActionButton: _AddFAB(),
    );
  }
}

class _AddFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, b) => const AddEditScreen(),
          transitionsBuilder: (_, a, b, child) =>
              SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
                child: child,
              ),
        ),
      ),
      backgroundColor: const Color(0xFF00897B),
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF00897B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.school_rounded,
                                      color: Colors.white70, size: 14),
                                  SizedBox(width: 4),
                                  Text('Campus Board',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text('Lost & Found',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5)),
                        const Text('Report · Search · Recover',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                                letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  BlocBuilder<ItemCubit, ItemState>(
                    builder: (context, state) => IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.refresh_rounded,
                            color: Colors.white, size: 20),
                      ),
                      onPressed: () => context.read<ItemCubit>().getItems(),
                    ),
                  ),
                ],
              ),
            ),
            // Stats row
            BlocBuilder<ItemCubit, ItemState>(
              builder: (context, state) {
                int total = 0, lost = 0, found = 0, claimed = 0;
                if (state is ItemLoaded) {
                  total = state.allItems.length;
                  lost = state.allItems.where((i) => i.type == 'Lost').length;
                  found = state.allItems.where((i) => i.type == 'Found').length;
                  claimed =
                      state.allItems.where((i) => i.status == 'Claimed').length;
                }
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(value: total, label: 'Total', icon: '📋'),
                      _Divider(),
                      _StatItem(value: lost, label: 'Lost', icon: '🔍'),
                      _Divider(),
                      _StatItem(value: found, label: 'Found', icon: '✅'),
                      _Divider(),
                      _StatItem(value: claimed, label: 'Claimed', icon: '🎉'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 30, color: Colors.white24);
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final String icon;
  const _StatItem(
      {required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 2),
        Text('$value',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search items, locations...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon:
              const Icon(Icons.search_rounded, color: Color(0xFF00897B)),
          suffixIcon: Icon(Icons.tune_rounded, color: Colors.grey[400]),
          filled: true,
          fillColor: const Color(0xFFF2F6F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (val) =>
            context.read<ItemCubit>().applyFilterAndSearch(search: val),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
      builder: (context, state) {
        String current = 'All';
        if (state is ItemLoaded) current = state.selectedFilter;

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Row(
            children: [
              for (final tab in [
                ('All', Icons.apps_rounded, Colors.grey),
                ('Lost', Icons.search_off_rounded, Color(0xFFE53935)),
                ('Found', Icons.volunteer_activism_rounded, Color(0xFF43A047)),
              ])
                Expanded(
                  child: GestureDetector(
                    onTap: () => context
                        .read<ItemCubit>()
                        .applyFilterAndSearch(filter: tab.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: current == tab.$1
                            ? tab.$3.withOpacity(0.12)
                            : const Color(0xFFF2F6F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: current == tab.$1
                              ? tab.$3
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(tab.$2,
                              size: 15,
                              color: current == tab.$1
                                  ? tab.$3
                                  : Colors.grey[500]),
                          const SizedBox(width: 5),
                          Text(
                            tab.$1,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: current == tab.$1
                                  ? tab.$3
                                  : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
      builder: (context, state) {
        if (state is ItemLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00897B)),
          );
        }
        if (state is ItemError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('😕', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 12),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => context.read<ItemCubit>().getItems(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ItemLoaded) {
          if (state.filteredItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📭', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 12),
                  Text('Nothing here yet',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Tap + to add a report',
                      style:
                          TextStyle(color: Colors.grey[400], fontSize: 13)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ItemCubit>().getItems(),
            color: const Color(0xFF00897B),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              itemCount: state.filteredItems.length,
              itemBuilder: (context, index) =>
                  _ItemCard(item: state.filteredItems[index]),
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
  const _ItemCard({required this.item});

  Color get _typeColor =>
      item.type == 'Lost' ? const Color(0xFFE53935) : const Color(0xFF43A047);

  String get _initials {
    final words = item.title.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return item.title.isNotEmpty ? item.title[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final isClaimed = item.status == 'Claimed';

    return Dismissible(
      key: Key(item.id ?? item.title),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFEF5350), Color(0xFFB71C1C)]),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 26),
            SizedBox(height: 4),
            Text('Delete',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Remove Item?'),
          content: Text(
              '"${item.title}" will be removed from the board.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      onDismissed: (_) => context.read<ItemCubit>().removeItem(item.id!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _typeColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _typeColor,
                      _typeColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(_initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Color(0xFF1A1A2E)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TypeBadge(type: item.type, color: _typeColor),
                      ],
                    ),
                    const SizedBox(height: 5),
                    if (item.description.isNotEmpty)
                      Text(
                        item.description,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12.5,
                            height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 13, color: Colors.grey[400]),
                        const SizedBox(width: 3),
                        Text(item.location,
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 12)),
                        const SizedBox(width: 10),
                        Icon(Icons.person_rounded,
                            size: 13, color: Colors.grey[400]),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(item.contactInfo,
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _StatusChip(isClaimed: isClaimed),
                        const Spacer(),
                        _IconBtn(
                          icon: Icons.edit_rounded,
                          color: const Color(0xFF00897B),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddEditScreen(item: item)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _IconBtn(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  final Color color;
  const _TypeBadge({required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(type,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isClaimed;
  const _StatusChip({required this.isClaimed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: isClaimed ? Colors.blueGrey : Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          isClaimed ? 'Claimed' : 'Active',
          style: TextStyle(
            color: isClaimed ? Colors.blueGrey : Colors.green[700],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
