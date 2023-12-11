# like_button
Like Button 支持推特点赞效果和点赞数量动画的 ArkUI 库.

![LikeButton](https://github.com/HarmonyCandies/HarmonyCandies/blob/main/gif/like_button/LikeButton.gif)

- [like\_button](#like_button)
  - [安装](#安装)
  - [参数](#参数)
    - [配置参数](#配置参数)
    - [回调](#回调)
    - [组件创建回调](#组件创建回调)
  - [例子](#例子)
    - [无限点赞](#无限点赞)
    - [LikeCountWidget 特殊处理逻辑](#likecountwidget-特殊处理逻辑)
    - [设置 LikeWidget 和 LikeCountWidget 的位置](#设置-likewidget-和-likecountwidget-的位置)


## 安装

`ohpm install @candies/like_button`

## 参数

### 配置参数

| 参数 | 类型 | 描述 |
| --- | --- |--- |
| likeWidgetSize | number | LikeWidget 的大小(默认30) |
| bubblesSize | number |  动画时候的泡泡的大小(默认为 likeWidgetSize 的 2 倍) |
| bubblesColor | BubblesColor | 动画时候的泡泡的颜色，可以分别设置 4 种(默认为  dotPrimaryColor: '#FFFFC107',dotSecondaryColor: '#FFFF9800',dotThirdColor: '#FFFF5722',dotLastColor: '#FFF44336'|
| circleSize | number | 动画时候的圈的最大大小(默认为 likeWidgetSize 的 0.8 倍) |
| circleColor | BubblesColor | 动画时候的圈的颜色，需要设置2种 (默认为 start: '#FFFF5722', end: '#FFFFC107') |
| isLiked | boolean | 是否喜欢。(默认 `false`) |
| animationDuration | number | LikeWidget 动画时长(默认 1000 毫秒) |
| likeCount | number | 喜欢数量。如果不设置(undefined)，不显示 LikeCountWidget |
| flexOptions | FlexOptions | LikeWidget 和 LikeCountWidget 2个组件位置的配置(默认为 direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center) |
| likeCountAnimationType | LikeCountAnimationType | 喜欢数量动画的类型(none,part,all)。没有动画；只动画改变的部分；全部部分 |
| widgetsMargin | number | LikeWidget and LikeCountWidget 的距离 |
| likeCountAnimationDuration | number | LikeCountWidget 动画时长(默认 1000 毫秒) |
| controller | Controller | 可以通过调用 Controller 的 Tap 的方法，执行动画 |

### 回调

这是一个异步回调，你可以等待服务返回之后再改变状态。也可以先改变状态，请求失败之后重置回状态

```typescript
  onTap: (isLike: boolean) => Promise<boolean> = async (isLike: boolean) => {
    return !isLike;
  };
```

### 组件创建回调


| 回调 | 参数 | 描述 |
| --- | --- |--- |
| likeWidgetBuilder | isLiked: boolean | 用于自定义 LikeWidget |
| likeCountWidgetBuilder |  isLiked: boolean,likeCount: number,showText: string | 用于自定义 LikeCountWidget |

```typescript
  @BuilderParam
  likeWidgetBuilder?: ($$: LikeWidgetBuilderParam) => void = this.buildLikeWidget;
  @BuilderParam
  likeCountWidgetBuilder?: ($$: LikeCountWidgetBuilderParam) => void = this.buildLikeCountWidget;
```

## 例子

### 无限点赞

将 `onTap` 固定返回 `true`，可以实现无限点赞的效果。
 
```typescript
LikeButton(
  {
    likeCount: 666,
    onTap: async (isLike: boolean): Promise<true> => {
      return true;
    },
  }
)
```

### LikeCountWidget 特殊处理逻辑

你可以根据 `likeCount` 的值的不同，做一些特殊的处理。

``` typescript
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

@Builder
buildLikeCountWidget2($$: LikeCountWidgetBuilderParam) {
  if ($$.likeCount >= 1000)
    Text(`${($$.likeCount / 1000).toFixed(1)}k`).fontColor($$.isLiked ? '#FF004D40' : Color.Gray)
  else
    Text(`${$$.showText}`).fontColor($$.isLiked ? '#FF004D40' : Color.Gray)
}

@Builder
buildLikeWidget8($$: LikeWidgetBuilderParam) {
  Image($r('app.media.save'))
    .fillColor($$.isLiked ? '#FF004D40' : Color.Gray)
}
```

### 设置 LikeWidget 和 LikeCountWidget 的位置


 ```typescript
LikeButton(
  {
    likeCount: 888,
    flexOptions: {
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
    },
  }
)
```