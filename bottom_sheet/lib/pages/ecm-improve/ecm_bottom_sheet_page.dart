import 'package:bottom_sheet/config/assets.dart';
import 'package:bottom_sheet/pages/ecm-improve/JobStatus.dart';
import 'package:bottom_sheet/pages/ecm-improve/JobStatusEnum.dart';
import 'package:bottom_sheet/pages/ecm-improve/SearchItemModel.dart';
import 'package:flutter/material.dart';

class EcmBottomSheetPage extends StatefulWidget {
  const EcmBottomSheetPage({Key? key}) : super(key: key);

  @override
  _EcmBottomSheetPageState createState() => _EcmBottomSheetPageState();
}

class _EcmBottomSheetPageState extends State<EcmBottomSheetPage> {
  String _bottomSheetIcon = Asset.doubleUpArrow;
  late double _bottomSheetPosition;
  List<SearchItemModel> list = [
    SearchItemModel(
        title: "1412",
        subTitle: "Kid",
        description: "Phantom night thief",
        jobStatus: JobStatus.fromJobStatusEnum(JobStatusEnum.AC)),
    SearchItemModel(
        title: "1412",
        subTitle: "Kid",
        description: "Phantom night thief",
        jobStatus: JobStatus.fromJobStatusEnum(JobStatusEnum.AC)),
    SearchItemModel(
        title: "1412",
        subTitle: "Kid",
        description: "Phantom night thief",
        jobStatus: JobStatus.fromJobStatusEnum(JobStatusEnum.AC)),
    SearchItemModel(
        title: "1412",
        subTitle: "Kid",
        description: "Phantom night thief",
        jobStatus: JobStatus.fromJobStatusEnum(JobStatusEnum.AC)),
    SearchItemModel(
        title: "1412",
        subTitle: "Kid",
        description: "Phantom night thief",
        jobStatus: JobStatus.fromJobStatusEnum(JobStatusEnum.AC)),
  ];

