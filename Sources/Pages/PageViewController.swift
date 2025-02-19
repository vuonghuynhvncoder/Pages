//
//  PageViewController.swift
//  Pages
//
//  Created by Nacho Navarro on 03/11/2019.
//  Copyright © 2019 nachonavarro. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SwiftUI
import UIKit

/// The UIPageViewController in charge of the pages.
@available(iOS 13.0, *)
struct PageViewController: UIViewControllerRepresentable {

    let id: String
    @Binding var currentPage: Int

    var navigationOrientation: UIPageViewController.NavigationOrientation
    var transitionStyle: UIPageViewController.TransitionStyle
    var bounce: Bool
    var wrap: Bool
    var disable: Bool
    var onPageChanged: ((Int) -> Void)?
    var onScrolled: (() -> Void)?
    var controllers: [UIViewController]

    func makeCoordinator() -> PagesCoordinator {
        PagesCoordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
//        debugPrint("PageViewController::makeUIViewController")
        let pageViewController = UIPageViewController(
            transitionStyle: self.transitionStyle,
            navigationOrientation: self.navigationOrientation
        )
        pageViewController.dataSource = disable ? nil : context.coordinator
        pageViewController.delegate = context.coordinator
        pageViewController.view.backgroundColor = .clear

        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = context.coordinator
                break
            }
        }

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let previousId = context.coordinator.parent.id
        let previousPage = context.coordinator.parent.currentPage
        if(previousId == id && previousPage == currentPage
           && (pageViewController.viewControllers?.first) != nil){
            return
        }
        let isScroll = context.coordinator.isScroll
        context.coordinator.parent = self
        context.coordinator.isScroll = false
        let animated = (currentPage != previousPage && !isScroll)
        var direction: UIPageViewController.NavigationDirection
        if(currentPage == 0 && previousPage == controllers.count - 1) {
            direction = .forward
        }else{
            direction = currentPage - previousPage > 0 ? .forward : .reverse
        }
//        debugPrint("PageViewController::updateUIViewController previousPage: \(previousPage), currentPage: \(currentPage), animated: \(animated), direction: \(direction)")
        pageViewController.setViewControllers(
            [controllers[currentPage]],
            direction: direction,
            animated: animated
        )
        onPageChange()
    }
    
    private func onPageChange() {
        if let onPageChanged = onPageChanged {
            onPageChanged(currentPage)
        }
    }
    
    fileprivate func onScroll() {
        if let onScrolled = onScrolled {
            onScrolled()
        }
    }

}

@available(iOS 13.0, *)
class PagesCoordinator: NSObject, UIPageViewControllerDataSource,
                             UIPageViewControllerDelegate {
    var parent: PageViewController
    var isScroll = false

    init(_ pageViewController: PageViewController) {
        self.parent = pageViewController
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = parent.controllers.firstIndex(of: viewController) else {
            return nil
        }
//        debugPrint("PagesCoordinator::pageViewController1 index: \(index)")
        if(index == 0 && parent.controllers.count < 2) {
            return nil
        }
        return index == 0 ? (self.parent.wrap ? parent.controllers.last : nil) : parent.controllers[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = parent.controllers.firstIndex(of: viewController) else {
            return nil
        }
//        debugPrint("PagesCoordinator::pageViewController2 index: \(index)")
        if (index == parent.controllers.count - 1 && parent.controllers.count < 2) {
            return nil
        }
        return index == parent.controllers.count - 1 ? (self.parent.wrap ? parent.controllers.first : nil) : parent.controllers[index + 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
//        debugPrint("PagesCoordinator::pageViewController3 completed: \(completed)")
        if completed,
        let visibleViewController = pageViewController.viewControllers?.first,
        let index = parent.controllers.firstIndex(of: visibleViewController) {
            isScroll = true
            parent.currentPage = index
            parent.onScroll()
        }
    }
}

@available(iOS 13.0, *)
extension PagesCoordinator: UIScrollViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        debugPrint("PagesCoordinator::scrollViewWillBeginDecelerating")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        debugPrint("PagesCoordinator::scrollViewWillBeginDragging")
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        debugPrint("PagesCoordinator::scrollViewWillBeginZooming")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !parent.bounce {
            if parent.navigationOrientation == .horizontal {
                disableHorizontalBounce(scrollView)
            } else {
                disableVerticalBounce(scrollView)
            }
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        debugPrint("PagesCoordinator::scrollViewShouldScrollToTop")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        debugPrint("PagesCoordinator::scrollViewDidEndDragging")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        debugPrint("PagesCoordinator::scrollViewDidEndScrollingAnimation")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        debugPrint("PagesCoordinator::scrollViewDidEndDecelerating")
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        debugPrint("PagesCoordinator::scrollViewWillEndDragging")
        scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        debugPrint("PagesCoordinator::scrollViewDidEndZooming")
    }

    private func disableHorizontalBounce(_ scrollView: UIScrollView) {
        if parent.currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width ||
           parent.currentPage == self.parent.controllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }

    private func disableVerticalBounce(_ scrollView: UIScrollView) {
        if parent.currentPage == 0 && scrollView.contentOffset.y < scrollView.bounds.size.height ||
           parent.currentPage == self.parent.controllers.count - 1 && scrollView.contentOffset.y > scrollView.bounds.size.height {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.bounds.size.height)
        }
    }
}
