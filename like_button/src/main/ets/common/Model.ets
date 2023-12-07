
export enum LikeCountAnimationType {
  //no animation
  none,
  //animation only on change part
  part,
  //animation on all
  all,
}

export class BubblesColor {
  constructor(value: {
    dotPrimaryColor: ResourceColor,
    dotSecondaryColor: ResourceColor,
    dotThirdColor?: ResourceColor,
    dotLastColor?: ResourceColor,
  }) {
    this.dotPrimaryColor = value.dotPrimaryColor;
    this.dotSecondaryColor = value.dotSecondaryColor;
    this.dotThirdColor = value.dotThirdColor == undefined ? value.dotPrimaryColor : value.dotThirdColor;
    this.dotLastColor = value.dotLastColor == undefined ? value.dotSecondaryColor : value.dotLastColor;
  }

  dotPrimaryColor: ResourceColor;
  dotSecondaryColor: ResourceColor;
  dotThirdColor: ResourceColor;
  dotLastColor: ResourceColor;
}

export class CircleColor {
  constructor(value: {
    start: ResourceColor,
    end: ResourceColor,
  }) {
    this.start = value.start;
    this.end = value.end;
  }

  start: ResourceColor;
  end: ResourceColor;
}

