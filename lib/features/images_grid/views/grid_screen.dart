import 'package:flutter/material.dart';
import 'package:pixaby_tw/features/images_grid/models/image.dart';
import 'package:pixaby_tw/features/images_grid/views/widgets/image_view.dart';
import 'package:pixaby_tw/features/images_grid_repository.dart';
import 'package:pixaby_tw/features/pagination/models/pagination_model.dart';

class GridScreen extends StatefulWidget {
  static const id = '/';

  const GridScreen({super.key});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  PaginationModel<PixabyImage>? _images;

  Future<void> _loadImages({bool reset = false}) async {
    try {
      final res = await ImagesGridRepository.instance.getImages(
        page: _images?.paginationKey,
      );

      _images = _images.update(res, reset: reset);
      setState(() {});
    } catch (_) {
      // TODO: handle error
    }
  }

  @override
  void initState() {
    super.initState();

    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _images == null
            ? const Center(child: CircularProgressIndicator.adaptive())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  maxCrossAxisExtent: 200,
                ),
                itemBuilder: (context, index) {
                  final image = _images![index];

                  precacheImage(NetworkImage(image.largeImageURL), context);

                  return PixabyImageView(image: image);
                },
                itemCount: _images!.length,
              ),
      ),
    );
  }
}
