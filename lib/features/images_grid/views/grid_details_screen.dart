import 'package:flutter/material.dart';
import 'package:pixaby_tw/features/images_grid/models/image.dart';

class GridDetailsScreen extends StatelessWidget {
  static const id = '/details';

  const GridDetailsScreen({
    super.key,
    required this.image,
  });

  final PixabyImage image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: Hero(
                tag: image.id,
                child: Image.network(
                  image.largeImageURL,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;

                    return Center(
                      child: CircularProgressIndicator.adaptive(
                        value: progress.expectedTotalBytes == null
                            ? null
                            : progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!,
                      ),
                    );
                  },
                ),
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
      ),
    );
  }
}
