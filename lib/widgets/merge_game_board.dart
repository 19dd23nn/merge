import 'package:flutter/material.dart';
import '../game_models.dart';
import '../services/energy_service.dart';
import '../services/board_state_service.dart';

class MergeGameBoard extends StatefulWidget {
  final Function(List<List<BoardItem?>>)? onBoardChanged;

  const MergeGameBoard({super.key, this.onBoardChanged});

  @override
  State<MergeGameBoard> createState() => _MergeGameBoardState();
}

class _MergeGameBoardState extends State<MergeGameBoard> {
  final int rows = 9;
  final int cols = 7;
  final double cellSize = 55; // 고정 셀 크기(px)
  final int maxItemLevel = 4;
  final int maxPackLevel = 3;
  late List<List<BoardItem?>> grid;
  BoardItem? selectedObject;

  @override
  void initState() {
    super.initState();

    // 저장된 상태가 있으면 복원, 없으면 초기화
    final saved = BoardStateService.instance.savedGrid;
    if (saved != null && saved.length == rows && saved.first.length == cols) {
      grid = _deepCopyAndRewire(saved);
      _resumeAllPackCooldowns();
    } else {
      grid = List.generate(rows, (_) => List.generate(cols, (_) => null));

      // 초기 예시 배치
      grid[0][0] = Item(level: 1, type: ItemType.feed);
      grid[0][1] = Item(level: 1, type: ItemType.feed);
      grid[0][2] = Item(level: 1, type: ItemType.water);

      grid[8][6] = Pack(
        level: 1,
        type: PackType.feedstuff,
        onStateChanged: () {
          if (mounted) {
            widget.onBoardChanged?.call(grid);
          }
        },
      );
      grid[8][5] = Pack(
        level: 1,
        type: PackType.feedstuff,
        onStateChanged: () {
          if (mounted) {
            widget.onBoardChanged?.call(grid);
          }
        },
      );
      grid[7][5] = Pack(
        level: 1,
        type: PackType.watering,
        onStateChanged: () {
          if (mounted) {
            widget.onBoardChanged?.call(grid);
          }
        },
      );
    }
  }

