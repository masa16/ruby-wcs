require "mkmf"

# configure options:
#  --with-metis-dir=path
#  --with-metis-include=path
#  --with-metis-lib=path

dir_config("wcs")
exit unless have_header("wcs/wcs.h")
exit unless have_library("wcs")
$objs = ["wcs_wrap.o"]
create_makefile("wcs")
