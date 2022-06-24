//
//  CBButton.swift
//  NPCombine
//

#if os(iOS)

import Combine
import CoreCombine
import UIKit

public class CBButton: UIButton {
	private var subscription: AnyCancellable?

	public func track(subject: CBSubject<String>?) {
		if let subject = subject {
			self.subscription = subject
				.receive(on: DispatchQueue.mainIfNeeded)
				.sink { [weak self] value in
					guard let self = self else { return }
					self.setTitle(value, for: .normal)
					self.sizeToFit()
				}
		} else {
			self.subscription = nil
		}
	}
}

#endif
