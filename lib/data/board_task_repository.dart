import 'package:flutter/material.dart';
import 'board_task_data.dart';
import 'dart:math';

class BoardTaskRepository {
  // 모든 가능한 task들의 데이터베이스
  static final List<BoardTask> _allTasks = [
    BoardTask(
      title: "collect feed_1",
      description: "feed_1 아이템을 모으기",
      category: BoardTaskCategory.lv1,
      color: Colors.redAccent,
      rewardCoins: 50,
    ),
    BoardTask(
      title: "collect feed_2",
      description: "feed_2 아이템을 모으기",
      category: BoardTaskCategory.lv1,
      color: Colors.pink,
      rewardCoins: 40,
    ),
    BoardTask(
      title: "collect feed_3",
      description: "feed_3 아이템을 모으기",
      category: BoardTaskCategory.lv1,
      color: Colors.orange,
      rewardCoins: 60,
    ),
    BoardTask(
      title: "collect feed_4",
      description: "feed_4 아이템을 모으기",
      category: BoardTaskCategory.lv1,
      color: Colors.purple,
      rewardCoins: 80,
    ),
    BoardTask(
      title: "collect feed_5",
      description: "feed_5 아이템을 모으기",
      category: BoardTaskCategory.lv1,
      color: Colors.amber,
      rewardCoins: 100,
    ),
    BoardTask(
      title: "collect water_1",
      description: "water_1 아이템을 모으기",
      category: BoardTaskCategory.lv2,
      color: Colors.green,
      rewardCoins: 30,
    ),
    BoardTask(
      title: "collect water_2",
      description: "water_2 아이템을 모으기",
      category: BoardTaskCategory.lv2,
      color: Colors.pink,
      rewardCoins: 35,
    ),
    BoardTask(
      title: "collect water_3",
      description: "water_3 아이템을 모으기",
      category: BoardTaskCategory.lv2,
      color: Colors.blue,
      rewardCoins: 70,
    ),
    BoardTask(
      title: "collect water_4",
      description: "water_4 아이템을 모으기",
      category: BoardTaskCategory.lv2,
      color: Colors.indigo,
      rewardCoins: 90,
    ),
    BoardTask(
      title: "collect water_5",
      description: "water_5 아이템을 모으기",
      category: BoardTaskCategory.lv2,
      color: Colors.indigo,
      rewardCoins: 90,
    ),
  ];

  // 현재 활성화된 task들 (보드에 표시되는 task들)
  static final List<BoardTask> _activeTasks = [];
  
  // 기본 task 개수
  static const int _defaultTaskCount = 3;

  // 현재 허용된 최대 레벨 (이 레벨 이하의 task만 생성/교체)
  static int _maxAllowedLevel = 1;

  /// 태스크 제목에서 요구 레벨을 파싱 (예: "collect feed_3" -> 3)
  /// 카테고리 기반이 기본이지만, 예외/미정의 대비용으로 남겨둠
  static int _getRequiredLevel(BoardTask task) {
    // 카테고리 우선
    switch (task.category) {
      case BoardTaskCategory.lv1:
        return 1;
      case BoardTaskCategory.lv2:
        return 2;
    }
  }

  /// 현재 허용 레벨을 설정
  static void setMaxAllowedLevel(int level) {
    _maxAllowedLevel = level;
  }

  /// 주어진 레벨까지의 태스크를 활성 목록에 누적 추가
  static void ensureTasksUpToLevel(int level) {
    for (final t in _allTasks) {
      final req = _getRequiredLevel(t);
      if (req <= level && !_activeTasks.any((a) => a.title == t.title)) {
        _activeTasks.add(t);
      }
    }
  }

  /// 레벨에 맞춰 활성 태스크를 재구성 (해당 레벨 이하만 채움)
  static void resetTasksForLevel(int level) {
    _activeTasks.clear();
    setMaxAllowedLevel(level);
    for (final t in _allTasks) {
      if (_getRequiredLevel(t) <= level) {
        _activeTasks.add(t);
      }
    }
  }

  /// 레벨과 최대 개수에 맞춰 활성 태스크를 무작위로 제한하여 구성
  static void resetTasksForLevelWithCount(int level, int maxCount) {
    _activeTasks.clear();
    setMaxAllowedLevel(level);

    final candidates = _allTasks.where((t) => _getRequiredLevel(t) <= level).toList();
    candidates.shuffle(Random());

    final count = maxCount.clamp(0, candidates.length);
    for (int i = 0; i < count; i++) {
      _activeTasks.add(candidates[i]);
    }
  }

  // 초기화: 랜덤으로 3개 task 선택
  static void initializeTasks({int taskCount = _defaultTaskCount}) {
    _activeTasks.clear();
    final random = Random();
    final shuffledTasks = List<BoardTask>.from(_allTasks);
    shuffledTasks.shuffle(random);
    
    // 지정된 개수만큼 선택
    for (int i = 0; i < taskCount && i < shuffledTasks.length; i++) {
      _activeTasks.add(shuffledTasks[i]);
    }
  }

  /// 현재 활성화된 task들 가져오기
  static List<BoardTask> getActiveTasks() {
    return List.from(_activeTasks);
  }

  /// 특정 task 제거하고 새로운 task로 교체
  static BoardTask? replaceTask(String taskId) {
    // 완료된 task 제거
    final removedTask = _activeTasks.firstWhere(
      (task) => task.id == taskId,
      orElse: () => throw Exception('Task not found'),
    );
    _activeTasks.remove(removedTask);

    // 새로운 task 선택 (중복되지 않도록)
    List<BoardTask> availableTasks = _allTasks.where(
      (task) => !_activeTasks.any((active) => active.title == task.title) && _getRequiredLevel(task) <= _maxAllowedLevel
    ).toList();

    // 레벨 제한으로 비어있을 경우, 중복은 피하되 전체에서 선택
    if (availableTasks.isEmpty) {
      availableTasks = _allTasks.where(
        (task) => !_activeTasks.any((active) => active.title == task.title)
      ).toList();
    }

    if (availableTasks.isEmpty) {
      // 모든 task가 사용된 경우, 전체에서 랜덤 선택
      availableTasks.addAll(_allTasks);
    }

    final random = Random();
    final newTask = availableTasks[random.nextInt(availableTasks.length)];
    
    // 새로운 task를 리스트 마지막에 추가
    _activeTasks.add(newTask);
    
    return newTask;
  }

  /// 카테고리별 Task 불러오기 (기존 호환성을 위해 유지)
  static List<BoardTask> byCategory(BoardTaskCategory category) {
    return _activeTasks.where((t) => t.category == category).toList();
  }

  /// 모든 task 가져오기
  static List<BoardTask> getAllTasks() {
    return List.from(_allTasks);
  }
}


