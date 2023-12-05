import { BubblesColor, CircleColor } from '../common/Model';
import { BubblesPainter } from '../painter/BubblesPainter';
import { CirclePainter } from '../painter/CirclePainter';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { DecelerateCurve, Interval, OvershootCurve } from '../common/Curve';

@Component
export struct LikeButton {
  /// size of like widget
  @State likeComponentSize: number = 30;
  /// animation duration to change isLiked state
  // final Duration animationDuration;

  /// total size of bubbles
  @State bubblesSize: number = this.likeComponentSize * 2;
  /// colors of bubbles
  @State bubblesColor: BubblesColor = new BubblesColor(
    { dotPrimaryColor: '#FFFFC107',
      dotSecondaryColor: '#FFFF9800',
      dotThirdColor: '#FFFF5722',
      dotLastColor: '#FFF44336', }
  );
  /// size of circle
  @State circleSize: number = this.likeComponentSize * 0.8;
  /// colors of circle
  @State circleColor: CircleColor = new CircleColor({ start: '#FFFF5722', end: '#FFFFC107', });
  /// tap call back of like button
  // final LikeButtonTapCallback? onTap;
  /// whether it is liked
  /// it's initial value
  /// you can get current value from onTap/countBuilder
  @State isLiked: boolean | null = false;
  /// animation duration to change isLiked state
  animationDuration: number = 1000;
  @BuilderParam
  likeComponentBuilder?: () => void = this.buildLikeComponent.bind(this);
  @State outerCircleRadiusProgress: number = 0;
  @State innerCircleRadiusProgress: number = 0;
  @State bubblesProgress: number = 0;
  @State iconScale: number = 0;
  _outerCircleAnimatorResult: AnimatorResult | null = null;
  _innerCircleAnimatorResult: AnimatorResult | null = null;
  _bubblesAnimatorResult: AnimatorResult | null = null;
  _iconScaleAnimatorResult: AnimatorResult | null = null;

  @Builder
  buildLikeComponent() {
    Image($r('app.media.favorite'))
      .fillColor(this.isLiked ? Color.Pink : Color.Gray)
  }

  aboutToAppear() {

    // this.initAnimation();
  }

  initAnimation() {

    // curve: const Interval(
    //   0.0,
    //   0.3,
    //   curve: Curves.ease,
    // ),
    this._outerCircleAnimatorResult = animator.create({
      duration: this.animationDuration * 0.3,
      easing: "ease",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.1,
      end: 1.0
    });
    this._outerCircleAnimatorResult.onframe = (value: number) => {
      this.outerCircleRadiusProgress = value;
    };
    this._outerCircleAnimatorResult.onfinish = () => {
      this._outerCircleAnimatorResult = null;
    }
    // curve: const Interval(
    //   0.2,
    //   0.5,
    //   curve: Curves.ease,
    // ),
    this._innerCircleAnimatorResult = animator.create({
      duration: this.animationDuration * 0.3,
      easing: "ease",
      delay: this.animationDuration * 0.2,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.2,
      end: 1.0
    });

    this._innerCircleAnimatorResult.onframe = (value: number) => {
      this.innerCircleRadiusProgress = value;
    };

    this._innerCircleAnimatorResult.onfinish = () => {
      this._innerCircleAnimatorResult = null;
    }

    let decelerate = new Interval({ begin: 0.1, end: 1.0, curve: new DecelerateCurve() });
    //  curve: const Interval(
    //   0.1,
    //   1.0,
    //   curve: Curves.decelerate,
    // ),
    this._bubblesAnimatorResult = animator.create({
      duration: this.animationDuration,
      easing: "linear",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.2,
      end: 1.0
    });
    this._bubblesAnimatorResult.onframe = (value: number) => {
      this.bubblesProgress = decelerate.transform(value);
    };
    this._bubblesAnimatorResult.onfinish = () => {
      this._bubblesAnimatorResult = null;
    }

    let overshootCurve = new Interval({ begin: 0.1, end: 1.0, curve: new OvershootCurve() });
    // curve: const Interval(
    //   0.35,
    //   0.7,
    //   curve: OvershootCurve(),
    // ),

    this._iconScaleAnimatorResult = animator.create({
      duration: this.animationDuration,
      easing: "linear",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.2,
      end: 1.0
    });
    this._iconScaleAnimatorResult.onframe = (value: number) => {
      this.iconScale = overshootCurve.transform(value);
    };
    this._iconScaleAnimatorResult.onfinish = () => {
      this._iconScaleAnimatorResult = null;
    }

  }

  play() {
    if (this._outerCircleAnimatorResult != null || this._innerCircleAnimatorResult != null || this._bubblesAnimatorResult != null) {
      return;
    }
    this.initAnimation();
    this._bubblesAnimatorResult?.play();
    this._outerCircleAnimatorResult?.play();
    this._innerCircleAnimatorResult?.play();
    this._iconScaleAnimatorResult?.play();
  }

  dispose() {
    this._outerCircleAnimatorResult?.cancel();
    this._outerCircleAnimatorResult = null;
    this._innerCircleAnimatorResult?.cancel();
    this._innerCircleAnimatorResult = null;
    this._bubblesAnimatorResult?.cancel();
    this._bubblesAnimatorResult = null;
    this._iconScaleAnimatorResult?.cancel();
    this._iconScaleAnimatorResult = null;
  }

  aboutToDisappear() {
    this.dispose();
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      BubblesPainter(
        { bubblesSize: this.bubblesSize,
          bubblesColor: this.bubblesColor,
          currentProgress: this.bubblesProgress,
        }
      )
      CirclePainter(
        {
          circleColor: this.circleColor,
          circleSize: this.circleSize,
          innerCircleRadiusProgress: this.innerCircleRadiusProgress,
          outerCircleRadiusProgress: this.outerCircleRadiusProgress,
        }
      )
      Column() {
        this.likeComponentBuilder()
      }.scale({
        x: this.isLiked ? this.iconScale : 1.0,
        y: this.isLiked ? this.iconScale : 1.0,
      })
    }.width(this.likeComponentSize).height(this.likeComponentSize).onClick((event) => {
      this.isLiked = !this.isLiked;
      if (this.isLiked) {
        this.play();
      }
    })

  }
}