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
    
    // MARK: - Init
    init(content: Content) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
        let navigator = VCNavigator(self)
        self.content.navigator = navigator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        hideNavigationBar()
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
    
    func hideNavigationBar() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
}

class VCNavigator {
    
    weak var parentVC: UIViewController?
    
    init(_ parentVC: UIViewController) {
        self.parentVC = parentVC
    }
    
    func navigate(to destination: UIViewController) {
        parentVC?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func dismiss() {
        parentVC?.navigationController?.popViewController(animated: true)
    }
}

protocol NavigatableView: View {
    var navigator: VCNavigator? { get set }
}
