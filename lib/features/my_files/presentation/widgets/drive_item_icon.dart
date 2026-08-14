import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/drive_item.dart';

class DriveItemIcon extends StatelessWidget {
  const DriveItemIcon({
    required this.item,
    required this.size,
    super.key,
  });

  final DriveItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return switch (item.kind) {
      DriveItemKind.folder => _FolderIcon(
        size: size,
        shared: item.isShared,
      ),
      DriveItemKind.personalVault => _VaultIcon(size: size),
      DriveItemKind.pdf => _DocumentIcon(
        size: size,
        color: AppColors.pdf,
        label: 'PDF',
      ),
      DriveItemKind.excel => _DocumentIcon(
        size: size,
        color: AppColors.excel,
        label: 'X',
      ),
      DriveItemKind.word => _DocumentIcon(
        size: size,
        color: AppColors.word,
        label: 'W',
      ),
      DriveItemKind.powerPoint => _DocumentIcon(
        size: size,
        color: AppColors.powerPoint,
        label: 'P',
      ),
      DriveItemKind.photo => Icon(
        Icons.photo_rounded,
        size: size,
        color: AppColors.photo,
      ),
      DriveItemKind.text => Icon(
        Icons.description_outlined,
        size: size,
        color: AppColors.textFile,
      ),
      DriveItemKind.video => Icon(
        Icons.video_file_rounded,
        size: size,
        color: AppColors.video,
      ),
      DriveItemKind.generic => Icon(
        Icons.insert_drive_file_outlined,
        size: size,
        color: AppColors.genericFile,
      ),
    };
  }
}

class _FolderIcon extends StatelessWidget {
  const _FolderIcon({required this.size, required this.shared});

  final double size;
  final bool shared;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Icon(
              Icons.folder_rounded,
              size: size,
              color: AppColors.folder,
            ),
          ),
          if (shared)
            PositionedDirectional(
              end: -size * .04,
              bottom: -size * .04,
              child: Container(
                width: size * .46,
                height: size * .46,
                decoration: const BoxDecoration(
                  color: AppColors.brandAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people_alt_rounded,
                  size: size * .28,
                  color: AppColors.onBrand,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VaultIcon extends StatelessWidget {
  const _VaultIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.brandAccent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        size: size * .56,
        color: AppColors.onBrand,
      ),
    );
  }
}

class _DocumentIcon extends StatelessWidget {
  const _DocumentIcon({
    required this.size,
    required this.color,
    required this.label,
  });

  final double size;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.insert_drive_file_rounded, size: size, color: color),
          Positioned(
            left: size * .17,
            right: size * .17,
            bottom: size * .18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.buttonLarge),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: AppTypography.myFilesPopupHeader.copyWith(
                  color: AppColors.onBrand,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}