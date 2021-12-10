import 'package:hive/hive.dart';
import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';
import 'package:path_provider/path_provider.dart' as PathProvider;

class AppDB {
  static Future<void> init() async {
    final docsDirectory = await PathProvider.getApplicationDocumentsDirectory();
    Hive.init(docsDirectory.path);
  }

  static void dispose() async {
    await Hive.close();
  }

  static LazyBox getBox(String boxName) {
    final lazyBox = Hive.box(boxName) as LazyBox;
    return lazyBox;
  }

  static Future<void> clear() async {}
}
