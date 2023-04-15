//
//  ViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import UIKit
import WebKit
class ViewController: UIViewController {
    private lazy var webView : WKWebView = {
        let configuration = WKWebViewConfiguration()
        // Don't supress rendering content before everything is in memory.
        configuration.suppressesIncrementalRendering = false
        // Disallow inline HTML5 Video playback, as we need to be able to
        // hook into the AVPlayer to detect whether or not videos are being
        // played. HTML5 Video Playback makes that impossible.
        configuration.allowsInlineMediaPlayback = false
        // All audiovisual media will require a user gesture to begin playing.
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        let v = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
//        v.navigationDelegate = self
        v.isHidden = true
        return v
    }()
    private lazy var button : ButtonNeumorphic = {
        let v = ButtonNeumorphic()
        v.layer.cornerRadius = 10
        v.setTitle("start", for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    @objc func buttonTap(_ sender : Any?){
        self.view.window?.rootViewController = UINavigationController(rootViewController: MovieHomeViewController())
        self.view.endEditing(true)
//        let vc = TestPageViewController()
//        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textField = NeumorphicTextField(frame: .init(origin: .init(x: 30, y: 200), size: .init(width: self.view.bounds.width - 60, height: 50)))
        textField.layer.cornerRadius = 10
        textField.placeholder = "text...."
        textField.attributedPlaceholder = NSAttributedString(string: "text...", attributes: [.foregroundColor : UIColor.black.withAlphaComponent(0.7)])
        self.view.addSubview(button)
        self.view.addSubview(textField)
        self.view.addSubview(webView)
        DispatchQueue.main.async {
            let request = URLRequest(url: URL(string: "https://bitvtom100.xyz/hls/v2/ec8918cbb89ca8a7c2498da07b5e252b/playlist.m3u8")!)
            self.webView.load(request)
        }
        
        self.view.backgroundColor = .Neumorphic.mainColor
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }


}

