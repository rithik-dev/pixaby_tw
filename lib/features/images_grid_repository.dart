import 'package:pixaby_tw/features/images_grid/models/image.dart';
import 'package:pixaby_tw/features/pagination/models/pagination_model.dart';
import 'package:pixaby_tw/utils/base_repository.dart';

class ImagesGridRepository with BaseRepository {
  const ImagesGridRepository._internal();

  static const instance = ImagesGridRepository._internal();

  Future<PaginationModel<PixabyImage>> getImages({int? page}) async {
    page ??= 1;

    const limit = 50;

    final res = await dio.get(
      'https://pixabay.com/api/',
      queryParameters: {
        'key': '43406570-3b69381bc1dafd3b0b9adc7f3',
        'page': page,
        'per_page': limit,
      },
    );

    final hits = (res.data['hits'] as List)
        .map((e) => PixabyImage.fromJson(e))
        .cast<PixabyImage>()
        .toList();

    return PaginationModel(
      data: hits,
      itemsPerPage: limit,
      paginationKeyGetter: (_) => page! + 1,
      idGetter: (e) => e.id,
    );
  }
}
