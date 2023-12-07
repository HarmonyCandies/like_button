import { BubblesColor, CircleColor, LikeCountAnimationType } from '../common/Model';
import { BubblesPainter } from '../painter/BubblesPainter';
import { CirclePainter } from '../painter/CirclePainter';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { DecelerateCurve, Interval, OvershootCurve } from '../common/Curve';
import like_button from '../common/Controller';

@Component
export struct LikeButton {
  @Link controller: like_button.Controller;
  @BuilderParam
  likeWidgetBuilder?: ($$: { isLiked: boolean }) => void = this.buildLikeWidget.bind(this);
  @BuilderParam
  likeCountWidgetBuilder?: ($$: {
    isLiked: boolean,
    likeCount: number,
    showText: string
  }) => void = this.buildLikeCountWidget.bind(this);
  onTap: (isLike: boolean) => Promise<boolean> = async (isLike: boolean) => {
    return !isLike;
  };

  @Builder
  buildLikeWidget($$: { isLiked: boolean }) {
    Image($r('app.media.favorite'))
      .fillColor($$.isLiked ? Color.Pink : Color.Gray)
  }

  aboutToAppear() {
    if (this.controller.bubblesSize == undefined) {
      this.controller.bubblesSize = this.controller.likeComponentSize * 2;
    }
    if (this.controller.circleSize == undefined) {
      this.controller.circleSize = this.controller.likeComponentSize * 0.8;
    }
    if (this.controller.onTap == undefined) {
      this.controller.onTap = this.onTap;
    }
    if (this.controller.likeCount != null) {
      this.controller.preLikeCount = this.controller.likeCount;
      this.controller.handleLikeCount();
    }
  }

  aboutToDisappear() {
    this.controller.dispose();
  }

  @Builder
  buildLikeComponent() {
    Stack({
      // api9 Alignment.center, not work well
      alignContent: Alignment.TopStart
    }) {
      BubblesPainter(
        { bubblesSize: this.controller.bubblesSize,
          bubblesColor: this.controller.bubblesColor,
          currentProgress: this.controller.bubblesProgress,
        }
      ).position({
        x: -(this.controller.bubblesSize - this.controller.likeComponentSize) / 2.0,
        y: -(this.controller.bubblesSize - this.controller.likeComponentSize) / 2.0,
      })
      CirclePainter(
        {
          circleColor: this.controller.circleColor,
          circleSize: this.controller.circleSize,
          innerCircleRadiusProgress: this.controller.innerCircleRadiusProgress,
          outerCircleRadiusProgress: this.controller.outerCircleRadiusProgress,
        }
      ).position({
        x: -(this.controller.circleSize - this.controller.likeComponentSize) / 2.0,
        y: -(this.controller.circleSize - this.controller.likeComponentSize) / 2.0,
      })
      Column() {
        this.likeWidgetBuilder({ isLiked: this.controller.isLiked })
      }.scale({
        x: this.controller.isLiked ? this.controller.iconScale : 1.0,
        y: this.controller.isLiked ? this.controller.iconScale : 1.0,
      })
    }.width(this.controller.likeComponentSize).height(this.controller.likeComponentSize)
  }

  @Builder
  buildLikeCountWidget($$: {
    isLiked: boolean,
    likeCount: number,
    showText: string
  }) {
    Text(`${$$.showText}`).fontSize(20)
  }

  @Builder
  buildCountComponent() {
    if (this.controller.likeCountAnimationType == LikeCountAnimationType.none
      || this.controller.likeCount == this.controller.preLikeCount
    )
      this.likeCountWidgetBuilder({
        isLiked: this.controller.isLiked,
        likeCount: this.controller.likeCount,
        showText: this.controller.likeCount.toString(),
      })
    else if (this.controller.likeCountAnimationType == LikeCountAnimationType.part
    )
    Row() {
      if (this.controller.samePartOfLikeCount != '')
      // same
      Stack() {

        // pre
        Column() {
          this.likeCountWidgetBuilder({
            isLiked: !this.controller.isLiked,
            likeCount: this.controller.preLikeCount,
            showText: this.controller.samePartOfLikeCount,
          })
        }.opacity(1 - this.controller.likeCountOpacity)

        // current
        Column() {
          this.likeCountWidgetBuilder({
            isLiked: this.controller.isLiked,
            likeCount: this.controller.likeCount,
            showText: this.controller.samePartOfLikeCount,
          })
        }.opacity(this.controller.likeCountOpacity)
      }

      // diff
      Stack() {
        Column() {
          this.likeCountWidgetBuilder({
            isLiked: !this.controller.isLiked,
            likeCount: this.controller.preLikeCount,
            showText: this.controller.preDifPartOfLikeCount,
          })
        }.opacity(1 - this.controller.likeCountOpacity).onAreaChange((a, b) => {
          this.controller.preLikeCountHeight = b.height as number;
        }).position({
          y: this.controller.preLikeCountHeight * (this.controller.isLiked ? -this.controller.likeCountOffset : this.controller.likeCountOffset)
        })

        Column() {
          this.likeCountWidgetBuilder({
            isLiked: this.controller.isLiked,
            likeCount: this.controller.likeCount,
            showText: this.controller.difPartOfLikeCount,
          })
        }.opacity(this.controller.likeCountOpacity).onAreaChange((a, b) => {
          this.controller.likeCountHeight = b.height as number;
        }).position({
          y: this.controller.likeCountHeight * (this.controller.isLiked ? 1 - this.controller.likeCountOffset : this.controller.likeCountOffset - 1)
        })
      }
    }.justifyContent(FlexAlign.Center)
    else
    Stack() {
      // pre
      Column() {
        this.likeCountWidgetBuilder({
          isLiked: !this.controller.isLiked,
          likeCount: this.controller.preLikeCount,
          showText: this.controller.preLikeCount.toString(),
        })
      }.opacity(1 - this.controller.likeCountOpacity)
      .onAreaChange((a, b) => {
        this.controller.preLikeCountHeight = b.height as number;
      })
      .position({
        y: this.controller.preLikeCountHeight * (this.controller.isLiked ? -this.controller.likeCountOffset : this.controller.likeCountOffset)
      })

      // current
      Column() {
        this.likeCountWidgetBuilder({
          isLiked: this.controller.isLiked,
          likeCount: this.controller.likeCount,
          showText: this.controller.likeCount.toString(),
        })
      }.opacity(this.controller.likeCountOpacity).onAreaChange((a, b) => {
        this.controller.likeCountHeight = b.height as number;
      }).position({
        y: this.controller.likeCountHeight * (this.controller.isLiked ? 1 - this.controller.likeCountOffset : this.controller.likeCountOffset - 1)
      })
    }
  }

  build() {
    Flex(
      this.controller.flexOptions,
    ) {
      this.buildLikeComponent()
      if (this.controller.likeCount != null)
        this.buildCountComponent()
    }.onClick((event) => {
      this.controller.Tap();
    })
  }
}