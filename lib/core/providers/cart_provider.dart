import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/database/db.dart';
import 'package:ojos_app/features/cart/data/models/order_entity.dart';
import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';
import 'package:ojos_app/features/product/presentation/widgets/lens_select_ipd_add_widget.dart';
import 'package:ojos_app/features/product/presentation/widgets/lens_select_size_widget.dart';
import 'package:ojos_app/features/product/presentation/widgets/lens_select_size_widget.dart';

//To control the choice of answers
class CartProvider with ChangeNotifier {
  CartProvider() {
    initList();
  }

  List<CartEntity> listOfCart = [];
  List<OrderEntity> listOfCartOrders = [];

  get getListOfItems => listOfCart;

  addItemToCart(CartEntity cartEntity) {
    print('item new is ${cartEntity.id}');
    print('isExist(cartEntity) ${cartEntity.id} ${isExist(cartEntity)}');
    if (isExist(cartEntity)) {
      if (cartEntity.argsForGlasses != null) {
        print('updateee');
        updateArgs(cartEntity);
      }
      increaseItemCount(cartEntity.id);
    } else {
      listOfCart.add(cartEntity);
    }

    notifyListeners();
  }

  bool isExist(CartEntity cartEntity) {
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.id == cartEntity.id) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  updateArgs(CartEntity cartEntity) {
    print('updateee');
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.id == cartEntity.id) {
          print('updateee');
          item.argsForGlasses = cartEntity.argsForGlasses;
        }
      }
    }
  }

  initList() async {
    //   listAnswer = new Map();
    listOfCart = [];
  }

  clearList() {
    // listAnswer = new Map();
    listOfCart.clear();
    notifyListeners();
  }

  setItemCount() {}

  getTotalPrices() {
    double total = 0;
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if ((item.productEntity?.priceAfterDiscount?.isNotEmpty ?? false) ||
            item.productEntity?.priceAfterDiscount != '0') {
          total +=
              (double.parse(item.productEntity?.priceAfterDiscount ?? '0.0') *
                  (item.count ?? 1));
        } else {
          total += (item.productEntity?.price ?? 1.0) * (item.count ?? 1);
        }
      }
    }
    return total;
  }

  getTotalPricesint() {
    double total = 0;
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if ((item.productEntity?.priceAfterDiscount?.isNotEmpty ?? false) ||
            item.productEntity?.priceAfterDiscount != '0') {
          total +=
              (double.parse(item.productEntity?.priceAfterDiscount ?? '0.0') *
                  (item.count ?? 1));
        } else {
          total += (item.productEntity?.price ?? 1.0) * (item.count ?? 1);
        }
      }
    }
    return total.toInt();
  }

  increaseItemCount(int? id) {
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.id != null && item.id == id) {
          item.count = (item.count ?? 0) + 1;
        }
      }
    }
    notifyListeners();
  }

  decreaseItemCount(int? id) {
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.id != null && item.id == id) {
          if (item.count == 1) {
            listOfCart.removeWhere((element) => element.id == id);
            notifyListeners();
          } else
            item.count = (item.count ?? 0) - 1;
        }
      }
    }
    notifyListeners();
  }

  List<dynamic>? getItems() {
    return listOfCart;
  }

  List<OrderEntity>? getOrderItems() {
    for (var i in listOfCart) {
      listOfCartOrders.add(OrderEntity(
        product_id: i.productEntity!.id,
        type_product: i.productEntity!.type,
        quantity: i.count,
        price: i.productEntity!.price,
        RightSPH: i.sizeForRightEye == LensesSelectedEnum.CPH ? 1 : 0,
        RightAXI: i.sizeForRightEye == LensesSelectedEnum.AXIS ? 1 : 0,
        RightCYL: i.sizeForRightEye == LensesSelectedEnum.CYI ? 1 : 0,
        LeftSPH: i.sizeForLeftEye == LensesSelectedEnum.CPH ? 1 : 0,
        LeftAXI: i.sizeForLeftEye == LensesSelectedEnum.AXIS ? 1 : 0,
        LeftCYL: i.sizeForLeftEye == LensesSelectedEnum.CYI ? 1 : 0,
        APD: i.lensSize == LensesIpdAddEnum.ADD ? 1 : 0,
        IPD: i.lensSize == LensesIpdAddEnum.IPD ? 1 : 0,
      ));
    }
    return listOfCartOrders;
  }

  int getItemsCount() {
    int count = 0;
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.count != null && item.count != 0) {
          count += (item.count ?? 0);
        }
      }
    }
    return count;
  }
}
