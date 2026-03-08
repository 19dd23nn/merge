import 'package:flutter/material.dart';

/// 하단 BotBar
/// - baseLift: 기본 위치 오프셋 (항상 위로 올림)
/// - liftWhenSelected: 선택 시 추가로 올릴 픽셀
/// - 모든 버튼은 이미지 에셋 + 텍스트 구조
class BotBar extends StatelessWidget {
  final int currentScreenIndex;
  final ValueChanged<int> onTap;
  final bool useNotch;
  final double baseLift;
  final double liftWhenSelected;

  const BotBar({
    super.key,
    required this.currentScreenIndex,
    required this.onTap,
    this.useNotch = true,
    this.baseLift = -20.0,
    this.liftWhenSelected = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black.withValues(alpha: 0.5),
      elevation: 0,
      clipBehavior: Clip.none,
      shape: useNotch
          ? const AutomaticNotchedShape(RoundedRectangleBorder())
          : null,
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BotBarButton(
                text: 'Pets',
                color: Colors.transparent,
                isSelected: currentScreenIndex == 0,
                onPressed: () => onTap(0),
                imageAsset: 'assets/album.png',
                showTextWhenSelected: true,
                tooltip: 'Pets',
                semanticsLabel: 'Open Pets',
                baseLift: baseLift,
                liftWhenSelected: liftWhenSelected,
              ),
              const SizedBox(width: 10),
              _BotBarButton(
                text: 'Home',
                color: Colors.transparent,
                isSelected: currentScreenIndex == 1,
                onPressed: () => onTap(1),
                imageAsset: 'assets/album.png', // ✅ Home도 이미지
                showTextWhenSelected: true,
                tooltip: 'Home',
                semanticsLabel: 'Go to Home',
                baseLift: baseLift,
                liftWhenSelected: liftWhenSelected,
              ),
              const SizedBox(width: 10),
              _BotBarButton(
                text: 'Setting',
                color: Colors.transparent,
                isSelected: currentScreenIndex == 2,
                onPressed: () => onTap(2),
                imageAsset: 'assets/album.png', // ✅ Setting도 이미지
                showTextWhenSelected: true,
                tooltip: 'Settings',
                semanticsLabel: 'Open Settings',
                baseLift: baseLift,
                liftWhenSelected: liftWhenSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotBarButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool isSelected;
  final VoidCallback onPressed;

  final String imageAsset; // ✅ 필수 이미지 에셋
  final bool showTextWhenSelected;
  final String? semanticsLabel;
  final String? tooltip;

  final double baseLift;
  final double liftWhenSelected;

  const _BotBarButton({
    required this.text,
    required this.color,
    required this.isSelected,
    required this.onPressed,
    required this.imageAsset, // ✅ 필수
    this.showTextWhenSelected = false,
    this.semanticsLabel,
    this.tooltip,
    this.baseLift = 0.0,
    this.liftWhenSelected = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 220);
    final double scale = isSelected ? 1.12 : 1.0;

    // 총 이동량 = 기본 + 선택 시
    final double totalLift = baseLift + (isSelected ? liftWhenSelected : 0.0);

    // 버튼 비주얼: 이미지 원본 그대로
    Widget visual = Image.asset(
      imageAsset,
      semanticLabel: semanticsLabel ?? text,
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Semantics(
          selected: isSelected,
          button: true,
          label: semanticsLabel ?? text,
          child: Tooltip(
            message: tooltip ?? text,
            waitDuration: const Duration(milliseconds: 500),
            child: OverflowBox(
              minHeight: 0,
              maxHeight: double.infinity, // 원본 이미지 커도 오버플로우 에러 없음
              alignment: Alignment.bottomCenter,
              child: AnimatedScale(
                duration: duration,
                scale: scale,
                curve: Curves.easeOutCubic,
                child: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  transform: Matrix4.translationValues(0, -totalLift, 0),
                  transformAlignment: Alignment.bottomCenter,
                  child: Material(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.none,
                    child: InkWell(
                      onTap: onPressed,
                      onLongPress: onPressed,
                      borderRadius: BorderRadius.circular(14),
                      mouseCursor: SystemMouseCursors.click,
                      focusColor: Colors.white.withValues(alpha: 0.12),
                      highlightColor: Colors.white.withValues(alpha: 0.08),
                      splashColor: Colors.white.withValues(alpha: 0.18),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            visual,
                            if (isSelected && showTextWhenSelected) ...[
                              const SizedBox(height: 0),
                              Text(
                                text,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
