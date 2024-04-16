import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pixaby_tw/features/images_grid/models/image.dart';
import 'package:pixaby_tw/features/images_grid/views/grid_details_screen.dart';

class PixabyImageView extends StatelessWidget {
  const PixabyImageView({
    super.key,
    required this.image,
  });

  final PixabyImage image;

  static final _didHoverMap = <String, ValueNotifier<bool>>{};

  @override
  Widget build(BuildContext context) {
    _didHoverMap[image.id] ??= ValueNotifier(false);

    return InkWell(
      onHover: (isHovering) {
        if (isHovering && !_didHoverMap[image.id]!.value) {
          _didHoverMap[image.id]!.value = true;
        }
      },
      onTap: () => Navigator.pushNamed(
        context,
        GridDetailsScreen.id,
        arguments: {'image': image},
      ),
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _didHoverMap[image.id]!,
              child: Hero(
                tag: image.id,
                child: CachedNetworkImage(
                  imageUrl: image.previewURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              builder: (context, didHover, child) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    child!,
                    if (didHover)
                      CachedNetworkImage(
                        imageUrl: image.largeImageURL,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          image.likes.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          image.views.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
