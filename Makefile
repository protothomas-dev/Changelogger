.PHONY: release install

release: 
	swift build --configuration release

install: 
	swift build --configuration release
	cp -f .build/release/Changelogger /usr/local/bin/changelogger