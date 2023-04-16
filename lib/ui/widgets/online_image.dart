import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OnlineImage extends StatelessWidget {
  const OnlineImage({
    required this.placeholder,
    this.picture,
  });

  final String? picture;
  final String placeholder;

  @override
  Widget build(final BuildContext context) {
    final image = picture;
    return image == null
        ? Image.asset(
            placeholder,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            placeholder: (final context, final url) => const Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (final context, final url, final error) => Image.asset(
              'assets/spaceship.jpg',
              fit: BoxFit.cover,
            ),
          );
  }
}
