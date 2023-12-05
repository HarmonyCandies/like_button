import { LikeButton } from '@candies/like_button';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        LikeButton(
          { animationDuration: 5000, isLiked: false, }
        )
       .backgroundColor('#FFFF5722')
      }
      .width('100%')
    }
    .height('100%')
  }
}