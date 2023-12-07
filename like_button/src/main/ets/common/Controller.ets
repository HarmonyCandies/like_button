import { BubblesColor, CircleColor, LikeCountAnimationType } from './Model';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { Cubic, DecelerateCurve, Interval, OvershootCurve } from './Curve';


namespace like_button {
  export class Controller {
    onTap: () => void;

    Tap() {
      if (this.onTap != undefined) {
        this.onTap();
      }
    }   
  }
}

export default like_button;
