function ReadNetCDFFile()
% Modified:File Reader into a function By Stephen Forczyk
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. I wrote this since can't find a function in the
% built-in set of netCDF functions included in MATLAB that displays all 
% header info of the file (equivalent to the old 'ncdump' function). 
%
% Replace the string 'filename.nc' with the file name you want to load.
% Make sure that the nc-file is located in the same folder as this script.
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName;
% Set up cell to hold generic GOES Waveband Data
GoesWaveBand=cell(17,5);
GoesWaveBand{1,1}='Band Num';
GoesWaveBand{1,2}='Resolution-km';
GoesWaveBand{1,3}='Wavelength-microns';
GoesWaveBand{1,4}='Spectrum';
GoesWaveBand{1,5}='Band Desc';
GoesWaveBand{2,1}=1;
GoesWaveBand{2,2}=1;
GoesWaveBand{2,3}=0.47;
GoesWaveBand{2,4}='Visible';
GoesWaveBand{2,5}='Blue Band';
GoesWaveBand{3,1}=2;
GoesWaveBand{3,2}=0.5;
GoesWaveBand{3,3}=0.64;
GoesWaveBand{3,4}='Visible';
GoesWaveBand{3,5}='Red Band';
GoesWaveBand{4,1}=3;
GoesWaveBand{4,2}=1;
GoesWaveBand{4,3}=0.86;
GoesWaveBand{4,4}='Near IR';
GoesWaveBand{4,5}='Red Band';
GoesWaveBand{5,1}=4;
GoesWaveBand{5,2}=2;
GoesWaveBand{5,3}=1.37;
GoesWaveBand{5,4}='Near-IR';
GoesWaveBand{5,5}='Cirrus Band';
GoesWaveBand{6,1}=5;
GoesWaveBand{6,2}=1;
GoesWaveBand{6,3}=1.60;
GoesWaveBand{6,4}='Near-IR';
GoesWaveBand{6,5}='Snow/Ice Band';
GoesWaveBand{7,1}=6;
GoesWaveBand{7,2}=2;
GoesWaveBand{7,3}=2.24;
GoesWaveBand{7,4}='Near-IR';
GoesWaveBand{7,5}='Cloud Particle Band';
GoesWaveBand{8,1}=7;
GoesWaveBand{8,2}=2;
GoesWaveBand{8,3}=3.90;
GoesWaveBand{8,4}='IR';
GoesWaveBand{8,5}='Short Wave Window Band';
GoesWaveBand{9,1}=8;
GoesWaveBand{9,2}=2;
GoesWaveBand{9,3}=6.20;
GoesWaveBand{9,4}='IR';
GoesWaveBand{9,5}='Upper Troposphere WV Band';
GoesWaveBand{10,1}=9;
GoesWaveBand{10,2}=2;
GoesWaveBand{10,3}=6.90;
GoesWaveBand{10,4}='IR';
GoesWaveBand{10,5}='Mid Level Troposphere WV Band';
GoesWaveBand{11,1}=10;
GoesWaveBand{11,2}=2;
GoesWaveBand{11,3}=7.30;
GoesWaveBand{11,4}='IR';
GoesWaveBand{11,5}='Low Level Troposphere WV Band';
GoesWaveBand{12,1}=11;
GoesWaveBand{12,2}=2;
GoesWaveBand{12,3}=8.40;
GoesWaveBand{12,4}='IR';
GoesWaveBand{12,5}='Cloud Top Phase Band';
GoesWaveBand{13,1}=12;
GoesWaveBand{13,2}=2;
GoesWaveBand{13,3}=9.60;
GoesWaveBand{13,4}='IR';
GoesWaveBand{13,5}='Ozone Band';
GoesWaveBand{14,1}=13;
GoesWaveBand{14,2}=2;
GoesWaveBand{14,3}=10.30;
GoesWaveBand{14,4}='IR';
GoesWaveBand{14,5}='Clean IR Longwave Band';
GoesWaveBand{15,1}=14;
GoesWaveBand{15,2}=2;
GoesWaveBand{15,3}=11.20;
GoesWaveBand{15,4}='IR';
GoesWaveBand{15,5}='IR Longwave Band';
GoesWaveBand{16,1}=15;
GoesWaveBand{16,2}=2;
GoesWaveBand{16,3}=12.30;
GoesWaveBand{16,4}='IR';
GoesWaveBand{16,5}='Dirty IR Longwave Band';
GoesWaveBand{17,1}=16;
GoesWaveBand{17,2}=2;
GoesWaveBand{17,3}=13.30;
GoesWaveBand{17,4}='IR';
GoesWaveBand{17,5}='CO2 IR Longwave Band';
%nc_filename = 'OR_ABI-L2-CMIPC-M6C01_G16_s20201930001213_e20201930003586_c20201930004076.nc';   
[nc_filenamesuf,path]=uigetfile('*nc','Select One GOES Data File');% SMF Modification
GOESFileName=nc_filenamesuf;
nc_filename=strcat(path,nc_filenamesuf);
ncid=netcdf.open(nc_filename,'nowrite');
MetaDataS=struct('source_file',[],'Level',[],'SatelliteID',[],'data_type',[],'bandID',[],...
    'start_scan_year',[],'start_scan_day',[],'start_scan_hour',[],'start_scan_min',[],...
    'start_scan_sec',[],'end_scan_year',[],'end_scan_day',[],'end_scan_hour',[],...
    'end_scan_min',[],'end_scan_sec',[]);
