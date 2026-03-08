import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:merge/shopappbar.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key, this.appBar, this.onPurchase});

  /// 외부에서 직접 AppBar 위젯을 넣고 싶으면 여기로 주입하세요.
  /// 기본값: ShopAppBar
  final PreferredSizeWidget? appBar;

  /// 실제 결제 핸들러를 앱 쪽에서 주입하세요. (DartPad에선 스낵바로 대체)
  final void Function(ShopItem item)? onPurchase;

  void _triggerPurchase(BuildContext context, ShopItem item) {
    if (onPurchase != null) {
      onPurchase!(item);
      return;
    }
    // DartPad-safe stub
    final platform = defaultTargetPlatform;
    final store = platform == TargetPlatform.android
        ? 'Google Play'
        : platform == TargetPlatform.iOS
        ? 'App Store'
        : 'Store';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Would open $store purchase for ${item.name} (${_formatPrice(item.price)})',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _mockItems; // 실제 데이터로 교체 가능
    final byCategory = _groupByCategory(items);
    final catOrder = (byCategory.keys.toList()..sort());

    return Scaffold(
      appBar:
          appBar ?? const ShopAppBar(backgroundColor: Colors.white), // ✅ 기본값 지정
      body: CustomScrollView(
        slivers: [
          for (final cat in catOrder) ...[
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  cat,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3열
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = byCategory[cat]![index];
                  return _ProductCard(
                    item: item,
                    onBuy: () => _triggerPurchase(context, item),
                  );
                }, childCount: byCategory[cat]!.length),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ShopItem item;
  final VoidCallback onBuy;
  const _ProductCard({required this.item, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onBuy,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: item.imageUrl == null
                        ? Center(
                            child: Icon(
                              item.icon,
                              size: 36,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(
                                item.icon,
                                size: 36,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onBuy,
                  child: Text('Buy • ${_formatPrice(item.price)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final IconData icon;
  final String? imageUrl;
  final List<String> tags;

  const ShopItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    this.imageUrl,
    this.tags = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ShopItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

String _formatPrice(double v) {
  final s = v.toStringAsFixed(2);
  final parts = s.split('.');
  final whole = parts[0];
  final decimals = parts[1];
  final buf = StringBuffer();
  for (int i = 0; i < whole.length; i++) {
    final left = whole.length - i - 1;
    buf.write(whole[i]);
    if (left > 0 && left % 3 == 0) buf.write(',');
  }
  return '\$${buf.toString()}.$decimals';
}

Map<String, List<ShopItem>> _groupByCategory(List<ShopItem> items) {
  final map = <String, List<ShopItem>>{};
  for (final i in items) {
    map.putIfAbsent(i.category, () => []).add(i);
  }
  return map;
}

// --- MOCK DATA ---
const List<ShopItem> _mockItems = [
  ShopItem(
    id: 'p1',
    name: 'Gem Pack Small',
    category: 'Gems',
    price: 4.99,
    icon: Icons.diamond_outlined,
    tags: ['currency', 'starter'],
  ),
  ShopItem(
    id: 'p2',
    name: 'Gem Pack Medium',
    category: 'Gems',
    price: 9.99,
    icon: Icons.diamond_rounded,
    tags: ['currency', 'value'],
  ),
  ShopItem(
    id: 'p3',
    name: 'Gem Pack Large',
    category: 'Gems',
    price: 19.99,
    icon: Icons.auto_awesome,
    tags: ['currency', 'best'],
  ),
  ShopItem(
    id: 'p4',
    name: 'Starter Bundle',
    category: 'Bundles',
    price: 6.99,
    icon: Icons.backpack_outlined,
    tags: ['bundle', 'starter'],
  ),
  ShopItem(
    id: 'p5',
    name: 'Epic Bundle',
    category: 'Bundles',
    price: 24.99,
    icon: Icons.workspace_premium_outlined,
    tags: ['bundle', 'epic'],
  ),
  ShopItem(
    id: 'p6',
    name: 'Energy Refill',
    category: 'Boosts',
    price: 2.99,
    icon: Icons.bolt,
    tags: ['energy', 'boost'],
  ),
  ShopItem(
    id: 'p7',
    name: 'Double XP (24h)',
    category: 'Boosts',
    price: 3.99,
    icon: Icons.trending_up,
    tags: ['xp', 'boost'],
  ),
  ShopItem(
    id: 'p8',
    name: 'Premium Pass',
    category: 'Passes',
    price: 9.99,
    icon: Icons.card_membership,
    tags: ['season', 'premium'],
  ),
  ShopItem(
    id: 'p9',
    name: 'Skin: Neon Dragon',
    category: 'Cosmetics',
    price: 4.49,
    icon: Icons.brush,
    tags: ['skin', 'cosmetic', 'dragon'],
  ),
  ShopItem(
    id: 'p10',
    name: 'Skin: Cyber Ninja',
    category: 'Cosmetics',
    price: 4.49,
    icon: Icons.brush_outlined,
    tags: ['skin', 'cosmetic', 'ninja'],
  ),
];
