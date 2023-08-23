import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String? photoUrl;
  final bool isLoading;
  final String? username;
  final void Function()? onTap;

  const AvatarImage({
    super.key,
    required this.photoUrl,
    required this.username,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: onTap,
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Transform.scale(
                    scale: 0.7,
                    child: const CircularProgressIndicator(),
                  ),
                )
              : photoUrl == '' || photoUrl == null
                  ? Center(
                      child: Text(
                        '${username?[0].toUpperCase()}${username?[1].toUpperCase()}',
                        style: const TextStyle(),
                      ),
                    )
                  : Ink.image(
                      width: 32,
                      height: 32,
                      image: CachedNetworkImageProvider(photoUrl!),
                    ),
        ),
      ),
    );
  }
}
