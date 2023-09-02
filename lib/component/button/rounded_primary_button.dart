import 'dart:async';
import 'package:flutter/material.dart';

class RoundedPrimaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String buttonName;
  final bool isLoading;
  final bool isChanged;
  final Duration? cooldownDuration;

  const RoundedPrimaryButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
    this.isLoading = false,
    this.isChanged = false,
    this.cooldownDuration,
  }) : super(key: key);

  @override
  State<RoundedPrimaryButton> createState() => _RoundedPrimaryButtonState();
}

class _RoundedPrimaryButtonState extends State<RoundedPrimaryButton> {
  bool _isOnCooldown = false;
  int _remainingCooldown = 0;
  Timer? _cooldownTimer; // Timer yang diperlukan untuk cooldown

  @override
  void initState() {
    super.initState();
    if (widget.cooldownDuration != null) {
      _startCooldown();
    }
  }

  @override
  void dispose() {
    // Hentikan timer jika ada sebelum widget di-dipose
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonBackgroundColor =
        widget.isLoading || widget.isChanged ? Colors.blueGrey : Theme.of(context).colorScheme.primary;
    final Color buttonPrimaryColor = Theme.of(context).colorScheme.background;
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              const Size.fromHeight(45),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
        ),
      ),
      child: Builder(builder: (context) {
        if (_isOnCooldown) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(buttonBackgroundColor),
              foregroundColor: MaterialStateProperty.all<Color>(buttonPrimaryColor),
            ),
            onPressed: null,
            child: Text("Tunggu $_remainingCooldown detik lagi"),
          );
        } else {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(buttonBackgroundColor),
              foregroundColor: MaterialStateProperty.all<Color>(buttonPrimaryColor),
            ),
            onPressed: widget.isLoading || widget.isChanged || _isOnCooldown
                ? null
                : () {
                    if (widget.onPressed != null) {
                      widget.onPressed!();
                    }
                  },
            child: widget.isLoading
                ? Transform.scale(
                    scale: 0.7,
                    child: CircularProgressIndicator(
                      color: buttonPrimaryColor,
                    ),
                  )
                : Text(widget.buttonName),
          );
        }
      }),
    );
  }

  void _startCooldown() {
    setState(() {
      _isOnCooldown = true;
      _remainingCooldown = widget.cooldownDuration!.inSeconds;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingCooldown <= 0) {
        setState(() {
          _isOnCooldown = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _remainingCooldown--;
        });
      }
    });
  }
}
