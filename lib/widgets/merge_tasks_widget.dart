import 'dart:math';
import 'package:flutter/material.dart';
import '../data/board_task_data.dart';
import '../game_models.dart';

class MergeTasksWidget extends StatefulWidget {
  final List<BoardTask> mergeTasks;
  final List<List<BoardItem?>>? currentGrid;
  final Function(BoardTask) onCollectTask;

  const MergeTasksWidget({
    super.key,
    required this.mergeTasks,
    required this.currentGrid,
    required this.onCollectTask,
  });

  @override
  State<MergeTasksWidget> createState() => _MergeTasksWidgetState();
}

class _MergeTasksWidgetState extends State<MergeTasksWidget> {
  // 사용 가능한 펫 이미지 목록
  static const List<String> petImages = [
    'assets/pets/pet1/dog1.png',
    'assets/pets/pet2/dog2.png',
    'assets/pets/pet3/cat2.png',
    'assets/pets/pet4/cat1.png',
  ];

  // 각 태스크에 할당된 펫 이미지를 저장 (taskId -> petImagePath)
  final Map<String, String> _taskPetMap = {};
  final Random _random = Random();

  /// 태스크에 랜덤 펫 이미지 할당 (처음 한 번만)
  String _getPetForTask(String taskId) {
    if (!_taskPetMap.containsKey(taskId)) {
      _taskPetMap[taskId] = petImages[_random.nextInt(petImages.length)];
    }
    return _taskPetMap[taskId]!;
  }

  /// 개별 아이템 아이콘 위젯 생성 (이미지 사용)
  Widget _buildItemIcon(String imagePath) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      child: Image.asset(
        imagePath,
        width: 45,
        height: 45,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Text('?', style: const TextStyle(fontSize: 20));
        },
      ),
    );
  }

  /// 태스크에 필요한 아이템들을 아이콘으로 표시
  Widget _buildRequiredItems(BoardTask task) {
    List<Widget> itemIcons = [];

    final title = task.title;
    if (title.startsWith("collect ")) {
      final parts = title.substring(8).split('_');
      if (parts.length == 2) {
        final category = parts[0];
        final number = parts[1];
        itemIcons = [
          _buildItemIcon('assets/items/$category/${category}_$number.png'),
        ];
      }
    }

    if (itemIcons.isEmpty) {
      itemIcons = [_buildItemIcon('assets/sparkle.png')];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: itemIcons
          .map(
            (icon) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: icon,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190, // 펫 이미지를 위해 높이 증가
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.mergeTasks.length,
        itemBuilder: (context, i) {
          final task = widget.mergeTasks[i];
          final canCollect =
              widget.currentGrid != null &&
              task.isConditionMet(widget.currentGrid!);
          final petImage = _getPetForTask(task.id);

          return Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 펫 이미지 (트레이 뒤에 배치)
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      petImage,
                      width: 130,
                      height: 130,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(width: 100, height: 100);
                      },
                    ),
                  ),
                ),

                // 트레이 이미지 (menu.png)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/menu.png'),
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // 아이템 아이콘들을 트레이 위에 배치
                Positioned(
                  bottom: 19,
                  left: 0,
                  right: 0,
                  child: _buildRequiredItems(task),
                ),

                // Collect 버튼 (GO!)
                Positioned(
                  bottom: 5,
                  right: 20,
                  child: SizedBox(
                    width: 40,
                    child: TextButton(
                      onPressed: canCollect
                          ? () => widget.onCollectTask(task)
                          : null,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 24),
                        foregroundColor: canCollect ? task.color : Colors.grey,
                      ),
                      child: Text(
                        canCollect ? 'GO!' : '',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // 보상 골드 표시 (캐릭터 우측)
                Positioned(
                  top: 95,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/coin.png',
                          width: 16,
                          height: 16,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.circle,
                              size: 12,
                              color: Colors.amber,
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${task.rewardCoins}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
