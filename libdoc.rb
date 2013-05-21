module Wcs
  module_function

  # Convert between coordinate systems and equinoxes
  #
  # @overload wcscon(sys1,sys2,eq1,eq2,dtheta,dphi,epoch)
  #  @param [Fixnum] sys1 Input coordinate system (J2000, B1950, ECLIPTIC, GALACTIC
  #  @param [Fixnum] sys2 Output coordinate system (J2000, B1950, ECLIPTIC, G ALACTIC
  #  @param [Float]  eq1   Input equinox (default of sys1 if 0.0)
  #  @param [Float]  eq2   Output equinox (default of sys2 if 0.0)
  #  @param [Float]  dtheta Longitude or right ascension in degrees in sys1
  #  @param [Float]  dphi   Latitude or declination in degrees in sys1
  #  @param [Float]  epoch  Besselian epoch in years
  #  @return [Array] ([dtheta,dphi]) Longitude and Latitude in degrees in sys2
  def wcscon
    # defined in C
  end
end
