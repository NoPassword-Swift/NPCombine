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

	public func track<S: Subject>(subject: S?) where S.Output == String {
		guard let subject = subject else { return self.stopTracking() }
		self.subscription = subject
			.receive(on: DispatchQueue.mainIfNeeded)
			.sink(receiveCompletion: { [weak self] _ in
				guard let self = self else { return }
				self.stopTracking()
			}, receiveValue: { [weak self] value in
				guard let self = self else { return }
				self.setTitle(value, for: .normal)
				self.sizeToFit()
			})
	}

	public func track<S: Subject>(localizedSubject subject: S?) where S.Output: CustomLocalizedStringConvertible {
		guard let subject = subject else { return self.stopTracking() }
		self.subscription = subject
			.receive(on: DispatchQueue.mainIfNeeded)
			.sink(receiveCompletion: { [weak self] _ in
				guard let self = self else { return }
				self.stopTracking()
			}, receiveValue: { [weak self] value in
				guard let self = self else { return }
				self.setTitle(value.localizedDescription, for: .normal)
				self.sizeToFit()
			})
	}

	private func stopTracking() {
		self.subscription = nil
	}
}

#endif
