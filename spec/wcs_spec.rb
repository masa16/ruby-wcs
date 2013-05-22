$LOAD_PATH.unshift File.dirname(__FILE__) + '/../ext'
require "wcs"

def float_close(x,y,epsilon=Float::EPSILON)
  if Array===x && Array===y
    if x.size != y.size
      false
    end
    x.size.times.all? do |i|
      float_close(x[i],y[i],epsilon)
    end
  elsif Array===x || Array===y
    false
  elsif Numeric===x && Numeric===y
    if Float===x || Float===y
      (y-x).abs <= (x.abs+y.abs)*epsilon
    else
      x==y
    end
  else
    x==y
  end
end

RSpec::Matchers.define :be_close_to do |y|
  match do |x|
    float_close(x,y,1e-14)
  end
end



describe "Wcs::WorldCoor" do

  cra     = 0       # Center right ascension in degrees
  cdec    = 0       # Center declination in degrees
  specpix = 1      # Number of arcseconds per pixel
  xrpix   = 1       # Reference pixel X coordinate
  yrpix   = 1       # Reference pixel X coordinate
  nxpix   = 100     # Number of pixels along x-axis
  nypix   = 100     # Number of pixels along y-axis
  rotate  = 0       # Rotation angle (clockwise positive) in degrees
  equinox = 2000    # Equinox of coordinates, 1950 and 2000 supported
  epoch   = 2000
  proj    = "TAN"   # Projection

  describe Wcs::WorldCoor.new(cra,cdec,specpix,xrpix,yrpix,nxpix,nypix,rotate,equinox,epoch,proj) do
    its(:class){should == Wcs::WorldCoor}
  end

  naxis1  = 100  # /* Number of pixels along x-axis */
  naxis2  = 100  # /* Number of pixels along y-axis */
  ctype1  = "RA--TAN" #  /* FITS WCS projection for axis 1 */
  ctype2  = "DEC-TAN" #  /* FITS WCS projection for axis 2 */
  crpix1  = 0    # /* Reference pixel coordinates */
  crpix2  = 0    # /* Reference pixel coordinates */
  crval1  = 0    # /* Coordinate at reference pixel in degrees */
  crval2  = 0    # /* Coordinate at reference pixel in degrees */
  cd      = nil  # /* Rotation matrix, used if not NULL */
  cdelt1  = 0.1  # /* scale in degrees/pixel, if cd is NULL */
  cdelt2  = 0.1  # /* scale in degrees/pixel, if cd is NULL */
  crota   = 0    # /* Rotation angle in degrees, if cd is NULL */
  equinox = 2000 # /* Equinox of coordinates, 1950 and 2000 supported */
  epoch   = 2000 # /* Epoch of coordinates, for FK4/FK5 conversion */

  describe Wcs::WorldCoor.new(naxis1, naxis2, ctype1, ctype2,
                              crpix1, crpix2, crval1, crval2,
                              cd, cdelt1, cdelt2, crota, equinox, epoch) do
    its(:class){should == Wcs::WorldCoor}
  end

  hstr="
SIMPLE  = T
BITPIX  = -64
NAXIS   = 2
NAXIS1  = 10000
NAXIS2  = 10000
CTYPE1  = 'RA---TAN'
CTYPE2  = 'DEC--TAN'
EQUINOX = 2000
CRVAL1  =   10.685497001
CRVAL2  =   41.270525148
CDELT1  =   -0.000277780
CDELT2  =    0.000277780
CRPIX1  =      5000.0000
CRPIX2  =      5000.0000
CROTA2  =    0.0
END
"
  hstr = hstr.split(/\n/).map{|x| x+" "*(80-x.size)}.join("")

  describe Wcs::WorldCoor.new(hstr) do
    its(:class){should == Wcs::WorldCoor}
  end
end


