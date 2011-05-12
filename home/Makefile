GOOGLE_SDK_VERSION = 1.5.0

bootstrap:
	wget -c http://googleappengine.googlecode.com/files/google_appengine_$(GOOGLE_SDK_VERSION).zip
	unzip google_appengine_$(GOOGLE_SDK_VERSION).zip
	rm google_appengine_$(GOOGLE_SDK_VERSION).zip

server:
	python google_appengine/dev_appserver.py app/

deploy:
	python google_appengine/appcfg.py update app/