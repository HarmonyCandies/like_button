import { BubblesColor, CircleColor, LikeCountAnimationType } from '../common/Model';
import { BubblesPainter } from '../painter/BubblesPainter';
import { CirclePainter } from '../painter/CirclePainter';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { Cubic, DecelerateCurve, Interval, OvershootCurve } from '../common/Curve';
import like_button from '../common/Controller';

@Component
export struct LikeButton {
  controller: like_button.Controller = undefined;
  @BuilderParam
  likeWidgetBuilder?: ($$: { isLiked: boolean }) => void = this.buildLikeWidget.bind(this);
  @BuilderParam
  likeCountWidgetBuilder?: ($$: {
    isLiked: boolean,
    likeCount: number,
    showText: string
  }) => void = this.buildLikeCountWidget.bind(this);
  /// tap call back of like button
  onTap: (isLike: boolean) => Promise<boolean> = async (isLike: boolean) => {
    return !isLike;
  };
  /// size of like widget
  @Prop likeWidgetSize: number = 30;
  /// total size of bubbles
  @Prop bubblesSize: number = undefined;
  /// colors of bubbles
  @Prop bubblesColor: BubblesColor = new BubblesColor({
    dotPrimaryColor: '#FFFFC107',
    dotSecondaryColor: '#FFFF9800',
    dotThirdColor: '#FFFF5722',
    dotLastColor: '#FFF44336',
  });
  /// size of circle
  @Prop circleSize: number = undefined;
  /// colors of circle
  @Prop circleColor: CircleColor = new CircleColor({ start: '#FFFF5722', end: '#FFFFC107', });
  /// whether it is liked
  @Prop isLiked: boolean = false;
  /// animation duration to change isLiked state
  @Prop animationDuration: number = 1000;
  /// like count
  @Prop likeCount: number = undefined;
  /// The FlexOptions of LikeWidget and LikeCountWidget
  @Prop flexOptions: FlexOptions = {
    direction: FlexDirection.Row,
    justifyContent: FlexAlign.Center,
    alignItems: ItemAlign.Center,
  };
  /// animation type to change like count(none,part,all)
  @Prop likeCountAnimationType: LikeCountAnimationType = LikeCountAnimationType.part;
  /// The Margin between LikeWidget and LikeCountWidget
  @Prop widgetsMargin: number = 5;
  @Prop likeCountAnimationDuration: number = 1000;
  _outerCircleCurve = new Interval({
    begin: 0.0,
    end: 0.3,
    curve: Cubic.ease,
    beginValue: 0.1,
    endValue: 1.0,
  });
  _innerCircleCurve = new Interval({
    begin: 0.2,
    end: 0.5,
    curve: Cubic.ease,
    beginValue: 0.2,
    endValue: 1.0,
  });
  _bubblesCurve = new Interval({
    begin: 0.1,
    end: 1.0,
    curve: new DecelerateCurve(),
    beginValue: 0.0,
    endValue: 1.0,
  });
  _iconScaleCurve = new Interval({
    begin: 0.35,
    end: 0.7,
    curve: new OvershootCurve(),
    beginValue: 0.1,
    endValue: 1.0
  });
  @State private _preLikeCount: number = 0;
  @State _samePartOfLikeCount: string = '';
  @State _preDifPartOfLikeCount: string = '';
  @State _difPartOfLikeCount: string = '';
  @State _likeCountOffset: number = 0;
  @State _preLikeCountHeight: number = 0;
  @State _likeCountHeight: number = 0;

  @Builder
  buildLikeWidget($$: { isLiked: boolean }) {
    Image($r('app.media.favorite'))
      .fillColor($$.isLiked ? Color.Pink : Color.Gray)
  }

  aboutToAppear() {
    if (this.bubblesSize == undefined) {
      this.bubblesSize = this.likeWidgetSize * 2;
    }
    if (this.circleSize == undefined) {
      this.circleSize = this.likeWidgetSize * 0.8;
    }

    if (this.likeCount != undefined) {
      this._preLikeCount = this.likeCount;
      this.handleLikeCount();
    }
    if (this.controller != undefined) {
      this.controller.onTap = () => {
        this.Tap();
      };
    }
  }

  aboutToDisappear() {
    this.dispose();
  }

