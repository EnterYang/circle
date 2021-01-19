import 'dart:async' show Future, StreamController;
import 'dart:ui' as ui show Codec;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CIRCachedNetworkImageProvider
    extends ImageProvider<CachedNetworkImageProvider>
    implements CachedNetworkImageProvider {
  /// Creates an ImageProvider which loads an image from the [url], using the [scale].
  /// When the image fails to load [errorListener] is called.


  /// Web url of the image to load

  CIRCachedNetworkImageProvider(
      this.fileId,
       {
        this.scale = 1.0,
        this.errorListener,
        this.headers,
        this.cacheManager,
      }) :
        assert(scale != null);

  final int fileId;

  @override
  final BaseCacheManager cacheManager;


  @override
  String url;

  /// Scale of the image
  @override
  final double scale;

  /// Listener to be called when images fails to load.
  @override
  final ErrorListener errorListener;

  // Set headers for the image provider, for example for authentication
  @override
  final Map<String, String> headers;

  @override
  Future<CachedNetworkImageProvider> obtainKey(
      ImageConfiguration configuration) {
    return SynchronousFuture<CachedNetworkImageProvider>(this);
  }

  @override
  ImageStreamCompleter load(
      CachedNetworkImageProvider key, DecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
    StreamController<ImageChunkEvent>();
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode).first,
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>(
          'Image provider: $this \n Image key: $key',
          this,
          style: DiagnosticsTreeStyle.errorProperty,
        );
      },
    );
  }

  Stream<ui.Codec> _loadAsync(
      CachedNetworkImageProvider key,
      StreamController<ImageChunkEvent> chunkEvents,
      DecoderCallback decode,
      ) async* {
    assert(key == this);
    try {
      this.url = await CommonDataUtil.getInstance().getFileUrlWithFileId(fileId);
      var mngr = cacheManager ?? DefaultCacheManager();
      await for (var result in mngr.getFileStream(key.url,
          withProgress: true, headers: headers)) {
        if (result is DownloadProgress) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: result.downloaded,
            expectedTotalBytes: result.totalSize,
          ));
        }
        if (result is FileInfo) {
          var file = result.file;
          var bytes = await file.readAsBytes();
          var decoded = await decode(bytes);
          yield decoded;
        }
      }
    } catch (e) {
      errorListener?.call();
      rethrow;
    } finally {
      await chunkEvents.close();
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (other is CachedNetworkImageProvider) {
      return url == other.url && scale == other.scale;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';
}
