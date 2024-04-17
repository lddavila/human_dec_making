function rat_data = get_rat_data(location_of_rat_data)
home_dir = cd(location_of_rat_data);
rat_data = getTable(pwd);
cd(home_dir);
end