  @Builder
  buildLikeComponent() {
    Stack({
      // api9 Alignment.center, not work well
      alignContent: Alignment.TopStart
    }) {
      BubblesPainter(
        { bubblesSize: this.bubblesSize,
          bubblesColor: this.bubblesColor,
          currentProgress: this._bubblesProgress,
        }
      ).position({
        x: -(this.bubblesSize - this.likeWidgetSize) / 2.0,
        y: -(this.bubblesSize - this.likeWidgetSize) / 2.0,
      })
      CirclePainter(
        {
          circleColor: this.circleColor,
          circleSize: this.circleSize,
          innerCircleRadiusProgress: this._innerCircleRadiusProgress,
          outerCircleRadiusProgress: this._outerCircleRadiusProgress,
        }
      ).position({
        x: -(this.circleSize - this.likeWidgetSize) / 2.0,
        y: -(this.circleSize - this.likeWidgetSize) / 2.0,
      })
      Column() {
        this.likeWidgetBuilder({ isLiked: this.isLiked })
      }.scale({
        x: this.isLiked ? this._iconScale : 1.0,
        y: this.isLiked ? this._iconScale : 1.0,
      })
    }.width(this.likeWidgetSize).height(this.likeWidgetSize).clip(false)
  }

  @Builder
  buildLikeCountWidget($$: {
    isLiked: boolean,
    likeCount: number,
    showText: string
  }) {
    Text(`${$$.showText}`)
  }

  @Builder
  buildCountComponent() {
    if (this.likeCountAnimationType == LikeCountAnimationType.none
      || this.likeCount == this._preLikeCount
    )
      this.likeCountWidgetBuilder({
        isLiked: this.isLiked,
        likeCount: this.likeCount,
        showText: this.likeCount.toString(),
      })
    else if (this.likeCountAnimationType == LikeCountAnimationType.part
      && this._samePartOfLikeCount != ''
    )
    Row() {
      // same
      Stack() {

        // pre
        Column() {
          this.likeCountWidgetBuilder({
            isLiked: !this.isLiked,
            likeCount: this._preLikeCount,
            showText: this._samePartOfLikeCount,
          })
        }.opacity(1 - this._likeCountOpacity)

        // current
        Column() {
          this.likeCountWidgetBuilder({
            isLiked: this.isLiked,
            likeCount: this.likeCount,
            showText: this._samePartOfLikeCount,
          })
        }.opacity(this._likeCountOpacity)
      }

      // diff
      Stack() {
        Column() {
          this.likeCountWidgetBuilder({
            isLiked: !this.isLiked,
            likeCount: this._preLikeCount,
            showText: this._preDifPartOfLikeCount,
          })
        }.opacity(1 - this._likeCountOpacity).onAreaChange((_, b) => {
          this._preLikeCountHeight = b.height as number;
        }).position({
          y: this._preLikeCountHeight * (this.isLiked ? -this._likeCountOffset : this._likeCountOffset)
        })

        Column() {
          this.likeCountWidgetBuilder({
            isLiked: this.isLiked,
            likeCount: this.likeCount,
            showText: this._difPartOfLikeCount,
          })
        }.opacity(this._likeCountOpacity).onAreaChange((_, b) => {
          this._likeCountHeight = b.height as number;
        }).position({
          y: this._likeCountHeight * (this.isLiked ? 1 - this._likeCountOffset : this._likeCountOffset - 1)
        })
      }
    }.justifyContent(FlexAlign.Center)
    else
    Stack() {
      // pre
      Column() {
        this.likeCountWidgetBuilder({
          isLiked: !this.isLiked,
          likeCount: this._preLikeCount,
          showText: this._preLikeCount.toString(),
        })
      }.opacity(1 - this._likeCountOpacity)
      .onAreaChange((_, b) => {
        this._preLikeCountHeight = b.height as number;
      })
      .position({
        y: this._preLikeCountHeight * (this.isLiked ? -this._likeCountOffset : this._likeCountOffset)
      })

      // current
      Column() {
        this.likeCountWidgetBuilder({
          isLiked: this.isLiked,
          likeCount: this.likeCount,
          showText: this.likeCount.toString(),
        })
      }.opacity(this._likeCountOpacity).onAreaChange((_, b) => {
        this._likeCountHeight = b.height as number;
      }).position({
        y: this._likeCountHeight * (this.isLiked ? 1 - this._likeCountOffset : this._likeCountOffset - 1)
      })
    }
  }

