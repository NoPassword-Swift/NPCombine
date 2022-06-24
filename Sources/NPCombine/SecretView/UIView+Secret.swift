//
//  UIView+Secret.swift
//  NPCombine
//

#if os(iOS)

import UIKit

extension UIView {
	/// Attempt to get a UIView that protects its content from screen capuring
	/// Set `breakAPI` to pretend the API no longer works
	public static func CreateSecretView(breakAPI: Bool = false) -> UIView? {
		guard !breakAPI else { return nil }

		let textField = UITextField()
		textField.isSecureTextEntry = true

		guard let secretView = textField.layer.sublayers?.first?.delegate as? UIView else { return nil }
		secretView.subviews.forEach { $0.removeFromSuperview() }
		return secretView
	}
}

#endif
