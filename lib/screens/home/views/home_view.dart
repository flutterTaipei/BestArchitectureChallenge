import 'package:best_architecture_challenge/res/colors.dart';
import 'package:best_architecture_challenge/res/gaps.dart';
import 'package:best_architecture_challenge/res/styles.dart';
import 'package:best_architecture_challenge/screens/components/post_tile.dart';
import 'package:best_architecture_challenge/screens/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SortExt on int {
  bool isSortByTitle() => this == 2;
}

//home_view
class HomeView extends GetView<HomeController> {
  static const int _sortWithId = 1;
  static const int _sortWithTitle = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.default_bg,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildHeader(),
          _buildBody(),
        ],
      ),
    );
  }

  Positioned _buildBody() {
    return Positioned.fill(
            top: Get.height * 0.2,
            child: Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Obx(() => Text('Posts: ${controller.postList.length}', style: TextStyles.textBold22,))
                  ),
                  Gaps.vGap10,
                  Expanded(
                    child: GetBuilder<HomeController>(
                      builder: (_controller) {
                        return ListView.separated(
                          itemCount: _controller.postList.length,
                          itemBuilder: (context, index) {
                            return PostTile(
                                item: _controller.postList[index]);
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Positioned _buildHeader() {
    return Positioned(
              top: Get.height * 0.05,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyles.textBold26
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          'FlutterTaipei :)',
                          style: TextStyles.textBold26
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        icon: Icon(
                          Icons.sort,
                          size: 40,
                          color: Colors.white,
                        ),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text(
                                  '使用id排序',
                                  style: TextStyles.textSize16,
                                ),
                                value: _sortWithId,
                              ),
                              PopupMenuItem(
                                child: Text(
                                  '使用title排序',
                                  style: TextStyles.textSize16,
                                ),
                                value: _sortWithTitle,
                              )
                            ],
                        onSelected: (int value) {
                          controller.doSortBy(value.isSortByTitle());
                        })
                  ],
                ),
              ));
  }
}
