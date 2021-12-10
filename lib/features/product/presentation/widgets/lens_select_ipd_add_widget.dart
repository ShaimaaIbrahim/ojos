import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';

class LensSelectIpdAddWidget extends StatefulWidget {
  final Function(LensesIpdAddEnum)? onSelected;
  final double width;
  final double? height;
  final LensesIpdAddEnum? defaultValue;

  const LensSelectIpdAddWidget(
      {this.height,
      required this.width,
      required this.onSelected,
      this.defaultValue});

  @override
  _LensSelectSizeWidgetState createState() => _LensSelectSizeWidgetState();
}

class _LensSelectSizeWidgetState extends State<LensSelectIpdAddWidget> {
  LensesIpdAddEnum? _selected;

  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      _selected = widget.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildItem(
                context: context,
                title: 'IPD',
                isSelected: _selected == LensesIpdAddEnum.IPD,
                selected: LensesIpdAddEnum.IPD),
          ),
          HorizontalPadding(
            percentage: 1.0,
          ),
          Expanded(
            child: _buildItem(
                context: context,
                title: 'ADD',
                isSelected: _selected == LensesIpdAddEnum.ADD,
                selected: LensesIpdAddEnum.ADD),
          ),
        ],
      ),
    );
  }

  _buildItem(
      {String? title,
      bool? isSelected,
      required BuildContext context,
      LensesIpdAddEnum? selected}) {
    return InkWell(
      onTap: () {
        if (mounted)
          setState(() {
            _selected = selected;
          });
        if (widget.onSelected != null) {
          widget.onSelected!(_selected!);
        }
      },
      highlightColor: globalColor.transparent,
      splashColor: globalColor.transparent,
      hoverColor: globalColor.transparent,
      child: Container(
        child: Column(
          children: [
            isSelected ?? false
                ? Container(
                    height: 15.h,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 15.h,
                    ),
                  )
                : Container(
                    height: 15.h,
                  ),
            Container(
                decoration: BoxDecoration(
                    color: globalColor.white,
                    borderRadius: BorderRadius.circular(12.0.w),
                    border: Border.all(
                        color: isSelected ?? false
                            ? globalColor.primaryColor
                            : globalColor.grey.withOpacity(0.3),
                        width: 0.5)),
                alignment: AlignmentDirectional.center,
                height: 40.h,
                child: Text(
                  title ?? '',
                  style: textStyle.middleTSBasic.copyWith(
                      fontWeight: FontWeight.w500, color: globalColor.grey),
                )),
          ],
        ),
      ),
    );
  }
}

enum LensesIpdAddEnum { IPD, ADD }
