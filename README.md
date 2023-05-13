# SwiftUIWrapper

## 👀 해결하고자 하는 문제
기존 UIKit 프로젝트에서 SwiftUI 를 자유롭게 사용하기 위해 고민하다 만들게 되었습니다.   
UIHostingController 를 통해 SwiftUI View 를 호출하게 될 경우 예상하지 못한 많은 버그를 마주하곤 합니다.  
그러한 이슈를 미리 예방할 수 있는 방법을 고민하다 고안하게 되었습니다.  

SwiftUI, UIKit 를 같이 사용하다 보니 통일되지 못한 화면 전환 방식에 대해 고민을 하게 되었습니다.  
그래서 NavigationController 를 캡슐화하여 UIKit, SwiftUI 모두에서 통일된 방법으로 화면 전환 할 수 있도록 구조화 하였습니다.  
또한 기존 SwiftUI 처럼 View 에서 직접 Navigation 을 하지 않고 navigator 라는 객체를 통해 ViewModel 혹은 외부에서 화면을 전환할 수 있다는 장점도 있습니다.

## 🛠️ 사용된 디자인 패턴

- Adapter Pattern
- Command Pattern

## 👍 장점

1. NavigationController 를 SwiftUI 에서 도 UIKit 와 일관된 방법으로 화면 전환 할 수 있습니다.

2. 기존 SwiftUI 처럼 View 에서 직접 navigate 하지 않고 navigator 라는 객체를 통해 viewModel 등에서 navigation 을 할 수 있습니다.

3. UIHostingController를 사용해서 발생하는 버그들을 예방할 수 있습니다.

## 📱 코드 예시와 화면

<img src="https://user-images.githubusercontent.com/85481204/233837885-582ad25f-a645-4d17-98a4-d0526e57f878.gif" width="300" height="649">

✔️ SwiftUI Side 
```
struct RootView: NavigatableView {
    
    weak var navigator: VCNavigator?
    
    var body: some View {
       ...
    }
    
    func didTapButton() {
        let destination = SwiftUIWrapperVC(content: StackView())
        navigator?.push(to: destination)
    }
    
    func didTapDismiss() {
        navigator?.pop()
    }
}
```

✔️ UIKit Side
```
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    
    let controller = RootView
        .init()
        .wrap()
    let nc = UINavigationController(rootViewController: controller)
    window?.rootViewController = nc
    window?.makeKeyAndVisible()
}
```

## 📚 참고 (서적)
- [헤드 퍼스트 디자인 패턴](http://www.yes24.com/Product/Goods/108192370?pid=123487&cosemkid=go16481149710577107&gclid=CjwKCAjw6vyiBhB_EiwAQJRoppBl2zaSsFHSQovHwwz5gbVKrcYWoSBxIo4HnnMMQknyohEXXuY3jRoCr9oQAvD_BwE)
