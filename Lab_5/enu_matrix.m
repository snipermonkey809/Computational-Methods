function E = enu_matrix(lat,lon)
    % Rotation matrix from ECEF to East-North-Up about (lat, lon) [deg]
    E = [-sind(lon),            cosd(lon),            0;
         -sind(lat)*cosd(lon), -sind(lat)*sind(lon),  cosd(lat);
          cosd(lat)*cosd(lon),  cosd(lat)*sind(lon),  sind(lat)];
end