  void _resumeAllPackCooldowns() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        if (cell is Pack) {
          cell.resumeCooldownIfNeeded(() {
            if (mounted) setState(() {});
          });
        }
      }
    }
  }

  // 저장소에서 가져온 grid를 안전하게 복사하고 Pack의 콜백을 현재 위젯에 맞게 재부착
  List<List<BoardItem?>> _deepCopyAndRewire(List<List<BoardItem?>> source) {
    final copied = List.generate(rows, (_) => List<BoardItem?>.filled(cols, null));
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = source[r][c];
        if (cell == null) {
          copied[r][c] = null;
        } else if (cell is Item) {
          copied[r][c] = Item(level: cell.level, type: cell.type);
        } else if (cell is Pack) {
          final newPack = Pack(level: cell.level, type: cell.type, onStateChanged: () {
            if (mounted) {
              widget.onBoardChanged?.call(copied);
            }
          });
          // 런타임 상태값들도 복원
          newPack.onCooldown = cell.onCooldown;
          newPack.cooldownSecondsLeft = cell.cooldownSecondsLeft;
          newPack.remaining = cell.remaining;
          copied[r][c] = newPack;
        }
      }
    }
    return copied;
  }

  @override
  void dispose() {
    // 모든 팩 타이머 정리 후 상태 저장
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        if (cell is Pack) {
          cell.disposeTimer();
        }
      }
    }
    BoardStateService.instance.saveGrid(grid);
    super.dispose();
  }

  void handleDrop(int targetRow, int targetCol, int sourceRow, int sourceCol) {
    setState(() {
      if (targetRow == sourceRow && targetCol == sourceCol) return;

      final source = grid[sourceRow][sourceCol];
      final target = grid[targetRow][targetCol];

      // --- MERGE LOGIC ---
      if (source != null && target != null) {
        bool merged = false;
        if (source is Item &&
            target is Item &&
            source.type == target.type &&
            source.level == target.level &&
            source.level < maxItemLevel) {
          final newItem = Item(level: source.level + 1, type: source.type);
          grid[targetRow][targetCol] = newItem;
          if (selectedObject == source) selectedObject = newItem;
          grid[sourceRow][sourceCol] = null;
          merged = true;
        } else if (source is Pack &&
            target is Pack &&
            source.type == target.type &&
            source.level == target.level &&
            source.level < maxPackLevel) {
          final newPack = Pack(level: source.level + 1, type: source.type, onStateChanged: () {
            if (mounted) {
              widget.onBoardChanged?.call(grid);
            }
          });
          grid[targetRow][targetCol] = newPack;
          if (selectedObject == source) selectedObject = newPack;
          grid[sourceRow][sourceCol] = null;
          merged = true;
        }

        if (merged) return;
      }

      // --- MOVEMENT LOGIC ---
      if (target != null &&
          isAdjacent(sourceRow, sourceCol, targetRow, targetCol)) {
        grid[sourceRow][sourceCol] = target;
        grid[targetRow][targetCol] = source;
        return;
      }

      if (target != null) {
        final nearest = findNearestEmptyCellFrom(
          targetRow,
          targetCol,
          except: {
            '$sourceRow,$sourceCol': true,
            '$targetRow,$targetCol': true,
          },
        );
        if (nearest != null) {
          grid[nearest['row']!][nearest['col']!] = target;
        } else {
          return;
        }
      }

      grid[targetRow][targetCol] = source;
      grid[sourceRow][sourceCol] = null;
    });

    // 보드 상태 변경 후 콜백 및 저장
    widget.onBoardChanged?.call(grid);
    BoardStateService.instance.saveGrid(grid);
  }

  bool isAdjacent(int r1, int c1, int r2, int c2) {
    final dr = (r1 - r2).abs();
    final dc = (c1 - c2).abs();
    return (dr + dc) == 1;
  }

  void onCellTapped(int row, int col, BoardItem cell) {
    setState(() {
      if (selectedObject != cell) {
        selectedObject = cell;
      } else if (cell is Pack) {
        if (!cell.onCooldown && cell.remaining > 0) {
          // 에너지가 부족한지 확인
          if (EnergyService.instance.energy <= 0) {
            // 에너지가 부족하면 아이템 생성 불가
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('에너지가 부족합니다!'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          
          final nearest = findNearestEmptyCellFrom(row, col);
          if (nearest != null) {
            grid[nearest['row']!][nearest['col']!] = cell.generateItem();
            cell.remaining--;
            
            // 아이템 생성 시 에너지 1 감소
            EnergyService.instance.consumeEnergy(1);
            
            if (cell.remaining == 0) {
              cell.onStateChanged = () {
                if (mounted) {
                  widget.onBoardChanged?.call(grid);
                }
              };
              cell.startCooldown(() {
                setState(() {});
                // 쿨다운 시작 후 보드 상태 변경 알림
                widget.onBoardChanged?.call(grid);
              });
            }
            // 아이템 생성 후 보드 상태 변경 알림
            widget.onBoardChanged?.call(grid);
          }
        }
      }
    });

    // 보드 상태 변경 후 콜백 및 저장
    widget.onBoardChanged?.call(grid);
    BoardStateService.instance.saveGrid(grid);
  }

  Map<String, int>? findNearestEmptyCellFrom(
    int fromRow,
    int fromCol, {
    Map<String, bool>? except,
  }) {
    List<Map<String, int>> empty = [];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] == null) {
          String key = '$r,$c';
          if (except != null && except.containsKey(key)) continue;
          int dist = (fromRow - r).abs() + (fromCol - c).abs();
          empty.add({'row': r, 'col': c, 'distance': dist});
        }
      }
    }
    if (empty.isEmpty) return null;
    empty.sort((a, b) => a['distance']!.compareTo(b['distance']!));
    return empty.first;
  }

  bool isSelected(BoardItem? cell) {
    return cell != null && cell == selectedObject;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 이미지 (고정 크기로 설정)
        Center(
          child: SizedBox(
            width: 420, // 고정된 배경 이미지 크기
            height: 538, // 고정된 배경 이미지 크기
            child: Image.asset(
              'assets/board.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        // 게임 그리드 (배경 이미지와 정확히 중앙 정렬)
        Center(
          child: Column(
            children: [
              SizedBox(height: 21.5),
              SizedBox(
                width: cellSize * cols,
                height: cellSize * rows,
                child: buildGrid(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGrid() {
    final cells = <Widget>[];
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        cells.add(buildCell(row, col));
      }
    }

    return GridView.count(
      crossAxisCount: cols,
      childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: cells,
    );
  }

  Widget buildCell(int row, int col) {
    final cell = grid[row][col];
    final isSel = isSelected(cell);

    final baseColor = (row + col) % 2 == 0 ? Colors.grey[300] : Colors.white;
    final backgroundColor = isSel ? Colors.blue[100] : baseColor;

    final overlay = cell is Pack && cell.onCooldown
        ? Text(
            '⏳ ${cell.cooldownSecondsLeft}s',
            style: const TextStyle(fontSize: 12),
          )
        : null;

    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (details) {
        handleDrop(row, col, details.data['row'], details.data['col']);
      },
      builder: (context, _, __) {
        return GestureDetector(
          onTap: cell != null ? () => onCellTapped(row, col, cell) : null,
          child: Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
                        child: (cell != null)
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Draggable<Map<String, dynamic>>(
                        data: {'row': row, 'col': col},
                        onDragStarted: () {
                          setState(() {
                            selectedObject = cell;
                          });
                        },
                        feedback: Material(
                          color: Colors.transparent,
                          child: Image.asset(
                            cell.imagePath,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                '?',
                                style: const TextStyle(fontSize: 28),
                              );
                            },
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: Material(
                            color: Colors.transparent,
                            child: Image.asset(
                              cell.imagePath,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  '?',
                                  style: const TextStyle(fontSize: 28),
                                );
                              },
                            ),
                          ),
                        ),
                        child: Image.asset(
                          cell.imagePath,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              '?',
                              style: const TextStyle(fontSize: 28),
                            );
                          },
                        ),
                      ),
                      if (overlay != null)
                        Positioned(bottom: 2, child: overlay),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }
} 