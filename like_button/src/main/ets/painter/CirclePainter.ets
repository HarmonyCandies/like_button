import { clamp, mapValueFromRangeToRange } from '../common/LikeButtonUtils';
import { CircleColor } from '../common/Model';
import { CustomPainter } from './CustomPainter'
import { DartColor } from '../common/Color';

@Component
export struct CirclePainter {
  @Prop @Watch('onRadiusProgressChanged') outerCircleRadiusProgress: number;
  @Prop @Watch('onRadiusProgressChanged') innerCircleRadiusProgress: number;
  @Prop circleColor: CircleColor;
  @Prop circleSize: number;
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  onRadiusProgressChanged() {
    this.paint();
  }

  build() {
    Canvas(this.context).onReady(() => {
      this.paint();
    }).width(this.circleSize).height(this.circleSize)
  }

  paint() {
    this.context.clearRect(0, 0, this.circleSize, this.circleSize);
    if (this.outerCircleRadiusProgress == this.innerCircleRadiusProgress) {
      return;
    }
    let colorProgress = clamp(this.outerCircleRadiusProgress, 0.5, 1.0);
    colorProgress = mapValueFromRangeToRange(colorProgress, 0.5, 1.0, 0.0, 1.0);
    this.context.fillStyle = DartColor.lerp(DartColor.fromResourceColor(this.circleColor.start), DartColor.fromResourceColor(this.circleColor.end), colorProgress)!
      .toString();
    let center = this.circleSize * 0.5;
    // let strokeWidth = this.outerCircleRadiusProgress * center -
    //   (this.innerCircleRadiusProgress * center);
    // this.context.lineWidth=strokeWidth;
    // this.context.beginPath();
    // this.context.arc(center, center, center * this.outerCircleRadiusProgress, 0, Math.PI * 2);
    // this.context.closePath();
    // this.context.stroke();

    // 0,99 make sure not draw out of Canvas
    // maybe it's be a bug.
    this.context.beginPath();
    this.context.arc(center, center, center * 0.99 * this.outerCircleRadiusProgress, 0, Math.PI * 2);
    this.context.closePath();
    this.context.fill();
    if (this.innerCircleRadiusProgress > 0) {
      this.context.save()
      this.context.beginPath()
      this.context.arc(center, center, center * 0.99 * this.innerCircleRadiusProgress, 0, Math.PI * 2)
      this.context.closePath();
      this.context.clip()
      this.context.clearRect(0, 0, this.circleSize, this.circleSize)
      this.context.restore()
    }
  }
}

