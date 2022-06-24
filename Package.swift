// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "NPCombine",
	platforms: [
		.iOS("14.0"),
		.macOS("12.0"),
	],
	products: [
		.library(
			name: "NPCombine",
			targets: ["NPCombine"]),
	],
	dependencies: [
		.package(url: "https://github.com/NoPassword-Swift/ConstraintKit.git", "0.0.1"..<"0.1.0"),
		.package(url: "https://github.com/NoPassword-Swift/CoreCombine.git", "0.0.1"..<"0.1.0"),
		.package(url: "https://github.com/NoPassword-Swift/NPKit.git", "0.0.1"..<"0.1.0"),
	],
	targets: [
		.target(
			name: "NPCombine",
			dependencies: [
				"ConstraintKit",
				"CoreCombine",
				"NPKit",
			]),
	]
)
