//
//  CBButton.swift
//  NPCombine
//

#if os(iOS)

import Combine
import CoreCombine
import Font
import NPKit
import UIKit

public class CBButton: UIButton {
	private var subscription: AnyCancellable?

	public func track<P: Publisher>(publisher: P?) where P.Output == String {
		guard let publisher = publisher else { return self.stopTracking() }
		self.subscription = publisher
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

	public func track<P: Publisher>(localizedPublisher publisher: P?) where P.Output: CustomLocalizedStringConvertible {
		guard let publisher = publisher else { return self.stopTracking() }
		self.subscription = publisher
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

	public static func make() -> UIButton { NPButton.make() }
}

#endif
