import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/features/routine/models/routine_model.dart';
import 'package:mindfulminis/features/routine/routine_data/routine_data.dart';
import 'package:mindfulminis/features/routine/widgets/create_routine_conatiner.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

/// Shows a modal bottom sheet to pick how many days to extend a routine.
/// Returns the updated [RoutineModel] on success, or `null` if cancelled.
Future<RoutineModel?> showExtendRoutineSheet(
  BuildContext context,
  RoutineModel routine,
) {
  return showModalBottomSheet<RoutineModel?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _ExtendRoutineSheet(routine: routine),
  );
}

class _ExtendRoutineSheet extends StatefulWidget {
  final RoutineModel routine;
  const _ExtendRoutineSheet({required this.routine});

  @override
  State<_ExtendRoutineSheet> createState() => _ExtendRoutineSheetState();
}

class _ExtendRoutineSheetState extends State<_ExtendRoutineSheet> {
  String? _selectedDays;
  bool _loading = false;

  static const _options = [
    {
      'title': 'Kickstart',
      'subtitle': '30 Days',
      'duration': '30',
    },
    {
      'title': 'Habit Builder',
      'subtitle': '90 Days',
      'duration': '90',
    },
    {
      'title': 'Transformation',
      'subtitle': '180 Days',
      'duration': '180',
    },
    {
      'title': "Day's Mastery",
      'subtitle': '365 Days',
      'duration': '365',
    },
  ];

  Future<void> _extend() async {
    if (_selectedDays == null) return;
    setState(() => _loading = true);
    try {
      final routineData = sl<RoutineData>();
      final updated = await routineData.extendRoutine(
        widget.routine.id,
        int.parse(_selectedDays!),
      );
      if (mounted) Navigator.pop(context, updated);
    } catch (e) {
      SmartDialog.showToast(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Space.h20,
          Text(
            'Extend Routine',
            style: AppTextTheme.titleTextTheme(context)
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          Space.h4,
          Text(
            'How many more days would you like to continue?',
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyTextStyle(context)
                .bodyMedium
                ?.copyWith(fontSize: 14),
          ),
          Space.h20,
          ..._options.map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CreateRoutineConatiner(
                icon: Assets.icons.routineCalenderIcon,
                title: opt['title']!,
                subtitle: opt['subtitle']!,
                radioValue: opt['duration']!,
                groupValue: _selectedDays ?? '',
                onChanged: (val) {
                  setState(() => _selectedDays = val);
                },
              ),
            );
          }),
          Space.h8,
          SizedBox(
            width: double.infinity,
            height: 50,
            child: GradientButton(
              onPressed: _selectedDays == null || _loading ? null : _extend,
              child: Center(
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Extend',
                        style: AppTextTheme.mainButtonTextStyle(context)
                            .titleLarge
                            ?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
