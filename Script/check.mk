#
# unittest.mk
#

SRCROOT		?= ..

PRODUCT		= Canary

top_dir     	= $(SRCROOT)
unit_test	= $(BUILD_DIR)/$(CONFIGURATION)/UnitTest
test_dir	= $(top_dir)/../UnitTest
test_log	= $(BUILD_DIR)/$(CONFIGURATION)/UnitTest.log

unit_test: dummy
	test -f $(unit_test)
	(cd $(test_dir) ; $(unit_test) 2>&1 > $(test_log))
	diff $(test_log) $(test_dir)/UnitTest.log.OK

clean:
	rm -f $(BUILD_DIR)/$(CONFIGURATION)/UnitTest.log

dummy:

