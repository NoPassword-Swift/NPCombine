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

	public init(tracking subject: CBSubject<Bool>? = nil) {
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

	public func track(subject: CBSubject<Bool>?) {
		if let subject = subject {
			self.subjectSend = { subject.send($0) }
			self.subscription = subject
				.receive(on: DispatchQueue.mainIfNeeded)
				.sink { [weak self] value in
					guard let self = self else { return }
					self.setOn(value, animated: true)
				}
			self.isOn = subject.value
			self.isEnabled = true
		} else {
			self.subscription = nil
			self.isOn = false
			self.isEnabled = false
		}
	}
}

#endif
