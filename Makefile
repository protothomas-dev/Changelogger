.PHONY: release install

release: 
	swift build --configuration release
	(cd .build/release/; zip -yr - "Changelogger") > "./changelogger.zip"

install: 
	swift build --configuration release
	cp -f .build/release/Changelogger /usr/local/bin/changelogger