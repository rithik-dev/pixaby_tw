extension PaginationModelExtension<T> on PaginationModel<T>? {
  // do not call this like response?.update, call it like response.update...
  PaginationModel<T> update(
    PaginationModel<T> newResponse, {
    bool reset = false,
  }) {
    return reset || this == null ? newResponse : this!._update(newResponse);
  }
}

class PaginationModel<T> {
  dynamic paginationKey;
  List<T> data;
  int itemsPerPage;
  final String Function(T) idGetter;
  final dynamic Function(T) _paginationKeyGetter;
  bool allowMultipleItemsWithSameId;
  Map<String, dynamic>? meta;

  dynamic getPaginationKeyForItem(T item) => _paginationKeyGetter(item);

  dynamic getPaginationKeyForItemAtIndex(int index) =>
      getPaginationKeyForItem(data[index]);

  static bool _calculateHasMore({
    required int dataLength,
    required int itemsPerPage,
  }) {
    if (dataLength == 0) return false;

    return dataLength >= itemsPerPage;
  }

  late bool _hasMore;

  PaginationModel.empty({
    required this.idGetter,
  })  : paginationKey = null,
        _hasMore = false,
        itemsPerPage = 0,
        data = const [],
        allowMultipleItemsWithSameId = false,
        _paginationKeyGetter = ((_) => null);

  PaginationModel.fromList({
    required this.data,
    required this.idGetter,
  })  : paginationKey = null,
        _hasMore = false,
        itemsPerPage = 0,
        allowMultipleItemsWithSameId = false,
        _paginationKeyGetter = ((_) => null);

  PaginationModel({
    required this.data,
    required this.itemsPerPage,
    required dynamic Function(T) paginationKeyGetter,
    required this.idGetter,
    this.allowMultipleItemsWithSameId = false,
    this.meta,
    bool? hasMoreOverride,
    dynamic defaultPaginationKey,
  })  : _hasMore = hasMoreOverride ??
            _calculateHasMore(
              dataLength: data.length,
              itemsPerPage: itemsPerPage,
            ),
        _paginationKeyGetter = paginationKeyGetter,
        paginationKey = defaultPaginationKey ??
            _getPaginationKey(
              data,
              paginationKeyGetter: paginationKeyGetter,
            );

  bool get hasMore => _hasMore;

  bool get isEmpty => data.isEmpty;

  bool get isNotEmpty => data.isNotEmpty;

  int get length => data.length;

  PaginationModel<N> updateListWithNewType<N>(
    N Function(T) mapper, {
    required dynamic Function(N) paginationKeyGetter,
    required String Function(N) idGetter,
  }) {
    return PaginationModel<N>(
      data: data.map(mapper).toList().cast<N>(),
      itemsPerPage: itemsPerPage,
      idGetter: idGetter,
      allowMultipleItemsWithSameId: allowMultipleItemsWithSameId,
      paginationKeyGetter: paginationKeyGetter,
      defaultPaginationKey: paginationKey,
      meta: meta,
    ).._hasMore = _hasMore;
  }

  void addAll(
    Iterable<T> newData, {
    bool shouldUpdatePaginationKey = true,
  }) {
    data = <T>[...data];

    if (allowMultipleItemsWithSameId) {
      data.addAll(newData);
    } else {
      final existingIds = data.map(idGetter).toSet();
      data.addAll(
        newData.where((e) => !existingIds.contains(idGetter(e))),
      );
    }

    if (shouldUpdatePaginationKey) updatePaginationKey();
  }

  PaginationModel<T> _update(PaginationModel<T> newResponse) {
    itemsPerPage = newResponse.itemsPerPage;

    _hasMore = _calculateHasMore(
      dataLength: newResponse.length,
      itemsPerPage: itemsPerPage,
    );

    if (newResponse.isNotEmpty) {
      addAll(newResponse.data, shouldUpdatePaginationKey: false);
      paginationKey = newResponse.paginationKey;
    }

    meta = {
      ...?meta,
      ...?newResponse.meta,
    };

    allowMultipleItemsWithSameId = newResponse.allowMultipleItemsWithSameId;

    return this;
  }

  void insert(
    T item, {
    int insertionIdx = 0,
    bool removeLastIfExceedsItemsPerPage = true,
    bool shouldUpdatePaginationKey = true,
  }) {
    data = <T>[...data];

    final id = idGetter(item);

    if (!allowMultipleItemsWithSameId) {
      final existingIdx = data.indexWhere((e) => idGetter(e) == id);
      if (existingIdx != -1) {
        data.removeAt(existingIdx);
      }
    }

    data.insert(insertionIdx, item);

    if (removeLastIfExceedsItemsPerPage && data.length > itemsPerPage) {
      data.removeLast();
    }

    if (shouldUpdatePaginationKey) {
      updatePaginationKey();
    }
  }

  void updateMeta(
    Map<String, dynamic> Function(Map<String, dynamic>?) updater,
  ) {
    meta = updater(meta);
  }

  void updatePaginationKey() {
    paginationKey = _getPaginationKey(
      data,
      paginationKeyGetter: _paginationKeyGetter,
    );
  }

  static dynamic _getPaginationKey<T>(
    List<T> data, {
    required dynamic Function(T) paginationKeyGetter,
  }) {
    return data.isEmpty ? null : paginationKeyGetter(data.last);
  }

  PaginationModel<T> map(T Function(T) mapper, {bool inPlace = false}) {
    if (inPlace) {
      data = data.map(mapper).toList().cast<T>();
      return this;
    } else {
      return PaginationModel<T>(
        data: data.map(mapper).toList().cast<T>(),
        itemsPerPage: itemsPerPage,
        idGetter: idGetter,
        defaultPaginationKey: paginationKey,
        paginationKeyGetter: _paginationKeyGetter,
        allowMultipleItemsWithSameId: allowMultipleItemsWithSameId,
        meta: meta,
      ).._hasMore = _hasMore;
    }
  }

  PaginationModel<T> filter(
    bool Function(T) predicate, {
    bool inPlace = false,
  }) {
    if (inPlace) {
      data = data.where(predicate).toList().cast<T>();
      return this;
    } else {
      return PaginationModel<T>(
        data: data.where(predicate).toList().cast<T>(),
        itemsPerPage: itemsPerPage,
        idGetter: idGetter,
        defaultPaginationKey: paginationKey,
        paginationKeyGetter: _paginationKeyGetter,
        allowMultipleItemsWithSameId: allowMultipleItemsWithSameId,
        meta: meta,
      ).._hasMore = _hasMore;
    }
  }

  bool updateItemWithId(
    String id, {
    required T Function(T) updater,
  }) {
    final index = data.indexWhere((e) => idGetter(e) == id);
    if (index != -1) {
      data[index] = updater(data[index]);
      return true;
    }

    return false;
  }

  void operator []=(int index, T value) => data[index] = value;

  T operator [](int index) => data[index];
}
