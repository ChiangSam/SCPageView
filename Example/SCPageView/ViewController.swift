//
//  ViewController.swift
//  SCPageView
//
//  Created by yatangsweet@hotmail.com on 05/14/2020.
//  Copyright (c) 2020 yatangsweet@hotmail.com. All rights reserved.
//

import UIKit
import SCPageView
import SnapKit
import Kingfisher
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {
    
    var bannerUrlArr = ["http://img.51miz.com/preview/muban/00/00/42/38/M-423841-25D67946.jpg","http://img.51miz.com/preview/muban/00/00/42/38/M-423841-9328294B.jpg","http://bpic.588ku.com/back_water_img/20/02/05/170ef52baa612d80c43e7afdf9cebc23e5.jpg%21/fw/750/quality/99/unsharp/true/compress/true"]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pageView = SCPageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
                pageView.register(BannerCell.self)
             
             pageView.numberOfPages = bannerUrlArr.count
             view.addSubview(pageView)
             

             pageView.delegate = self
             pageView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: SCPageViewDataSource {
    func pageView(_ pageView: SCPageView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pageView.dequeueReusableCell(for: index) as! BannerCell
        cell.bannerIV.kf.setImage(with: URL(string: bannerUrlArr[index]))
        return cell
    }
}

class BannerCell: UICollectionViewCell {
    var bannerIV: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        configUI()
    }
    
    
    private func configUI() {
        bannerIV = UIImageView()
        addSubview(bannerIV)
        bannerIV.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
}
