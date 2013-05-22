%module wcs
%{
#include "wcs/wcs.h"
typedef int BOOLEAN;
%}
%include "typemaps.i"
%include "wcs_h.i"

%typemap(in) double *cd {
    if (NIL_P($input)) {
        $1 = (double *)0;
    } else {
        /* Get the length of the List */
        int size = RARRAY_LEN($input);
        int i;
        /* Get the first element in memory */
        VALUE *ptr = RARRAY_PTR($input);
        $1 = (double *)malloc((size+1)*sizeof(double));
        for (i=0; i < size; i++, ptr++) {
            /* Convert Ruby Object String to char* */
            $1[i] = NUM2DBL(*ptr);
        }
    }
 }
%typemap(freearg) double *cd {
  free($1);
 }

%extend WorldCoor {

  WorldCoor( /* set up a WCS structure from arguments */
        double cra,     /* Center right ascension in degrees */
        double cdec,    /* Center declination in degrees */
        double secpix,  /* Number of arcseconds per pixel */
        double xrpix,   /* Reference pixel X coordinate */
        double yrpix,   /* Reference pixel X coordinate */
        int nxpix,      /* Number of pixels along x-axis */
        int nypix,      /* Number of pixels along y-axis */
        double rotate,  /* Rotation angle (clockwise positive) in degrees */
        int equinox,    /* Equinox of coordinates, 1950 and 2000 supported */
        double epoch,   /* Epoch of coordinates, used for FK4/FK5 conversion
                         * no effect if 0 */
        char *proj)     /* Projection */
  {
    struct WorldCoor *v;
    v = wcsxinit( cra, cdec, secpix, xrpix, yrpix, nxpix, nypix,
                  rotate, equinox, epoch, proj );
    if (v==NULL) {
      rb_raise(rb_eRuntimeError,"fail to initialize WorldCoor");
    };
    return v;
  }

  WorldCoor(
        int naxis1,     /* Number of pixels along x-axis */
        int naxis2,     /* Number of pixels along y-axis */
        char *ctype1,   /* FITS WCS projection for axis 1 */
        char *ctype2,   /* FITS WCS projection for axis 2 */
        double crpix1,  /* Reference pixel coordinates */
        double crpix2,  /* Reference pixel coordinates */
        double crval1,  /* Coordinate at reference pixel in degrees */
        double crval2,  /* Coordinate at reference pixel in degrees */
        double *cd,     /* Rotation matrix, used if not NULL */
        double cdelt1,  /* scale in degrees/pixel, if cd is NULL */
        double cdelt2,  /* scale in degrees/pixel, if cd is NULL */
        double crota,   /* Rotation angle in degrees, if cd is NULL */
        int equinox,    /* Equinox of coordinates, 1950 and 2000 supported */
        double epoch)  /* Epoch of coordinates, for FK4/FK5 conversion */
  {
    struct WorldCoor *v;
    v = wcskinit( naxis1, naxis2, ctype1, ctype2, crpix1, crpix2,
                  crval1, crval2, cd, cdelt1, cdelt2, crota, equinox, epoch );
    if (v==NULL) {
      rb_raise(rb_eRuntimeError,"fail to initialize WorldCoor");
    };
    return v;
  }

  /* WCS data structure initialization subroutines in wcsinit.c */
  WorldCoor( /* set up WCS structure from a FITS image header */
        const char* hstring)
  {
    struct WorldCoor *v;
    v = wcsinit( hstring );
    if (v==NULL) {
      rb_raise(rb_eRuntimeError,"fail to initialize WorldCoor with string");
    };
    return v;
  }

  WorldCoor( /* set up WCS structure from a FITS image header */
        const char* hstring,    /* FITS header */
        const char* wcsname)    /* WCS name */
  {
    struct WorldCoor *v;
    v = wcsinitn( hstring, wcsname );
    if (v==NULL) {
      rb_raise(rb_eRuntimeError,"fail to initialize WorldCoor with string");
    };
    return v;
  }

  ~WorldCoor() {
    wcsfree($self);
  }

    int wcstype(                /* Set projection type from header CTYPEs */
        char *ctype1,           /* FITS WCS projection for axis 1 */
        char *ctype2)           /* FITS WCS projection for axis 2 */
    {
      return wcstype($self, ctype1, ctype2);
    }

    %typemap(out) BOOLEAN {
      if ($1)
        $result = Qtrue;
      else
        $result = Qfalse;
    }

    BOOLEAN iswcs()             /* Returns 1 if wcs structure set, else 0 */
    {
      return iswcs($self);
    }

    BOOLEAN nowcs()             /* Returns 0 if wcs structure set, else 1 */
    {
      return nowcs($self);
    }


    VALUE pix2wcst(     /* Convert pixel coordinates to World Coordinate string */
        double xpix,    /* Image horizontal coordinate in pixels */
        double ypix)    /* Image vertical coordinate in pixels */
        //char *wcstring,       /* World coordinate string (returned) */
        //int lstr)     /* Length of world coordinate string (returned) */
    {
      volatile VALUE str = Qnil;
      char wcstring[51];
      int r;
      wcstring[50] = '\0';
      r = pix2wcst($self, xpix, ypix, wcstring, 50);
      str = rb_str_new2(wcstring);
      if (r==0) {
        rb_raise(rb_eRuntimeError,"fail to convert pixel coordinates to World Coordinate string");
      }
      return str;
    }

    %apply double *OUTPUT {
        double *xpix,   /* Image horizontal coordinate in pixels (returned) */
        double *ypix,   /* Image vertical coordinate in pixels (returned) */
        double *xpos,   /* Longitude/Right Ascension in degrees (returned) */
        double *ypos    /* Latitude/Declination in degrees (returned) */
    }
    %apply int *OUTPUT {
        int    *offscl
    }

    void pix2wcs (      /* Convert pixel coordinates to World Coordinates */
        double xpix,    /* Image horizontal coordinate in pixels */
        double ypix,    /* Image vertical coordinate in pixels */
        double *xpos,   /* Longitude/Right Ascension in degrees (returned) */
        double *ypos)   /* Latitude/Declination in degrees (returned) */
    {
      pix2wcs($self, xpix, ypix, xpos, ypos);
    }

    void wcsc2pix (     /* Convert World Coordinates to pixel coordinates */
        double xpos,    /* Longitude/Right Ascension in degrees */
        double ypos,    /* Latitude/Declination in degrees */
        char *coorsys,  /* Coordinate system (B1950, J2000, etc) */
        double *xpix,   /* Image horizontal coordinate in pixels (returned) */
        double *ypix,   /* Image vertical coordinate in pixels (returned) */
        int *offscl)
    {
      wcsc2pix($self, xpos, ypos, coorsys, xpix, ypix, offscl);
    }

    void wcs2pix (      /* Convert World Coordinates to pixel coordinates */
        double xpos,    /* Longitude/Right Ascension in degrees */
        double ypos,    /* Latitude/Declination in degrees */
        double *xpix,   /* Image horizontal coordinate in pixels (returned) */
        double *ypix,   /* Image vertical coordinate in pixels (returned) */
        int *offscl)
    {
      wcs2pix($self, xpos, ypos, xpix, ypix, offscl);
    }


    void wcsshift(      /* Change center of WCS */
        double cra,     /* New center right ascension in degrees */
        double cdec,    /* New center declination in degrees */
        char *coorsys)  /* FK4 or FK5 coordinates (1950 or 2000) */
    {
      wcsshift($self, cra, cdec, coorsys);
    }

    %apply double *OUTPUT {
        double  *cra,   /* Right ascension of image center (deg) (returned) */
        double  *cdec,  /* Declination of image center (deg) (returned) */
        double  *width, /* Width in degrees (returned) */
        double  *height, /* Height in degrees (returned) */
        double  *dra,   /* Half-width in right ascension (deg) (returned) */
        double  *ddec   /* Half-width in declination (deg) (returned) */
    }

    void wcsfull(       /* Return RA and Dec of image center, size in degrees */
        double  *cra,   /* Right ascension of image center (deg) (returned) */
        double  *cdec,  /* Declination of image center (deg) (returned) */
        double  *width, /* Width in degrees (returned) */
        double  *height) /* Height in degrees (returned) */
    {
      wcsfull($self, cra, cdec, width, height);
    }

    void wcscent()      /* Print the image center and size in WCS units */
    {
       wcscent($self);
    }

    void wcssize(       /* Return image center and size in RA and Dec */
        double *cra,    /* Right ascension of image center (deg) (returned) */
        double *cdec,   /* Declination of image center (deg) (returned) */
        double *dra,    /* Half-width in right ascension (deg) (returned) */
        double *ddec)   /* Half-width in declination (deg) (returned) */
    {
      wcssize($self, cra, cdec, dra, ddec);
    }

    %apply double *OUTPUT {
        double  *ora1,  /* Min. right ascension of image (deg) (returned) */
        double  *ora2,  /* Max. right ascension of image (deg) (returned) */
        double  *odec1, /* Min. declination of image (deg) (returned) */
        double  *odec2  /* Max. declination of image (deg) (returned) */
    }

    void wcsrange(      /* Return min and max RA and Dec of image in degrees */
        double  *ora1,  /* Min. right ascension of image (deg) (returned) */
        double  *ora2,  /* Max. right ascension of image (deg) (returned) */
        double  *odec1, /* Min. declination of image (deg) (returned) */
        double  *odec2) /* Max. declination of image (deg) (returned) */
    {
      wcsrange($self,ora1,ora2,odec1,odec2);
    }

%typemap(in) double *cd {
    if (NIL_P($input)) {
        $1 = (double *)0;
    } else {
        /* Get the length of the List */
        int size = RARRAY_LEN($input);
        int i;
        /* Get the first element in memory */
        VALUE *ptr = RARRAY_PTR($input);
        $1 = (double *)malloc((size+1)*sizeof(double));
        for (i=0; i < size; i++, ptr++) {
            /* Convert Ruby Object String to char* */
            $1[i] = NUM2DBL(*ptr);
        }
    }
 }
%typemap(freearg) double *cd {
  free($1);
 }

    void wcscdset(      /* Set scaling and rotation from CD matrix */
        double *cd)     /* CD matrix, ignored if NULL */
    {
      wcscdset($self,cd);
    }

    void wcsdeltset(    /* set scaling, rotation from CDELTi, CROTA2 */
        double cdelt1,  /* degrees/pixel in first axis (or both axes) */
        double cdelt2,  /* degrees/pixel in second axis if nonzero */
        double crota)   /* Rotation counterclockwise in degrees */
    {
      wcsdeltset($self,cdelt1,cdelt2,crota);
    }

    void wcspcset(      /* set scaling, rotation from CDELTs and PC matrix */
        double cdelt1,  /* degrees/pixel in first axis (or both axes) */
        double cdelt2,  /* degrees/pixel in second axis if nonzero */
        double *pc)     /* Rotation matrix, ignored if NULL */
    {
      wcspcset($self,cdelt1,cdelt2,pc);
    }


    char *getradecsys() /* Return name of image coordinate system */
    {
       return getradecsys($self);
    }

    void wcsoutinit(    /* Set output coordinate system for pix2wcs */
        char *coorsys)  /* Coordinate system (B1950, J2000, etc) */
    {
      wcsoutinit($self,coorsys);
    }

    char *getwcsout()   /* Return current output coordinate system */
    {
      return getwcsout($self);
    }

    void wcsininit(     /* Set input coordinate system for wcs2pix */
        char *coorsys)  /* Coordinate system (B1950, J2000, etc) */
    {
      wcsininit($self,coorsys);
    }

    char *getwcsin()    /* Return current input coordinate system */
    {
      return getwcsin($self);
    }

    int setwcsdeg(      /* Set WCS coordinate output format */
        int degout)     /* 1= degrees, 0= hh:mm:ss dd:mm:ss */
    {
      return setwcsdeg($self,degout);
    }

    int wcsndec(        /* Set or get number of output decimal places */
        int ndec)       /* Number of decimal places in output string
                           if < 0, return current ndec unchanged */
    {
      return wcsndec($self,ndec);
    }

    int wcsreset(       /* Change WCS using arguments */
        double crpix1,  /* Horizontal reference pixel */
        double crpix2,  /* Vertical reference pixel */
        double crval1,  /* Reference pixel horizontal coordinate in degrees */
        double crval2,  /* Reference pixel vertical coordinate in degrees */
        double cdelt1,  /* Horizontal scale in degrees/pixel, ignored if cd is not NULL */
        double cdelt2,  /* Vertical scale in degrees/pixel, ignored if cd is not NULL */
        double crota,   /* Rotation angle in degrees, ignored if cd is not NULL */
        double *cd)     /* Rotation matrix, used if not NULL */
    {
      return wcsreset($self,crpix1,crpix2,crval1,crval2,cdelt1,cdelt2,crota,cd);
    }

    void wcseqset(   /* Change equinox of reference pixel coordinates in WCS */
        double equinox) /* Desired equinox as fractional year */
    {
      wcseqset($self,equinox);
    }

    void setwcslin(     /* Set pix2wcst() mode for LINEAR coordinates */
        int mode)       /* 0: x y linear, 1: x units x units
                           2: x y linear units */
    {
      setwcslin($self,mode);
    }

    int wcszout ()      /* Return coordinate in third dimension */
    {
      return wcszout($self);
    }

 }; // end of WorldCoor


    double wcsdist(     /* Compute angular distance between 2 sky positions */
        double ra1,     /* First longitude/right ascension in degrees */
        double dec1,    /* First latitude/declination in degrees */
        double ra2,     /* Second longitude/right ascension in degrees */
        double dec2)    /* Second latitude/declination in degrees */
    {
      return wcsdist($self, ra1, dec1, ra2, dec2);
    }

    double wcsdiff(     /* Compute angular distance between 2 sky positions */
        double ra1,     /* First longitude/right ascension in degrees */
        double dec1,    /* First latitude/declination in degrees */
        double ra2,     /* Second longitude/right ascension in degrees */
        double dec2)    /* Second latitude/declination in degrees */
    {
      return wcsdiff($self, ra1, dec1, ra2, dec2);
    }

    void setwcserr(     /* Set WCS error message for later printing */
        char *errmsg);  /* Error mesage < 80 char */

    void wcserr(void);  /* Print WCS error message to stderr */

    void setdefwcs(     /* Set flag to use AIPS WCS instead of WCSLIB */
        int oldwcs);    /* 1 for AIPS WCS subroutines, else WCSLIB */

    int getdefwcs(void);        /* Return flag for AIPS WCS set by setdefwcs */

    int wcszin(         /* Set third dimension for cube projections */
        int izpix);     /* Set coordinate in third dimension (face) */

    void setwcsfile(    /* Set filename for WCS error message */
        char *filename); /* FITS or IRAF file name */