  build() {
    Flex(
      this.flexOptions,
    ) {
      this.buildLikeComponent()
      if (this.likeCount != undefined)
      Column() {
        this.buildCountComponent()
      }.clip(true).margin({
        left: this.flexOptions.direction == FlexDirection.Row ? this.widgetsMargin : 0,
        right: this.flexOptions.direction == FlexDirection.RowReverse ? this.widgetsMargin : 0,
        top: this.flexOptions.direction == FlexDirection.Column ? this.widgetsMargin : 0,
        bottom: this.flexOptions.direction == FlexDirection.ColumnReverse ? this.widgetsMargin : 0,
      })
    }.onClick((_) => {
      this.Tap();
    })
  }

  _animatorResult: AnimatorResult | undefined = undefined;
  _likeCountAnimatorResult: AnimatorResult | undefined = undefined;
  @State _outerCircleRadiusProgress: number = 0;
  @State _innerCircleRadiusProgress: number = 0;
  @State _bubblesProgress: number = 0;
  @State _iconScale: number = 0;
  @State _likeCountOpacity: number = 0;

  initAnimation() {
    let options: AnimatorOptions = {
      duration: this.animationDuration,
      easing: "ease",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.0,
      end: 1.0
    };
    // curve: const Interval(
    //   0.0,
    //   0.3,
    //   curve: Curves.ease,
    // ),

    this._animatorResult = animator.create(options);
    this._animatorResult.onframe = (value: number) => {
      this._outerCircleRadiusProgress = this._outerCircleCurve.transform(value);
      this._innerCircleRadiusProgress = this._innerCircleCurve.transform(value);
      this._bubblesProgress = this._bubblesCurve.transform(value);
      this._iconScale = this._iconScaleCurve.transform(value);
    };
    this._animatorResult.onfinish = () => {
      this._animatorResult = undefined;
    }
  }

  public isAnimating(): boolean {
    return this._animatorResult != undefined || this._likeCountAnimatorResult != undefined;
  }

  playLikeAnimation() {
    if (this._animatorResult != undefined) {
      return;
    }
    this.initAnimation();
    this._animatorResult.play();
  }

  dispose() {
    if (this._animatorResult != undefined) {
      this._animatorResult.cancel();
      this._animatorResult = undefined;
    }

    if (this._likeCountAnimatorResult != undefined) {
      this._likeCountAnimatorResult.cancel();
      this._likeCountAnimatorResult = undefined;
    }
  }

  Tap() {
    if (this.isAnimating()) {
      return;
    }
    this.onTap(this.isLiked).then((value) => {
      this.isLiked = value;
      if (this.likeCount != undefined) {
        this._preLikeCount = this.likeCount;
        this.likeCount += (this.isLiked ? 1 : -1)
        this.handleLikeCount();
        this.playLikeCountAnimation();
      }

      if (this.isLiked) {
        this.playLikeAnimation();
      }
    });
  }

  initLikeCountAnimation() {
    let options: AnimatorOptions = {
      duration: this.likeCountAnimationDuration,
      easing: "ease",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.0,
      end: 1.0,
    };
    this._likeCountAnimatorResult = animator.create(options);
    this._likeCountAnimatorResult.onframe = (value) => {
      this._likeCountOpacity = value;
      this._likeCountOffset = value;
    };
    this._likeCountAnimatorResult.onfinish = () => {
      this._likeCountAnimatorResult = undefined;
    };
  }

  playLikeCountAnimation() {
    if (this._likeCountAnimatorResult != undefined) {
      return;
    }
    this.initLikeCountAnimation()
    this._likeCountAnimatorResult.play();
  }

  handleLikeCount() {
    let preLikeCount = this._preLikeCount.toString();
    let likeCount = this.likeCount.toString();
    if (preLikeCount.length != likeCount.length) {
      this._samePartOfLikeCount = '';
      this._preDifPartOfLikeCount = preLikeCount;
      this._difPartOfLikeCount = likeCount;
    }
    else {
      for (let index = 0; index < likeCount.length; index++) {
        if (preLikeCount[index] != likeCount[index]) {
          this._samePartOfLikeCount = likeCount.substring(0, index);
          this._preDifPartOfLikeCount = preLikeCount.substring(index);
          this._difPartOfLikeCount = likeCount.substring(index);
          break;
        }
      }
    }
  }
}