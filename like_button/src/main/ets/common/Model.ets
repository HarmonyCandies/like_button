import { DartColor } from './Color';

export enum LikeCountAnimationType {
  //no animation
  none,
  //animation only on change part
  part,
  //animation on all
  all,
}


export interface BubblesColor {
  dotPrimaryColor: ResourceColor | DartColor;
  dotSecondaryColor: ResourceColor | DartColor;
  dotThirdColor?: ResourceColor | DartColor | null;
  dotLastColor?: ResourceColor | DartColor | null;
}


export interface CircleColor {
  start: ResourceColor | DartColor;
  end: ResourceColor | DartColor;
}

