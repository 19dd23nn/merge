import 'package:flutter/material.dart';
import 'dart:math';
import '../game_models.dart';

/// 카테고리 구분용 enum
enum BoardTaskCategory { lv1, lv2 }

/// Task 데이터 모델
class BoardTask {
  final String title;
  final String description;
  final BoardTaskCategory category;
  final Color color;
  final String id; // 고유 식별자 추가
  final int rewardCoins;

  BoardTask({
    required this.title,
    required this.description,
    required this.category,
    required this.color,
    this.rewardCoins = 0,
    String? id,
  }) : id =
           id ??
           "${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(99999)}";

  /// 보드의 아이템들이 이 task의 조건을 충족하는지 확인
  bool isConditionMet(List<List<BoardItem?>> grid) {
    switch (title) {
      case "collect feed_1":
        return _hasFeed_1(grid);
      case "collect feed_2":
        return _hasFeed_2(grid);
      case "collect feed_3":
        return _hasFeed_3(grid);
      case "collect feed_4":
        return _hasFeed_4(grid);
      case "collect feed_5":
        return _hasFeed_5(grid);
      case "collect water_1":
        return _hasWater_1(grid);
      case "collect water_2":
        return _hasWater_2(grid);
      case "collect water_3":
        return _hasWater_3(grid);
      case "collect water_4":
        return _hasWater_4(grid);
      case "collect water_5":
        return _hasWater_5(grid);
      default:
        return false;
    }
  }

  /// 현재 task가 요구하는 아이템 1개를 보드에서 소진(삭제)
  /// 조건에 맞는 아이템을 찾으면 해당 칸을 null로 만들고 true 반환
  /// 찾지 못하면 false 반환
  bool consumeOneFromGrid(List<List<BoardItem?>> grid) {
    try {
      // title 형식: "collect feed_1" 또는 "collect water_3"
      final parts = title.split(' ');
      if (parts.length < 2) return false;
      final spec = parts[1]; // e.g., feed_1
      final specParts = spec.split('_');
      if (specParts.length != 2) return false;
      final typeStr = specParts[0];
      final level = int.tryParse(specParts[1]);
      if (level == null) return false;

      ItemType? requiredType;
      switch (typeStr) {
        case 'feed':
          requiredType = ItemType.feed;
          break;
        case 'water':
          requiredType = ItemType.water;
          break;
        default:
          requiredType = null;
      }
      if (requiredType == null) return false;

      for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[row].length; col++) {
          final cell = grid[row][col];
          if (cell is Item &&
              cell.type == requiredType &&
              cell.level == level) {
            grid[row][col] = null;
            return true;
          }
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// collect feed_1의 조건을 충족하는지 확인
  bool _hasFeed_1(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.feed && item.level == 1) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect feed_2의 조건을 충족하는지 확인
  bool _hasFeed_2(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.feed && item.level == 2) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect feed_3의 조건을 충족하는지 확인
  bool _hasFeed_3(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.feed && item.level == 3) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect feed_4의 조건을 충족하는지 확인
  bool _hasFeed_4(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.feed && item.level == 4) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect feed_5의 조건을 충족하는지 확인
  bool _hasFeed_5(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.feed && item.level == 5) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect water_1의 조건을 충족하는지 확인
  bool _hasWater_1(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.water && item.level == 1) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect water_2의 조건을 충족하는지 확인
  bool _hasWater_2(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.water && item.level == 2) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect water_3의 조건을 충족하는지 확인
  bool _hasWater_3(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.water && item.level == 3) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect water_4의 조건을 충족하는지 확인
  bool _hasWater_4(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.water && item.level == 4) {
          return true;
        }
      }
    }
    return false;
  }

  /// collect water_5의 조건을 충족하는지 확인
  bool _hasWater_5(List<List<BoardItem?>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final item = grid[row][col];
        if (item is Item && item.type == ItemType.water && item.level == 5) {
          return true;
        }
      }
    }
    return false;
  }
}
