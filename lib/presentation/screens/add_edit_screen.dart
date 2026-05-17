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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3),
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isEdit ? 'Edit Report' : 'New Report',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type selector
            _SectionCard(
              title: 'Report Type',
              child: Row(
                children: ['Lost', 'Found'].map((type) {
                  final selected = _type == type;
                  final color = type == 'Lost'
                      ? const Color(0xFFE53935)
                      : const Color(0xFF43A047);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                            right: type == 'Lost' ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected
                              ? color
                              : color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: selected
                                  ? color
                                  : color.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              type == 'Lost'
                                  ? Icons.search_rounded
                                  : Icons.volunteer_activism_rounded,
                              color: selected ? Colors.white : color,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              type,
                              style: TextStyle(
                                color: selected ? Colors.white : color,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            if (isEdit)
              _SectionCard(
                title: 'Status',
                child: Row(
                  children: ['Active', 'Claimed'].map((s) {
                    final selected = _status == s;
                    final color = s == 'Active' ? Colors.green : Colors.blueGrey;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _status = s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(right: s == 'Active' ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? color
                                : color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: selected
                                    ? color
                                    : color.withOpacity(0.3)),
                          ),
                          child: Text(
                            s,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected ? Colors.white : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Details
            _SectionCard(
              title: 'Item Details',
              child: Column(
                children: [
                  _Field(
                    label: 'Item Name',
                    icon: Icons.label_rounded,
                    initialValue: _title,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _title = v!,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Description',
                    icon: Icons.notes_rounded,
                    initialValue: _description,
                    maxLines: 3,
                    onSaved: (v) => _description = v!,
                  ),
                ],
              ),
            ),

            // Location & Contact
            _SectionCard(
              title: 'Location & Contact',
              child: Column(
                children: [
                  _Field(
                    label: 'Campus Location',
                    icon: Icons.location_on_rounded,
                    initialValue: _location,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _location = v!,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Contact (Phone / Email)',
                    icon: Icons.contact_phone_rounded,
                    initialValue: _contactInfo,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _contactInfo = v!,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: _submit,
                child: Text(
                  isEdit ? 'Save Changes' : 'Submit Report',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final itemObj = LostFoundItem(
        id: widget.item?.id,
        title: _title,
        description: _description,
        location: _location,
        contactInfo: _contactInfo,
        type: _type,
        status: _status,
      );
      if (widget.item != null) {
        context.read<ItemCubit>().editItem(itemObj);
      } else {
        context.read<ItemCubit>().addItem(itemObj);
      }
      Navigator.pop(context);
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final IconData icon;
  final String initialValue;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String?) onSaved;

  const _Field({
    required this.label,
    required this.icon,
    required this.initialValue,
    this.maxLines = 1,
    this.validator,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
