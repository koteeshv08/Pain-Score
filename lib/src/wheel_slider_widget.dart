import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rootally_ai/src/utils/screen_config.dart';
import 'package:rootally_ai/src/utils/size_extension.dart';
import 'package:rootally_ai/wheel_slider.dart';

class WheelSlider extends StatelessWidget {
  WheelSlider({
    Key? key,
    required this.config,
    required this.onChanged,
    this.dateContainerHeight = 100,
    this.maxDate = 11,
    this.itemWidth = 50,
    this.textStyle,
    this.subTextStyle,
    this.wheelHeight = 131,
    this.animDuration = const Duration(milliseconds: 200),
    this.secondaryBarCount = 3,
    this.selectorLeftSpacing = 136,
    this.selectorHeight = 131,
    this.selectorWidth = 3,
    this.selectorColor = const Color(0xff4c67e2),
    this.controller,
    this.minDate = 0,
    this.initialDate = 0,
  })  : assert(itemWidth >= 0),
        assert(maxDate >= 0),
        assert(maxDate <= 11),
        assert(minDate >= 0),
        assert(maxDate > minDate),
        assert(initialDate >= minDate && initialDate <= maxDate),
        super(key: key);

  final int dateContainerHeight;

  final TextStyle? textStyle;

  final TextStyle? subTextStyle;

  final int wheelHeight;

  final Duration animDuration;

  final int secondaryBarCount;

  final int selectorLeftSpacing;

  final int selectorHeight;

  final int selectorWidth;

  final Color selectorColor;

  final FixedExtentScrollController? controller;

  /// Maximum weight that the slider can be scrolled
  final int maxDate;

  ///
  /// Minimum date that slider can be scrolled minimum
  /// eg. if min date is 12 set min date to 11
  ///
  final int minDate;

  /// Pointer configuration
  final PointerConfig config;

  /// Size of each child in the main axis
  final int itemWidth;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onChanged;

  ///
  /// Initial date for date picker
  ///
  final int initialDate;

  final onChange = ValueNotifier(0);

  final dateController = ScrollController();

  late final _dbRef = FirebaseDatabase.instance.ref().child("sliderID");
  late DatabaseReference databaseReference;

  getData(int index) {
    _dbRef.once().then((snapshot) async {
      // var data=_dbRef.orderByChild("sliderID").equalTo(index.toString()).once();
      // print(data);
      print("${_dbRef.orderByChild("id").equalTo(index)}");
      //print("${snapshot.snapshot.value}");

    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => dateController.animateTo(
        initialDate * dateContainerHeight.h,
        duration: animDuration,
        curve: Curves.fastOutSlowIn,
      ),
    );
    ScreenUtil().init(context);
    return Column(
      children: [
        Container(
          //color: Colors.amber,
          height: 40,
          width: 40,
          margin: const EdgeInsets.only(right: 6),
          child: ListView.builder(
            itemCount: maxDate - minDate,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            controller: dateController,
            itemBuilder: (_, index) {
              return SizedBox(
                height: dateContainerHeight.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Text(
                      (index + minDate ).toString(),
                      style: textStyle ??
                          const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(
          //color: Colors.green,
          height: 70,
          child: RotatedBox(
            quarterTurns: -1,
            child: Stack(
              children: [
                ListWheelScrollView(
                  controller: controller ??
                      FixedExtentScrollController(initialItem: initialDate),
                  itemExtent: 40,
                  physics: const FixedExtentScrollPhysics(),
                  perspective: 0.00000001,
                  onSelectedItemChanged: (val) {
                    onChange.value = val;
                    onChanged.call(val + 1);
                    dateController.animateTo(
                      val * dateContainerHeight.h,
                      duration: animDuration,
                      curve: Curves.fastOutSlowIn,
                    );
                  },
                  children: [
                    for (var i = 0; i < maxDate - minDate; i++) ...{
                      Column(
                        children: [
                          SecondaryPointer(
                            color: config.color,
                            //width: 35,
                            //height: 3,
                             num: i,
                          ),
                          // if (i != maxDate - minDate - 1) ...{
                          //   for (var i = 0; i < secondaryBarCount; i++) ...{
                          //     SizedBox(height: config.gap.w),
                          //     SecondaryPointer(
                          //       color: config.color,
                          //       width: config.secondaryHeight,
                          //       height: config.width,
                          //     ),
                          //   },
                          // }
                        ],
                      )
                    }
                  ],
                ),
                Positioned(
                  top: 193,
                  child: Container(
                    height: selectorWidth.w,
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(width:50,height:50,margin: EdgeInsets.only(top: 20),child: ElevatedButton(child: Text("Getdata"),onPressed: getData(1),),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
