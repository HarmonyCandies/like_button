import {
  BubblesColor,
  CircleColor,
  LikeButton,
  like_button,
  DartColor,
  LikeCountAnimationType
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
  buildLikeWidget1($$: { isLiked: boolean }) {
    Image($r('app.media.bag'))
      .fillColor($$.isLiked ? '#FF7C4DFF' : Color.Gray)
  }

  @Builder
  buildLikeWidget2($$: { isLiked: boolean }) {
    Image($r('app.media.clean'))
      .fillColor($$.isLiked ? Color.Green : Color.Gray)
  }

  @Builder
  buildLikeWidget3($$: { isLiked: boolean }) {
    Image($r('app.media.flower'))
      .fillColor($$.isLiked ? Color.Red : Color.Gray)
  }

  @Builder
  buildLikeWidget4($$: { isLiked: boolean }) {
    Image($r('app.media.color_palette'))
      .fillColor($$.isLiked ? '#FF40C4FF' : Color.Gray)
  }

  @Builder
  buildLikeWidget5($$: { isLiked: boolean }) {
    Image($r('app.media.eraser'))
      .fillColor($$.isLiked ? '#FF212121' : Color.Gray)
  }

  @Builder
  buildLikeWidget6($$: { isLiked: boolean }) {
    Image($r('app.media.clock'))
      .fillColor($$.isLiked ? '#FF536DFE' : Color.Gray)
  }

  @Builder
  buildLikeWidget7($$: { isLiked: boolean }) {
    Image($r('app.media.lock'))
      .fillColor($$.isLiked ? '#FFE65100' : Color.Gray)
  }

  @Builder
  buildLikeWidget8($$: { isLiked: boolean }) {
    Image($r('app.media.save'))
      .fillColor($$.isLiked ? '#FF004D40' : Color.Gray)
  }

  @Builder
  buildLikeCountWidget($$: {
    isLiked: boolean,
    likeCount: number,
    showText: string
  }) {
    if ($$.likeCount == 0)
      Text('love')
    else
      Text(`${$$.showText}`)
  }

  @Builder
  buildLikeCountWidget1($$: {
    isLiked: boolean,
    likeCount: number,
    showText: string
  }) {
    Text(`${$$.showText}`).fontColor($$.isLiked ? '#FF536DFE' : Color.Gray)
  }

  @Builder
  buildLikeCountWidget2($$: {
    isLiked: boolean,
    likeCount: number,
    showText: string
  }) {
    if ($$.likeCount >= 1000)
      Text(`${($$.likeCount / 1000).toFixed(1)}k`).fontColor($$.isLiked ? '#FF004D40' : Color.Gray)
    else
      Text(`${$$.showText}`).fontColor($$.isLiked ? '#FF004D40' : Color.Gray)
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
              bubblesColor: new BubblesColor({
                dotPrimaryColor: '#ff33b5e5',
                dotSecondaryColor: '#ff0099cc',
              },),
              circleColor: new CircleColor({
                start: '#ff00ddff',
                end: '#ff0099cc',
              }),
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 888,
              likeWidgetBuilder: this.buildLikeWidget2,
              bubblesColor: new BubblesColor({
                dotPrimaryColor: new DartColor(0xff669900),
                dotSecondaryColor: new DartColor(0xff99cc00),
              },),
              circleColor: new CircleColor({
                start: new DartColor(0xff669900),
                end: new DartColor(0xff669900),
              }),
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
              bubblesColor: new BubblesColor({
                dotPrimaryColor: '#FFE57373',
                dotSecondaryColor: '#FFEF9A9A',
              },),
              circleColor: new CircleColor({
                start: '#FFFF8A80',
                end: '#FFFF1744',
              }),
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
              bubblesColor: new BubblesColor({
                dotPrimaryColor: '#FF4FC3F7',
                dotSecondaryColor: '#FF81D4FA',
              },),
              circleColor: new CircleColor({
                start: '#FFFF4081',
                end: '#FFF50057',
              }),
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
              bubblesColor: new BubblesColor({
                dotPrimaryColor: '#FF757575',
                dotSecondaryColor: '#FFEEEEEE',
              },),
              circleColor: new CircleColor({
                start: '#FFEEEEEE',
                end: '#FFBDBDBD',
              }),
              likeCountWidgetBuilder: this.buildLikeCountWidget,
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 888,
              likeWidgetBuilder: this.buildLikeWidget6,
              bubblesColor: new BubblesColor({
                dotPrimaryColor: '#FF304FFE',
                dotSecondaryColor: '#FF536DFE',
              },),
              circleColor: new CircleColor({
                start: '#FF536DFE',
                end: '#FF3D5AFE',
              }),
              likeCountWidgetBuilder: this.buildLikeCountWidget1,
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 888,
              likeWidgetBuilder: this.buildLikeWidget7,
              bubblesColor: new BubblesColor({
                dotPrimaryColor: '#FFFB8C00',
                dotSecondaryColor: '#FFFFCC80',
              },),
              circleColor: new CircleColor({
                start: '#FFFFCC80',
                end: '#FFFFA726',
              }),
              likeCountAnimationType: LikeCountAnimationType.all,
            }
          )
        }

        GridItem() {
          LikeButton(
            {
              likeCount: 999,
              likeWidgetBuilder: this.buildLikeWidget8,
              bubblesColor: new BubblesColor({
                dotPrimaryColor: '#FF00796B',
                dotSecondaryColor: '#FF004D40',
              },),
              circleColor: new CircleColor({
                start: '#FF26A69A',
                end: '#FFB2DFDB',
              }),
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