//%typemap(in) char **header {
//  int size;
//  char *str;
//  char *buf;
//  size = RSTRING_LEN($input);
//  str = StringValuePtr($input);
//  buf = (char*)malloc(size+1);
//  strncpy(buf, str, size);
//  $1 = &(buf);
//  puts("pass 1");
// }
//
//%typemap(freearg) char **header {
//  free(*$1);
// }
//    int cpwcs (         /* Copy WCS keywords with no suffix to ones with suffix */
//        char **header,  /* Pointer to start of FITS header */
//        char *cwcs);    /* Keyword suffix character for output WCS */

    void savewcscoor(   /* Save output coordinate system */
        char *wcscoor); /* coordinate system (J2000, B1950, galactic) */

    char *getwcscoor(void); /* Return output coordinate system */


    /* Coordinate conversion subroutines in wcscon.c */

%apply double *INOUT {
        double *dtheta, /* Longitude or right ascension in degrees
                           Input in sys1, returned in sys2 */
        double *dphi,   /* Latitude or declination in degrees
                           Input in sys1, returned in sys2 */
        double *ptheta, /* Longitude or right ascension proper motion in deg/year
                           Input in sys1, returned in sys2 */
        double *pphi,   /* Latitude or declination proper motion in deg/year */
        double *px,     /* Parallax in arcseconds */
        double *rv,     /* Radial velocity in km/sec */
        double *io_ra,  /* Right ascension in degrees (B1950 in, J2000 out) */
        double *io_dec  /* Declination in degrees (B1950 in, J2000 out) */
 }

    void wcsconv(       /* Convert between coordinate systems and equinoxes */
        int sys1,       /* Input coordinate system (J2000, B1950, ECLIPTIC, GALACTIC */
        int sys2,       /* Output coordinate system (J2000, B1950, ECLIPTIC, G ALACTIC */
        double eq1,     /* Input equinox (default of sys1 if 0.0) */
        double eq2,     /* Output equinox (default of sys2 if 0.0) */
        double ep1,     /* Input Besselian epoch in years */
        double ep2,     /* Output Besselian epoch in years */
        double *dtheta, /* Longitude or right ascension in degrees
                           Input in sys1, returned in sys2 */
        double *dphi,   /* Latitude or declination in degrees
                           Input in sys1, returned in sys2 */
        double *ptheta, /* Longitude or right ascension proper motion in deg/year
                           Input in sys1, returned in sys2 */
        double *pphi,   /* Latitude or declination proper motion in deg/year */
        double *px,     /* Parallax in arcseconds */
        double *rv);    /* Radial velocity in km/sec */

    void wcsconp(       /* Convert between coordinate systems and equinoxes */
        int sys1,       /* Input coordinate system (J2000, B1950, ECLIPTIC, GALACTIC */
        int sys2,       /* Output coordinate system (J2000, B1950, ECLIPTIC, G ALACTIC */
        double eq1,     /* Input equinox (default of sys1 if 0.0) */
        double eq2,     /* Output equinox (default of sys2 if 0.0) */
        double ep1,     /* Input Besselian epoch in years */
        double ep2,     /* Output Besselian epoch in years */
        double *dtheta, /* Longitude or right ascension in degrees
                           Input in sys1, returned in sys2 */
        double *dphi,   /* Latitude or declination in degrees
                           Input in sys1, returned in sys2 */
        double *ptheta, /* Longitude or right ascension proper motion in degrees/year
                           Input in sys1, returned in sys2 */
        double *pphi);  /* Latitude or declination proper motion in degrees/year
                           Input in sys1, returned in sys2 */

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

    void fk425e (       /* Convert B1950(FK4) to J2000(FK5) coordinates */
        double *io_ra,  /* Right ascension in degrees (B1950 in, J2000 out) */
        double *io_dec, /* Declination in degrees (B1950 in, J2000 out) */
        double epoch);  /* Besselian epoch in years */

    void fk524e (       /* Convert J2000(FK5) to B1950(FK4) coordinates */
        double *io_ra,  /* Right ascension in degrees (J2000 in, B1950 out) */
        double *io_dec, /* Declination in degrees (J2000 in, B1950 out) */
        double epoch);  /* Besselian epoch in years */

    int wcscsys(        /* Return code for coordinate system in string */
        char *coorsys);  /* Coordinate system (B1950, J2000, etc) */

    double wcsceq (     /* Set equinox from string (return 0.0 if not obvious) */
        char *wcstring_in);  /* Coordinate system (B1950, J2000, etc) */


