function [lat,lon,h] = ecef2lla_simple(p)
    % WGS84 geodetic latitude, longitude [deg] and height [m] from ECEF [m]
    a = 6378137; e2 = 6.69437999014e-3;
    lon = atan2d(p(2),p(1));
    rho = hypot(p(1),p(2));
    lat = atan2d(p(3),rho*(1 - e2));
    for k = 1:10
        N = a/sqrt(1 - e2*sind(lat)^2);
        h = rho/cosd(lat) - N;
        lat = atan2d(p(3),rho*(1 - e2*N/(N + h)));
    end
end