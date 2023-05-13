//
//  SwiftUIWrapperVC.swift
//  SwiftUIWrapperVC
//
//  Created by insub on 2023/04/22.
//

import SwiftUI

class SwiftUIWrapperVC<Content: NavigatableView>: UIViewController {
    
    // MARK: - Properties
    private var contentView: UIView!
    private var content: Content
    
    let navigator: VCNavigator
    
    // MARK: - Init
    init(content: Content) {
        self.navigator = VCNavigator()
        self.content = content
        self.content.navigator = self.navigator
        super.init(nibName: nil, bundle: nil)
        self.navigator.parentVC = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    // MARK: - Action
    func setView() {
        contentView = UIView(frame: view.bounds)
        let hController = UIHostingController(rootView: self.content)
        
        addChild(hController)
        view.addSubview(contentView)
        
        contentView.addSubview(hController.view)
        hController.view.frame = contentView.frame
    }
}

@MainActor
class VCNavigator {
    
    weak var parentVC: UIViewController?

    func navigate(to destination: UIViewController) {
        parentVC?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pop(to controller: AnyClass) {
        guard let parentVC, let nc = parentVC.navigationController else { return }
        for vc in nc.viewControllers {
            guard vc.isMember(of: controller) else { continue }
            nc.popToViewController(vc, animated: true)
        }
    }
    
    func pop(to controllers: AnyClass...) {
        guard let parentVC, let nc = parentVC.navigationController else { return }
        for vc in nc.viewControllers {
            let result = controllers.contains(where: { vc.isMember(of: $0) })
            guard result else { continue }
            nc.popToViewController(vc, animated: true)
        }
    }
    
    func pop() {
        self.parentVC?.navigationController?.popViewController(animated: true)
    }
}

protocol NavigatableView: View {
    var navigator: VCNavigator? { get set }
}

extension NavigatableView {
    
    func wrap() -> SwiftUIWrapperVC<Self> {
        return SwiftUIWrapperVC(content: self)
    }
}
