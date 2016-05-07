#
#
#

SRCDOC_DIR	= ../Document/Canary

all: copy_doc

copy_doc: dummy
	(cd $(SRCDOC_DIR) ; tar cf - *) | tar xfv -

dummy:

