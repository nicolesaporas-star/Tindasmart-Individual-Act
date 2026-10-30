
import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

// The four UI states required by Activity 9.
enum ReportUiState {
  idle,
  loading,
  success,
  empty,
  error,
}

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() =>
      _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _productController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;

  String? _selectedCategory;

  bool _showReports = false;
  bool _simulateFailure = false;

  // Temporary in-memory report records.
  // These are not saved to PostgreSQL.
  final List<Map<String, String>> _reports = [];

  final List<String> _categories = [
    'Damaged Product',
    'Expired Product',
    'Missing Inventory',
    'Incorrect Stock Quantity',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _productController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Simulated asynchronous report submission.
  Future<void> _submitReport() async {
    if (_uiState == ReportUiState.loading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _uiState = ReportUiState.loading;
    });

    try {
      // Simulate a three-second submission process.
      await Future<void>.delayed(
        const Duration(seconds: 3),
      );

      if (_simulateFailure) {
        throw Exception('Simulated submission failure.');
      }

      if (!mounted) return;

      setState(() {
        _reports.add({
          'title': _titleController.text.trim(),
          'product': _productController.text.trim(),
          'category': _selectedCategory!,
          'description': _descriptionController.text.trim(),
        });

        _uiState = ReportUiState.success;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.error;
      });
    }
  }

  void _openNewReport() {
    setState(() {
      _showReports = false;
      _uiState = ReportUiState.idle;
    });
  }

  void _openMyReports() {
    setState(() {
      _showReports = true;

      _uiState = _reports.isEmpty
          ? ReportUiState.empty
          : ReportUiState.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report Center',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: const Color(0xFF0F172A),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 750,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inventory Reports',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Report inventory issues and monitor '
                    'your submitted reports.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Navigation between form and report list.
                  Row(
                    children: [
                      Expanded(
                        child: _sectionButton(
                          'New Report',
                          Icons.add_circle_outline,
                          !_showReports,
                          _openNewReport,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _sectionButton(
                          'My Reports',
                          Icons.assignment_outlined,
                          _showReports,
                          _openMyReports,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  if (_showReports)
                    _buildReportsSection()
                  else
                    _buildReportForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable section navigation button.
  Widget _sectionButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected
            ? Colors.white
            : const Color(0xFF2563EB),
        backgroundColor: isSelected
            ? const Color(0xFF2563EB)
            : Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        side: const BorderSide(
          color: Color(0xFF2563EB),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Report form interface.
  Widget _buildReportForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submit an Inventory Report',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 20),

          AppTextField(
            controller: _titleController,
            label: 'Report Title',
            hint: 'Enter the report title',
            prefixIcon: Icons.title,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a report title.';
              }

              if (value.trim().length < 3) {
                return 'Title must contain at least 3 characters.';
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          AppTextField(
            controller: _productController,
            label: 'Product Name',
            hint: 'Enter the affected product name',
            prefixIcon: Icons.inventory_2_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a product name.';
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Issue Category',
              prefixIcon: const Icon(
                Icons.category_outlined,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an issue category.';
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          AppTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Describe the inventory issue...',
            prefixIcon: Icons.description_outlined,
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please provide a description.';
              }

              if (value.trim().length < 10) {
                return 'Description must contain at least 10 characters.';
              }

              return null;
            },
          ),

          const SizedBox(height: 20),

          // Testing control for reproducing the Error state.
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Simulate submission error',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Testing only. Turn this on to demonstrate '
              'the Error state.',
            ),
            value: _simulateFailure,
            onChanged: (value) {
              setState(() {
                _simulateFailure = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Loading and Success feedback.
          if (_uiState == ReportUiState.loading)
            _buildStateMessage(
              icon: Icons.hourglass_top,
              title: 'Submitting Report...',
              message: 'Please wait while your report is processed.',
              color: const Color(0xFF2563EB),
            ),

          if (_uiState == ReportUiState.success)
            _buildStateMessage(
              icon: Icons.check_circle_outline,
              title: 'Report Submitted Successfully!',
              message: 'Your report was added to the temporary '
                  'report list. No database record was created.',
              color: const Color(0xFF16A34A),
            ),

          if (_uiState == ReportUiState.error)
            _buildStateMessage(
              icon: Icons.error_outline,
              title: 'Submission Failed',
              message: 'Something went wrong while submitting '
                  'your report. Turn off simulation or check '
                  'your entries, then try again.',
              color: const Color(0xFFDC2626),
            ),

          const SizedBox(height: 20),

          if (_uiState == ReportUiState.error)
            AppButton(
              label: 'Retry Submission',
              icon: Icons.refresh,
              onPressed: _submitReport,
            )
          else
            AppButton(
              label: 'Submit Report',
              icon: Icons.send,
              isLoading: _uiState == ReportUiState.loading,
              onPressed: _uiState == ReportUiState.loading
                  ? null
                  : _submitReport,
            ),

          if (_uiState == ReportUiState.success) ...[
            const SizedBox(height: 12),

            AppButton(
              label: 'View My Reports',
              icon: Icons.assignment_outlined,
              onPressed: _openMyReports,
            ),
          ],
        ],
      ),
    );
  }

  // My Reports section, including the Empty state.
  Widget _buildReportsSection() {
    if (_reports.isEmpty) {
      return _buildStateMessage(
        icon: Icons.inbox_outlined,
        title: 'No Reports Available',
        message: 'You have not submitted any inventory '
            'reports yet. Create a new report to get started.',
        color: const Color(0xFF64748B),
        action: AppButton(
          label: 'Create New Report',
          icon: Icons.add,
          onPressed: _openNewReport,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Submitted Reports',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        ..._reports.map((report) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF2563EB),
                ),
              ),
              title: Text(report['title']!),
              subtitle: Text(
                '${report['product']} • ${report['category']}',
              ),
              isThreeLine: true,
            ),
          );
        }),
      ],
    );
  }

  // Shared UI state message builder.
  Widget _buildStateMessage({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            message,
            style: const TextStyle(
              height: 1.5,
              color: Color(0xFF334155),
            ),
          ),

          if (action != null) ...[
            const SizedBox(height: 18),
            action,
          ],
        ],
      ),
    );
  }
}
