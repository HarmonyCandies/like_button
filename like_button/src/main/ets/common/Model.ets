export  class BubblesColor {
  private _dotPrimaryColor: ResourceColor ;
  private _dotSecondaryColor: ResourceColor ;
  private _dotThirdColor: ResourceColor ;
  private _dotLastColor: ResourceColor ;

  constructor(value: {
    dotPrimaryColor: ResourceColor ,
    dotSecondaryColor: ResourceColor ,
    dotThirdColor?: ResourceColor ,
    dotLastColor?: ResourceColor
  }) {
    this._dotPrimaryColor = value.dotPrimaryColor;
    this._dotSecondaryColor = value.dotSecondaryColor;
    if (value.dotThirdColor == undefined) {
      this._dotThirdColor = value.dotPrimaryColor;
    }
    else {
      this._dotThirdColor = value.dotThirdColor;
    }

    if (value.dotLastColor == undefined) {
      this._dotLastColor = value.dotSecondaryColor;
    }
    else {
      this._dotLastColor = value.dotLastColor;
    }
  }

  get dotPrimaryColor(): ResourceColor  {
    return this._dotPrimaryColor;
  }

  get dotSecondaryColor(): ResourceColor  {
    return this._dotSecondaryColor;
  }

  get dotThirdColor(): ResourceColor  {
    return this._dotThirdColor;
  }

  get dotLastColor(): ResourceColor  {
    return this._dotLastColor;
  }
}

export class CircleColor {
  private _start: ResourceColor ;
  private _end: ResourceColor ;

  constructor(value: {
    start: ResourceColor ,
    end: ResourceColor
  }) {
    this._start = value.start;
    this._end = value.end;
  }

  get start(): ResourceColor  {
    return this._start;
  }

  get end(): ResourceColor  {
    return this._end;
  }
}

