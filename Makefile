
setup:
	xcodegen
	pod install

# Reset the project for a clean build
reset:
	rm -rf *.xcodeproj
	rm -rf *.xcworkspace
	rm -rf Pods/
	rm Podfile.lock


test:
	rm -rf TestResults
	xcodebuild test -workspace RxComposableArchitectureDemo.xcworkspace -scheme RxComposableArchitectureDemo -destination 'platform=iOS Simulator,name=iPhone 7,OS=12.0' -resultBundlePath TestResults

report:
	xchtmlreport -r TestResults

