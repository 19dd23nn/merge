import 'package:flutter/material.dart';

class DiaWidget extends StatelessWidget {
  const DiaWidget({super.key});

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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withAlpha(150),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, top: 3.5),
                    child: Text(
                      '9999',
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
                  image: AssetImage('assets/dia.png'),
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