[iunder]=strfind(nc_filenamesuf,'_');
numunder=length(iunder);
[idash]=strfind(nc_filenamesuf,'-');
numdash=length(idash);
MetaDataS.source_file=nc_filenamesuf;
is=idash(1)+1;
ie=idash(2)-1;
MetaDataS.Level=nc_filenamesuf(is:ie);
is=iunder(2)+1;
ie=iunder(3)-1;
MetaDataS.SatelliteID=nc_filenamesuf(is:ie);
is=idash(2)+1;
ie=idash(3)-1;
MetaDataS.data_type=nc_filenamesuf(is:ie);
is=idash(3)+1;
ie=iunder(2)-1;
substr=nc_filenamesuf(is:ie);
strlen=length(substr);
[is]=strfind(substr,'C');
bandstr=substr(is+1:strlen);
bandnum=str2num(bandstr);
MetaDataS.bandID=bandnum;
is=iunder(3)+2;
ie=is+3;
MetaDataS.start_scan_year=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+2;
MetaDataS.start_scan_day=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+1;
MetaDataS.start_scan_hour=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+1;
MetaDataS.start_scan_min=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+2;
MetaDataS.start_scan_sec=str2num(nc_filenamesuf(is:ie));
is=iunder(4)+2;
ie=is+3;
MetaDataS.end_scan_year=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+2;
MetaDataS.end_scan_day=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+1;
MetaDataS.end_scan_hour=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+1;
MetaDataS.end_scan_min=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+2;
MetaDataS.end_scan_sec=str2num(nc_filenamesuf(is:ie));
CMIS=struct('values',[],'fill',[],'bit_depth',[],'valid_range',[],...
    'scale_factor',[],'add_offset',[],'resolution',[],'grid_mapping',[],...
    'ancillary_variables',[],'long_name',[],'standard_name',[]); 
DQFS=struct('values',[],'fill',[],'valid_range',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'flag_values',[],'flag_meanings',[],...
    'number_of_qf_values',[],'long_name',[],'standard_name',[],...
    'percent_good_pixel_qf',[],'percent_conditionally_usable_pixel_qf',[],...
    'percent_out_of_range_pixel_qf',[],'percent_no_value_pixel_qf',[],...
    'percent_focal_plane_temperature_threshold_exceeded_qf',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[],'grid_mapping_name',[]);
goesImagerS=struct('values',[],'long_name',[],'perspective_point_height',[],...
    'semi_major_axis',[],'semi_minor_axis',[],'inverse_flattening',[],...
    'latitude_of_projection_origin',[],'longitude_of_projection_origin',[],...
    'sweep_angle_axis',[]);
