# Ruby/WCS

Ruby wrapper of [WCSTools](http://tdc-www.harvard.edu/wcstools/) using SWIG.
Provides calculation and conversion of sky positions in astronomical coordinates.

This is **NOT** [WCSLIB](http://www.atnf.csiro.au/people/mcalabre/WCS/wcslib/) wrapper.

* [GitHub](https://github.com/masa16/ruby-wcs)
* [RubyGems](https://rubygems.org/gems/wcs)
* [Class Documentation](http://rubydoc.info/gems/wcs/frames/)

## Installation

 1. Install WCSTools library. For RedHat Linux:

        $ yum install wcstools-devel

    Or download source code and install.

 2. Install Ruby/WCS. Install from RubyGems as:

        $ gem install wcs

    Or install from source code:

        $ ruby setup.rb

    If WCSTools is installed at non-default directoriy:

        $ ruby setup.rb all -- --with-wcs-dir=/usr/local/wcstools

        $ gem install wcs -- --with-wcs-include=/usr/local/include \
          --with-wcs-lib=/usr/local/lib

    Or add this line to your application's Gemfile:

        gem 'wcs'

    And then execute:

        $ bundle


## Usage

    require 'wcs'

    ra = 0
    dec = 0
    l,b = Wcs.wcscon(Wcs::J2000,Wcs::GALACTIC,0,0,ra,dec,2000)
    #=> [96.33726964987589, -60.188551749437046]

    naxis1  = 100       # Number of pixels along x-axis
    naxis2  = 100       # Number of pixels along y-axis
    ctype1  = "RA--TAN" # FITS WCS projection for axis 1
    ctype2  = "DEC-TAN" # FITS WCS projection for axis 2
    crpix1  = 0         # Reference pixel coordinates
    crpix2  = 0         # Reference pixel coordinates
    crval1  = 0         # Coordinate at reference pixel in degrees
    crval2  = 0         # Coordinate at reference pixel in degrees
    cd      = nil       # Rotation matrix, used if not NULL
    cdelt1  = 0.1       # scale in degrees/pixel, if cd is NULL
    cdelt2  = 0.1       # scale in degrees/pixel, if cd is NULL
    crota   = 0         # Rotation angle in degrees, if cd is NULL
    equinox = 2000      # Equinox of coordinates, 1950 and 2000 supported
    epoch   = 2000      # Epoch of coordinates, for FK4/FK5 conversion

    wcs = Wcs::WorldCoor.new(naxis1,naxis2,ctype1,ctype2,
      crpix1,crpix2,crval1,crval2,cd,cdelt1,cdelt2,
      crota,equinox,epoch)

    xpix,ypix,offscl = wcs.wcs2pix(0.5,0.5)
    #=> [5.000126927791313, 5.000317324553201, 0]

    xpos,ypos = wcs.pix2wcs(12,34)
    #=> [1.1998245865308625, 3.395274673610471]


## Platforms tested

* ruby 2.0.0p0 (2013-02-24 revision 39474) [x86_64-linux]

## Copying License

This program is free software.
You can distribute/modify this program
under the same terms as LGPL.
See "COPYING" file.
NO WARRANTY.

## Author

Masahiro TANAKA
