import '../game_models.dart';

class BoardStateService {
  static final BoardStateService instance = BoardStateService._internal();
  BoardStateService._internal();

  // 최근 저장된 그리드 상태 (앱 생명주기 동안 메모리 유지)
  List<List<BoardItem?>>? _savedGrid;

  List<List<BoardItem?>>? get savedGrid => _savedGrid;

  void saveGrid(List<List<BoardItem?>> grid) {
    // 2차원 리스트 + 셀 객체까지 딥 카피
    _savedGrid = List.generate(grid.length, (r) {
      return List<BoardItem?>.generate(grid[r].length, (c) {
        final cell = grid[r][c];
        if (cell == null) return null;
        if (cell is Item) {
          return Item(level: cell.level, type: cell.type);
        }
        if (cell is Pack) {
          final p = Pack(level: cell.level, type: cell.type);
          p.onCooldown = cell.onCooldown;
          p.cooldownSecondsLeft = cell.cooldownSecondsLeft;
          p.remaining = cell.remaining;
          return p;
        }
        return null;
      });
    });
  }

  void clear() {
    _savedGrid = null;
  }
} 