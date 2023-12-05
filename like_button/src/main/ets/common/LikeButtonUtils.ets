export function degToRad(deg: number): number {
  return deg * (Math.PI / 180.0);
}
;

export function radToDeg(rad: number): number {

  return rad * (180.0 / Math.PI);
}

export function clamp(value: number, low: number, high: number): number {

  return Math.min(Math.max(value, low), high);
}

export function mapValueFromRangeToRange(value: number, fromLow: number, fromHigh: number,
                                         toLow: number, toHigh: number): number {
  return toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));
}


