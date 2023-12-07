import { DartColor } from './Color';

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
    dotPrimaryColor: ResourceColor | DartColor,
    dotSecondaryColor: ResourceColor | DartColor,
    dotThirdColor?: ResourceColor | DartColor,
    dotLastColor?: ResourceColor | DartColor,
  }) {
    this.dotPrimaryColor = value.dotPrimaryColor;
    this.dotSecondaryColor = value.dotSecondaryColor;
    this.dotThirdColor = value.dotThirdColor == undefined ? value.dotPrimaryColor : value.dotThirdColor;
    this.dotLastColor = value.dotLastColor == undefined ? value.dotSecondaryColor : value.dotLastColor;
  }

  dotPrimaryColor: ResourceColor | DartColor;
  dotSecondaryColor: ResourceColor | DartColor;
  dotThirdColor: ResourceColor | DartColor;
  dotLastColor: ResourceColor | DartColor;
}


export class CircleColor {
  constructor(value: {
    start: ResourceColor | DartColor,
    end: ResourceColor | DartColor,
  }) {
    this.start = value.start;
    this.end = value.end;
  }

  start: ResourceColor | DartColor;
  end: ResourceColor | DartColor;
}

