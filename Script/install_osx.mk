#
# install.mk
#

PROJECT_NAME=Canary

install: dummy
	xcodebuild install -target $(PROJECT_NAME) \
	  -project $(PROJECT_NAME).xcodeproj \
	  -configuration Release DSTROOT=/ ONLY_ACTIVE_ARCH=NO

dummy:
