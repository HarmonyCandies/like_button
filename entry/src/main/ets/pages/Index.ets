import {
  BubblesColor,
  CircleColor,
  LikeButton,
  like_button,
  DartColor,
  LikeCountAnimationType,
  LikeWidgetBuilderParam,
  LikeCountWidgetBuilderParam,
} from '@candies/like_button';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State controller: like_button.Controller = new like_button.Controller();
  likeWidgetSize: number = 30;

  aboutToAppear() {

  }

  @Builder
  buildLikeWidget1($$: LikeWidgetBuilderParam) {
    Image($r('app.media.bag'))
      .fillColor($$.isLiked ? '#FF7C4DFF' : Color.Gray)
  }

  @Builder
  buildLikeWidget2($$: LikeWidgetBuilderParam) {
    Image($r('app.media.clean'))
      .fillColor($$.isLiked ? Color.Green : Color.Gray)
  }

  @Builder
  buildLikeWidget3($$: LikeWidgetBuilderParam) {
    Image($r('app.media.flower'))
      .fillColor($$.isLiked ? Color.Red : Color.Gray)
  }

  @Builder
  buildLikeWidget4($$: LikeWidgetBuilderParam) {
    Image($r('app.media.color_palette'))
      .fillColor($$.isLiked ? '#FF40C4FF' : Color.Gray)
  }

  @Builder
  buildLikeWidget5($$: LikeWidgetBuilderParam) {
    Image($r('app.media.eraser'))
      .fillColor($$.isLiked ? '#FF212121' : Color.Gray)
  }

  @Builder
  buildLikeWidget6($$: LikeWidgetBuilderParam) {
    Image($r('app.media.clock'))
      .fillColor($$.isLiked ? '#FF536DFE' : Color.Gray)
  }

  @Builder
  buildLikeWidget7($$: LikeWidgetBuilderParam) {
    Image($r('app.media.lock'))
      .fillColor($$.isLiked ? '#FFE65100' : Color.Gray)
  }

  @Builder
  buildLikeWidget8($$: LikeWidgetBuilderParam) {
    Image($r('app.media.save'))
      .fillColor($$.isLiked ? '#FF004D40' : Color.Gray)
  }

  @Builder
  buildLikeCountWidget($$: LikeCountWidgetBuilderParam) {
    if ($$.likeCount == 0) {
      Text('love')
    } else {
      Text(`${$$.showText}`)
    }
  }

  @Builder
  buildLikeCountWidget1($$: LikeCountWidgetBuilderParam) {
    Text(`${$$.showText}`).fontColor($$.isLiked ? '#FF536DFE' : Color.Gray)
  }

  @Builder
  buildLikeCountWidget2($$: LikeCountWidgetBuilderParam) {
    if ($$.likeCount >= 1000) {
      Text(`${($$.likeCount / 1000).toFixed(1)}k`).fontColor($$.isLiked ? '#FF004D40' : Color.Gray)
    } else {
      Text(`${$$.showText}`).fontColor($$.isLiked ? '#FF004D40' : Color.Gray)
    }
  }

  @Builder
  buildMenus() {
    Button() {
      Image($r('app.media.favorite')).fillColor(Color.Pink).width(30).height(30)
    }.onClick((_) => {
      this.controller.Tap();
    }).backgroundColor(Color.Transparent)
  }

  build() {
    Navigation() {
      Grid() {
        GridItem() {
          LikeButton(
            {
              controller: this.controller,
            }
          )
        }
        GridItem() {
          LikeButton(
            {
              likeCount: 666,
              onTap: async (isLike: boolean): Promise<true> => {
                return true;
              },
              likeWidgetBuilder: this.buildLikeWidget1,
              bubblesColor: {
                dotPrimaryColor: '#ff33b5e5',
                dotSecondaryColor: '#ff0099cc',
              },
              circleColor: {
                start: '#ff00ddff',
                end: '#ff0099cc',
              },
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 888,
              likeWidgetBuilder: this.buildLikeWidget2,
              bubblesColor: {
                dotPrimaryColor: new DartColor(0xff669900),
                dotSecondaryColor: new DartColor(0xff99cc00),
              },
              circleColor: {
                start: new DartColor(0xff669900),
                end: new DartColor(0xff669900),
              },
              flexOptions: {
                direction: FlexDirection.RowReverse,
                justifyContent: FlexAlign.Center,
                alignItems: ItemAlign.Center,
              },
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 888,
              likeWidgetBuilder: this.buildLikeWidget3,
              bubblesColor: {
                dotPrimaryColor: '#FFE57373',
                dotSecondaryColor: '#FFEF9A9A',
              },
              circleColor: {
                start: '#FFFF8A80',
                end: '#FFFF1744',
              },
              flexOptions: {
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.Center,
                alignItems: ItemAlign.Center,
              },
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 888,
              likeWidgetBuilder: this.buildLikeWidget4,
              bubblesColor: {
                dotPrimaryColor: '#FF4FC3F7',
                dotSecondaryColor: '#FF81D4FA',
              },
              circleColor: {
                start: '#FFFF4081',
                end: '#FFF50057',
              },
              flexOptions: {
                direction: FlexDirection.ColumnReverse,
                justifyContent: FlexAlign.Center,
                alignItems: ItemAlign.Center,
              },
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 0,
              likeWidgetBuilder: this.buildLikeWidget5,
              bubblesColor: {
                dotPrimaryColor: '#FF757575',
                dotSecondaryColor: '#FFEEEEEE',
              },
              circleColor: {
                start: '#FFEEEEEE',
                end: '#FFBDBDBD',
              },
              likeCountWidgetBuilder: this.buildLikeCountWidget,
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 888,
              likeWidgetBuilder: this.buildLikeWidget6,
              bubblesColor: {
                dotPrimaryColor: '#FF304FFE',
                dotSecondaryColor: '#FF536DFE',
              },
              circleColor: {
                start: '#FF536DFE',
                end: '#FF3D5AFE',
              },
              likeCountWidgetBuilder: this.buildLikeCountWidget1,
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 888,
              likeWidgetBuilder: this.buildLikeWidget7,
              bubblesColor: {
                dotPrimaryColor: '#FFFB8C00',
                dotSecondaryColor: '#FFFFCC80',
              },
              circleColor: {
                start: '#FFFFCC80',
                end: '#FFFFA726',
              },
              likeCountAnimationType: LikeCountAnimationType.all,
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 999,
              likeWidgetBuilder: this.buildLikeWidget8,
              bubblesColor: {
                dotPrimaryColor: '#FF00796B',
                dotSecondaryColor: '#FF004D40',
              },
              circleColor: {
                start: '#FF26A69A',
                end: '#FFB2DFDB',
              },
              likeCountWidgetBuilder: this.buildLikeCountWidget2,
            }
          )
        }
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
      .height('100%')
    }.title('LikeButtonDemo').titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true).menus(this.buildMenus)
  }
}


