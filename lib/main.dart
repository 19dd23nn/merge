import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'services/coin_service.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'board.dart';
import 'utils/no_animation_page_route.dart';

class _TaskEntry {
  final String title;
  final int cost;
  final bool cleared;

  const _TaskEntry({
    required this.title,
    required this.cost,
    this.cleared = false,
  });

  _TaskEntry copyWith({String? title, int? cost, bool? cleared}) {
    return _TaskEntry(
      title: title ?? this.title,
      cost: cost ?? this.cost,
      cleared: cleared ?? this.cleared,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSpineFlutter(enableMemoryDebugging: false);
  runApp(const MergeGameApp());
}

class MergeGameApp extends StatelessWidget {
  const MergeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentLevel = 1;
  int maxLevel = 5; // 기본값

  late final CoinService _coinService;
  late VoidCallback _coinListener;

  List<_TaskEntry> tasks = [];
  late final SpineWidgetController _dogController;

  @override
  void initState() {
    super.initState();
    _coinService = CoinService.instance;
    _coinListener = () {
      if (mounted) setState(() {});
    };
    _coinService.addListener(_coinListener);
    _generateTasksForLevel();
    _dogController = SpineWidgetController(
      onInitialized: (controller) {
        controller.animationState.setAnimationByName(0, 'loop', true);
      },
    );
  }

  @override
  void dispose() {
    _coinService.removeListener(_coinListener);
    super.dispose();
  }

  void _generateTasksForLevel() {
    // 샘플 8개 생성: 레벨에 따라 코스트를 소폭 증가
    final baseCost = 20 * currentLevel;
    tasks = List.generate(5, (i) {
      final idx = i + 1;
      return _TaskEntry(
        title: 'Task $idx',
        cost: baseCost + i * 5,
        cleared: false,
      );
    });
  }

  void _attemptClearTask(int index) {
    final t = tasks[index];
    if (t.cleared) return;
    if (_coinService.coins < t.cost) return;
    _coinService.spend(t.cost);
    setState(() {
      tasks[index] = t.copyWith(cleared: true);
    });

    // 모두 완료 시 레벨업
    final allCleared = tasks.every((e) => e.cleared);
    if (allCleared) {
      if (currentLevel < maxLevel) {
        setState(() {
          currentLevel += 1;
          _generateTasksForLevel();
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Level up!')));
      } else {
        // 최대 레벨 도달
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Max level reached')));
      }
    }
  }

  bool get _isAtMaxLevel => currentLevel >= maxLevel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/main_bg.png'),
              fit: BoxFit.none,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  Expanded(flex: 3, child: Container()),
                  Expanded(
                    flex: 7,
                    child: Transform.translate(
                      offset: const Offset(0, 70),
                      child: SpineWidget.fromAsset(
                        'assets/dogs/dog1.atlas',
                        'assets/dogs/dog1.json',
                        _dogController,
                        fit: BoxFit.none,
                        sizedByBounds: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.orange,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 15,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Text(
                                      _isAtMaxLevel ? 'Coming soon' : 'Tasks',
                                    ),
                                    onPressed: _isAtMaxLevel
                                        ? null
                                        : () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.6,
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.brown[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: StatefulBuilder(
                                                      builder: (context, setStateDialog) {
                                                        return Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 16,
                                                            ),
                                                            const Text(
                                                              "Tasks",
                                                              style: TextStyle(
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12.0,
                                                                  ),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  '레벨 $currentLevel / Max $maxLevel',
                                                                  style: const TextStyle(
                                                                    color: Colors
                                                                        .white70,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12.0,
                                                                    ),
                                                                child: ListView.separated(
                                                                  itemCount: tasks
                                                                      .length,
                                                                  separatorBuilder:
                                                                      (
                                                                        _,
                                                                        __,
                                                                      ) => const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                  itemBuilder: (context, i) {
                                                                    final t =
                                                                        tasks[i];
                                                                    return Opacity(
                                                                      opacity:
                                                                          t.cleared
                                                                          ? 0.5
                                                                          : 1.0,
                                                                      child: Container(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                              12,
                                                                            ),
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              Colors.brown[400],
                                                                          borderRadius: BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                t.title,
                                                                                style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed:
                                                                                  t.cleared ||
                                                                                      _coinService.coins <
                                                                                          t.cost
                                                                                  ? null
                                                                                  : () {
                                                                                      _attemptClearTask(
                                                                                        i,
                                                                                      );
                                                                                      setStateDialog(
                                                                                        () {},
                                                                                      );
                                                                                    },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.orange,
                                                                                foregroundColor: Colors.white,
                                                                              ),
                                                                              child: Text(
                                                                                'Clear ${t.cost}',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                  ),
                                                              child: ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      "close",
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                  ),
                                ),
                              ),
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.orange,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 15,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Text('Level $currentLevel'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        NoAnimationPageRoute(
                                          page: BoardScreen(
                                            level: currentLevel,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(flex: 2, child: Container()),
                      ],
                    ),
                    flex: 2,
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ],
    );
  }
}
