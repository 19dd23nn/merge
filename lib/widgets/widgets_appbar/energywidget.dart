import 'package:flutter/material.dart';
import '../../services/energy_service.dart';

class EnergyWidget extends StatefulWidget {
  const EnergyWidget({super.key});

  @override
  State<EnergyWidget> createState() => _EnergyWidgetState();
}

class _EnergyWidgetState extends State<EnergyWidget> {
  late final EnergyService _service;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _service = EnergyService.instance;
    _service.ensureStarted();
    _listener = () {
      if (mounted) setState(() {});
    };
    _service.addListener(_listener);
  }

  @override
  void dispose() {
    _service.removeListener(_listener);
    super.dispose();
  }

  void startTimer() {}

  void addEnergy(int amount) {
    _service.addEnergy(amount); // 아이템 사용 → 100 초과 가능
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 7,
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withAlpha(150),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '${_service.energy}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 에너지 아이콘
          Positioned(
            bottom: -10,
            left: -5,
            height: 50,
            width: 50,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/energy.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 타이머 (컨테이너 상단 바로 아래에 겹치게 배치)
          if (_service.energy < 100)
            Positioned(
              top: 31, // 컨테이너 높이(30)보다 조금 아래에 배치
              left: 21,
              right: 0,
              child: Center(
                child: Text(
                  formatTime(_service.timerSeconds),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
