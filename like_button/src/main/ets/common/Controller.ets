import { BubblesColor, CircleColor } from './Model';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { Cubic, DecelerateCurve, Interval, OvershootCurve } from './Curve';


namespace like_button {
  export class Controller {
    /// size of like widget
    likeComponentSize: number = 30;
    /// animation duration to change isLiked state
    // final Duration animationDuration;

    /// total size of bubbles
    bubblesSize: number;
    /// colors of bubbles
    bubblesColor: BubblesColor = new BubblesColor(
      { dotPrimaryColor: '#FFFFC107',
        dotSecondaryColor: '#FFFF9800',
        dotThirdColor: '#FFFF5722',
        dotLastColor: '#FFF44336', }
    );
    /// size of circle
    circleSize: number;
    /// colors of circle
    circleColor: CircleColor = new CircleColor({ start: '#FFFF5722', end: '#FFFFC107', });
    /// tap call back of like button
    // final LikeButtonTapCallback? onTap;
    /// whether it is liked
    /// it's initial value
    /// you can get current value from onTap/countBuilder
    isLiked: boolean | null = false;
    /// animation duration to change isLiked state
    animationDuration: number = 1000;
    outerCircleRadiusProgress: number = 0;
    innerCircleRadiusProgress: number = 0;
    bubblesProgress: number = 0;
    iconScale: number = 0;
    _animatorResult: AnimatorResult | undefined = undefined;
    onTap: (isLike: boolean) => Promise<boolean>;
    private outerCircleCurve = new Interval({
      begin: 0.0,
      end: 0.3,
      curve: Cubic.ease,
      beginValue: 0.1,
      endValue: 1.0,
    });
    private innerCircleCurve = new Interval({
      begin: 0.2,
      end: 0.5,
      curve: Cubic.ease,
      beginValue: 0.2,
      endValue: 1.0,
    });
    private bubblesCurve = new Interval({
      begin: 0.1,
      end: 1.0,
      curve: new DecelerateCurve(),
      beginValue: 0.0,
      endValue: 1.0,
    });
    private iconScaleCurve = new Interval({
      begin: 0.35,
      end: 0.7,
      curve: new OvershootCurve(),
      beginValue: 0.1,
      endValue: 1.0
    });

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
        this.outerCircleRadiusProgress = this.outerCircleCurve.transform(value);
        this.innerCircleRadiusProgress = this.innerCircleCurve.transform(value);
        this.bubblesProgress = this.bubblesCurve.transform(value);
        this.iconScale = this.iconScaleCurve.transform(value);
      };
      this._animatorResult.onfinish = () => {
        this._animatorResult = undefined;
      }
    }

    public isAnimating(): boolean {
      return this._animatorResult != undefined;

    }

    play() {
      if (this.isAnimating()) {
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
    }

    Tap() {
      if (this.isAnimating()) {
        return;
      }
      this.onTap(this.isLiked).then((value) => {
        this.isLiked = value;
        if (this.isLiked) {
          this.play();
        }
      });
    }
  }
}

export default like_button;
