/* SIRTF distortion matrix coefficients */
#define DISTMAX 10
struct Distort {
  int    a_order;                /* max power for the 1st dimension */
  double a[DISTMAX][DISTMAX];  /* coefficient array of 1st dimension */
  int    b_order;                /* max power for 1st dimension */
  double b[DISTMAX][DISTMAX];  /* coefficient array of 2nd dimension */
  int    ap_order;               /* max power for the 1st dimension */
  double ap[DISTMAX][DISTMAX]; /* coefficient array of 1st dimension */
  int    bp_order;               /* max power for 1st dimension */
  double bp[DISTMAX][DISTMAX]; /* coefficient array of 2nd dimension */
};

struct WorldCoor {
  double	xref;		/* X reference coordinate value (deg) */
  double	yref;		/* Y reference coordinate value (deg) */
  double	xrefpix;	/* X reference pixel */
  double	yrefpix;	/* Y reference pixel */
  double	xinc;		/* X coordinate increment (deg) */
  double	yinc;		/* Y coordinate increment (deg) */
  double	rot;		/* rotation around axis (deg) (N through E) */
  double	cd[4];		/* rotation matrix */
  double	dc[4];		/* inverse rotation matrix */
  double	equinox;	/* Equinox of coordinates default to 1950.0 */
  double	epoch;		/* Epoch of coordinates default to equinox */
  double	nxpix;		/* Number of pixels in X-dimension of image */
  double	nypix;		/* Number of pixels in Y-dimension of image */
  double	plate_ra;	/* Right ascension of plate center */
  double	plate_dec;	/* Declination of plate center */
  double	plate_scale;	/* Plate scale in arcsec/mm */
  double	x_pixel_offset;	/* X pixel offset of image lower right */
  double	y_pixel_offset;	/* Y pixel offset of image lower right */
  double	x_pixel_size;	/* X pixel_size */
  double	y_pixel_size;	/* Y pixel_size */
  double	ppo_coeff[6];	/* pixel to plate coefficients for DSS */
  double	x_coeff[20];	/* X coefficients for plate model */
  double	y_coeff[20];	/* Y coefficients for plate model */
  double	xpix;		/* X (RA) coordinate (pixels) */
  double	ypix;		/* Y (dec) coordinate (pixels) */
  double	zpix;		/* Z (face) coordinate (pixels) */
  double	xpos;		/* X (RA) coordinate (deg) */
  double	ypos;		/* Y (dec) coordinate (deg) */
  double	crpix[9];	/* Values of CRPIXn keywords */
  double	crval[9];	/* Values of CRVALn keywords */
  double	cdelt[9];	/* Values of CDELTn keywords */
  double	pc[81];		/* Values of PCiiijjj keywords */
  double	projp[10];	/* Constants for various projections */
  double	longpole;	/* Longitude of North Pole in degrees */
  double	latpole;	/* Latitude of North Pole in degrees */
  double	rodeg;		/* Radius of the projection generating sphere */
  double	imrot;		/* Rotation angle of north pole */
  double	pa_north;	/* Position angle of north (0=horizontal) */
  double	pa_east;	/* Position angle of east (0=horizontal) */
  double	radvel;		/* Radial velocity (km/sec away from observer)*/
  double	zvel;		/* Radial velocity (v/c away from observer)*/
  int		imflip;		/* If not 0, image is reflected around axis */
  int		prjcode;	/* projection code (-1-32) */
  int		latbase;	/* Latitude base 90 (NPA), 0 (LAT), -90 (SPA) */
  int		ncoeff1;	/* Number of x-axis plate fit coefficients */
  int		ncoeff2;	/* Number of y-axis plate fit coefficients */
  int		changesys;	/* 1 for FK4->FK5, 2 for FK5->FK4 */
  				/* 3 for FK4->galactic, 4 for FK5->galactic */
  int		printsys;	/* 1 to print coordinate system, else 0 */
  int		ndec;		/* Number of decimal places in PIX2WCST */
  int		degout;		/* 1 to always print degrees in PIX2WCST */
  int		tabsys;		/* 1 to put tab between RA & Dec, else 0 */
  int		rotmat;		/* 0 if CDELT, CROTA; 1 if CD */
  int		coorflip;	/* 0 if x=RA, y=Dec; 1 if x=Dec, y=RA */
  int		offscl;		/* 0 if OK, 1 if offscale */
  int		wcson;		/* 1 if WCS is set, else 0 */
  int		naxis;		/* Number of axes in image (for WCSLIB 3.0) */
  int		naxes;		/* Number of axes in image */
  int		wcsproj;	/* WCS_OLD: AIPS worldpos() and worldpix()
				   WCS_NEW: Mark Calabretta's WCSLIB subroutines
				   WCS_BEST: WCSLIB for all but CAR,COE,NCP
				   WCS_ALT:  AIPS for all but CAR,COE,NCP */
  int		linmode;	/* 0=system only, 1=units, 2=system+units */
  int		detector;	/* Instrument detector number */
  char		instrument[32];	/* Instrument name */
  char		ctype[9][9];	/* Values of CTYPEn keywords */
  char		c1type[9];	/*  1st coordinate type code:
					RA--, GLON, ELON */
  char		c2type[9];	/*  2nd coordinate type code:
					DEC-, GLAT, ELAT */
  char		ptype[9];	/*  projection type code:
				    SIN, TAN, ARC, NCP, GLS, MER, AIT, etc */
  char		units[9][32];	/* Units if LINEAR */
  char		radecsys[32];	/* Reference frame: FK4, FK4-NO-E, FK5, GAPPT*/
  char		radecout[32];	/* Output reference frame: FK4,FK5,GAL,ECL */
  char		radecin[32];	/* Input reference frame: FK4,FK5,GAL,ECL */
  double	eqin;		/* Input equinox (match sysin if 0.0) */
  double	eqout;		/* Output equinox (match sysout if 0.0) */
  int		sysin;		/* Input coordinate system code */
  int		syswcs;		/* WCS coordinate system code */
  int		sysout;		/* Output coordinate system code */
				/* WCS_B1950, WCS_J2000, WCS_ICRS, WCS_GALACTIC,
				 * WCS_ECLIPTIC, WCS_LINEAR, WCS_ALTAZ  */
  char		center[32];	/* Center coordinates (with frame) */
  struct wcsprm wcsl;		/* WCSLIB main projection parameters */
  struct linprm lin;		/* WCSLIB image/pixel conversion parameters */
  struct celprm cel;		/* WCSLIB projection type */
  struct prjprm prj;		/* WCSLIB projection parameters */
  struct IRAFsurface *lngcor;	/* RA/longitude correction structure */
  struct IRAFsurface *latcor;	/* Dec/latitude correction structure */
  int		distcode;	/* Distortion code 0=none 1=SIRTF */
  struct Distort distort;	/* SIRTF distortion coefficients */
  char *command_format[10];	/* WCS command formats */
				/* where %s is replaced by WCS coordinates */
				/* where %f is replaced by the image filename */
				/* where %x is replaced by image coordinates */
  double	ltm[4];		/* Image rotation matrix */
  double	ltv[2];		/* Image offset */
  int		idpix[2];	/* First pixel to use in image (x, y) */
  int		ndpix[2];	/* Number of pixels to use in image (x, y) */
  struct WorldCoor *wcs;	/* WCS upon which this WCS depends */
  struct WorldCoor *wcsdep;	/* WCS depending on this WCS */
  char		*wcsname;	/* WCS name (defaults to NULL pointer) */
  char		wcschar;	/* WCS character (A-Z, null, space) */
  int		logwcs;		/* 1 if DC-FLAG is set for log wavelength */
};

