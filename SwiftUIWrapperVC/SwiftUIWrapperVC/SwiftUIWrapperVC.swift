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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func hideNavigationBar(_ animated: Bool) {
        if #unavailable(iOS 16) {
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.setNavigationBarHidden(true, animated: animated)
            }
        }
    }
}

class VCNavigator {
    
    weak var parentVC: UIViewController?
    
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
