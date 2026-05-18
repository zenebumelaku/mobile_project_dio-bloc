import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/item_cubit.dart';
import '../../data/models/item_model.dart';

class AddEditScreen extends StatefulWidget {
  final LostFoundItem? item;
  const AddEditScreen({super.key, this.item});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title, _description, _location, _contactInfo, _type, _status;

  @override
  void initState() {
    super.initState();
    _title = widget.item?.title ?? '';
    _description = widget.item?.description ?? '';
    _location = widget.item?.location ?? '';
    _contactInfo = widget.item?.contactInfo ?? '';
    _type = widget.item?.type ?? 'Lost';
    _status = widget.item?.status ?? 'Active';
  }

  bool get _isEdit => widget.item != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F5),
      body: Column(
        children: [
          _buildHeader(cs),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                children: [
                  _buildTypeSelector(),
                  if (_isEdit) ...[
                    const SizedBox(height: 12),
                    _buildStatusSelector(),
                  ],
                  const SizedBox(height: 12),
                  _buildCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Item Details',
                    child: Column(
                      children: [
                        _buildField(
                          label: 'Item Name',
                          hint: 'e.g. Blue backpack, iPhone 14...',
                          icon: Icons.label_outline_rounded,
                          initialValue: _title,
                          validator: (v) =>
                              v!.trim().isEmpty ? 'Item name is required' : null,
                          onSaved: (v) => _title = v!.trim(),
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          label: 'Description',
                          hint: 'Describe the item in detail...',
                          icon: Icons.notes_rounded,
                          initialValue: _description,
                          maxLines: 3,
                          onSaved: (v) => _description = v!.trim(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCard(
                    icon: Icons.place_outlined,
                    title: 'Where & Who',
                    child: Column(
                      children: [
                        _buildField(
                          label: 'Campus Location',
                          hint: 'e.g. Library, Block C, Cafeteria...',
                          icon: Icons.location_on_outlined,
                          initialValue: _location,
                          validator: (v) =>
                              v!.trim().isEmpty ? 'Location is required' : null,
                          onSaved: (v) => _location = v!.trim(),
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          label: 'Contact Info',
                          hint: 'Phone number or email...',
                          icon: Icons.contact_phone_outlined,
                          initialValue: _contactInfo,
                          validator: (v) =>
                              v!.trim().isEmpty ? 'Contact is required' : null,
                          onSaved: (v) => _contactInfo = v!.trim(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSubmitButton(cs),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) {
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEdit ? 'Edit Report' : 'New Report',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _isEdit
                        ? 'Update the item details'
                        : 'Fill in the details below',
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              Text(_isEdit ? '✏️' : '📝',
                  style: const TextStyle(fontSize: 28)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        _TypeOption(
          emoji: '🔍',
          label: 'Lost',
          subtitle: 'I lost something',
          color: const Color(0xFFE53935),
          selected: _type == 'Lost',
          onTap: () => setState(() => _type = 'Lost'),
        ),
        const SizedBox(width: 12),
        _TypeOption(
          emoji: '🎒',
          label: 'Found',
          subtitle: 'I found something',
          color: const Color(0xFF43A047),
          selected: _type == 'Found',
          onTap: () => setState(() => _type = 'Found'),
        ),
      ],
    );
  }

  Widget _buildStatusSelector() {
    return Row(
      children: [
        _TypeOption(
          emoji: '🟢',
          label: 'Active',
          subtitle: 'Still looking',
          color: Colors.green,
          selected: _status == 'Active',
          onTap: () => setState(() => _status = 'Active'),
        ),
        const SizedBox(width: 12),
        _TypeOption(
          emoji: '🎉',
          label: 'Claimed',
          subtitle: 'Resolved',
          color: Colors.blueGrey,
          selected: _status == 'Claimed',
          onTap: () => setState(() => _status = 'Claimed'),
        ),
      ],
    );
  }

  Widget _buildCard(
      {required IconData icon,
      required String title,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF00897B)),
              const SizedBox(width: 6),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Color(0xFF00897B))),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required String initialValue,
    int maxLines = 1,
    String? Function(String?)? validator,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFFF8FAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF00897B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildSubmitButton(ColorScheme cs) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00897B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: _submit,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_isEdit ? Icons.save_rounded : Icons.send_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              _isEdit ? 'Save Changes' : 'Submit Report',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final item = LostFoundItem(
        id: widget.item?.id,
        title: _title,
        description: _description,
        location: _location,
        contactInfo: _contactInfo,
        type: _type,
        status: _status,
      );
      if (_isEdit) {
        context.read<ItemCubit>().editItem(item);
      } else {
        context.read<ItemCubit>().addItem(item);
      }
      Navigator.pop(context);
    }
  }
}

class _TypeOption extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _TypeOption({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? color : Colors.grey[200]!,
              width: 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: selected ? Colors.white : Colors.grey[800])),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11,
                          color: selected
                              ? Colors.white70
                              : Colors.grey[500])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