describe "Wcs::WorldCoor" do

  before{
    naxis1  = 100  # /* Number of pixels along x-axis */
    naxis2  = 100  # /* Number of pixels along y-axis */
    ctype1  = "RA--TAN" #  /* FITS WCS projection for axis 1 */
    ctype2  = "DEC-TAN" #  /* FITS WCS projection for axis 2 */
    crpix1  = 0    # /* Reference pixel coordinates */
    crpix2  = 0    # /* Reference pixel coordinates */
    crval1  = 0    # /* Coordinate at reference pixel in degrees */
    crval2  = 0    # /* Coordinate at reference pixel in degrees */
    cd      = nil  # /* Rotation matrix, used if not NULL */
    cdelt1  = 0.1  # /* scale in degrees/pixel, if cd is NULL */
    cdelt2  = 0.1  # /* scale in degrees/pixel, if cd is NULL */
    crota   = 0    # /* Rotation angle in degrees, if cd is NULL */
    equinox = 2000 # /* Equinox of coordinates, 1950 and 2000 supported */
    epoch   = 2000 # /* Epoch of coordinates, for FK4/FK5 conversion */

    @wcs = Wcs::WorldCoor.new(naxis1, naxis2, ctype1, ctype2,
                              crpix1, crpix2, crval1, crval2,
                              cd, cdelt1, cdelt2, crota, equinox, epoch)
  }

  it {@wcs.class.should == Wcs::WorldCoor}
  it {@wcs.wcs2pix(0.5,0.5).should be_close_to [5.000126927791313, 5.000317324553201, 0]}
  it {@wcs.pix2wcs(50,50).should be_close_to [4.987365288755012, 4.968577292595944]}

  # Set projection type from header CTYPEs
  #
  # @param [String] ctype1  FITS WCS projection for axis 1
  # @param [String] ctype2  FITS WCS projection for axis 2
  ctype1='TAN'
  ctype2='TAN'
  it {@wcs.wcstype(ctype1,ctype2).should == 0}

  # @return [Bool] Returns 1 if wcs structure set, else 0
  it {@wcs.iswcs.should == true}

  # @return [Bool] Returns 0 if wcs structure set, else 1
  it {@wcs.nowcs.should == false}

  # Convert pixel coordinates to World Coordinate string
  #
  # @param [Float] xpix  Image horizontal coordinate in pixels
  # @param [Float] ypix  Image vertical coordinate in pixels
  # @return [String]  World coordinate string
  xpix = 10
  ypix = 10
  it {@wcs.pix2wcst(xpix,ypix).should == "00:03:59.976 +00:59:59.09 FK5"}

  # Convert pixel coordinates to World Coordinates
  #
  # @param [Float] xpix  Image horizontal coordinate in pixels
  # @param [Float] ypix  Image vertical coordinate in pixels
  # @return [[xpos,ypos]] RA and Dec in degrees
  it {@wcs.pix2wcs(xpix,ypix).should == [0.9998984794143875, 0.9997462518566833]}

  # Convert World Coordinates to pixel coordinates
  #
  # @param [Float] xpos  Longitude/Right Ascension in degrees
  # @param [Float] ypos  Latitude/Declination in degrees
  # @param [String] coorsys  Coordinate system (FK4, FK5, B1950, J2000, GALACTIC, ECLIPTIC)
  # @return [[xpix,ypix,offscl]]
  #  * xpix:   Image horizontal coordinate in pixels
  #  * ypix:   Image vertical coordinate in pixels
  #  * offscl:  0 if within bounds, else off scale
  xpos = 1.0
  ypos = 1.0
  coorsys = 'J2000'
  it {@wcs.wcsc2pix(xpos,ypos,coorsys).should be_close_to [10.001015515136944, 10.002538950267457, 0]}

  # Convert World Coordinates to pixel coordinates
  #
  # @param [Float] xpos  Longitude/Right Ascension in degrees
  # @param [Float] ypos  Latitude/Declination in degrees
  # @return [[xpix,ypix,offscl]]
  #  * xpix:   Image horizontal coordinate in pixels
  #  * ypix:   Image vertical coordinate in pixels
  #  * offscl:  0 if within bounds, else off scale
  it {@wcs.wcs2pix(xpos,ypos).should be_close_to [10.001015515136944, 10.002538950267457, 0]}

  # Change center of WCS
  #
  # @param [Float] cra  New center right ascension in degrees
  # @param [Float] cdec  New center declination in degrees
  # @param [String] coorsys  FK4 or FK5 coordinates (1950 or 2000)
  cra = 1.0
  cdec = 1.0
  coorsys = 'FK5'
  it {@wcs.wcsshift(cra,cdec,coorsys).should == nil}

  # Return RA and Dec of image center, size in degrees
  #
  # @return [[ra,dec,width,height]]
  #  * ra:  Right ascension of image center (deg) (returned)
  #  * dec:  Declination of image center (deg) (returned)
  #  * width:  Width in degrees (returned)
  #  * height:  Height in degrees (returned)
  it {@wcs.wcsfull.should ==  [5.036983632308005, 5.017631465225092, 9.861328265404987, 9.861328461681406]}

  # Print the image center and size in WCS units
  it {@wcs.wcscent.should == nil}

  # Return image center and size in RA and Dec
  #
  # @return [[cra,cdec,ora,odec]]
  #  * cra:   Right ascension of image center (deg) (returned)
  #  * cdec:  Declination of image center (deg) (returned)
  #  * dra:   Half-width in right ascension (deg) (returned)
  #  * ddec:  Half-width in declination (deg) (returned)
  it {@wcs.wcssize.should == [5.036983632308005, 5.017631465225092, 4.949631960155275, 4.930664230840703]}

  # Return min and max RA and Dec of image in degrees
  #
  # @return [[ra1,ra2,dec1,dec1]]
  #  * ra1:   Min. right ascension of image (deg) (returned)
  #  * ra2:   Max. right ascension of image (deg) (returned)
  #  * dec1:  Min. declination of image (deg) (returned)
  #  * dec2:  Max. declination of image (deg) (returned)
  it {@wcs.wcsrange.should == [0.09999989846104272, 9.900277248989845, 0.09851075234944665, 9.900262468395615]}

  # Set scaling and rotation from CD matrix
  #
  # @param [Array] cd  CD matrix, (2x2 array) ignored if NULL
  cd = [1,0,0,1]
  it {@wcs.wcscdset(cd).should == nil}

  # set scaling, rotation from CDELTi, CROTA2
  #
  # @param [Float] cdelt1  degrees/pixel in first axis (or both axes)
  # @param [Float] cdelt2  degrees/pixel in second axis if nonzero
  # @param [Float] crota  Rotation counterclockwise in degrees
  cdelt1 = 0.001
  cdelt2 = 0.001
  crota = 0
  it {@wcs.wcsdeltset(cdelt1,cdelt2,crota).should == nil}

  # set scaling, rotation from CDELTs and PC matrix
  #
  # @param [Float] cdelt1  degrees/pixel in first axis (or both axes)
  # @param [Float] cdelt2  degrees/pixel in second axis if nonzero
  # @param [Array] pc  Rotation matrix, ignored if NULL
  pc = nil
  it {@wcs.wcspcset(cdelt1,cdelt2,pc).should == nil}

  # @return [String] name of image coordinate system
  it {@wcs.getradecsys.should == 'FK5'}

  # Set output coordinate system for pix2wcs
  #
  # @param [String] coorsys  Coordinate system (B1950, J2000, etc)
  coorsys = 'J2000'
  it {@wcs.wcsoutinit(coorsys).should == nil}

  # @return [String] Return current output coordinate system
  it {@wcs.getwcsout.should == 'FK5'}

  # Set input coordinate system for wcs2pix
  #
  # @param [String] coorsys  Coordinate system (B1950, J2000, etc)
  it {@wcs.wcsininit(coorsys).should == nil}

  # @return [String] Return current input coordinate system
  it {@wcs.getwcsin.should == 'FK5'}

  # Set WCS coordinate output format
  #
  # @param [Integer] degout  1= degrees, 0= hh:mm:ss dd:mm:ss
  degout = 1
  it {@wcs.setwcsdeg(degout).should == 0}

  # Set or get number of output decimal places
  #
  # @param [Integer] ndec  Number of decimal places in output string. if < 0, return current ndec unchanged
  ndec = 2
  it {@wcs.wcsndec(ndec).should == 2}

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
  #it {@wcs.wcsreset(crpix1,crpix2,crval1,crval2,cdelt1,cdelt2,crota,cd).should == nil}

  # Change equinox of reference pixel coordinates in WCS
  #
  # @param [Float] equinox  Desired equinox as fractional year
  equinox = 2000
  it {@wcs.wcseqset(equinox).should == nil}

  # Set pix2wcst() mode for LINEAR coordinates
  #
  # @param [Integer] mode  0: x y linear, 1: x units x units, 2: x y linear units
  mode = 0
  it {@wcs.setwcslin(mode).should == nil}

  # Return coordinate in third dimension
  #
  # @return [Integer]
  it {@wcs.wcszout.should == 0}