%apply char *OUTPUT {
  char   *cstr
 }
%typemap(in,numinputs=0) char *cstr {
  $1 = malloc(64);
 }
%typemap(argout) char *cstr {
  $result = rb_str_new2($1);
 }
%typemap(freearg) char *cstr {
  free($1);
 }

    void wcscstr (      /* Set coordinate system type string from system and equinox */
        char   *cstr,   /* Coordinate system string (returned) */
        int    syswcs,  /* Coordinate system code */
        double equinox, /* Equinox of coordinate system */
        double epoch);  /* Epoch of coordinate system */

%apply double *OUTPUT {
  double opos[3]
 }
%typemap(in,numinputs=0) double opos[3] {
  $1 = malloc(sizeof(double)*3);
 }
%typemap(argout) double opos[3] {
  $result = rb_ary_new();
  rb_ary_push($result, rb_float_new($1[0]));
  rb_ary_push($result, rb_float_new($1[1]));
  rb_ary_push($result, rb_float_new($1[2]));
 }
%typemap(freearg) double opos[3] {
  free($1);
 }

    void d2v3 (         /* Convert RA and Dec in degrees and distance to vector */
        double rra,    /* Right ascension in degrees */
        double rdec,   /* Declination in degrees */
        double r,      /* Distance to object in same units as pos */
        double opos[3]); /* x,y,z geocentric equatorial position of object (returned) */

    void s2v3 (         /* Convert RA and Dec in radians and distance to vector */
        double rra,    /* Right ascension in radians */
        double rdec,   /* Declination in radians */
        double r,      /* Distance to object in same units as pos */
        double opos[3]); /* x,y,z geocentric equatorial position of object (returned) */

