import 'package:bank_sampah/core/constant/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String? photoUrl;
  final String? username;
  final double? size;
  final double? fontSize;
  final void Function()? onTap;

  const AvatarImage({
    super.key,
    this.photoUrl,
    this.username,
    this.size = 32,
    this.fontSize = 14,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        shape: const CircleBorder(side: BorderSide(color: CColors.shadow)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: onTap,
          child: photoUrl == '' || photoUrl == null
              ? Center(
                  child: Text(
                    '${username?[0].toUpperCase()}${username?[1].toUpperCase()}',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: photoUrl!,
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Transform.scale(
                      scale: 0.7,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
