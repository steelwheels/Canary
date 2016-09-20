#
#
#

all:
	(cd OSX && make PROJECT_NAME=Canary -f ../Script/install.mk)
	(cd iOS && make PROJECT_NAME=Canary -f ../Script/install.mk)


