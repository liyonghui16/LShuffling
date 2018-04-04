//
//  ShufflingView.swift
//  One
//
//  Created by Ens Livan on 2018/3/31.
//  Copyright © 2018年 Enslivan. All rights reserved.
//

import UIKit
import Kingfisher

public protocol ShufflingDataSource: NSObjectProtocol {
    func imageCountInShufflingView(_ shufflingView: ShufflingView) -> Int
    func shufflingView(_ shufflingView: ShufflingView, imageAt index: Int) -> String
    func shufflingView(_ shufflingView: ShufflingView, titleAt index: Int) -> String
    var placeholder: UIImage? { get }
}

public protocol ShufflingDelegate: NSObjectProtocol {
    func shufflingView(_ shufflingView: ShufflingView, didSrollTo index: Int)
    func shufflingView(_ shufflingView: ShufflingView, didClickImageAt index: Int)
}

public extension ShufflingDelegate {
    func shufflingView(_ shufflingView: ShufflingView, didSrollTo index: Int) {}
    func shufflingView(_ shufflingView: ShufflingView, didClickImageAt index: Int) {}
    
}

public extension ShufflingDataSource {
    var placeholder: UIImage? {
        return nil
    }
}

open class ShufflingView: UIView {
    // MARK: - props
    weak open var dataSource: ShufflingDataSource?
    weak open var delegate: ShufflingDelegate?
    open var isShowTitle: Bool = true {
        willSet {
            titleLabel.isHidden = !newValue
        }
    }
    open var isShowPageControl: Bool = true {
        willSet {
            pageControl.isHidden = !newValue
        }
    }
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: bounds)
        scrollView.contentSize = CGSize(width: bounds.size.width * 3, height: bounds.size.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private lazy var leftImageView: UIImageView = {
        let left = UIImageView()
        return left
    }()
    private lazy var currentImageView: UIImageView = {
        let current = UIImageView()
        return current
    }()
    private lazy var rightImageView: UIImageView = {
        let right = UIImageView()
        return right
    }()
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = UIColor.orange
//        control.hidesForSinglePage = true
        return control
    }()
    private var pageControlSize: CGSize = .zero
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 0.4, alpha: 0.5)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightText
        return label
    }()
    private var timer: Timer!
    private var currentIndex = 0
    
    // MARK: - life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(currentImageView)
        scrollView.addSubview(rightImageView)
        scrollView.contentOffset = CGPoint(x: frame.size.width, y: 0)
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        addGestureRecognizer(gesture)
        addSubview(titleLabel)
        addSubview(pageControl)
    }
    
    public func startShuffling() {
        let imageCount = dataSource!.imageCountInShufflingView(self)
        pageControl.currentPage = 0
        pageControl.numberOfPages = imageCount
        pageControlSize = pageControl.size(forNumberOfPages: imageCount)
        setNeedsLayout()
        currentImageView.kf.setImage(with: URL(string: dataSource!.shufflingView(self, imageAt: 0)), placeholder: dataSource!.placeholder)
        if imageCount > 1 {
            rightImageView.kf.setImage(with: URL(string: dataSource!.shufflingView(self, imageAt: 1)), placeholder: dataSource!.placeholder)
        }
        titleLabel.text = dataSource!.shufflingView(self, titleAt: 0)
        currentIndex = 0
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        timer.invalidate()
        timer = nil
    }
    
    // MARK: - event
    @objc
    private func tapGestureAction() {
        delegate?.shufflingView(self, didClickImageAt: currentIndex)
    }
    
    @objc
    private func timerAction() {
        scrollView.scrollRectToVisible(CGRect(x: 2 * frame.size.width, y: 0, width: frame.size.width, height: frame.size.height), animated: true)
    }
    
    // MARK: - timer public
    public func startTimer() {
        timer.fireDate = Date.distantPast
    }
    public func pauseTimer() {
        timer.fireDate = Date.distantFuture
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        leftImageView.frame = frame
        currentImageView.frame = CGRect(x: frame.size.width, y: 0, width: frame.size.width, height: frame.size.height)
        rightImageView.frame = CGRect(x: 2 * frame.size.width, y: 0, width: frame.size.width, height: frame.size.height)
        pageControl.frame = CGRect(x: frame.size.width - pageControlSize.width - 10, y: frame.size.height - pageControlSize.height, width: pageControlSize.width, height: pageControlSize.height)
        titleLabel.frame = CGRect(x: 0, y: frame.size.height - 30, width: frame.size.width, height: 30)
    }
    fileprivate func resetImage(imageCount: Int) {
        delegate!.shufflingView(self, didSrollTo: currentIndex)
        titleLabel.text = dataSource!.shufflingView(self, titleAt: currentIndex)
        pageControl.currentPage = currentIndex
        scrollView.contentOffset = CGPoint(x: frame.size.width, y: 0)
        let leftIndex = currentIndex == 0 ? imageCount - 1 : currentIndex - 1
        let rightIndex = currentIndex < imageCount - 1 ? currentIndex + 1 : 0
        leftImageView.kf.setImage(with: URL(string: dataSource!.shufflingView(self, imageAt: leftIndex)), placeholder: dataSource!.placeholder)
        currentImageView.kf.setImage(with: URL(string: dataSource!.shufflingView(self, imageAt: currentIndex)), placeholder: dataSource!.placeholder)
        rightImageView.kf.setImage(with: URL(string: dataSource!.shufflingView(self, imageAt: rightIndex)), placeholder: dataSource!.placeholder)
    }
}

extension ShufflingView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let imageCount = dataSource!.imageCountInShufflingView(self)
        if scrollView.contentOffset.x > frame.size.width {
            if currentIndex == imageCount - 1 {
                currentIndex = 0
            } else {
                currentIndex = currentIndex + 1
            }
        } else if scrollView.contentOffset.x == frame.size.width {
            return
        } else {
            if currentIndex == 0 {
                currentIndex = imageCount - 1
            } else {
                currentIndex = currentIndex - 1
            }
        }
        resetImage(imageCount: imageCount)
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let imageCount = dataSource!.imageCountInShufflingView(self)
        currentIndex = imageCount - 1 == currentIndex ? 0 : currentIndex + 1
        resetImage(imageCount: imageCount)
    }
}
