#
#
#

MODULE_NAME	= Canary

PROJECT_DIR	= ../OSX
DOCUMENT_DIR	= ../Document/html
README_FILE	= ../README.md

all: dummy
	(cd $(PROJECT_DIR) ; \
	 jazzy -o $(DOCUMENT_DIR) \
	   --author "Steel Wheels Project" \
	   --author_url "https://sites.google.com/site/steelwheelsproject/" \
	   --readme $(README_FILE) \
	   --module $(MODULE_NAME) \
	   --github_url https://github.com/steelwheels/Canary.git \
	)

dummy:

