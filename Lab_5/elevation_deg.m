function el = elevation_deg(S,p)
    % Elevation [deg] of each satellite (rows of S) seen from position p [m, ECEF],
    % using the local geodetic "up" at p.
    [lat,lon] = ecef2lla_simple(p(:)');
    up = [cosd(lat)*cosd(lon); cosd(lat)*sind(lon); sind(lat)];
    d = S - p(:)';
    el = asind((d*up)./vecnorm(d,2,2));
end