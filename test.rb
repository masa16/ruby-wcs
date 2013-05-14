require "wcs"

#  int naxis1,     /* Number of pixels along x-axis */
#  int naxis2,     /* Number of pixels along y-axis */
#  char *ctype1,   /* FITS WCS projection for axis 1 */
#  char *ctype2,   /* FITS WCS projection for axis 2 */
#  double crpix1,  /* Reference pixel coordinates */
#  double crpix2,  /* Reference pixel coordinates */
#  double crval1,  /* Coordinate at reference pixel in degrees */
#  double crval2,  /* Coordinate at reference pixel in degrees */
#  double *cd,     /* Rotation matrix, used if not NULL */
#  double cdelt1,  /* scale in degrees/pixel, if cd is NULL */
#  double cdelt2,  /* scale in degrees/pixel, if cd is NULL */
#  double crota,   /* Rotation angle in degrees, if cd is NULL */
#  int equinox,    /* Equinox of coordinates, 1950 and 2000 supported */
#  double epoch);  /* Epoch of coordinates, for FK4/FK5 conversion */

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

wcs = Wcs::WorldCoor.new(
naxis1, # /* Number of pixels along x-axis */
naxis2, # /* Number of pixels along y-axis */
ctype1, # /* FITS WCS projection for axis 1 */
ctype2, # /* FITS WCS projection for axis 2 */
crpix1, # /* Reference pixel coordinates */
crpix2, # /* Reference pixel coordinates */
crval1, # /* Coordinate at reference pixel in degrees */
crval2, # /* Coordinate at reference pixel in degrees */
cd,     # /* Rotation matrix, used if not NULL */
cdelt1, # /* scale in degrees/pixel, if cd is NULL */
cdelt2, # /* scale in degrees/pixel, if cd is NULL */
crota,  # /* Rotation angle in degrees, if cd is NULL */
equinox,# /* Equinox of coordinates, 1950 and 2000 supported */
epoch)  # /* Epoch of coordinates, for FK4/FK5 conversion */

=begin
    void wcs2pix (	/* Convert World Coordinates to pixel coordinates */
        struct WorldCoor *wcs,  /* World coordinate system structure */
        double xpos,	/* Longitude/Right Ascension in degrees */
        double ypos,	/* Latitude/Declination in degrees */
        double *xpix,	/* Image horizontal coordinate in pixels (returned) */
        double *ypix,	/* Image vertical coordinate in pixels (returned) */
        int *offscl);

    void pix2wcs (	/* Convert pixel coordinates to World Coordinates */
        struct WorldCoor *wcs,  /* World coordinate system structure */
        double xpix,	/* Image horizontal coordinate in pixels */
        double ypix,	/* Image vertical coordinate in pixels */
        double *xpos,	/* Longitude/Right Ascension in degrees (returned) */
        double *ypos);	/* Latitude/Declination in degrees (returned) */
=end

p wcs
p wcs.wcs2pix(0.5,0.5)
p wcs.pix2wcs(50,50)


=begin
    void wcscon(        /* Convert between coordinate systems and equinoxes */
        int sys1,       /* Input coordinate system (J2000, B1950, ECLIPTIC, GALACTIC */
        int sys2,       /* Output coordinate system (J2000, B1950, ECLIPTIC, G ALACTIC */
        double eq1,     /* Input equinox (default of sys1 if 0.0) */
        double eq2,     /* Output equinox (default of sys2 if 0.0) */
        double *dtheta, /* Longitude or right ascension in degrees
                           Input in sys1, returned in sys2 */
        double *dphi,   /* Latitude or declination in degrees
                           Input in sys1, returned in sys2 */
        double epoch);  /* Besselian epoch in years */
=end
alpha = 0
delta = 0
p Wcs.wcscon(Wcs::J2000,Wcs::GALACTIC,0,0,alpha,delta,2000)


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
wcs = Wcs::WorldCoor.new(hstr)
p wcs
p wcs.wcs2pix(0.5,0.5)
p wcs.pix2wcs(50,50)

p wcs.pix2wcst(50,50)
