# SwiftUIWrapperVC

기존 UIKit 프로젝트에서 SwiftUI 자유롭게 사용하기 위해 고민하다 만들게 되었습니다.  
NavigationController 를 캡슐화하여 UIKit, SwiftUI 모두에서 통일된 Navigate 방식을 사용할 수 있습니다.

간단한 코드 예시와 구현 화면은 아래와 같습니다 👇👇

✔️ SwiftUI Side 
```
    func didTapButton() {
        let destination = SwiftUIWrapperVC(content: StackView())
        navigator?.navigate(to: destination)
    }
    
    func didTapDismiss() {
        navigator?.dismiss()
    }
```

✔️ UIKit Side
```
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let vc = SwiftUIWrapperVC(content: RootView())
        let nc = UINavigationController(rootViewController: vc)
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }
```

<img src="https://user-images.githubusercontent.com/85481204/233837885-582ad25f-a645-4d17-98a4-d0526e57f878.gif" width="300" height="649">
