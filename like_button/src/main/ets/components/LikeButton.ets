import { BubblesColor, CircleColor } from '../common/Model';
import { BubblesPainter } from '../painter/BubblesPainter';
import { CirclePainter } from '../painter/CirclePainter';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { DecelerateCurve, Interval, OvershootCurve } from '../common/Curve';
import like_button from '../common/Controller';

@Component
export struct LikeButton {
  @Link controller: like_button.Controller;
  @BuilderParam
  likeComponentBuilder?: () => void = this.buildLikeComponent.bind(this);
  onTap: (isLike: boolean) => Promise<boolean> = async (isLike: boolean) => {
    return !isLike;
  };

  @Builder
  buildLikeComponent() {
    Image($r('app.media.favorite'))
      .fillColor(this.controller.isLiked ? Color.Pink : Color.Gray)
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

  }

  aboutToDisappear() {
    this.controller.dispose();
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      BubblesPainter(
        { bubblesSize: this.controller.bubblesSize,
          bubblesColor: this.controller.bubblesColor,
          currentProgress: this.controller.bubblesProgress,
        }
      )
      CirclePainter(
        {
          circleColor: this.controller.circleColor,
          circleSize: this.controller.circleSize,
          innerCircleRadiusProgress: this.controller.innerCircleRadiusProgress,
          outerCircleRadiusProgress: this.controller.outerCircleRadiusProgress,
        }
      )
      Column() {
        this.likeComponentBuilder()
      }.scale({
        x: this.controller.isLiked ? this.controller.iconScale : 1.0,
        y: this.controller.isLiked ? this.controller.iconScale : 1.0,
      })
    }.width(this.controller.likeComponentSize).height(this.controller.likeComponentSize).onClick((event) => {
      this.controller.Tap();
    })

  }
}