yImgS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'axis',[]);
yImgBS=struct('values',[],'long_name',[],'units',[]);
xImgS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'axis',[]);
xImgBS=struct('values',[],'long_name',[],'units',[]);
SatDataS=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'FillValue1',[],'units1',[],'values2',[],'long_name2',[],'standard_name2',[],...
    'FillValue2',[],'units2',[],'values3',[],'long_name3',[],'standard_name3',[],...
    'FillValue3',[],'units3',[]);
GeoSpatialS=struct('values',[],'long_name',[],'geospatial_westbound_longitude',[],...
    'geospatial_northbound_latitude',[],'geospatial_eastbound_longitude',[],...
    'geospatial_southbound_latitude',[],'geospatial_lat_center',[],...
    'geospatial_lon_center',[],'geospatial_lat_nadir',[],'geospatial_lon_nadir',[],...
    'geospatial_lat_units',[],'geospatial_lon_units',[]);
BandDataS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
ReflectanceS=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'FillValue1',[],'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],...
    'cell_methods1',[],'values2',[],'long_name2',[],'standard_name2',[],...
    'FillValue2',[],'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],...
    'cell_methods2',[],'values3',[],'long_name3',[],'standard_name3',[],...
    'FillValue3',[],'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],...
    'cell_methods3',[],'values4',[],'long_name4',[],'standard_name4',[],...
    'FillValue4',[],'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],...
    'cell_methods4',[]);
AlgoS=struct('values',[],'long_name',[],'input_ABI_L2_auxiliary_solar_zenith_angle_data',[],...
    'input_ABI_L1b_radiance_band_data',[]);
ErrorS=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'valid_range2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[]);
EarthSunS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'cell_methods',[]);
VersionContainerS=struct('values1',[],'long_name1',[],'L2_processing_parm_version',[],...
    'values2',[],'long_name2',[],'algorithm_version',[],'product_version',[]);
ESunS=struct('value',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'cell_methods',[]);
kappa0S=struct('values',[],'long_name',[],'FillValue',[],'units',[],'coordinates',[],...
    'cell_methods',[]);
PlanckS=struct('values1',[],'long_name1',[],'FillValue1',[],'units1',[],'coordinates1',[],...
   'values2',[],'long_name2',[],'FillValue2',[],'units2',[],'coordinates2',[],...
   'values3',[],'long_name3',[],'FillValue3',[],'units3',[],'coordinates3',[],...
   'values4',[],'long_name4',[],'FillValue4',[],'units4',[],'coordinates4',[]);
FocalPlaneS=struct('values1',[],'long_name1',[],'FillValue1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],'values2',[],...
    'long_name2',[],'FillValue2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],'units3',[],'coordinates3',[],...
    'grid_mapping3',[],'values4',[],'long_name4',[],'FillValue4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[]);
% Get information about the contents of the file.
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);

disp(' '),disp(' '),disp(' ')
disp('________________________________________________________')
disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
disp(['VARIABLES CONTAINED IN THE netCDF FILE: ' nc_filename ])
disp(' ')
for i = 0:numvars-1
    [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,i);
    disp(['--------------------< ' varname ' >---------------------'])
    flag = 0;
