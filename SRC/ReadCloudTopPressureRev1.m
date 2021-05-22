function ReadCloudTopPressureRev1()
% Modified: This function will read in the GOES Cloud Top Pressure Data

% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. I wrote this since can't find a function in the
% built-in set of netCDF functions included in MATLAB that displays all 
% header info of the file (equivalent to the old 'ncdump' function). 
%
% Replace the string 'filename.nc' with the file name you want to load.
% Make sure that the nc-file is located in the same folder as this script.
% This was modified from the Rev 0 to properly decode the pressure values
% stored as 16 bit unsigned values
% Written By: Stephen Forczyk
% Created: Nov 25,2020
% Revised:----
% Classification: Unclassified

global BandDataS MetaDataS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS CloudTopS;
global PressureS OutlierPixelsS CloudTopPressureS;
global AlgoS ErrorS  VersionContainerS;
global GoesWaveBand;
global AlgoProdVersionContainerS;
global LZAS LZABS SZAS SZABS;
global GRBErrorsS L0ErrorsS;
global CloudPixelsS;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global idebug isavefiles;
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath fid gridpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

fprintf(fid,'%s\n','Start reading Cloud Top Pressure data');

[nc_filenamesuf,path]=uigetfile('*nc','Select One GOES Data File');% SMF Modification
GOESFileName=nc_filenamesuf;
filestr=strcat('Reading In File-',nc_filenamesuf);
fprintf(fid,'%s\n',filestr);
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
PressureS=struct('values',[],'long_name',[],'standard_name',[],...
    'FillValue',[],'Unsigned',[],'valid_range',[],'scale_factor',[],'add_offset',[],...
    'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],'cell_methods',[],...
    'ancillary_variables',[]);
DQFS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'percent_good_quality_qf',[],'percent_invalid_due_to_not_geolocated_qf',[],...
    'percent_invalid_due_to_LZA_threshold_exceeded_qf',[],'percent_invalid_due_to_bad_or_missing_brightness_temp_data_qf',[],...
    'percent_invalid_due_to_clear_or_probably_clear_sky_qf',[],'percent_invalid_due_to_unknown_cloud_type_qf',[],...
    'percent_invalid_due_to_nonconvergent_retrieval_qf',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[],'units',[]);
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
OutlierPixelsS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
CloudTopS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...;
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],'units4',[],...
    'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
CloudTopPressureS=CloudTopS;
CloudPixelsS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
BandDataS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
AlgoS=struct('values',[],'long_name',[],'input_ABI_L1b_radiance_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_15_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_16_2km_data',[],...
    'input_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...
    'input_ABI_L2_intermediate_product_cloud_type_data',[],...
    'input_ABI_L2_inter_prod_CRTM_clear_sky_radiance_band_14_data',[],...;
    'input_ABI_L2_inter_prod_CRTM_clear_sky_radiance_band_15_data',[],...
    'input_ABI_L2_inter_prod_CRTM_clear_sky_radiance_band_16_data',[],...
    'inp_ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_prof_data',[],...
    'inp_ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_prof_data',[],...
    'inp_ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_prof_data',[],...;
    'inp_ABI_L2_inter_prod_CRTM_clear_sky_trans_band_14_prof_data',[],...
    'inp_ABI_L2_inter_prod_CRTM_clear_sky_trans_band_15_prof_data',[],...
    'inp_ABI_L2_inter_prod_CRTM_clear_sky_trans_band_16_prof_data',[],...;
    'inp_ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_14_prof_data',[],...
    'inp_ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_15_prof_data',[],...
    'inp_ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_16_prof_data',[],...;
    'input_dynamic_ancillary_NWP_surface_pressure_data',[],...
    'input_dynamic_ancillary_NWP_surface_temperature_data',[],...
    'input_dynamic_ancillary_NWP_tropopause_temperature_data',[],...;
    'input_dynamic_ancillary_NWP_temperature_profile_data',[],...
    'input_dynamic_ancillary_NWP_temperature_inversion_profile_data',[],...
    'input_dynamic_ancillary_NWP_geopotential_height_profile_data',[],...;
    'input_dynamic_ancillary_NWP_pressure_profile_data',[],...
    'input_dynamic_ancillary_NWP_surface_level_index_data',[],...
    'input_dynamic_ancillary_NWP_tropopause_level_index_data',[]);
LZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
LZABS=struct('values',[],'long_name',[]);
SZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
SZABS=struct('values',[],'long_name',[]);
GRBErrorsS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'coordinates',[],'cell_methods',[]);
L0ErrorsS=GRBErrorsS;
ErrorS=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'valid_range2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[]);

VersionContainerS=struct('values',[],'long_name',[],'L2_processing_parm_version',[]);
AlgoProdVersionContainerS=struct('values',[],'long_name',[],'algorithm_version',[]);

% Get information about the contents of the file.
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);
if(idebug==1)
    disp(' '),disp(' '),disp(' ')
    disp('________________________________________________________')
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp(['VARIABLES CONTAINED IN THE netCDF FILE: ' nc_filename ])
    dispstr=strcat('VARIABLES CONTAINED IN THE netCDF FILE:',GOESFileName);
    disp(' ')
    fprintf(fid,'%s\n','________________________________________________________');
    fprintf(fid,'%s\n','^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~');
    fprintf(fid,'%s\n',dispstr);
    variablestr=strcat('Number of variables in file=',num2str(numvars));
    disp(variablestr);
    fprintf(fid,'%s\n',variablestr);
    fprintf(fid,'\n');
end
for i = 0:numvars-1
    [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,i);
    disp(['--------------------< ' varname ' >---------------------'])
    flag = 0;
    for j = 0:numatts - 1
        a10=strcmp(varname,'PRES');
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
        a210=strcmp(varname,'algorithm_dynamic_input_data_container');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a370=strcmp(varname,'outlier_pixels');
        a380=strcmp(varname,'minimum_cloud_top_pressure');
        a390=strcmp(varname,'maximum_cloud_top_pressure');
        a400=strcmp(varname,'mean_cloud_top_pressure');
        a410=strcmp(varname,'std_dev_cloud_top_pressure');
        a420=strcmp(varname,'local_zenith_angle');
        a430=strcmp(varname,'local_zenith_angle_bounds');
        a440=strcmp(varname,'solar_zenith_angle');
        a450=strcmp(varname,'solar_zenith_angle_bounds');
        a460=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a470=strcmp(varname,'percent_uncorrectable_L0_errors');
        a480=strcmp(varname,'cloud_pixels');
        if (a10==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
                offset =0;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PressureS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PressureS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PressureS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                PressureS.scale_factor=attname2;
 %               PressureS.scale_factor=1;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                PressureS.add_offset=attname2;
%                PressureS.add_offset=500;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                PressureS.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PressureS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                PressureS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PressureS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                PressureS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PressureS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PressureS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                PressureS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PressureS.coordinates=attname2;
            end
        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQFS.FillValue=attname2;
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
            a1=strcmp(attname1,'percent_good_quality_qf');
            if(a1==1)
                DQFS.percent_good_quality_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_not_geolocated_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_not_geolocated_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_LZA_threshold_exceeded_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_LZA_threshold_exceeded_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_bad_or_missing_brightness_temp_data_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_bad_or_missing_brightness_temp_data_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_clear_or_probably_clear_sky_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_clear_or_probably_clear_sky_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_unknown_cloud_type_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_unknown_cloud_type_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_nonconvergent_retrieval_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_nonconvergent_retrieval_qf=attname2;
            end 
        elseif (a30==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                tBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                tBS.units=attname2;
            end
        elseif (a70==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            end
            a1=strcmp(attname1,'sweep_angle_axis');
            if(a1==1)
                goesImagerS.sweep_angle_axis=attname2;
            end
       elseif (a80==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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


        elseif (a210==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AlgoS.long_name=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_14_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L1b_radiance_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_15_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_16_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_16_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_4_level_cloud_mask_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_4_level_cloud_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_type_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_cloud_type_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_14_data');
            if(a1==1)
                AlgoS.input_ABI_L2_inter_prod_CRTM_clear_sky_radiance_band_14_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_data');
            if(a1==1)
                AlgoS.input_ABI_L2_inter_prod_CRTM_clear_sky_radiance_band_15_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_data');
            if(a1==1)
                AlgoS.input_ABI_L2_inter_prod_CRTM_clear_sky_radiance_band_16_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_14_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_14_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_clear_sky_trans_band_14_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_15_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_clear_sky_trans_band_15_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_16_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_clear_sky_trans_band_16_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_14_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_14_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_15_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_15_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_16_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_16_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_pressure_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_pressure_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_temperature_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_temperature_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_tropopause_temperature_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_tropopause_temperature_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_temperature_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_temperature_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_temperature_inversion_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_temperature_inversion_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_geopotential_height_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_geopotential_height_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_pressure_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_pressure_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_level_index_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_level_index_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_tropopause_level_index_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_tropopause_level_index_data=attname2;
            end
        elseif (a250==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VersionContainerS.long_name=attname2;
            end
            a1=strcmp(attname1,'L2_processing_parm_version');
            if(a1==1)
                VersionContainerS.L2_processing_parm_version=attname2;
            end
        elseif (a260==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AlgoProdVersionContainerS.long_name=attname2;
            end
            a1=strcmp(attname1,'algorithm_version');
            if(a1==1)
               AlgoProdVersionContainerS.algorithm_version=attname2;
            end
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                AlgoProdVersionContainerS.product_version=attname2;
            end
         elseif (a370==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutlierPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutlierPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutlierPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutlierPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutlierPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutlierPixelsS.cell_methods=attname2;
            end
         elseif (a380==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudTopPressureS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CloudTopPressureS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudTopPressureS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CloudTopPressureS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudTopPressureS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudTopPressureS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudTopPressureS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudTopPressureS.cell_methods1=attname2;
            end
        elseif (a390==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudTopPressureS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CloudTopPressureS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudTopPressureS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CloudTopPressureS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudTopPressureS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudTopPressureS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudTopPressureS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudTopPressureS.cell_methods2=attname2;
            end
       elseif (a400==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudTopPressureS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CloudTopPressureS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudTopPressureS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CloudTopPressureS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudTopPressureS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudTopPressureS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudTopPressureS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudTopPressureS.cell_methods3=attname2;
            end
        elseif (a410==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudTopPressureS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CloudTopPressureS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudTopPressureS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CloudTopPressureS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudTopPressureS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudTopPressureS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudTopPressureS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudTopPressureS.cell_methods4=attname2;
            end
       elseif (a420==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LZAS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LZAS.FillValue=attname2;
            end
        elseif (a430==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LZABS.long_name=attname2;
            end
        elseif (a440==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SZAS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SZAS.FillValue=attname2;
            end
        elseif (a450==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SZABS.long_name=attname2;
            end
        elseif (a460==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GRBErrorsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GRBErrorsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GRBErrorsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                GRBErrorsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                GRBErrorsS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                GRBErrorsS.valid_range=attname2;
            end
            ab=1;
        elseif (a470==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                L0ErrorsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                L0ErrorsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                L0ErrorsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                L0ErrorsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                L0ErrorsS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                L0ErrorsS.valid_range=attname2;
            end
         elseif (a480==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudPixelsS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudPixelsS.grid_mapping=attname2;
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
%        eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
        if(a10==1) 
               eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
               ab=1;
               FillValue=PressureS.FillValue;
               [PRES,numnanvals] = ReplaceFillValues(PRES,FillValue);
               [nrows,ncols]=size(PRES);
               level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=PRES(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           PRES(ik,jk)=corval;
                      end
                   end
               end
               Pressure=PRES*scale+offset;
               PressureS.values=Pressure; 
        end
        if(a40==1)
            eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
            yS.values=y;
        end
        if(a50==1)
            eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
            xS.values=x;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a20==1)
            DQFS.values=DQF;
        end
        if(a30==1)
            tS.values=t;
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

        if(a210==1)
            AlgoS.values=[];
        end

        if(a250==1)
            VersionContainerS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProdVersionContainerS.values=algorithm_product_version_container;
        end

        if(a370==1)
            OutlierPixelsS.values=outlier_pixels;
        end
        if(a380==1)
            CloudTopPressureS.values1=minimum_cloud_top_pressure;
        end
        if(a390==1)
            CloudTopPressureS.values2=maximum_cloud_top_pressure;
        end
        if(a400==1)
            CloudTopPressureS.values3=mean_cloud_top_pressure;
        end
        if(a410==1)
            CloudTopPressureS.values4=std_dev_cloud_top_pressure;
        end
        if(a420==1)
            LZAS.values=local_zenith_angle;
        end
        if(a430==1)
            LZABS.values=local_zenith_angle_bounds;
        end
        if(a440==1)
            SZAS.values=solar_zenith_angle;
        end
        if(a450==1)
            SZABS.values=solar_zenith_angle_bounds;          
        end
        if(a460==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors;          
        end
        if(a470==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
        end
        if(a480==1)
            CloudPixelsS.values=cloud_pixels;
        end
    end
end
disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
disp('________________________________________________________')
disp(' '),disp(' ')
% Close the file
netcdf.close(ncid);
fprintf(fid,'%s\n','Finished reading Cloud Top Pressure data');
% Get some basic data on the CloudTopPressures
ab=1;
Pressure=PressureS.values;
[nrows,ncols]=size(Pressure);
Pressure1D=reshape(Pressure,nrows*ncols,1);
PressureSort=sort(Pressure1D);
a1=isnan(PressureSort);
numnan=sum(a1);
numvals1=(nrows*ncols);
numvals=numvals1-numnan;
num10=round(.10*numvals);
num50=round(.50*numvals);
num90=round(.90*numvals);
val10=PressureSort(num10,1);
val50=PressureSort(num50,1);
val90=PressureSort(num90,1);
presmin=PressureSort(1,1);
presmax=PressureSort(numvals,1);
dispstr=strcat('Number of Pressure Values=',num2str(numvals1),'-Filled Values=',num2str(numnan),...
    '-number of good pressure values=',num2str(numvals));
disp(dispstr);
presstr1='------- Retrieving Some Stats The Cloud Top Pressure Data------';
fprintf(fid,'%s\n',presstr1);
fprintf(fid,'%s\n',dispstr);
presstr2=strcat('10 ptile Pressure=',num2str(val10));
presstr3=strcat('50 ptile Pressure=',num2str(val50));
presstr4=strcat('90 ptile Pressure=',num2str(val90));
presstr5=strcat('Min Pressure=',num2str(presmin,6),'-Max Pressure=',num2str(presmax,6),...
    '-in hPa');
disp(presstr2);
disp(presstr3);
disp(presstr4);
disp(presstr5);
fprintf(fid,'%s\n',presstr2);
fprintf(fid,'%s\n',presstr3);
fprintf(fid,'%s\n',presstr4);
fprintf(fid,'%s\n',presstr5);

ab=2;
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
% Now write a Matlab file containing the decoded data
% use the original file name with a .mat extension
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='PressureS BandDataS MetaDataS  DQFS tS yS xS tBS goesImagerS';
    varstr2=' yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS LZAS LZABS';
    varstr3=' AlgoS  VersionContainerS AlgoProdVersionContainerS OutlierPixelsS';
    varstr4=' GoesWaveBand CloudPixelsS CloudTopPressureS  GOESFileName';
    varstr5=' SZAS SZABS GRBErrorsS L0ErrorsS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    savestr1=strcat('User saved cloud top pressure data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr1);
else
    savestr2=strcat('User did not save cloud top pressure data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr2);
end
ab=1;

% Get the image west and east edges
westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
if(westEdge<-130)
    westEdge=-130;
end
eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
if(eastEdge>-60)
    eastEdge=-60;
end

northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
southEdge=double(GeoSpatialS.geospatial_southbound_latitude);
if(northEdge>60)
    northEdge=60;
end
if(southEdge<30)
    southEdge=30;
end
[numrows,numcols]=size(Pressure);
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=[(northEdge-southEdge)/numcols];
GeoRef.CellExtentInLongitude=[abs((eastEdge-westEdge))/numrows];
% Display the Cloud Top Pressures
is=1;
[ix]=strfind(GOESFileName,'_e');
ie=ix(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('CloudTopPressure-Data-',filename);
DisplayCloudTopPressureRev3(Pressure,titlestr)
titlestr=strcat('CloudTopPressure-Hist-',filename);
PlotCloudTopPresssureHistogram(Pressure,titlestr)
titlestr=strcat('Cloud-Tops-PressureCumilDist-',filename);
PlotCloudTopPressureCumilDist(Pressure,titlestr)
end