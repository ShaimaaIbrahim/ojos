import 'package:ojos_app/core/entities/base_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_details_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/presentation/args/select_lenses_args.dart';
import 'package:ojos_app/features/product/presentation/widgets/lens_select_ipd_add_widget.dart';
import 'package:ojos_app/features/product/presentation/widgets/lens_select_size_widget.dart';

class CartEntity extends BaseEntity {
  int? id;
  int? colorId;
  ProductDetailsEntity? productEntity;
  bool? isGlasses;
  LensesSelectedEnum? sizeForRightEye;
  LensesSelectedEnum? sizeForLeftEye;
  LensesIpdAddEnum? lensSize;
  // ignore: non_constant_identifier_names
  int? SizeModeId;
  // final String ipdSize;
  SelectLensesArgs? argsForGlasses;
  int? count;

  CartEntity({
    required this.id,
    required this.colorId,
    required this.productEntity,
    required this.isGlasses,
    required this.lensSize,
    required this.sizeForLeftEye,
    required this.sizeForRightEye,
    // ignore: non_constant_identifier_names
    required this.SizeModeId,
    required this.count,
    required this.argsForGlasses,
  });

  @override
  List<Object> get props => [
        id ?? '',
        colorId ?? "",
        productEntity ?? '',
        isGlasses ?? "",
        lensSize ?? '',
        SizeModeId ?? "",
        sizeForLeftEye ?? '',
        sizeForRightEye ?? '',
        count ?? '',
        argsForGlasses ?? ''
      ];
}