/* Projections (1-26 are WCSLIB) (values for wcs->prjcode) */
#define PIX -1	/* Pixel WCS */
#define LIN  0	/* Linear projection */
#define AZP  1	/* Zenithal/Azimuthal Perspective */
#define SZP  2	/* Zenithal/Azimuthal Perspective */
#define TAN  3	/* Gnomonic = Tangent Plane */
#define SIN  4	/* Orthographic/synthesis */
#define STG  5	/* Stereographic */
#define ARC  6	/* Zenithal/azimuthal equidistant */
#define ZPN  7	/* Zenithal/azimuthal PolyNomial */
#define ZEA  8	/* Zenithal/azimuthal Equal Area */
#define AIR  9	/* Airy */
#define CYP 10	/* CYlindrical Perspective */
#define CAR 11	/* Cartesian */
#define MER 12	/* Mercator */
#define CEA 13	/* Cylindrical Equal Area */
#define COP 14	/* Conic PerSpective (COP) */
#define COD 15	/* COnic equiDistant */
#define COE 16	/* COnic Equal area */
#define COO 17	/* COnic Orthomorphic */
#define BON 18	/* Bonne */
#define PCO 19	/* Polyconic */
#define SFL 20	/* Sanson-Flamsteed (GLobal Sinusoidal) */
#define PAR 21	/* Parabolic */
#define AIT 22	/* Hammer-Aitoff */
#define MOL 23	/* Mollweide */
#define CSC 24	/* COBE quadrilateralized Spherical Cube */
#define QSC 25	/* Quadrilateralized Spherical Cube */
#define TSC 26	/* Tangential Spherical Cube */
#define NCP 27	/* Special case of SIN */
#define GLS 28	/* Same as SFL */
#define DSS 29	/* Digitized Sky Survey plate solution */
#define PLT 30	/* Plate fit polynomials (SAO) */
#define TNX 31	/* Gnomonic = Tangent Plane (NOAO with corrections) */

/* Coordinate systems */
#define J2000	1	/* J2000(FK5) right ascension and declination */
#define B1950	2	/* B1950(FK4) right ascension and declination */
#define GALACTIC 3	/* Galactic longitude and latitude */
#define ECLIPTIC 4	/* Ecliptic longitude and latitude */
#define ALTAZ	5	/* Azimuth and altitude/elevation */
#define LINEAR	6	/* Linear with optional units */
#define NPOLE	7	/* Longitude and north polar angle */
#define SPA	8	/* Longitude and south polar angle */
#define PLANET	9	/* Longitude and latitude on planet */
#define XY	10	/* X-Y Cartesian coordinates */
#define ICRS	11	/* ICRS right ascension and declination */

/* Method to use */
#define BEST	0	/* Use best WCS projections */
#define ALT	1	/* Use not best WCS projections */
#define OLD	2	/* Use AIPS WCS projections */
#define NEW	3	/* Use WCSLIB 2.5 WCS projections */

/* Distortion codes (values for wcs->distcode) */
#define DISTORT_NONE	0	/* No distortion coefficients */
#define DISTORT_SIRTF	1	/* SIRTF distortion matrix */
