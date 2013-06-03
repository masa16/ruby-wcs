require "mkmf"

# configure options:
#  --with-wcs-dir=path
#  --with-wcs-include=path
#  --with-wcs-lib=path

dir_config("wcs")
exit unless have_header("wcs/wcs.h")
exit unless have_library("wcs","wcscon")
$objs = ["wcs_wrap.o"]
create_makefile("wcs")
