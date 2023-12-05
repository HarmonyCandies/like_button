export class CustomPainter {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  protected canvas: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

}