end


describe "Wcs" do
  alpha = 0
  delta = 0
  describe Wcs.wcscon(Wcs::J2000,Wcs::GALACTIC,0,0,alpha,delta,2000) do
    it{should be_close_to [96.33726964987589, -60.188551749437046]}
  end


  # Compute angular distance between 2 sky positions
  #
  # @param [Float] ra1  First longitude/right ascension in degrees
  # @param [Float] dec1  First latitude/declination in degrees
  # @param [Float] ra2  Second longitude/right ascension in degrees
  # @param [Float] dec2  Second latitude/declination in degrees
  # @return [Float]
  ra1 = 0
  dec1 = 0
  ra2 = 1
  dec2 = 1
  describe Wcs.wcsdist(ra1,dec1,ra2,dec2) do
    it{should be_close_to 1.414177660951948}
  end

  # Compute angular distance between 2 sky positions
  #
  # @param [Float] ra1  First longitude/right ascension in degrees
  # @param [Float] dec1  First latitude/declination in degrees
  # @param [Float] ra2  Second longitude/right ascension in degrees
  # @param [Float] dec2  Second latitude/declination in degrees
  # @return [Float]
  describe Wcs.wcsdiff(ra1,dec1,ra2,dec2) do
    it{should be_close_to 1.4142404881141812}
  end

  # Set WCS error message for later printing
  #
  # @param [String] errmsg  Error mesage < 80 char
  # @return [String]
  errmsg = "test message"
  describe Wcs.setwcserr(errmsg) do
    it{should == ""}
  end

  # Print WCS error message to stderr
  describe Wcs.wcserr do
    it{should == ""}
  end

  # Set flag to use AIPS WCS instead of WCSLIB
  #
  # @param [Integer] oldwcs  1 for AIPS WCS subroutines, else WCSLIB
  # @return [String]
  oldwcs = 0
  describe Wcs.setdefwcs(oldwcs) do
    it{should ==""}
  end

  # Return flag for AIPS WCS set by setdefwcs
  # @return [Integer]
  describe Wcs.getdefwcs do
    it{should == 0}
  end

  # Set third dimension for cube projections
  #
  # @param [Integer] izpix  Set coordinate in third dimension (face)
  # @return [Integer]
  izpix = 4
  describe Wcs.wcszin(izpix) do
    it{should == 4}
  end

  # Set filename for WCS error message
  #
  # @param [String] filename  FITS or IRAF file name
  # @return [String]
  filename = 'test.dat'
  describe Wcs.setwcsfile(filename) do
    it{should == ''}
  end


  # Save output coordinate system
  #
  # @param [String] wcscoor  coordinate system (J2000, B1950, galactic)
  # @return [String]
  wcscoor = 'J2000'
  describe Wcs.savewcscoor(wcscoor) do
    it{should == ''}
  end

  # Return output coordinate system
  # @return [String]
  describe Wcs.getwcscoor do
    it{should == 'J2000'}
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
  sys1 = Wcs::J2000
  sys2 = Wcs::GALACTIC
  eq1 = 0
  eq2 = 0
  ep1 = 2000
  ep2 = 2000
  dtheta = 0
  dphi = 0
  ptheta = 0
  pphi = 0
  px = 0
  rv = 0
  describe Wcs.wcsconv(sys1,sys2,eq1,eq2,ep1,ep2,dtheta,dphi,ptheta,pphi,px,rv) do
    it{should be_close_to [96.33726964987589, -60.188551749437046, 0.0, 0.0, 0.0, 0.0]}
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
  sys1 = Wcs::J2000
  sys2 = Wcs::GALACTIC
  eq1 = 0
  eq2 = 0
  ep1 = 0
  ep2 = 0
  dtheta = 0
  dphi = 0
  ptheta = 0
  pphi = 0
  describe Wcs.wcsconp(sys1,sys2,eq1,eq2,ep1,ep2,dtheta,dphi,ptheta,pphi) do
    it{should be_close_to [96.33726964987589, -60.188551749437046, 0.0, 0.0]}
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
  sys1 = Wcs::J2000
  sys2 = Wcs::GALACTIC
  eq1 = 0
  eq2 = 0
  dtheta = 0
  dphi = 0
  epoch = 2000
  describe Wcs.wcscon(sys1,sys2,eq1,eq2,dtheta,dphi,epoch) do
    it{should be_close_to [96.33726964987589, -60.188551749437046]}
  end

  # Convert B1950(FK4) to J2000(FK5) coordinates
  #
  # @param [Float] ra  Right ascension in degrees (B1950 in, J2000 out)
  # @param [Float] dec  Declination in degrees (B1950 in, J2000 out)
  # @param [Float] epoch  Besselian epoch in years
  # @return [[ra,dec]]
  ra = 0
  dec = 0
  epoch = 2000
  describe Wcs.fk425e(ra,dec,epoch) do
    it{should be_close_to [0.6407243227035837, 0.2783490290365543]}
  end

  # Convert J2000(FK5) to B1950(FK4) coordinates
  #
  # @param [Float] ra  Right ascension in degrees (J2000 in, B1950 out)
  # @param [Float] dec  Declination in degrees (J2000 in, B1950 out)
  # @param [Float] epoch  Besselian epoch in years
  # @return [[ra,dec]]
  ra = 0
  dec = 0
  epoch = 2000
  describe Wcs.fk524e(ra,dec,epoch) do
    it{should be_close_to [359.3592746342251, -0.27834947215423617]}
  end

  # Return code for coordinate system in string
  #
  # @param [String] coorsys  Coordinate system (B1950, J2000, etc)
  # @return [Integer]
  coorsys = 'J2000'
  describe Wcs.wcscsys(coorsys) do
    it{should == 1}
  end

  # Set equinox from string
  #
  # @param [String] wcstring_in  Coordinate system (B1950, J2000, etc)
  # @return [Float] return 0.0 if not obvious
  wcstring_in = 'J2000'
  describe Wcs.wcsceq(wcstring_in) do
    it{should == 2000}
  end

  # Set coordinate system type string from system and equinox
  #
  # @param [Integer] syswcs  Coordinate system code
  # @param [Float] equinox  Equinox of coordinate system
  # @param [Float] epoch  Epoch of coordinate system
  # @return [String]  Coordinate system string (returned)
  syswcs = Wcs::J2000
  equinox = 2000
  epoch = 2000
  describe Wcs.wcscstr(syswcs,equinox,epoch) do
    it{should == "J2000"}
  end

  # Convert RA and Dec in degrees and distance to vector
  #
  # @param [Float] ra  Right ascension in degrees
  # @param [Float] dec  Declination in degrees
  # @param [Float] r  Distance to object in same units as pos
  # @return [[x,y,z]] x,y,z geocentric equatorial position of object
  ra = 0
  dec = 0
  r = 1
  describe Wcs.d2v3(ra,dec,r) do
    it{should be_close_to [1,0,0]}
  end

  # Convert RA and Dec in radians and distance to vector
  #
  # @param [Float] ra  Right ascension in radians
  # @param [Float] dec  Declination in radians
  # @param [Float] r  Distance to object in same units as pos
  # @return [[x,y,z]] x,y,z geocentric equatorial position of object
  describe Wcs.s2v3(ra,dec,r) do
    it{should be_close_to [1,0,0]}
  end

  # Convert vector to RA and Dec in degrees and distance
  #
  # @param [Array] pos  x,y,z geocentric equatorial position of object
  # @return [[ra,dec,r]]
  #   * ra:  Right ascension in degrees (returned)
  #   * dec: Declination in degrees (returned)
  #   * r:   Distance to object in same units as pos (returned)
  pos = [1.0,1.0,1.0]
  describe Wcs.v2d3(pos) do
    it{should be_close_to [45.0, 35.264389682754654, 1.7320508075688772]}
  end

  # Convert vector to RA and Dec in radians and distance
  #
  # @param [Array] pos  x,y,z geocentric equatorial position of object
  # @return [[ra,dec,r]]
  #  * ra:  Right ascension in radians (returned)
  #  * dec: Declination in radians (returned)
  #  * r:   Distance to object in same units as pos (returned)
  describe Wcs.v2s3(pos) do
    it{should be_close_to [0.7853981633974483, 0.6154797086703873, 1.7320508075688772]}
  end

end
