//
//  CBToggle.swift
//  NPCombine
//

#if os(iOS)

import Combine
import CoreCombine
import NPKit
import UIKit

public class CBToggle: NPToggle {
	private var subjectSend: ((Bool) -> Void)?
	private var subscription: AnyCancellable?

	public init<S: Subject>(tracking subject: S? = nil) where S.Output == Bool {
		super.init()
		self.addAction(UIAction { [weak self] _ in
			guard let self = self else { return }
			self.subjectSend?(self.isOn)
		}, for: .valueChanged)
		self.track(subject: subject)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func track<S: Subject>(subject: S?) where S.Output == Bool {
		guard let subject = subject else { return self.stopTracking() }
		self.subjectSend = { subject.send($0) }
		self.subscription = subject
			.receive(on: DispatchQueue.mainIfNeeded)
			.sink(receiveCompletion: { [weak self] _ in
				guard let self = self else { return }
				self.stopTracking()
			}, receiveValue: { [weak self] value in
				guard let self = self else { return }
				self.setOn(value, animated: true)
			})
		self.isEnabled = true
	}

	private func stopTracking() {
		self.subscription = nil
		self.isOn = false
		self.isEnabled = false
	}
}

#endif
