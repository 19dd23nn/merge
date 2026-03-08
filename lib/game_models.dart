import 'dart:async';
import 'package:flutter/material.dart';

// --- Enums for Type Safety ---
enum ItemType { feed, water }
enum PackType { feedstuff, watering }

// --- Base Class ---
abstract class BoardItem {
  String get imagePath;
  int get level;
}

// --- Items ---

class Item extends BoardItem {
  @override
  final int level;
  final ItemType type;

  Item({required this.level, required this.type});

  @override
  String get imagePath {
    if (level <= 0) return 'assets/sparkle.png';

    switch (type) {
      case ItemType.feed:
        return 'assets/items/feed/feed_$level.png';
      case ItemType.water:
        return 'assets/items/water/water_$level.png';
    }
  }
}

// --- Packs ---

class Pack extends BoardItem {
  @override
  final int level;
  final PackType type;

  late int remaining;
  bool onCooldown = false;
  Timer? cooldownTimer;
  int cooldownSecondsLeft = 0;
  VoidCallback? onStateChanged;

  Pack({required this.level, required this.type, this.onStateChanged}) {
    remaining = initialRemaining;
  }

  int get initialRemaining {
    if (type == PackType.watering) return 16 * level;
    return 32 * level;
  }

  int get cooldownSeconds {
    if (type == PackType.watering) return 15;
    return 30;
  }

  @override
  String get imagePath {
    if (level <= 0) return 'assets/sparkle.png';

    switch (type) {
      case PackType.feedstuff:
        return 'assets/packs/feedstuff/feedstuff_$level.png';
      case PackType.watering:
        return 'assets/packs/watering/watering_$level.png';
    }
  }

  void startCooldown(VoidCallback onTick) {
    onCooldown = true;
    cooldownSecondsLeft = cooldownSeconds;
    cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      cooldownSecondsLeft--;
      if (cooldownSecondsLeft <= 0) {
        timer.cancel();
        onCooldown = false;
        remaining = initialRemaining;
        cooldownSecondsLeft = 0;
      }
      onTick();
      // 상태 변경 시 콜백 호출
      onStateChanged?.call();
    });
  }

  // 저장된 남은 시간으로 쿨다운을 재개
  void resumeCooldownIfNeeded(VoidCallback onTick) {
    if (onCooldown && cooldownSecondsLeft > 0 && cooldownTimer == null) {
      cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        cooldownSecondsLeft--;
        if (cooldownSecondsLeft <= 0) {
          timer.cancel();
          onCooldown = false;
          remaining = initialRemaining;
          cooldownSecondsLeft = 0;
        }
        onTick();
        onStateChanged?.call();
      });
    }
  }

  void disposeTimer() {
    cooldownTimer?.cancel();
    cooldownTimer = null;
  }

  Item generateItem() {
    // Watering packs generate water items, feedstuff packs generate feed items
    final itemType = (type == PackType.watering) ? ItemType.water : ItemType.feed;
    // Higher level packs generate higher level items
    return Item(level: level, type: itemType);
  }
}