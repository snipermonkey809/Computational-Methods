function p = lla2ecef_simple(lat,lon,h)
    % WGS84 ECEF position [m, 3x1] from geodetic latitude/longitude [deg] and height [m]
    a = 6378137; e2 = 6.69437999014e-3;
    N = a/sqrt(1 - e2*sind(lat)^2);
    p = [(N + h)*cosd(lat)*cosd(lon); (N + h)*cosd(lat)*sind(lon); (N*(1 - e2) + h)*sind(lat)];
end