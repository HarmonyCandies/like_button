/// convert from dart Color

export class DartColor {
  readonly value: number;

  constructor(value: number) {
    //  this.value = value & 0xFFFFFFFF;
    // 强制转换为无符号32位整数
    this.value = value >>> 0;

  }

  static fromARGB(a: number, r: number, g: number, b: number): DartColor {
    let value =
      ((a & 0xff) << 24) |
        ((r & 0xff) << 16) |
        ((g & 0xff) << 8) |
        (b & 0xff);

    return new DartColor(value);
  }

  static fromRGBO(r: number, g: number, b: number, opacity: number): DartColor {
    const value =
      (((Math.round(opacity * 0xff) & 0xff) << 24) |
        (r & 0xff) << 16) |
        ((g & 0xff) << 8) |
        (b & 0xff);

    return new DartColor(value);
  }

  get alpha(): number {
    return (0xff000000 & this.value) >>> 24;
  }

  get opacity(): number {
    return this.alpha / 0xFF;
  }

  get red(): number {
    return (0x00ff0000 & this.value) >>> 16;
  }

  get green(): number {
    return (0x0000ff00 & this.value) >>> 8;
  }

  get blue(): number {
    return (0x000000ff & this.value);
  }

  withAlpha(a: number): DartColor {
    return DartColor.fromARGB(a, this.red, this.green, this.blue);
  }

  withOpacity(opacity: number): DartColor {
    if (opacity < 0.0 || opacity > 1.0) {
      throw new Error('Opacity must be between 0.0 and 1.0');
    }
    return this.withAlpha(Math.round(opacity * 255));
  }

  withRed(r: number): DartColor {
    return DartColor.fromARGB(this.alpha, r, this.green, this.blue);
  }

  withGreen(g: number): DartColor {
    return DartColor.fromARGB(this.alpha, this.red, g, this.blue);
  }

  withBlue(b: number): DartColor {
    return DartColor.fromARGB(this.alpha, this.red, this.green, b);
  }

  computeLuminance(): number {
    const linearizeColorComponent = (component: number): number => {
      if (component <= 0.03928) {
        return component / 12.92;
      }
      return Math.pow((component + 0.055) / 1.055, 2.4);
    };

    const R = linearizeColorComponent(this.red / 0xFF);
    const G = linearizeColorComponent(this.green / 0xFF);
    const B = linearizeColorComponent(this.blue / 0xFF);

    return 0.2126 * R + 0.7152 * G + 0.0722 * B;
  }

  static lerp(a: DartColor | null, b: DartColor | null, t: number): DartColor | null {
    if (t < 0) {
      t = 0;
    } else if (t > 1) {
      t = 1;
    }

    if (b === null) {
      if (a === null) {
        return null;
      } else {
        return a.withAlpha(Math.round((1 - t) * a.alpha));
      }
    } else {
      if (a === null) {
        return b.withAlpha(Math.round(t * b.alpha));
      } else {
        const alpha = Math.round(DartColor._lerpInt(a.alpha, b.alpha, t));
        const red = DartColor._lerpInt(a.red, b.red, t);
        const green = DartColor._lerpInt(a.green, b.green, t);
        const blue = DartColor._lerpInt(a.blue, b.blue, t);

        return DartColor.fromARGB(alpha, red, green, blue);
      }
    }
  }

  private static _lerpInt(a: number, b: number, t: number): number {
    return a + (b - a) * t;
  }

  private static _scaleAlpha(color: DartColor, factor: number): DartColor {
    return color.withAlpha(Math.round(color.alpha * factor));
  }

  static alphaBlend(foreground: DartColor, background: DartColor): DartColor {
    const alpha = foreground.alpha;
    if (alpha === 0x00) {
      return background;
    }

    const invAlpha = 0xff - alpha;
    let backAlpha = background.alpha;

    if (backAlpha === 0xff) {
      return DartColor.fromARGB(
        0xff,
        Math.round((alpha * foreground.red + invAlpha * background.red) / 0xff),
        Math.round((alpha * foreground.green + invAlpha * background.green) / 0xff),
        Math.round((alpha * foreground.blue + invAlpha * background.blue) / 0xff)
      );
    } else {
      backAlpha = (backAlpha * invAlpha) / 0xff;
      const outAlpha = alpha + backAlpha;
      return DartColor.fromARGB(
        outAlpha,
        Math.round((foreground.red * alpha + background.red * backAlpha) / outAlpha),
        Math.round((foreground.green * alpha + background.green * backAlpha) / outAlpha),
        Math.round((foreground.blue * alpha + background.blue * backAlpha) / outAlpha)
      );
    }
  }

  static fromString(colorString: string): DartColor {

    let hexValue: string = colorString;

    if (hexValue.charAt(0) === '#') {
      hexValue = hexValue.substr(1);
    }

    if (hexValue.length !== 6 && hexValue.length !== 8) {
      throw new Error('Invalid color string format');
    }

    if (hexValue.length === 6) {
      hexValue = `FF${hexValue}`;
    }

    const parsedValue: number = parseInt(hexValue, 16);
    return new DartColor(parsedValue);
  }

  static fromResourceColor(color: ResourceColor | DartColor): DartColor {
    if (color instanceof DartColor) {
      return color;
    }
    return DartColor.fromString(color as string);
  }

  toString(): string {
    return `#${this.value.toString(16).padStart(8, '0')}`;
  }
}
