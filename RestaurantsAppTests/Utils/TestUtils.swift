//
//  TestUtils.swift
//  RestaurantsAppTests
//
//  Created by Facundo Andrés Siri on 21/09/2022.
//

import UIKit

struct TestUtils {
    
    static func checkTapGestureRecognizerAndCallAction(of view: UIView) {
        /// Get all gesture recognizers.
        let gestureRecognizers = view.gestureRecognizers!
        let tapGestureRecognizerList = gestureRecognizers.filter { gesture in
            gesture is UITapGestureRecognizer
        }

        /// Get the targets.
        let tapGestureRecognizer = tapGestureRecognizerList.first!
        let targets = (tapGestureRecognizer.value(forKeyPath: "_targets") as? [Any])!
        let target = targets.first!

        /// Get the selector parsing the UIGestureRecognizerTarget description.
        let selectorString = String(describing: target).components(separatedBy: ", ").first!
            .replacingOccurrences(of: "(action=", with: "")
        let selector = NSSelectorFromString(selectorString)

        /// Get the target from iVars.
        let targetActionPairClass: AnyClass = NSClassFromString("UIGestureRecognizerTarget")!
        let targetIvar = class_getInstanceVariable(targetActionPairClass, "_target")!
        let targetObject = object_getIvar(target, targetIvar) as AnyObject

        /// Simulate the tap gesture.
        targetObject.performSelector(onMainThread: selector, with: tapGestureRecognizer, waitUntilDone: true)
    }
}
