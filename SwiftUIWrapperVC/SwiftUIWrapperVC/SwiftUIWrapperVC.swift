//
//  SwiftUIWrapperVC.swift
//  SwiftUIWrapperVC
//
//  Created by insub on 2023/04/22.
//

import SwiftUI

class SwiftUIWrapperVC<Content: WrappableView>: UIViewController, ToastMessageCommand {
    
    // MARK: - Properties
    var hController = UIHostingController<Content?>(rootView: nil)
    var content: Content
    
    let navigator: VCNavigator
    var backgroundColor: UIColor?
    
    // MARK: - Init
    init(
        content: Content, 
        backgroundColor: UIColor? = nil, 
        hideBottomBar: Bool = true
    ) {
        self.navigator = VCNavigator()
        self.content = content
        self.content.navigator = self.navigator
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
        self.navigator.set(controller: self)
        self.hidesBottomBarWhenPushed = hideBottomBar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar(false)
    }
    
    // MARK: - Action
    func setView() {
        hController = UIHostingController(rootView: self.content)
        hController.view.frame = view.frame
        
        if let backgroundColor {
            hController.view.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        }
        
        addChild(hController)
        view.addSubview(hController.view)
        hController.didMove(toParent: self)
    }
}

@MainActor
class VCNavigator {
    
    private(set) weak var parentVC: UIViewController?
    
    var window: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return window
    }
    
    func set(controller: UIViewController) {
        self.parentVC = controller
    }
    
    // MARK: - Navigation
    func push(to destination: UIViewController) {
        parentVC?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pop(to controller: AnyClass) {
        guard let parentVC, let nController = parentVC.navigationController else { return }
        guard let target = nController
            .viewControllers
            .first(
                where: { 
                    $0.isMember(of: controller) 
                } 
            ) 
        else { return }
        
        nController
            .popToViewController(
                target,
                animated: true
            )
    }
    
    func pop(to controllers: AnyClass...) {
        
        guard let parentVC, 
              let nController = parentVC.navigationController 
        else { return }
        
        for vController in nController.viewControllers {
            
            let result = controllers
                .contains(where: {
                    vController.isMember(of: $0)
                })
            
            guard result else { continue }
            
            nController
                .popToViewController(
                    vController, animated: true
                )
        }
    }
    
    func pop() {
        self
            .parentVC?
            .navigationController?
            .popViewController(
                animated: true
            )
    }
    
    // MARK: - Modal
    func present(to destination: UIViewController, style: UIModalPresentationStyle = .fullScreen, animation: Bool = true) {
        destination.modalPresentationStyle = style
        self
            .parentVC?
            .present(
                destination,
                animated: animation
            )
    }

    func dismiss(animation: Bool = true) {
        self
            .parentVC?
            .dismiss(
                animated: animation
            )
    }
    
    func removeFromParentAndSuperView() {
        parentVC?
            .removeFromParentAndSuperView()
    }
    
    func customModal(_ controller: UIViewController) {
        window?
            .rootViewController?
            .addChildAndSubView(
                controller
            )
    }
}

extension UIViewController {
    
    func addChildAndSubView(_ controller: UIViewController) {
        self.addChild(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func removeFromParentAndSuperView() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

protocol WrappableView: View {
    var navigator: VCNavigator? { get set }
}

extension WrappableView {
    
    func wrap(
        backgroundColor: UIColor? = nil, 
        hideBottomBar: Bool = true
    ) -> SwiftUIWrapperVC<Self> {
        
        SwiftUIWrapperVC(
            content: self,
            backgroundColor: backgroundColor,
            hideBottomBar: hideBottomBar
        )
    }
}
