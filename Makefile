.DEFAULT_GOAL := Dwarf\ Fortress.app
url_version := $(shell echo $(version) | sed 's/0.//; s/\./_/g')
temp_dir = $(shell echo $@ | sed 's/.app/.incomplete/')

downloads/df_$(url_version)_osx.tar.bz2:
	cd downloads && wget "http://www.bay12games.com/dwarves/$(@F)"

downloads/df_$(url_version)_osx: downloads/df_$(url_version)_osx.tar.bz2
	cd downloads && tar -xf $(@F).tar.bz2
	mv downloads/df_osx $@

Dwarf\ Fortress\ $(version).app: downloads/df_$(url_version)_osx
	mkdir -p "$(temp_dir)/Contents/Resources"
	sed "s/\$${VERSION}/$(version)/g; s/\$${COPY_YEAR}/`date +'%Y'`/g" Info.plist > "$(temp_dir)/Contents/Info.plist"
	cp dficon.icns "$(temp_dir)/Contents/Resources"
	cp -r "downloads/df_$(url_version)_osx" "$(temp_dir)/Contents/MacOS"
#	cp -r "downloads/*.framework" "`echo $@ | sed 's/.app/.incomplete/'`/Contents/MacOS/libs"
	mv "$(temp_dir)" "$@"

Dwarf\ Fortress.app: Dwarf\ Fortress\ $(version).app
	ln -s "Dwarf Fortress $(version).app" "Dwarf Fortress.app"
