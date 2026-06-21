// lib/modules/contact/view/add_contact_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_filed.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // ── Permission check ────────────────────────────────────────────────
      final status = await fc.FlutterContacts.permissions
          .request(fc.PermissionType.readWrite);

      if (status != fc.PermissionStatus.granted) {
        _showSnackBar('Contacts permission denied', isError: true);
        setState(() => _isSaving = false);
        return;
      }

      // ── Build contact ───────────────────────────────────────────────────
      final newContact = fc.Contact(
        name: fc.Name(
          first: _firstNameController.text.trim(),
          last: _lastNameController.text.trim(),
        ),
        phones: _phoneController.text.trim().isNotEmpty
            ? [fc.Phone(number: _phoneController.text.trim())]
            : [],
        emails: _emailController.text.trim().isNotEmpty
            ? [fc.Email(address: _emailController.text.trim())]
            : [],
      );

      // ── Save to device ──────────────────────────────────────────────────
      await fc.FlutterContacts.create(newContact);

      if (mounted) {
        _showSnackBar('Contact saved successfully');
        Navigator.pop(context, true); // true = refresh needed
      }
    } catch (e) {
      _showSnackBar('Failed to save contact: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? cs.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface.withOpacity(0.85),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          'New Contact',
          variant: CustomTextVariant.headlineMedium,
          color: cs.primary,
        ),
        actions: [
          _isSaving
              ? Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            ),
          )
              : TextButton(
            onPressed: _saveContact,
            child: CustomText(
              'Save',
              variant: CustomTextVariant.titleSmall,
              color: cs.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Avatar placeholder ─────────────────────────────────────────
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: cs.secondaryContainer,
                    child: Icon(
                      Icons.person_rounded,
                      size: 44,
                      color: cs.onSecondaryContainer,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: cs.surface, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: cs.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── First Name ──────────────────────────────────────────────────
            CustomTextFormField(
              controller: _firstNameController,
              hintText: 'First name',
              prefixIcon: Icons.person_outline_rounded,
              borderRadius: 16,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'First name required' : null,
            ),
            const SizedBox(height: 12),

            // ── Last Name ───────────────────────────────────────────────────
            CustomTextFormField(
              controller: _lastNameController,
              hintText: 'Last name',
              prefixIcon: Icons.person_outline_rounded,
              borderRadius: 16,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),

            // ── Phone ────────────────────────────────────────────────────────
            CustomTextFormField(
              controller: _phoneController,
              hintText: 'Phone number',
              prefixIcon: Icons.phone_outlined,
              borderRadius: 16,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                if (v.trim().length < 6) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ── Email ────────────────────────────────────────────────────────
            CustomTextFormField(
              controller: _emailController,
              hintText: 'Email (optional)',
              prefixIcon: Icons.email_outlined,
              borderRadius: 16,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),

            // ── Save Button ─────────────────────────────────────────────────
            FilledButton(
              onPressed: _isSaving ? null : _saveContact,
              child: _isSaving
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }
}