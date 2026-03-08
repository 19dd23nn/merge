import 'package:flutter/material.dart';
import 'game_models.dart';
import 'package:merge/appbar.dart';
import 'data/board_task_repository.dart';
import 'data/board_task_data.dart';
import 'services/coin_service.dart';
import 'widgets/merge_tasks_widget.dart';
import 'widgets/merge_game_board.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key, required this.level});

  final int level;

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<BoardTask> mergeTasks = [];
  List<List<BoardItem?>>? currentGrid;

  @override
  void initState() {
    super.initState();
    _loadMergeTasks();
  }

  int _taskCountForLevel(int level) {
    if (level >= 9) return 5;
    if (level >= 5) return 4;
    if (level >= 3) return 3;
    return 3;
  }

  void _loadMergeTasks() {
    setState(() {
      final maxCount = _taskCountForLevel(widget.level);
      BoardTaskRepository.resetTasksForLevelWithCount(widget.level, maxCount);
      mergeTasks = BoardTaskRepository.getActiveTasks();
    });
  }

  void _onBoardChanged(List<List<BoardItem?>> grid) {
    setState(() {
      currentGrid = grid;
    });
  }

  void _collectTask(BoardTask task) {
    // 현재 보드 상태 확인 및 조건 검증
    if (currentGrid == null || !task.isConditionMet(currentGrid!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('조건을 만족하는 아이템이 없습니다.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 조건 아이템 1개 소진
    final consumed = task.consumeOneFromGrid(currentGrid!);
    if (!consumed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('아이템 소진에 실패했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 보상 코인 지급
    if (task.rewardCoins > 0) {
      CoinService.instance.add(task.rewardCoins);
    }

    try {
      // task 교체: 완료된 task 제거하고 새로운 task 추가
      final newTask = BoardTaskRepository.replaceTask(task.id);

      setState(() {
        // mergeTasks를 새로 가져오기
        mergeTasks = BoardTaskRepository.getActiveTasks();
        // currentGrid는 동일 참조를 유지하며 이미 소진 반영됨
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Task completed! +${task.rewardCoins} coins. New task: ${newTask?.title ?? "None"}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task completion failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 110,
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                // Aidkit Button (왼쪽)
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/aidkit.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.medical_services, color: Colors.white),
                  ),
                ),
                const Expanded(flex: 6, child: SizedBox()),
                // Back Button (오른쪽)
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        'assets/brush.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: SharedAppBar(backgroundColor: Colors.transparent),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Merge Tasks Widget (겹치되 잘리지 않게 처리)
              SizedBox(
                height: 190,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 35,
                      child: MergeTasksWidget(
                        mergeTasks: mergeTasks,
                        currentGrid: currentGrid,
                        onCollectTask: _collectTask,
                      ),
                    ),
                  ],
                ),
              ),

              MergeGameBoard(onBoardChanged: _onBoardChanged),
              const SizedBox(height: 15),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context),
        ),
      ],
    );
  }
}

class BoardState extends ChangeNotifier {
  Map<String, int> items = {}; // {"apple": 2, "dessert": 1}

  void addItem(String name) {
    items[name] = (items[name] ?? 0) + 1;
    notifyListeners();
  }

  void removeItem(String name, int count) {
    if (items.containsKey(name)) {
      items[name] = (items[name]! - count).clamp(0, 999);
      notifyListeners();
    }
  }
}
