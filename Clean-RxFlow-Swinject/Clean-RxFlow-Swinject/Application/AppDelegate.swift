//
//  AppDelegate.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit
import RxSwift
import RxFlow
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    
    static let container = Container()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        AppDelegate.container.registerDependencies()
        
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        let appFlow = AppFlow()
        
        self.coordinator.coordinate(flow: appFlow, with: AppStepper())
        
        Flows.use(appFlow, when: .created) { root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }
        return true
    }
}


