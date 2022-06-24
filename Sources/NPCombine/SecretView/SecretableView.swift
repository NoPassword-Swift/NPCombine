//
//  SecretableView.swift
//  NPCombine
//

#if os(iOS)

import Color
import Combine
import ConstraintKit
import CoreCombine
import NPKit
import UIKit

public class SecretableView: NPView {
	private var secretView = UIView()
	public private(set) var view: UIView
	public private(set) var isSecret = false

	private var subscription: AnyCancellable?

	private lazy var secretConstraints: [NSLayoutConstraint] = self.createSecretConstraints()

	public init(view: UIView, enableAPI: CBSubject<Bool>? = nil, breakAPI: CBSubject<Bool>? = nil) {
		self.view = view
		super.init()

		self.addSubview(self.view)
		self.view.fillSuperview().activate()

		self.updateSettings(enableAPI: enableAPI, breakAPI: breakAPI)
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func updateSettings(enableAPI: CBSubject<Bool>? = nil, breakAPI: CBSubject<Bool>? = nil) {
		let enableAPI = enableAPI ?? .init(name: "", true)
		let breakAPI = breakAPI ?? .init(name: "", false)
		self.subscription = enableAPI.combineLatest(breakAPI)
			.receive(on: DispatchQueue.mainIfNeeded)
			.sink { [weak self] (enableAPI: Bool, breakAPI: Bool) in
				guard let self = self else { return }
				let wasSecret = self.isSecret
				if wasSecret {
					self.makeNotSecret()
				}
				self.secretView = Self.CreateSecretView(enableAPI: enableAPI, breakAPI: breakAPI)
				self.secretConstraints = self.createSecretConstraints()
				if wasSecret {
					self.makeSecret()
				}
			}
	}

	public func makeSecret() {
		self.isSecret = true
		self.addSubview(self.secretView)
		self.secretView.addSubview(self.view)
		self.secretConstraints.activate()
	}

	public func makeNotSecret() {
		self.isSecret = false
		self.secretConstraints.deactivate()
		self.addSubview(self.view)
		self.secretView.removeFromSuperview()
	}
}

extension SecretableView {
	private func createSecretConstraints() -> [NSLayoutConstraint] {
		self.view.centerResistingCompression(in: self.secretView, inset: 5)
	}
}

extension SecretableView {
	private static func CreateSecretView(enableAPI: Bool, breakAPI: Bool) -> UIView {
		let view: UIView = {
			if enableAPI {
				return UIView.CreateSecretView(breakAPI: breakAPI) ?? {
					let view = UIView()
					view.layer.cornerRadius = 5
					view.backgroundColor = Color.systemRed.withAlphaComponent(0.33)
					return view
				}()
			} else {
				return UIView()
			}
		}()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
}

#endif
