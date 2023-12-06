import { clamp, degToRad, mapValueFromRangeToRange } from '../common/LikeButtonUtils';
import { BubblesColor } from '../common/Model';
import { Color } from '../common/Color';

@Component
export struct BubblesPainter {
  @Prop @Watch('onCurrentProgressChanged') currentProgress: number;
  @Prop bubblesColor: BubblesColor;
  @Prop bubblesSize: number;
  bubblesCount: number = 7;
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  _outerBubblesPositionAngle: number = 51.42;
  _centerX: number = 0.0;
  _centerY: number = 0.0;
  _circlePaintColors: Array<string> = [];
  _maxOuterDotsRadius: number = 0.0;
  _maxInnerDotsRadius: number = 0.0;
  _maxDotSize: number = 0.0;
  _currentRadius1: number = 0.0;
  _currentDotSize1: number = 0.0;
  _currentDotSize2: number = 0.0;
  _currentRadius2: number = 0.0;

  onCurrentProgressChanged() {
    this.init();
    this.paint();
  }

  aboutToAppear() {
    this._outerBubblesPositionAngle = 360 / this.bubblesCount;
    this._circlePaintColors.push(...[
      this.bubblesColor.dotPrimaryColor as string,
      this.bubblesColor.dotSecondaryColor  as string,
      this.bubblesColor.dotThirdColor  as string,
      this.bubblesColor.dotLastColor  as string,],
    );
    this.init();
  }

  init() {
    this._centerX = this.bubblesSize * 0.5;
    this._centerY = this.bubblesSize * 0.5;
    this._maxDotSize = this.bubblesSize * 0.05;
    this._maxOuterDotsRadius = this.bubblesSize * 0.5 - this._maxDotSize * 2;
    this._maxInnerDotsRadius = 0.8 * this._maxOuterDotsRadius;
    this._updateOuterBubblesPosition();
    this._updateInnerBubblesPosition();
    this._updateBubblesPaints();
  }

  build() {
    Canvas(this.context).onReady(() => {
      this.init();
      this.paint();
    }).width(this.bubblesSize).height(this.bubblesSize).onAreaChange(() => {
      this.init();
    })
  }

  paint() {
    this.context.clearRect(0, 0, this.bubblesSize, this.bubblesSize);
    this._drawOuterBubblesFrame();
    this._drawInnerBubblesFrame();
  }

  _updateOuterBubblesPosition() {
    if (this.currentProgress < 0.3) {
      this._currentRadius1 = mapValueFromRangeToRange(
        this.currentProgress, 0.0, 0.3, 0.0, this._maxOuterDotsRadius * 0.8);
    } else {
      this._currentRadius1 = mapValueFromRangeToRange(this.currentProgress, 0.3, 1.0,
        0.8 * this._maxOuterDotsRadius, this._maxOuterDotsRadius);
    }
    if (this.currentProgress == 0) {
      this._currentDotSize1 = 0;
    } else if (this.currentProgress < 0.7) {
      this._currentDotSize1 = this._maxDotSize;
    } else {
      this._currentDotSize1 = mapValueFromRangeToRange(
        this.currentProgress, 0.7, 1.0, this._maxDotSize, 0.0);
    }
  }

  _updateInnerBubblesPosition() {
    if (this.currentProgress < 0.3) {
      this._currentRadius2 = mapValueFromRangeToRange(
        this.currentProgress, 0.0, 0.3, 0.0, this._maxInnerDotsRadius);
    } else {
      this._currentRadius2 = this._maxInnerDotsRadius;
    }
    if (this.currentProgress == 0) {
      this._currentDotSize2 = 0;
    } else if (this.currentProgress < 0.2) {
      this._currentDotSize2 = this._maxDotSize;
    } else if (this.currentProgress < 0.5) {
      this._currentDotSize2 = mapValueFromRangeToRange(
        this.currentProgress, 0.2, 0.5, this._maxDotSize!, 0.3 * this._maxDotSize!);
    } else {
      this._currentDotSize2 = mapValueFromRangeToRange(
        this.currentProgress, 0.5, 1.0, this._maxDotSize! * 0.3, 0.0);
    }
  }

