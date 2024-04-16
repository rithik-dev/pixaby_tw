import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pixaby_tw/features/images_grid/models/image.dart';
import 'package:pixaby_tw/features/images_grid/views/widgets/image_view.dart';
import 'package:pixaby_tw/features/images_grid_repository.dart';
import 'package:pixaby_tw/features/pagination/models/pagination_model.dart';

class GridScreen extends StatefulWidget {
  static const id = '/';

  const GridScreen({super.key});

  static const maxThumbnailWidth = 300.0;

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  final _scrollController = ScrollController();

  PaginationModel<PixabyImage>? _images;
  Object? _error;
  bool _loadMoreError = false;

  void _registerResetListener() {
    _scrollController.addListener(() {
      final pos = _scrollController.position;

      if (pos.userScrollDirection == ScrollDirection.reverse &&
          pos.pixels > pos.maxScrollExtent &&
          _loadMoreError) {
        setState(() => _loadMoreError = false);
      }
    });
  }

  Future<void> _loadImages({bool reset = false}) async {
    try {
      if (reset && _error != null) {
        _error = null;
        setState(() {});
      }

      final res = await ImagesGridRepository.instance.getImages(
        page: _images?.paginationKey,
      );

      _images = _images.update(res, reset: reset);
      if (!reset) _loadMoreError = false;
      setState(() {});
    } catch (e) {
      if (!reset) {
        _loadMoreError = true;
      } else {
        _error = e;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _registerResetListener();
    _loadImages(reset: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _error != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Something went wrong!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _loadImages(reset: true),
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              )
            : _images == null
                ? const Center(child: CircularProgressIndicator.adaptive())
                : RefreshIndicator(
                    onRefresh: () => _loadImages(reset: true),
                    child: GridView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        maxCrossAxisExtent: GridScreen.maxThumbnailWidth,
                      ),
                      itemBuilder: (context, index) {
                        if (_images!.length == index && _images!.hasMore) {
                          _loadImages();

                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        final image = _images![index];
                        return PixabyImageView(image: image);
                      },
                      itemCount: _images!.length +
                          (_images!.hasMore && !_loadMoreError ? 1 : 0),
                    ),
                  ),
      ),
    );
  }
}
