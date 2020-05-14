//
//  SCPageView.swift
//  PageViewDemo
//
//  Created by Sam Chiang on 2020/5/5.
//  Copyright © 2020 Sam Chiang. All rights reserved.
//

import UIKit

// MARK: 代理

public protocol SCPageViewDelegate: NSObjectProtocol {
    func didSelectedItem(_ index: Int)
}

// MARK: 数据源

public protocol SCPageViewDataSource: NSObjectProtocol {
//    func pageView(_ pageView: SCPageView, numberOfItems: Int) -> Int
    func pageView(_ pageView: SCPageView, cellForItemAt index: Int) -> UICollectionViewCell
}

open class SCPageView: UIView {
    var pageControl: UIPageControl!

    /// 是否开启无限循环
    /*
     如果是无限循环 -> 判断numberOfPages >= 3 ? collectionView 的 numberOfSection == 3 , 改变item位置 实现无限循环 : numberOfPages
     如果不是无限循环 -> collectionView 的 item 就是 numberOfPages
     */
    var isInfiniteLoop = true {
        didSet {
            if isInfiniteLoop {
                startTimer()
            } else {
                startTimer()
            }
        }
    }

    /// 是否自动播放， 默认 true
    var autoScrolling = true

    /// 自动翻页的时间戳
    var autoScrollInterval: TimeInterval = 5

    /// itemSize  Default CGSize.zero
    var itemSize: CGSize = CGSize.zero

    /// 默认当前页
    open var currentPage: Int = 0 {
        didSet {
//            pageControl.currentPage = currentPage
        }
    }

    /// 翻转定时器
    private var switchTimer: Timer?

    /// 总页数
    open var numberOfPages: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }

    /// DataSource
    open weak var dataSource: SCPageViewDataSource?

    /// Delegate
    open weak var delegate: SCPageViewDataSource?

    private var collectionView: UICollectionView!

    private var startX: CGFloat = 0


    /// 用于自定义更改样式
    open var layout: SCPageViewFlowLayout! {
        didSet {
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }

    private let identifier = "bannerCellId"

    // TODO: 晚点用于配置 动画样式
//    open var transform:

    public override init(frame: CGRect) {
        super.init(frame: frame)
        // 默认的Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.width, height: frame.height)
//        layout.layoutAttributesForItem(at: <#T##IndexPath#>)

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        backgroundColor = UIColor.yellow
        addSubview(collectionView)
        setConstraints()


//        // 初始化collectionView的位置
        if isInfiniteLoop {
//            collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .centeredHorizontally, animated: false)
            startTimer()
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if isInfiniteLoop {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .centeredHorizontally, animated: false)
            startX = frame.width
        }
    }
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        stopTimer()
    }

 
}

// MARK: 约束设置
extension SCPageView {
    /// 设置CollectionView的约束
     private func setConstraints() {
         collectionView.translatesAutoresizingMaskIntoConstraints = false

         let topConstraints = NSLayoutConstraint(item: collectionView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)

         let leftConstraints = NSLayoutConstraint(item: collectionView!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)

         let rightConstraints = NSLayoutConstraint(item: collectionView!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)

         let bottomConstraints = NSLayoutConstraint(item: collectionView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)

         collectionView.superview?.addConstraints([topConstraints, leftConstraints, rightConstraints, bottomConstraints])
     }
}

// Mark - : Register 注册
extension SCPageView {
    open func register(_ cellClass: AnyClass?) {
        if collectionView != nil {
            collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
        }
    }
}

// MARK: 定时器开关

extension SCPageView {
    ///  启动定时器
    func startTimer() {
        switchTimer = Timer(timeInterval: autoScrollInterval, target: self, selector: #selector(switchNextPage), userInfo: nil, repeats: true)
        RunLoop.current.add(switchTimer!, forMode: .default) // 添加到default 模式，这样 在scorllView isTracking 的时候会停止
//        switchTimer?.fire()
    }

    /// 停止定时器
    func stopTimer() {
        switchTimer?.invalidate()
        switchTimer = nil
    }

    
}

extension SCPageView {
    
    /// 这个方法只有自动的时候会调用
    @objc func switchNextPage() {
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 2), at: .centeredHorizontally, animated: true)
    }
}

// MARK: 返回的Cell

extension SCPageView {
    open func dequeueReusableCell(for index: Int) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0))
    }
}

extension SCPageView: UIScrollViewDelegate {
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }
  
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startX = scrollView.contentOffset.x
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScroll(scrollView)
        }
    }

    /// 表示ScorllView 停止滚动
    /// - Parameter scrollView: scrollView
    func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        if isInfiniteLoop && numberOfPages > 0 {
            // 如果是无限循环，需要判断左右滑动改变页码
            if scrollView.contentOffset.x / self.frame.width == 0 {
                currentPage = currentPage - 1 < 0 ? numberOfPages - 1 : currentPage - 1
            } else if scrollView.contentOffset.x / self.frame.width == 2 {
                currentPage = currentPage + 1 == numberOfPages ? 0 : currentPage + 1
            } else {
                return
            }
            let indexPath = IndexPath(item: 0, section: 1)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            UIView.setAnimationsEnabled(false)
            collectionView.reloadData()
            UIView.setAnimationsEnabled(true)
        } else {
            currentPage = Int(ceil(scrollView.contentOffset.x / self.frame.width))
        }
    }
}

// MARK: UICollectionViewDelegate

extension SCPageView: UICollectionViewDelegate {
}

// MARK: UICollectionViewDataSource

extension SCPageView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isInfiniteLoop {
            return 3
        } else {
            return numberOfPages
        }
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: 这里做currentPage 的计算， 返回currentPage 的 cell

        if isInfiniteLoop {
            var loadPage = 0
            switch indexPath.section {
            case 0: // 表示前一页
                loadPage = currentPage - 1 < 0 ? numberOfPages - 1 : currentPage - 1
            case 1:
                loadPage = currentPage
            case 2:
                loadPage = currentPage + 1 == numberOfPages ? 0 : currentPage + 1
            default:
                break
            }
            if dataSource?.pageView(self, cellForItemAt: loadPage) != nil {
                return dataSource!.pageView(self, cellForItemAt: loadPage)
            }
        } else {
            return dataSource!.pageView(self, cellForItemAt: indexPath.section)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
}
