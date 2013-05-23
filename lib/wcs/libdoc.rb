module Wcs
class WorldCoor

  # set up a WCS structure from arguments
  #
  # @overload initiallize(cra,cdec,secpix,xrpix,yrpix,nxpix,nypix,rotate,equinox,proj)
  #   @param [Float] cra  Center right ascension in degrees
  #   @param [Float] cdec  Center declination in degrees
  #   @param [Float] secpix  Number of arcseconds per pixel
  #   @param [Float] xrpix  Reference pixel X coordinate
  #   @param [Float] yrpix  Reference pixel X coordinate
  #   @param [Integer] nxpix  Number of pixels along x-axis
  #   @param [Integer] nypix  Number of pixels along y-axis
  #   @param [Float] rotate  Rotation angle (clockwise positive) in degrees
  #   @param [Integer] equinox  Equinox of coordinates, 1950 and 2000 supported
  #   @param [Float] epoch  Epoch of coordinates, for FK4/FK5 conversion, no effect if 0
  #   @param [String] proj  Projection
  # @overload initialize(naxis1,naxis2,ctype1,ctype2,crpix1,crpix2,crval1,crval2,cd,cdelt1,cdelt2,crota,equinox,epoch)
  #   @param [Integer] naxis1  Number of pixels along x-axis
  #   @param [Integer] naxis2  Number of pixels along y-axis
  #   @param [String] ctype1  FITS WCS projection for axis 1
  #   @param [String] ctype2  FITS WCS projection for axis 2
  #   @param [Float] crpix1  Reference pixel coordinates
  #   @param [Float] crpix2  Reference pixel coordinates
  #   @param [Float] crval1  Coordinate at reference pixel in degrees
  #   @param [Float] crval2  Coordinate at reference pixel in degrees
  #   @param [Float] cd  Rotation matrix, used if not NULL
  #   @param [Float] cdelt1  scale in degrees/pixel, if cd is NULL
  #   @param [Float] cdelt2  scale in degrees/pixel, if cd is NULL
  #   @param [Float] crota  Rotation angle in degrees, if cd is NULL
  #   @param [Integer] equinox  Equinox of coordinates, 1950 and 2000 supported
  #   @param [Float] epoch  Epoch of coordinates, for FK4/FK5 conversion
  # @overload initialize(hstring,wcsname)
  #   @param [String] hstring  FITS header
  #   @param [String] wcsname  WCS name
  def initialize(*args)
  end

  # Set projection type from header CTYPEs
  #
  # @param [String] ctype1  FITS WCS projection for axis 1
  # @param [String] ctype2  FITS WCS projection for axis 2
  # @return [Integer]
  def wcstype(ctype1,ctype2)
    # This function is defined in C
  end

  # @return [Boolean] Returns 1 if wcs structure set, else 0
  def iswcs
  end

  # @return [Boolean] Returns 0 if wcs structure set, else 1
  def nowcs
  end

  # Convert pixel coordinates to World Coordinate string
  #
  # @param [Float] xpix  Image horizontal coordinate in pixels
  # @param [Float] ypix  Image vertical coordinate in pixels
  # @return [String]  World coordinate string
  def pix2wcst(xpix,ypix)
    # This function is defined in C
  end

  # Convert pixel coordinates to World Coordinates
  #
  # @param [Float] xpix  Image horizontal coordinate in pixels
  # @param [Float] ypix  Image vertical coordinate in pixels
  # @return [[xpos,ypos]] RA and Dec in degrees
  def pix2wcs(xpix,ypix)
    # This function is defined in C
  end

  # Convert World Coordinates to pixel coordinates
  #
  # @param [Float] xpos  Longitude/Right Ascension in degrees
  # @param [Float] ypos  Latitude/Declination in degrees
  # @param [String] coorsys  Coordinate system (FK4, FK5, B1950, J2000, GALACTIC, ECLIPTIC)
  # @return [[xpix,ypix,offscl]]
  #  * xpix:   Image horizontal coordinate in pixels
  #  * ypix:   Image vertical coordinate in pixels
  #  * offscl:  0 if within bounds, else off scale
  def wcsc2pix(xpos,ypos,coorsys)
  end

  # Convert World Coordinates to pixel coordinates
  #
  # @param [Float] xpos  Longitude/Right Ascension in degrees
  # @param [Float] ypos  Latitude/Declination in degrees
  # @return [[xpix,ypix,offscl]]
  #  * xpix:   Image horizontal coordinate in pixels
  #  * ypix:   Image vertical coordinate in pixels
  #  * offscl:  0 if within bounds, else off scale
  def wcs2pix(xpos,ypos)
  end

  # Change center of WCS
  #
  # @param [Float] cra  New center right ascension in degrees
  # @param [Float] cdec  New center declination in degrees
  # @param [String] coorsys  FK4 or FK5 coordinates (1950 or 2000)
  # @return [nil]
  def wcsshift(cra,cdec,coorsys)
    # This function is defined in C
  end

  # Return RA and Dec of image center, size in degrees
  #
  # @return [[ra,dec,width,height]]
  #  * ra:  Right ascension of image center (deg)
  #  * dec:  Declination of image center (deg)
  #  * width:  Width in degrees
  #  * height:  Height in degrees
  def wcsfull
    # This function is defined in C
  end

  # Print the image center and size in WCS units
  # @return [nil]
  def wcscent
  end

  # Return image center and size in RA and Dec
  #
  # @return [[cra,cdec,ora,odec]]
  #  * cra:   Right ascension of image center (deg)
  #  * cdec:  Declination of image center (deg)
  #  * dra:   Half-width in right ascension (deg)
  #  * ddec:  Half-width in declination (deg)
  def wcssize
    # This function is defined in C
  end

  # Return min and max RA and Dec of image in degrees
  #
  # @return [[ra1,ra2,dec1,dec1]]
  #  * ra1:   Min. right ascension of image (deg)
  #  * ra2:   Max. right ascension of image (deg)
  #  * dec1:  Min. declination of image (deg)
  #  * dec2:  Max. declination of image (deg)
  def wcsrange
    # This function is defined in C
  end

  # Set scaling and rotation from CD matrix
  #
  # @param [Array] cd  CD matrix, (2x2 array) ignored if NULL
  # @return [nil]
  def wcscdset(cd)
    # This function is defined in C
  end

  # set scaling, rotation from CDELTi, CROTA2
  #
  # @param [Float] cdelt1  degrees/pixel in first axis (or both axes)
  # @param [Float] cdelt2  degrees/pixel in second axis if nonzero
  # @param [Float] crota  Rotation counterclockwise in degrees
  # @return [nil]
  def wcsdeltset(cdelt1,cdelt2,crota)
    # This function is defined in C
  end

  # set scaling, rotation from CDELTs and PC matrix
  #
  # @param [Float] cdelt1  degrees/pixel in first axis (or both axes)
  # @param [Float] cdelt2  degrees/pixel in second axis if nonzero
  # @param [Array] pc  Rotation matrix, ignored if NULL
  def wcspcset(cdelt1,cdelt2,pc)
    # This function is defined in C
  end

  # @return [String] name of image coordinate system
  def getradecsys
  end

  # Set output coordinate system for pix2wcs
  #
  # @param [String] coorsys  Coordinate system (B1950, J2000, etc)
  # @return [nil]
  def wcsoutinit(coorsys)
    # This function is defined in C
  end

  # @return [String] Return current output coordinate system
  def getwcsout
  end

  # Set input coordinate system for wcs2pix
  #
  # @param [String] coorsys  Coordinate system (B1950, J2000, etc)
  # @return [nil]
  def wcsininit(coorsys)
    # This function is defined in C
  end

  # @return [String] Return current input coordinate system
  def getwcsin
  end

  # Set WCS coordinate output format
  #
  # @param [Integer] degout  1= degrees, 0= hh:mm:ss dd:mm:ss
  # @return [Integer]
  def setwcsdeg(degout)
    # This function is defined in C
  end

  # Set or get number of output decimal places
  #
  # @param [Integer] ndec  Number of decimal places in output string. if < 0, return current ndec unchanged
  def wcsndec
  end

  # Change WCS using arguments
  #
  # @param [Float] crpix1  Horizontal reference pixel
  # @param [Float] crpix2  Vertical reference pixel
  # @param [Float] crval1  Reference pixel horizontal coordinate in degrees
  # @param [Float] crval2  Reference pixel vertical coordinate in degrees
  # @param [Float] cdelt1  Horizontal scale in degrees/pixel, ignored if cd is not NULL
  # @param [Float] cdelt2  Vertical scale in degrees/pixel, ignored if cd is not NULL
  # @param [Float] crota  Rotation angle in degrees, ignored if cd is not NULL
  # @param [Array] cd  Rotation matrix, used if not NULL
  # @return [Integer]
  def wcsreset(crpix1,crpix2,crval1,crval2,cdelt1,cdelt2,crota,cd)
    # This function is defined in C
  end

  # Change equinox of reference pixel coordinates in WCS
  #
  # @param [Float] equinox  Desired equinox as fractional year
  # @return [nil]
  def wcseqset(equinox)
    # This function is defined in C
  end

  # Set pix2wcst() mode for LINEAR coordinates
  #
  # @param [Integer] mode  0: x y linear, 1: x units x units, 2: x y linear units
  # @return [Integer]
  def setwcslin(mode)
  end

  # Return coordinate in third dimension
  #
  # @return [Integer]
  def wcszout
    # This function is defined in C
  end

  end # WorldCoor

  module_function

  # Compute angular distance between 2 sky positions
  #
  # @param [Float] ra1  First longitude/right ascension in degrees
  # @param [Float] dec1  First latitude/declination in degrees
  # @param [Float] ra2  Second longitude/right ascension in degrees
  # @param [Float] dec2  Second latitude/declination in degrees
  # @return [Float]
  def wcsdist(ra1,dec1,ra2,dec2)
    # This function is defined in C
  end

  # Compute angular distance between 2 sky positions
  #
  # @param [Float] ra1  First longitude/right ascension in degrees
  # @param [Float] dec1  First latitude/declination in degrees
  # @param [Float] ra2  Second longitude/right ascension in degrees
  # @param [Float] dec2  Second latitude/declination in degrees
  # @return [Float]
  def wcsdiff(ra1,dec1,ra2,dec2)
    # This function is defined in C
  end

  # Set WCS error message for later printing
  #
  # @param [String] errmsg  Error mesage < 80 char
  # @return [nil]
  def setwcserr(errmsg)
    # This function is defined in C
  end

  # Print WCS error message to stderr
  # @return [nil]
  def wcserr
  end

  # Set flag to use AIPS WCS instead of WCSLIB
  #
  # @param [Integer] oldwcs  1 for AIPS WCS subroutines, else WCSLIB
  # @return [nil]
  def setdefwcs(oldwcs)
    # This function is defined in C
  end

  # Return flag for AIPS WCS set by setdefwcs
  # @return [Integer]
  def getdefwcs
  end

  # Set third dimension for cube projections
  #
  # @param [Integer] izpix  Set coordinate in third dimension (face)
  # @return [Integer]
  def wcszin(izpix)
    # This function is defined in C
  end

  # Set filename for WCS error message
  #
  # @param [String] filename  FITS or IRAF file name
  # @return [nil]
  def setwcsfile(filename)
    # This function is defined in C
  end


  # Save output coordinate system
  #
  # @param [String] wcscoor  coordinate system (J2000, B1950, galactic)
  # @return [nil]
  def savewcscoor(wcscoor)
    # This function is defined in C
  end

  # Return output coordinate system
  # @return [String]
  def getwcscoor
  end

  # Convert from coordinate system sys1 to coordinate system sys2, converting
  # proper motions, too, and adding them if an epoch is specified
  #
  # @param [Integer] sys1  Input coordinate system (J2000, B1950, ECLIPTIC, GALACTIC
  # @param [Integer] sys2  Output coordinate system (J2000, B1950, ECLIPTIC, G ALACTIC
  # @param [Float] eq1  Input equinox (default of sys1 if 0.0)
  # @param [Float] eq2  Output equinox (default of sys2 if 0.0)
  # @param [Float] ep1  Input Besselian epoch in years
  # @param [Float] ep2  Output Besselian epoch in years
  # @param [Float] dtheta Longitude or right ascension in degrees in sys1
  # @param [Float] dphi  Latitude or declination in degrees in sys1
  # @param [Float] ptheta Longitude or right ascension proper motion in deg/year in sys1
  # @param [Float] pphi  Latitude or declination proper motion in deg/year
  # @param [Float] px  Parallax in arcseconds
  # @param [Float] rv  Radial velocity in km/sec
  # @return [[dtheta,dphi,ptheta,pphi,px,rv]]
  #  * dtheta: Longitude or right ascension in degrees in sys1
  #  * dphi:  Latitude or declination in degrees in sys1
  #  * ptheta: Longitude or right ascension proper motion in deg/year in sys1
  #  * pphi:  Latitude or declination proper motion in deg/year
  #  * px:  Parallax in arcseconds
  #  * rv:  Radial velocity in km/sec
  def wcsconv(sys1,sys2,eq1,eq2,ep1,ep2,dtheta,dphi,ptheta,pphi,px,rv)
    # This function is defined in C
  end

  # Convert from coordinate system sys1 to coordinate system sys2, converting
  # proper motions, too, and adding them if an epoch is specified
  #
  # @param [Integer] sys1   Input coordinate system (J2000, B1950, ECLIPTIC, GALACTIC
  # @param [Integer] sys2   Output coordinate system (J2000, B1950, ECLIPTIC, GALACTIC
  # @param [Float] eq1    Input equinox (default of sys1 if 0.0)
  # @param [Float] eq2    Output equinox (default of sys2 if 0.0)
  # @param [Float] ep1    Input Besselian epoch in years (for proper motion)
  # @param [Float] ep2    Output Besselian epoch in years (for proper motion)
  # @param [Float] dtheta  Longitude or right ascension in degrees
  # @param [Float] dphi    Latitude or declination in degrees
  # @param [Float] ptheta  Longitude or right ascension proper motion in RA degrees/yea
  # @param [Float] pphi    Latitude or declination proper motion in Dec degrees/year
  # @return [[dtheta,dphi,ptheta,pphi]]
  #  * dtheta:  Longitude or right ascension in degrees
  #  * dphi:    Latitude or declination in degrees
  #  * ptheta:  Longitude or right ascension proper motion in RA degrees/yea
  #  * pphi:    Latitude or declination proper motion in Dec degrees/year
  def wcsconp(sys1,sys2,eq1,eq2,ep1,ep2,dtheta,dphi,ptheta,pphi);
  end

  # Convert between coordinate systems and equinoxes
  #
  # @param [Integer] sys1  Input coordinate system (J2000, B1950, ECLIPTIC, GALACTIC
  # @param [Integer] sys2  Output coordinate system (J2000, B1950, ECLIPTIC, G ALACTIC
  # @param [Float] eq1  Input equinox (default of sys1 if 0.0)
  # @param [Float] eq2  Output equinox (default of sys2 if 0.0)
  # @param [Float] dtheta  Longitude or right ascension in degrees
  # @param [Float] dphi    Latitude or declination in degrees
  # @param [Float] epoch  Besselian epoch in years
  # @return [[dtheta,dphi]]
  #  * dtheta:  Longitude or right ascension in degrees
  #  * dphi:    Latitude or declination in degrees
  def wcscon(sys1,sys2,eq1,eq2,dtheta,dphi,epoch)
    # This function is defined in C
  end

  # Convert B1950(FK4) to J2000(FK5) coordinates
  #
  # @param [Float] ra  Right ascension in degrees (B1950 in, J2000 out)
  # @param [Float] dec  Declination in degrees (B1950 in, J2000 out)
  # @param [Float] epoch  Besselian epoch in years
  # @return [[ra,dec]]
  def fk425e(ra,dec,epoch)
    # This function is defined in C
  end

  # Convert J2000(FK5) to B1950(FK4) coordinates
  #
  # @param [Float] ra  Right ascension in degrees (J2000 in, B1950 out)
  # @param [Float] dec  Declination in degrees (J2000 in, B1950 out)
  # @param [Float] epoch  Besselian epoch in years
  # @return [[ra,dec]]
  def fk524e(ra,dec,epoch)
    # This function is defined in C
  end

  # Return code for coordinate system in string
  #
  # @param [String] coorsys  Coordinate system (B1950, J2000, etc)
  # @return [Integer]
  def wcscsys(coorsys)
    # This function is defined in C
  end

  # Set equinox from string
  #
  # @param [String] wcstring_in  Coordinate system (B1950, J2000, etc)
  # @return [Float] return 0.0 if not obvious
  def wcsceq(wcstring_in)
    # This function is defined in C
  end

  # Set coordinate system type string from system and equinox
  #
  # @param [Integer] syswcs  Coordinate system code
  # @param [Float] equinox  Equinox of coordinate system
  # @param [Float] epoch  Epoch of coordinate system
  # @return [String]  Coordinate system string
  def wcscstr(cstr,syswcs,equinox,epoch)
    # This function is defined in C
  end

  # Convert RA and Dec in degrees and distance to vector
  #
  # @param [Float] ra  Right ascension in degrees
  # @param [Float] dec  Declination in degrees
  # @param [Float] r  Distance to object in same units as pos
  # @return [[x,y,z]] x,y,z geocentric equatorial position of object
  def d2v3(ra,dec,r)
    # This function is defined in C
  end

  # Convert RA and Dec in radians and distance to vector
  #
  # @param [Float] ra  Right ascension in radians
  # @param [Float] dec  Declination in radians
  # @param [Float] r  Distance to object in same units as pos
  # @return [[x,y,z]] x,y,z geocentric equatorial position of object
  def s2v3(ra,dec,r)
    # This function is defined in C
  end

  # Convert vector to RA and Dec in degrees and distance
  #
  # @param [Array] pos  x,y,z geocentric equatorial position of object
  # @return [[ra,dec,r]]
  #   * ra:  Right ascension in degrees
  #   * dec: Declination in degrees
  #   * r:   Distance to object in same units as pos
  def v2d3(pos)
    # This function is defined in C
  end

  # Convert vector to RA and Dec in radians and distance
  #
  # @param [Array] pos  x,y,z geocentric equatorial position of object
  # @return [[ra,dec,r]]
  #  * ra:  Right ascension in radians
  #  * dec: Declination in radians
  #  * r:   Distance to object in same units as pos
  def v2s3(pos)
    # This function is defined in C
  end

end