  _updateBubblesPaints() {
    let progress = clamp(this.currentProgress, 0.6, 1.0);
    let alpha =
    parseInt(mapValueFromRangeToRange(progress, 0.6, 1.0, 255.0, 0.0).toString());
    if (this.currentProgress < 0.5) {
      let progress =
      mapValueFromRangeToRange(this.currentProgress, 0.0, 0.5, 0.0, 1.0);


      this._circlePaintColors[0] = Color.lerp(Color.fromResourceColor(this.bubblesColor.dotPrimaryColor ,), Color.fromResourceColor(this.bubblesColor.dotSecondaryColor ), progress)
        .withAlpha(alpha)
        .toString();

      this._circlePaintColors[1] = Color.lerp(Color.fromResourceColor(this.bubblesColor.dotPrimaryColor ,), Color.fromResourceColor(this.bubblesColor.dotThirdColor ), progress)
        .withAlpha(alpha)
        .toString();
      this._circlePaintColors[2] = Color.lerp(Color.fromResourceColor(this.bubblesColor.dotThirdColor ,), Color.fromResourceColor(this.bubblesColor.dotLastColor ), progress)
        .withAlpha(alpha)
        .toString();
      this._circlePaintColors[3] = Color.lerp(Color.fromResourceColor(this.bubblesColor.dotLastColor ,), Color.fromResourceColor(this.bubblesColor.dotPrimaryColor ), progress)
        .withAlpha(alpha)
        .toString();
    }

    else {
      let progress =
      mapValueFromRangeToRange(this.currentProgress, 0.5, 1.0, 0.0, 1.0);
      this._circlePaintColors[0] = Color.lerp(Color.fromResourceColor(this.bubblesColor.dotPrimaryColor ,), Color.fromResourceColor(this.bubblesColor.dotThirdColor ), progress)
        .withAlpha(alpha)
        .toString();
      this._circlePaintColors[1] = Color.lerp(Color.fromResourceColor(this.bubblesColor.dotThirdColor,), Color.fromResourceColor(this.bubblesColor.dotLastColor ), progress)
        .withAlpha(alpha)
        .toString();
      this._circlePaintColors[2] = Color.lerp(Color.fromResourceColor(this.bubblesColor.dotLastColor ,), Color.fromResourceColor(this.bubblesColor.dotPrimaryColor ), progress)
        .withAlpha(alpha)
        .toString();
      this._circlePaintColors[3] = Color.lerp(Color.fromResourceColor(this.bubblesColor.dotPrimaryColor ,), Color.fromResourceColor(this.bubblesColor.dotSecondaryColor ), progress)
        .withAlpha(alpha)
        .toString();

    }
  }

  _drawOuterBubblesFrame() {
    let start = this._outerBubblesPositionAngle / 4.0 * 3.0;

    for (let i = 0; i < this.bubblesCount; i++) {
      let cX = this._centerX +
        this._currentRadius1 *
        Math.cos(degToRad(start + this._outerBubblesPositionAngle * i));
      let cY = this._centerY +
        this._currentRadius1 *
        Math.sin(degToRad(start + this._outerBubblesPositionAngle * i));
      this.context.fillStyle = this._circlePaintColors[i%this._circlePaintColors.length];
      this.context.beginPath();
      this.context.arc(cX, cY, this._currentDotSize1, 0, Math.PI * 2);
      this.context.closePath();
      this.context.fill();
    }
  }

  _drawInnerBubblesFrame() {
    let start = this._outerBubblesPositionAngle / 4.0 * 3.0 -
      this._outerBubblesPositionAngle / 2.0;
    for (let i = 0; i < this.bubblesCount; i++) {
      let cX = this._centerX +
        this._currentRadius2 *
        Math.cos(degToRad(start + this._outerBubblesPositionAngle * i));
      let cY = this._centerY +
        this._currentRadius2 *
        Math.sin(degToRad(start + this._outerBubblesPositionAngle * i));

      this.context.fillStyle = this._circlePaintColors[(i + 1)%this._circlePaintColors.length];
      this.context.beginPath();
      this.context.arc(cX, cY, this._currentDotSize2, 0, Math.PI * 2);
      this.context.closePath();
      this.context.fill();
    }
  }
}