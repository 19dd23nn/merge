import 'package:flutter/material.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets'),
        centerTitle: true,
      ),
      // ===== body =====
      body: Container(
        color: const Color(0xFF0E63B5), // 파란 배경 레일
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            CharacterCard(
              name: 'Raya',
              episode: null, // 회색 처리 + 잠금
              locked: true,
              image: const AssetImage('assets/raya.png'), // 없으면 Placeholder로 대체됨
            ),
            const SizedBox(height: 12),
            CharacterCard(
              name: 'James',
              episode: 2,
              locked: true,
              image: const AssetImage('assets/james.png'),
              desaturateWhenLocked: true,
            ),
            const SizedBox(height: 12),
            CharacterCard(
              name: 'Jessica',
              episode: 1,
              locked: false,
              image: const AssetImage('assets/jessica.png'),
              progressCurrent: 1,
              progressTotal: 14,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// 재사용 가능한 캐릭터 카드
class CharacterCard extends StatelessWidget {
  final String name;
  final int? episode; // null이면 에피소드 배지 미표시
  final bool locked;
  final ImageProvider? image;
  final int? progressCurrent;
  final int? progressTotal;
  final bool desaturateWhenLocked;

  const CharacterCard({
    super.key,
    required this.name,
    required this.locked,
    this.episode,
    this.image,
    this.progressCurrent,
    this.progressTotal,
    this.desaturateWhenLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasProgress = progressCurrent != null && progressTotal != null;

    Widget portrait = image != null
        ? Image(
      image: image!,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    )
        : Container(color: Colors.grey.shade300);

    if (locked && desaturateWhenLocked) {
      portrait = ColorFiltered(
        colorFilter:
        const ColorFilter.mode(Colors.grey, BlendMode.saturation),
        child: portrait,
      );
    }

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 배경 이미지
            SizedBox(
              height: 210,
              width: double.infinity,
              child: portrait,
            ),
            // 상단 에피소드 배지
            if (episode != null)
              Positioned(
                top: 8,
                left: 12,
                child: EpisodeBadge(episode: episode!),
              ),
            // 오른쪽 상단 i 버튼
            Positioned(
              top: 8,
              right: 12,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(Icons.info, size: 16, color: Colors.blue.shade700),
              ),
            ),
            // 하단 정보 바
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        if (locked)
                          const Icon(Icons.lock_outline, size: 18),
                      ],
                    ),
                    if (hasProgress) ...[
                      const SizedBox(height: 6),
                      _ProgressBar(
                        value: progressCurrent! / progressTotal!,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${progressCurrent!}/${progressTotal!}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EpisodeBadge extends StatelessWidget {
  final int episode;
  const EpisodeBadge({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFF8A65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Colors.black26),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.movie, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            'Episode $episode',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value; // 0.0 ~ 1.0
  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 10,
        backgroundColor: const Color(0xFFE8F5E9),
        valueColor: const AlwaysStoppedAnimation(Color(0xFF66BB6A)),
      ),
    );
  }
}
