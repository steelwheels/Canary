#
#
#

MODULE_NAME	= Canary

PROJECT_DIR	= ../OSX
DOCUMENT_DIR	= ../../Document
README_FILE	= ../README.md
GITHUB_NAME	= Canary.git

all: dummy
	(cd $(DOCUMENT_DIR) ; rm -r $(MODULE_NAME))
	(cd $(PROJECT_DIR) ; \
	 mkdir -p $(DOCUMENT_DIR)/$(MODULE_NAME) ; \
	 jazzy -o $(DOCUMENT_DIR)/$(MODULE_NAME) \
	   --author "Steel Wheels Project" \
	   --author_url "http://steelwheels.github.io/" \
	   --readme $(README_FILE) \
	   --module $(MODULE_NAME) \
	   --github_url https://github.com/steelwheels/$(GITHUB_NAME) \
	)

dummy:

