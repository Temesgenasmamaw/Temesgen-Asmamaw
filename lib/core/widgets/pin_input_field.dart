import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

/// PIN input field with animated dot indicators and custom numeric keypad.
class PinInputField extends StatelessWidget {
  final int pinLength;
  final int currentLength;
  final bool hasError;

  const PinInputField({
    super.key,
    this.pinLength = 4,
    required this.currentLength,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        final isFilled = index < currentLength;
        final isActive = index == currentLength;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.space8),
          width: AppSizes.pinFieldSize,
          height: AppSizes.pinFieldSize,
          decoration: BoxDecoration(
            color: isFilled
                ? (hasError ? AppColors.error : AppColors.safaricomRed)
                : AppColors.grey50,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : isActive
                  ? AppColors.safaricomRed
                  : isFilled
                  ? AppColors.safaricomRed
                  : AppColors.grey300,
              width: isActive ? 2.0 : 1.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.safaricomRed.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isFilled
                ? Container(
                    width: AppSizes.pinDotSize,
                    height: AppSizes.pinDotSize,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
        );
      }),
    );
  }
}

/// Custom numeric keypad for PIN entry.
class NumericKeypad extends StatelessWidget {
  final ValueChanged<int> onNumberTap;
  final VoidCallback onDeleteTap;
  final VoidCallback? onBiometricTap;

  const NumericKeypad({
    super.key,
    required this.onNumberTap,
    required this.onDeleteTap,
    this.onBiometricTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow([1, 2, 3]),
        const SizedBox(height: AppSizes.space12),
        _buildRow([4, 5, 6]),
        const SizedBox(height: AppSizes.space12),
        _buildRow([7, 8, 9]),
        const SizedBox(height: AppSizes.space12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Biometric / empty
            _buildSpecialKey(
              child: onBiometricTap != null
                  ? const Icon(
                      Icons.fingerprint,
                      size: 32,
                      color: AppColors.safaricomRed,
                    )
                  : const SizedBox.shrink(),
              onTap: onBiometricTap,
            ),
            _buildNumberKey(0),
            // Delete
            _buildSpecialKey(
              child: const Icon(
                Icons.backspace_outlined,
                size: 24,
                color: AppColors.grey700,
              ),
              onTap: onDeleteTap,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<int> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map(_buildNumberKey).toList(),
    );
  }

  Widget _buildNumberKey(int number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNumberTap(number),
        borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
        splashColor: AppColors.safaricomRed.withValues(alpha: 0.1),
        child: Container(
          width: AppSizes.numPadKeySize,
          height: AppSizes.numPadKeySize,
          alignment: Alignment.center,
          child: Text('$number', style: AppTextStyles.numPadKey),
        ),
      ),
    );
  }

  Widget _buildSpecialKey({required Widget child, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
        child: Container(
          width: AppSizes.numPadKeySize,
          height: AppSizes.numPadKeySize,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class FourDigitPinInput extends StatefulWidget {
  final ValueChanged<String> onPinChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;
  final bool enabled;

  const FourDigitPinInput({
    super.key,
    required this.onPinChanged,
    this.onCompleted,
    this.hasError = false,
    this.enabled = true,
  });

  @override
  State<FourDigitPinInput> createState() => FourDigitPinInputState();
}

class FourDigitPinInputState extends State<FourDigitPinInput>
    with SingleTickerProviderStateMixin {
  final List<String> _digits = List.filled(4, '');
  late final AnimationController _cursorController;
  late final Animation<double> _cursorOpacity;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);

    _cursorOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  /// Current 4-digit PIN string.
  String get pin => _digits.where((d) => d.isNotEmpty).join();

  /// Current number of entered digits.
  int get currentLength => pin.length;

  /// Clears all 4 fields and resets active cursor to the first field.
  void clear() {
    for (int i = 0; i < 4; i++) {
      _digits[i] = '';
    }
    widget.onPinChanged('');
    if (mounted) setState(() {});
  }

  /// Append a digit entered via the custom keypad.
  void appendDigit(int digit) {
    if (!widget.enabled) return;
    for (int i = 0; i < 4; i++) {
      if (_digits[i].isEmpty) {
        _digits[i] = '$digit';
        final currentPin = pin;
        widget.onPinChanged(currentPin);
        if (currentPin.length == 4) {
          widget.onCompleted?.call(currentPin);
        }
        if (mounted) setState(() {});
        break;
      }
    }
  }

  /// Delete the last entered digit.
  void deleteDigit() {
    if (!widget.enabled) return;
    for (int i = 3; i >= 0; i--) {
      if (_digits[i].isNotEmpty) {
        _digits[i] = '';
        final currentPin = pin;
        widget.onPinChanged(currentPin);
        if (mounted) setState(() {});
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (!widget.enabled) return KeyEventResult.ignored;
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            deleteDigit();
            return KeyEventResult.handled;
          }
          final character = event.character;
          if (character != null && RegExp(r'^[0-9]$').hasMatch(character)) {
            appendDigit(int.parse(character));
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) => _buildPinBox(index)),
      ),
    );
  }

  Widget _buildPinBox(int index) {
    final isFilled = _digits[index].isNotEmpty;
    final isActive = index == currentLength;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.space8),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isFilled
            ? AppColors.safaricomRed.withValues(alpha: 0.05)
            : isActive
            ? AppColors.safaricomRed.withValues(alpha: 0.02)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: widget.hasError
              ? AppColors.error
              : (isActive || isFilled)
              ? AppColors.safaricomRed
              : AppColors.grey300,
          width: (isActive || widget.hasError) ? 2.0 : 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.safaricomRed.withValues(alpha: 0.18),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(child: _buildBoxContent(index, isFilled, isActive)),
    );
  }

  Widget _buildBoxContent(int index, bool isFilled, bool isActive) {
    if (isFilled) {
      // 1. Entered input – RED color as requested
      return const Text(
        '●',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.safaricomRed,
        ),
      );
    } else if (isActive) {
      // 2. Active empty input – RED '|' cursor as requested
      return FadeTransition(
        opacity: _cursorOpacity,
        child: const Text(
          '|',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: AppColors.safaricomRed,
            height: 1.0,
          ),
        ),
      );
    }
    // 3. Inactive empty input – NO internal circle (completely clean)
    return const SizedBox.shrink();
  }
}

/// International standard numeric keypad for PIN entry.
///
/// Layout:
/// - Row 1: 1, 2 (ABC), 3 (DEF)
/// - Row 2: 4 (GHI), 5 (JKL), 6 (MNO)
/// - Row 3: 7 (PQRS), 8 (TUV), 9 (WXYZ)
/// - Row 4: [Empty], 0 (+), [Backspace]
class InternationalNumericKeypad extends StatelessWidget {
  final ValueChanged<int> onNumberTap;
  final VoidCallback onDeleteTap;
  final bool enabled;

  const InternationalNumericKeypad({
    super.key,
    required this.onNumberTap,
    required this.onDeleteTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow([
          const _KeyData(digit: 1, letters: ''),
          const _KeyData(digit: 2, letters: 'ABC'),
          const _KeyData(digit: 3, letters: 'DEF'),
        ]),
        const SizedBox(height: 6),
        _buildRow([
          const _KeyData(digit: 4, letters: 'GHI'),
          const _KeyData(digit: 5, letters: 'JKL'),
          const _KeyData(digit: 6, letters: 'MNO'),
        ]),
        const SizedBox(height: 6),
        _buildRow([
          const _KeyData(digit: 7, letters: 'PQRS'),
          const _KeyData(digit: 8, letters: 'TUV'),
          const _KeyData(digit: 9, letters: 'WXYZ'),
        ]),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Empty placeholder for balanced alignment
            const SizedBox(width: 70, height: 48),
            // 0 with '+'
            _buildKey(const _KeyData(digit: 0, letters: '+')),
            // Backspace / Delete action
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? onDeleteTap : null,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                splashColor: AppColors.safaricomRed.withValues(alpha: 0.15),
                child: Container(
                  width: 70,
                  height: 48,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.backspace_outlined,
                    size: 22,
                    color: enabled ? AppColors.grey800 : AppColors.grey400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<_KeyData> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map(_buildKey).toList(),
    );
  }

  Widget _buildKey(_KeyData key) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onNumberTap(key.digit) : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        splashColor: AppColors.safaricomRed.withValues(alpha: 0.15),
        highlightColor: AppColors.safaricomRed.withValues(alpha: 0.08),
        child: Container(
          width: 70,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.grey100.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${key.digit}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: enabled ? AppColors.grey900 : AppColors.grey400,
                  height: 1.1,
                ),
              ),
              if (key.letters.isNotEmpty)
                Text(
                  key.letters,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: enabled ? AppColors.grey500 : AppColors.grey400,
                    height: 1.1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeyData {
  final int digit;
  final String letters;

  const _KeyData({required this.digit, required this.letters});
}