  @override
  void didChangeDependencies() {
    _bottomSheetPosition = 0.5;
    super.didChangeDependencies();
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      title: Text(
        'EcmBottomSheetPage',
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [_buildAppBar()],
              ),
              SafeArea(
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification:
                      (DraggableScrollableNotification dsNotification) {

                    setState(() {
                      _bottomSheetPosition = dsNotification.extent;
                    });

                    return true;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.5,
                    maxChildSize: 1.0,
                    builder: (BuildContext context, myScrollController) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SingleChildScrollView(
                          controller: myScrollController,
                          physics: list.length == 0
                              ? NeverScrollableScrollPhysics()
                              : AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: _calculateMaxHeight()),
                            child: Container(
                              color: Colors.tealAccent[200],
                              child: NotificationListener<
                                  OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
                                  overscroll.disallowIndicator();
                                  return true;
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildBottomSheetHeader(list),
                                    Expanded(
                                      // height: this._contentHeight,
                                      child: NotificationListener<
                                          OverscrollIndicatorNotification>(
                                        onNotification: (overscroll) {
                                          overscroll.disallowIndicator();
                                          return true;
                                        },
                                        child: ListView.builder(
                                          itemBuilder: (ctx, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  list[index].isSelected =
                                                      !list[index].isSelected;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: list[index].isSelected
                                                        ? Color(0xFFF3F3F3)
                                                        : Colors.white),
                                                padding: EdgeInsets.only(top: 16),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 16),
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                list[index].title ??
                                                                    '',
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none,
                                                                  fontFamily:
                                                                      'Prompt Medium',
                                                                  color: Color(
                                                                      0xFF333276),
                                                                ),
                                                              ),
                                                              Text(
                                                                list[index]
                                                                        .subTitle ??
                                                                    '',
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none,
                                                                  fontFamily:
                                                                      'Prompt Medium',
                                                                  color: Color(
                                                                      0xFF474343),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Text(
                                                                  list[index]
                                                                          .description ??
                                                                      '',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
                                                                    fontFamily:
                                                                        'Prompt Light',
                                                                    color: Color(
                                                                        0xFFAF0606),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Align(
                                                            alignment:
                                                                Alignment.topRight,
                                                            child: Container(
                                                              width: 121,
                                                              height: 31,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: list[index]
                                                                    .jobStatus!
                                                                    .backgroundColor,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0),
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "Job Status ${list[index].jobStatus!.code}",
                                                                  style: TextStyle(
                                                                    fontSize: 13,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
                                                                    fontFamily:
                                                                        'Prompt Medium',
                                                                    color: list[index]
                                                                        .jobStatus!
                                                                        .color,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 18),
                                                      child: Divider(
                                                        height: 1,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: list.length,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildBottomSheetWithList(
  //     AsyncSnapshot<List<SearchItemModel>> snapShot,
  //     ScrollController myscrollController) {
  //   List<SearchItemModel> list = [];
  //   if (snapShot.hasData && snapShot.data!.isNotEmpty) {
  //     list = snapShot.data!;
  //   }
  //
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       // border: Border(
  //       //   top: BorderSide(
  //       //     color: list.isNotEmpty ? Color(0xFFB8B8B8) : Colors.white,
  //       //   ),
  //       // ),
  //     ),
  //     child: SingleChildScrollView(
  //       physics: list.length == 0
  //           ? NeverScrollableScrollPhysics()
  //           : AlwaysScrollableScrollPhysics(),
  //       controller: myscrollController,
  //       child: ConstrainedBox(
  //         constraints: BoxConstraints(maxHeight: _calculateMaxHeight()),
  //         child: snapShot.connectionState == ConnectionState.waiting
  //             ? Container()
  //             : list?.length == 0
  //             ? Container(
  //           child: Padding(
  //             padding: EdgeInsets.only(top: 40),
  //             child: Column(children: [
  //               SizedBox(
  //                 height: 84,
  //                 width: 84,
  //                 child: Image.asset(
  //                   Asset.bottomSheetSearch,
  //                   fit: BoxFit.contain,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 25,
  //               ),
  //               Text(
  //                 'ค้นหาไม่พบ',
  //                 style: TextStyle(
  //                   fontFamily: 'Prompt Medium',
  //                   fontSize: 20,
  //                   color: Color(0xFF333276),
  //                   decoration: TextDecoration.none,
  //                 ),
  //               ),
  //               Text(
  //                 'กรุณาลองใหม่อีกครั้ง',
  //                 style: TextStyle(
  //                   fontFamily: 'Prompt Light',
  //                   fontSize: 20,
  //                   color: Color(0xFF474343),
  //                   decoration: TextDecoration.none,
  //                 ),
  //               ),
  //             ]),
  //           ),
  //         )
  //             : Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             _buildBottomSheetHeader(list),
  //             Expanded(
  //               // height: this._contentHeight,
  //               child: NotificationListener<
  //                   OverscrollIndicatorNotification>(
  //                 onNotification: (overscroll) {
  //                   overscroll.disallowGlow();
  //                   return true;
  //                 },
  //                 child: ListView.builder(
  //                   itemBuilder: (ctx, index) {
  //                     return GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           list[index].isSelected =
  //                           !list[index].isSelected;
  //                         });
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                             color: list[index].isSelected
  //                                 ? Color(0xFFF3F3F3)
  //                                 : Colors.white),
  //                         padding: EdgeInsets.only(top: 16),
  //                         child: Column(
  //                           children: [
  //                             Container(
  //                               padding: EdgeInsets.symmetric(
  //                                   horizontal: 16),
  //                               child: Stack(
  //                                 children: [
  //                                   Column(
  //                                     crossAxisAlignment:
  //                                     CrossAxisAlignment.start,
  //                                     children: [
  //                                       Text(
  //                                         list[index].title ?? '',
  //                                         overflow:
  //                                         TextOverflow.ellipsis,
  //                                         style: TextStyle(
  //                                           fontSize: 20,
  //                                           decoration:
  //                                           TextDecoration.none,
  //                                           fontFamily:
  //                                           'Prompt Medium',
  //                                           color: Color(0xFF333276),
  //                                         ),
  //                                       ),
  //                                       Text(
  //                                         list[index].subTitle ?? '',
  //                                         overflow:
  //                                         TextOverflow.ellipsis,
  //                                         style: TextStyle(
  //                                           fontSize: 16,
  //                                           decoration:
  //                                           TextDecoration.none,
  //                                           fontFamily:
  //                                           'Prompt Medium',
  //                                           color: Color(0xFF474343),
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         height: 8,
  //                                       ),
  //                                       SizedBox(
  //                                         width:
  //                                         MediaQuery.of(context)
  //                                             .size
  //                                             .width,
  //                                         child: Text(
  //                                           list[index].description ??
  //                                               '',
  //                                           maxLines: 1,
  //                                           overflow:
  //                                           TextOverflow.ellipsis,
  //                                           style: TextStyle(
  //                                             fontSize: 16,
  //                                             decoration:
  //                                             TextDecoration.none,
  //                                             fontFamily:
  //                                             'Prompt Light',
  //                                             color:
  //                                             Color(0xFFAF0606),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   Align(
  //                                     alignment: Alignment.topRight,
  //                                     child: Container(
  //                                       width: 121,
  //                                       height: 31,
  //                                       decoration: BoxDecoration(
  //                                         color: list[index]
  //                                             .jobStatus
  //                                             .backgroundColor,
  //                                         borderRadius:
  //                                         BorderRadius.all(
  //                                           Radius.circular(20.0),
  //                                         ),
  //                                       ),
  //                                       child: Center(
  //                                         child: Text(
  //                                           "Job Status ${list[index].jobStatus.code}",
  //                                           style: TextStyle(
  //                                             fontSize: 13,
  //                                             decoration:
  //                                             TextDecoration.none,
  //                                             fontFamily:
  //                                             'Prompt Medium',
  //                                             color: list[index]
  //                                                 .jobStatus
  //                                                 .color,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding:
  //                               const EdgeInsets.only(top: 18),
  //                               child: Divider(
  //                                 height: 1,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   itemCount: list?.length,
  //                   scrollDirection: Axis.vertical,
  //                   shrinkWrap: true,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBottomSheetHeader(List<SearchItemModel> list) {
    return Container(
      height: 85.0,
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(
                  height: 19,
                  width: 15,
                  child: Image.asset(
                    _bottomSheetIcon,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  _getBottomSheetSubTitle(this.list),
                  style: _getTitleTextStyle(),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 72,
              margin: EdgeInsets.only(top: 8),
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      list.any((element) => element.isSelected)
                          ? Color(0xFF333276)
                          : Color(0xFFF3F3F3)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // side: BorderSide(color: Colors.teal, width: 2.0),
                    ),
                  ),
                ),
                child: Text(
                  'ADD',
                  style: list.any((element) => element.isSelected)
                      ? _getTitleTextStyle(
                          color: Color(0xFFFFFFFF),
                        )
                      : _getTitleTextStyle(),
                ),
                onPressed: () {
                  if (list.any((element) => element.isSelected)) {}
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetWithIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border(
        //   top: BorderSide(
        //     color: Color(0xFFB8B8B8),
        //   ),
        // ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 7,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'กำลังค้นหา',
                    style: TextStyle(
                      fontFamily: 'Prompt Light',
                      fontSize: 16,
                      color: Color(0xFF474343),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ])),
          ),
        ],
      ),
    );
  }

  String _getBottomSheetSubTitle(List<SearchItemModel> list) {
    return 'ปัดขึ้นเพื่อดูทั้งหมด ${list.length} รายการ';
  }

  TextStyle _getTitleTextStyle({color = const Color(0xFFB8B8B8)}) {
    return TextStyle(
        fontFamily: 'Prompt Light',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
        color: color);
  }

  double _calculateMaxHeight() {

    var result = (MediaQuery.of(context).size.height * _bottomSheetPosition) -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).viewInsets.bottom;

    // if(_bottomSheetPosition != 1.0){
    //   result -= this.widget.margin.vertical;
    // }
    result += 8;

    return result;
  }
}