%apply double *OUTPUT {
        double  *rra,   /* Right ascension in degrees (returned) */
        double  *rdec,  /* Declination in degrees (returned) */
        double  *r      /* Distance to object in same units as pos (returned) */
 }

%apply double *INPUT {
  double pos[3]
 }

%typemap(in) double pos[3] {
  $1 = malloc(sizeof(double)*3);
  $1[0] = NUM2DBL(RARRAY_PTR($input)[0]);
  $1[1] = NUM2DBL(RARRAY_PTR($input)[2]);
  $1[2] = NUM2DBL(RARRAY_PTR($input)[2]);
 }
%typemap(freearg) double pos[3] {
  free($1);
 }

    void v2d3 (         /* Convert vector to RA and Dec in degrees and distance */
        double  pos[3], /* x,y,z geocentric equatorial position of object */
        double  *rra,   /* Right ascension in degrees (returned) */
        double  *rdec,  /* Declination in degrees (returned) */
        double  *r);    /* Distance to object in same units as pos (returned) */

    void v2s3 (         /* Convert vector to RA and Dec in radians and distance */
        double  pos[3], /* x,y,z geocentric equatorial position of object */
        double  *rra,   /* Right ascension in radians (returned) */
        double  *rdec,  /* Declination in radians (returned) */
        double  *r);    /* Distance to object in same units as pos (returned) */
