//
//  ViewController.swift
//  LShuffling
//
//  Created by liyonghui16 on 04/04/2018.
//  Copyright (c) 2018 liyonghui16. All rights reserved.
//

import UIKit
import LShuffling

class ViewController: UIViewController {

    let shufflingView = ShufflingView(frame: CGRect(x: 0, y: 0, width: 375, height: 220))
    var imageUrls: [AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shufflingView.dataSource = self
        shufflingView.delegate = self
        view.addSubview(shufflingView)
        
        let data = try? Data(contentsOf: Bundle.main.url(forResource: "home0", withExtension: "json")!)
        let dict: NSDictionary = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
        let tmp: AnyObject = dict["data"] as AnyObject
        let list = tmp["content_list"]
        imageUrls = list as! [AnyObject]
        shufflingView.startShuffling()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: ShufflingDataSource {
    func shufflingView(_ shufflingView: ShufflingView, titleAt index: Int) -> String? {
        return imageUrls[index]["title"] as? String
    }
    func shufflingView(_ shufflingView: ShufflingView, imageAt index: Int) -> String {
        return imageUrls[index]["img_url"] as! String
    }
    func imageCountInShufflingView(_ shufflingView: ShufflingView) -> Int {
        return imageUrls.count
    }
}

extension ViewController: ShufflingDelegate {
    func shufflingView(_ shufflingView: ShufflingView, didSrollTo index: Int) {
    }
    func shufflingView(_ shufflingView: ShufflingView, didClickImageAt index: Int) {
        print("点击了第\(index)张图片~")
    }
}