%     if(varname=='CMI')
%        CMIS=struct('values',[],'fill',[],'bit_depth',[],'valid_range',[]); 
%     end
    for j = 0:numatts - 1
        a10=strcmp(varname,'CMI');
        a20=strcmp(varname,'DQF');
        a30=strcmp(varname,'t');
        a40=strcmp(varname,'y');
        a50=strcmp(varname,'x');
        a60=strcmp(varname,'time_bounds');
        a70=strcmp(varname,'goes_imager_projection');
        a80=strcmp(varname,'y_image');
        a90=strcmp(varname,'y_image_bounds');
        a100=strcmp(varname,'x_image');
        a110=strcmp(varname,'x_image_bounds');
        a120=strcmp(varname,'nominal_satellite_subpoint_lat');
        a130=strcmp(varname,'nominal_satellite_subpoint_lon');
        a140=strcmp(varname,'nominal_satellite_height');
        a150=strcmp(varname,'geospatial_lat_lon_extent');
        a160=strcmp(varname,'band_wavelength');
        a170=strcmp(varname,'min_reflectance_factor');
        a180=strcmp(varname,'max_reflectance_factor');
        a190=strcmp(varname,'mean_reflectance_factor');
        a200=strcmp(varname,'std_dev_reflectance_factor');
        a210=strcmp(varname,'algorithm_dynamic_input_data_container');
        a220=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a230=strcmp(varname,'percent_uncorrectable_L0_errors');
        a240=strcmp(varname,'earth_sun_distance_anomaly_in_AU');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'esun');
        a280=strcmp(varname,'kappa0');
        a290=strcmp(varname,'planck_fk1');
        a300=strcmp(varname,'planck_fk2');
        a310=strcmp(varname,'planck_bc1');
        a320=strcmp(varname,'planck_bc2');
        a330=strcmp(varname,'focal_plane_temperature_threshold_exceeded_count');
        a340=strcmp(varname,'maximum_focal_plane_temperature');
        a350=strcmp(varname,'focal_plane_temperature_threshold_increasing');
        a360=strcmp(varname,'focal_plane_temperature_threshold_decreasing');
        if (a10==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CMIS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMIS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMIS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMIS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMIS.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMIS.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMIS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMIS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CMIS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMIS.standard_name=attname2;
            end
        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQFS.fill=attname2;
            end

            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQFS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQFS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQFS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQFS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQFS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQFS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQFS.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQFS.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQFS.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQFS.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQFS.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQFS.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQFS.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
        elseif (a30==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'units');
            if(a1==1)
                tS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                tS.axis=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                tS.bounds=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                tS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                tS.standard_name=attname2;
            end
        elseif (a40==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                yS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                yS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                yS.axis=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                yS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                yS.standard_name=attname2;
            end
        elseif (a50==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                xS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                xS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                xS.axis=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                xS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                xS.standard_name=attname2;
            end
        elseif (a60==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                tBS.long_name=attname2;
            end
        elseif (a70==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                goesImagerS.long_name=attname2;
            end
            a1=strcmp(attname1,'grid_mapping_name');
            if(a1==1)
                goesImagerS.grid_Mapping_name=attname2;
            end
            a1=strcmp(attname1,'perspective_point_height');
            if(a1==1)
                goesImagerS.perspective_point_height=attname2;
            end
            a1=strcmp(attname1,'semi_major_axis');
            if(a1==1)
                goesImagerS.semi_major_axis=attname2;
            end
            a1=strcmp(attname1,'semi_minor_axis');
            if(a1==1)
                goesImagerS.semi_minor_axis=attname2;
            end
            a1=strcmp(attname1,'inverse_flattening');
            if(a1==1)
                goesImagerS.inverse_flattening=attname2;
            end
            a1=strcmp(attname1,'latitude_of_projection_origin');
            if(a1==1)
                goesImagerS.latitude_of_projection_origin=attname2;
            end
            a1=strcmp(attname1,'longitude_of_projection_origin');
            if(a1==1)
                goesImagerS.longitude_of_projection_origin=attname2;
                ab=1;
            end
            a1=strcmp(attname1,'sweep_angle_axis');
            if(a1==1)
                goesImagerS.sweep_angle_axis=attname2;
                ab=1;
            end
       elseif (a80==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                yImgS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                yImgS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yImgS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                yImgS.axis=attname2;
            end
        elseif (a90==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                yImgBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yImgBS.units=attname2;
            end
        elseif (a100==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                xImgS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                xImgS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xImgS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                xImgS.axis=attname2;
            end
        elseif (a110==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                xImgBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xImgBS.units=attname2;
            end
        elseif (a120==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SatDataS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SatDataS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SatDataS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SatDataS.units1=attname2;
            end
        elseif (a130==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SatDataS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SatDataS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SatDataS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SatDataS.units2=attname2;
            end
        elseif (a140==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SatDataS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SatDataS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SatDataS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SatDataS.units3=attname2;
            end
        elseif (a150==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GeoSpatialS.long_name=attname2;
            end
            a1=strcmp(attname1,'geospatial_westbound_longitude');
            if(a1==1)
                GeoSpatialS.geospatial_westbound_longitude=attname2;
            end
            a1=strcmp(attname1,'geospatial_northbound_latitude');
            if(a1==1)
                GeoSpatialS.geospatial_northbound_latitude=attname2;
            end
            a1=strcmp(attname1,'geospatial_eastbound_longitude');
            if(a1==1)
                GeoSpatialS.geospatial_eastbound_longitude=attname2;
            end
            a1=strcmp(attname1,'geospatial_southbound_latitude');
            if(a1==1)
                GeoSpatialS.geospatial_southbound_latitude=attname2;
            end
            a1=strcmp(attname1,'geospatial_lat_center');
            if(a1==1)
                GeoSpatialS.geospatial_lat_center=attname2;
            end
            a1=strcmp(attname1,'geospatial_lon_center');
            if(a1==1)
                GeoSpatialS.geospatial_lon_center=attname2;
            end
            a1=strcmp(attname1,'geospatial_lat_nadir');
            if(a1==1)
                GeoSpatialS.geospatial_lat_nadir=attname2;
            end
            a1=strcmp(attname1,'geospatial_lon_nadir');
            if(a1==1)
                GeoSpatialS.geospatial_lon_nadir=attname2;
            end
            a1=strcmp(attname1,'geospatial_lat_units');
            if(a1==1)
                GeoSpatialS.geospatial_lat_units=attname2;
            end
            a1=strcmp(attname1,'geospatial_lon_units');
            if(a1==1)
                GeoSpatialS.geospatial_lon_units=attname2;
            end
        elseif (a160==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BandDataS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BandDataS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BandDataS.units=attname2;
            end
        elseif (a170==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceS.cell_methods1=attname2;
            end
        elseif (a180==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceS.cell_methods2=attname2;
            end
        elseif (a190==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceS.cell_methods3=attname2;
            end
        elseif (a200==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceS.FillValue4=attname2;
            end

            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceS.cell_methods4=attname2;
            end
        elseif (a210==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AlgoS.long_name=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_solar_zenith_angle_data');
            if(a1==1)
                AlgoS.input_ABI_L2_auxiliary_solar_zenith_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_data');
            if(a1==1)
                AlgoS.input_ABI_L1b_radiance_band_data=attname2;
            end
        elseif (a220==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ErrorS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ErrorS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ErrorS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ErrorS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ErrorS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ErrorS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ErrorS.cell_methods1=attname2;
            end
         elseif (a230==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ErrorS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ErrorS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ErrorS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ErrorS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ErrorS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ErrorS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ErrorS.cell_methods2=attname2;
            end
        elseif (a240==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                EarthSunS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                EarthSunS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EarthSunS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                EarthSunS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                EarthSunS.cell_methods=attname2;
            end
        elseif (a250==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VersionContainerS.long_name1=attname2;
            end
            a1=strcmp(attname1,'L2_processing_parm_version');
            if(a1==1)
                VersionContainerS.L2_processing_parm_version=attname2;
            end
        elseif (a260==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VersionContainerS.long_name2=attname2;
            end
            a1=strcmp(attname1,'algorithm_version');
            if(a1==1)
                VersionContainerS.algorithm_version=attname2;
            end
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                VersionContainerS.product_version=attname2;
            end
        elseif (a270==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ESunS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ESunS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ESunS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ESunS.units=attname2;
            end

            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ESunS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ESunS.cell_methods=attname2;
            end
        elseif (a280==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                kappa0S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                kappa0S.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                kappa0S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                kappa0S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                kappa0S.cell_methods=attname2;
            end
        elseif (a290==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PlanckS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PlanckS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PlanckS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PlanckS.coordinates1=attname2;
            end
        elseif (a300==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PlanckS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PlanckS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PlanckS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PlanckS.coordinates2=attname2;
            end
        elseif (a310==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PlanckS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PlanckS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PlanckS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PlanckS.coordinates3=attname2;
            end
        elseif (a320==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PlanckS.long_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PlanckS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PlanckS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PlanckS.coordinates4=attname2;
            end
        elseif (a330==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FocalPlaneS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FocalPlaneS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FocalPlaneS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FocalPlaneS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FocalPlaneS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FocalPlaneS.cell_methods1=attname2;
            end
         elseif (a340==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FocalPlaneS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FocalPlaneS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FocalPlaneS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FocalPlaneS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FocalPlaneS.grid_mapping2=attname2;
            end
        elseif (a350==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FocalPlaneS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FocalPlaneS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FocalPlaneS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FocalPlaneS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FocalPlaneS.grid_mapping3=attname2;
            end
        elseif (a360==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FocalPlaneS.long_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FocalPlaneS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FocalPlaneS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FocalPlaneS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FocalPlaneS.grid_mapping4=attname2;
            end

        else
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end   
        end
    end
    disp(' ')
    
    if flag
        eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
        if(varname=='CMI')
            CMIS.values=CMI;
        end
        if(varname=='y')
            yS.values=y;
        end
        if(varname=='x')
            xS.values=x;
            ab=1;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a20==1)
            DQFS.values=DQF;
        end
        if(varname=='t')
            tS.values=t;
            ab=1;
        end
        if(a60==1)
            tBS.values=time_bounds;
        end
        if(a70==1)
            goesImagerS.values=goes_imager_projection;
        end
        if(a80==1)
            yImgS.values=y_image;
        end
        if(a90==1)
            yImgBS.values=y_image_bounds;
        end
        if(a100==1)
            xImgS.values=x_image;
        end
        if(a110==1)
            xImgBS.values=x_image_bounds;
        end
        if(a120==1)
            val=nominal_satellite_subpoint_lat;
            SatDataS.values1=val;
        end
        if(a130==1)
            val=nominal_satellite_subpoint_lon;
            SatDataS.values2=val;
        end
        if(a140==1)
            val=nominal_satellite_height;
            SatDataS.values3=val;
        end
        if(a150==1)
            GeoSpatialS.values=geospatial_lat_lon_extent;
        end
        if(a170==1)
            ReflectanceS.values1=min_reflectance_factor;
        end
        if(a180==1)
            ReflectanceS.values2=min_reflectance_factor;
        end
        if(a190==1)
            ReflectanceS.values3=min_reflectance_factor;
        end
        if(a200==1)
            ReflectanceS.values4=min_reflectance_factor;
        end
        if(a210==1)
            AlgoS.values=[];
        end
        if(a220==1)
            ErrorS.values1=percent_uncorrectable_GRB_errors;
        end
        if(a230==1)
            ErrorS.values2=percent_uncorrectable_L0_errors;
        end
        if(a240==1)
            EarthSunS.values=earth_sun_distance_anomaly_in_AU;
        end
        if(a270==1)
            ESunS.value=esun;
            ab=1;
        end
        if(a280==1)
            kappa0S.values=kappa0;
            ab=1;
        end
        if(a290==1)
            PlanckS.values1=planck_fk1;
            ab=1;
        end
        if(a300==1)
            PlanckS.values2=planck_fk2;
            ab=1;
        end
        if(a310==1)
            PlanckS.values3=planck_bc1;
            ab=1;
        end
        if(a320==1)
            PlanckS.values4=planck_bc2;
            ab=1;
        end
        if(a330==1)
            FocalPlaneS.values1=focal_plane_temperature_threshold_exceeded_count;
            ab=1;
        end
        if(a340==1)
            FocalPlaneS.values2=maximum_focal_plane_temperature;
            ab=1;
        end
        if(a350==1)
            FocalPlaneS.values3=focal_plane_temperature_threshold_increasing;
        end
        if(a360==1)
            FocalPlaneS.values4=focal_plane_temperature_threshold_increasing;
            ab=1;
        end

    end
end
disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
disp('________________________________________________________')
disp(' '),disp(' ')
end