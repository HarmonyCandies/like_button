import { LikeButton, like_button } from '@candies/like_button';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State controller: like_button.Controller = new like_button.Controller();

  aboutToAppear() {
    // this.controller.likeComponentSize = 150;
    // this.controller.animationDuration=5000;
  }

  build() {
    Navigation(){
      Grid() {
        GridItem() {
          LikeButton(
            {
              controller: this.controller
            }
          )
        }
        GridItem() {
          LikeButton(
            {
              controller: this.controller
            }
          )
        }
        GridItem() {
          LikeButton(
            {
              controller: this.controller
            }
          )
        }
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
      .height('100%')
    }.title('LikeButtonDemo').titleMode(NavigationTitleMode.Mini)
  }
}