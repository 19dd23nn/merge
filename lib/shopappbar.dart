import 'package:flutter/material.dart';
import 'package:merge/widgets/widgets_appbar/coinwidget.dart';
import 'package:merge/widgets/widgets_appbar/diawidget.dart';
import 'package:merge/widgets/widgets_appbar/energywidget.dart';

class ShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final bool automaticallyImplyLeading;

  const ShopAppBar({
    super.key,
    required this.backgroundColor,
    this.automaticallyImplyLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      elevation: 0,
      toolbarHeight: 100,
      titleSpacing: 0,
      title: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            children: [
              const SizedBox(width: 10),

              const EnergyWidget(),

              const SizedBox(width: 10),

              const CoinWidget(),

              const SizedBox(width: 10),

              const DiaWidget(),

              const SizedBox(width: 10),

              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/shop_in.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
