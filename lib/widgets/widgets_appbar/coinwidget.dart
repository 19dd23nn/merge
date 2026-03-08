import 'package:flutter/material.dart';
import '../../services/coin_service.dart';

class CoinWidget extends StatefulWidget {
  const CoinWidget({super.key});

  @override
  State<CoinWidget> createState() => _CoinWidgetState();
}

class _CoinWidgetState extends State<CoinWidget> {
  late final CoinService _service;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _service = CoinService.instance;
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

  String _format(int value) {
    return value.toString();
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
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      _format(_service.coins),
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

          Positioned(
            bottom: -10,
            left: -5,
            height: 50,
            width: 50,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/coin.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
