import { clamp } from './LikeButtonUtils'

export abstract class Curve {
  abstract transform(t: number): number;
}

export class Interval extends Curve {
  constructor(value: {
    begin: number,
    end: number,
    curve: Curve
  }) {
    super();
    this.begin = value.begin;
    this.end = value.end;
    this.curve = value.curve;
  }

  begin: number;
  end: number;
  curve: Curve;

  transform(t: number): number {
    t = clamp(((t - this.begin) / (this.end - this.begin)), 0.0, 1.0);
    if (t == 0.0 || t == 1.0)
      return t;
    return this.curve.transform(t);
  }
}


export class OvershootCurve extends Curve {
  transform(t: number): number {
    let period = 2.5;
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }
}

export class DecelerateCurve extends Curve {
  transform(t: number): number {
    t = 1.0 - t;
    return 1.0 - t * t;
  }
}