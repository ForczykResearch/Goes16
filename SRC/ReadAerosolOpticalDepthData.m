function ReadAerosolOpticalDepthData()
% Modified: This function will read in the GOES measured Aerosol Optical Depth Data
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. 
% Written By: Stephen Forczyk
% Created: Feb 11,2021
% Revised: Feb 12,2021 continue coding routine
% Revised: Feb 13,2021 continue coding routine
% Classification: Unclassified

global MetaDataS;
global AODS AODWaveS LandSenBandWS SeaSenBandWS;
global LandSenBandIDS SeaSenBandIDS;
global LatitudeBandS LatitudeBandBoundS;
global SnowFreeLandIceFreeSeaS;
global AOD550_RET_ATT_LandS AOD550_RET_ATT_SeaS;
global AOD550_Good_LZA_RET_ATTS AOD550_OutlierPixelS;
global AOD550_LandStatS AOD550_SeaStatS;
global LatBand_AOD550_LandStatS LatBand_AOD550_SeaStatS;
global LatBand_AOD550_RET_ATT_LandS LatBand_AOD550_RET_ATT_SeaS;
global LatBand_AOD550_LZA_RET_ATT_LandS LatBand_AOD550_LZA_GRET_ATT_LandS;
global LatBand_AOD550_LZA_HQRET_ATT_LandS;
global LatBand_AOD550_LZA_MQRET_ATT_LandS LatBand_AOD550_LZA_LQRET_ATT_LandS;
global LatBand_AOD550_LZA_NRET_ATT_LandS;
global LatBand_AOD550_LZA_GRET_ATT_SeaS LatBand_AOD550_LZA_HQRET_ATT_SeaS;
global LatBand_AOD550_LZA_MQRET_ATT_SeaS;
global LatBand_AOD550_LZA_LQRET_ATT_SeaS LatBand_AOD550_LZA_NRET_ATT_SeaS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS ;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SunGlintS SunGlintBS;
global RLZAS RLZABS RSZAS QSZAS RSZABS QSZABS;
global GRBErrorsS L0ErrorsS;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global RasterLats RasterLons;
global idebug isavefiles;
global iReport
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath fid gridpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start reading Aerosol Optical Depth Data----');
iReport(63,1)=iReport(63,1)+1;
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
AODS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'Unsigned',[],'valid_range',[],'scale_factor',[],'add_offset',[],...
    'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'ancillary_variables',[]);
SunGlintS=struct('values',[],'long_name',[]);
SunGlintBS=SunGlintS;
AODWaveS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
LandSenBandWS=AODWaveS;
SeaSenBandWS=AODWaveS;
LandSenBandIDS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
SeaSenBandIDS=LandSenBandIDS;
LatitudeBandS=struct('values',[],'long_name',[],'standard_name',[],'units',[],...
    'axis',[],'bounds',[]);
LatitudeBandBoundS=struct('values',[],'long_name',[]);
SnowFreeLandIceFreeSeaS=struct('values',[],'long_name',[],'standard_name',[]);
AOD550_RET_ATT_LandS=struct('values',[],'long_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
AOD550_RET_ATT_SeaS=AOD550_RET_ATT_LandS;
AOD550_Good_LZA_RET_ATTS=AOD550_RET_ATT_LandS;
AOD550_OutlierPixelS=AOD550_RET_ATT_LandS;
LatBand_AOD550_RET_ATT_SeaS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_GRET_ATT_LandS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_HQRET_ATT_LandS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_MQRET_ATT_LandS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_LQRET_ATT_LandS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_NRET_ATT_LandS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_GRET_ATT_SeaS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_HQRET_ATT_SeaS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_MQRET_ATT_SeaS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_LQRET_ATT_SeaS=LatBand_AOD550_RET_ATT_LandS;
LatBand_AOD550_LZA_NRET_ATT_SeaS=LatBand_AOD550_RET_ATT_LandS;
AOD550_LandStatS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
AOD550_SeaStatS=AOD550_LandStatS;
LatBand_AOD550_LandStatS=AOD550_LandStatS;
LatBand_AOD550_SeaStatS=AOD550_LandStatS;
RSZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
QSZAS=RSZAS;
RSZABS=struct('values',[],'long_name',[]);
QSZABS=RSZABS;
RLZABS=struct('value',[],'long_name',[]);
QLZAS=struct('value',[],'long_name',[],'standard_name',[],...
    'units',[],'bounds',[]);
QLZABS=struct('value',[],'long_name',[]);
RLZAS=struct('value',[],'long_name',[],'standard_name',[]);

DQFS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'pct_high_quality_retrieval_qf',[],...
    'pct_medium_quality_retrieval_qf',[],...
    'pct_low_quality_retrieval_qf',[],...
    'pct_no_retrieval_qf',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[]);
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
AlgoS=struct('values',[],'long_name',[],...
    'input_ABI_L2_auxiliary_solar_zenith_angle_data',[],...
    'input_ABI_L2_auxiliary_solar_azimuth_angle_data',[],...
    'input_ABI_L2_aux_sun_satellite_relative_azimuth_angle_data',[],...
    'input_ABI_L2_total_precipitable_water_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_1_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_2_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_3_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_4_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_5_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_6_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'input_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...
    'input_ABI_L2_intermediate_product_binary_snow_mask_data',[],...
    'input_dynamic_ancillary_global_snow_mask_data',[],...
    'input_dynamic_ancillary_NWP_total_precipitable_water_data',[],...
    'input_dynamic_ancillary_NWP_total_column_ozone_data',[],...
    'input_dynamic_ancillary_NWP_surface_wind_vector_data',[],...
    'input_dynamic_ancillary_NWP_surface_pressure_data',[],...
    'input_dynamic_ancillary_NWP_surface_geopotential_height_data',[]);
GRBErrorsS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'coordinates',[],'cell_methods',[]);
L0ErrorsS=GRBErrorsS;
ProcessParamS=struct('values',[],'long_name',[],'L2_processing_parm_version',[]);
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
    if(idebug==1)
        disp(['--------------------< ' varname ' >---------------------'])
        dispstr=strcat('--------------',varname,'--------------');
        fprintf(fid,'\n');
        fprintf(fid,'%s\n',dispstr);
    end
        flag = 0;
    for j = 0:numatts - 1
        a10=strcmp(varname,'AOD');
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
        a160=strcmp(varname,'sunglint_angle');
        a170=strcmp(varname,'sunglint_angle_bounds');
        a240=strcmp(varname,'algorithm_dynamic_input_data_container');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'retrieval_local_zenith_angle');
        a280=strcmp(varname,'quantitative_local_zenith_angle');
        a290=strcmp(varname,'retrieval_local_zenith_angle_bounds');
        a300=strcmp(varname,'quantitative_local_zenith_angle_bounds');
        a310=strcmp(varname,'retrieval_solar_zenith_angle');
        a320=strcmp(varname,'quantitative_solar_zenith_angle');
        a330=strcmp(varname,'retrieval_solar_zenith_angle_bounds');
        a340=strcmp(varname,'quantitative_solar_zenith_angle_bounds');
        a460=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a470=strcmp(varname,'percent_uncorrectable_L0_errors');
        a500=strcmp(varname,'aod_product_wavelength');
        a510=strcmp(varname,'land_sensor_band_wavelengths');
        a520=strcmp(varname,'sea_sensor_band_wavelengths');
        a530=strcmp(varname,'land_sensor_band_ids');
        a540=strcmp(varname,'sea_sensor_band_ids');
        a550=strcmp(varname,'latitude_bands');
        a560=strcmp(varname,'latitude_band_bounds');
        a570=strcmp(varname,'snow_free_land_and_ice_free_sea');
        a580=strcmp(varname,'aod550_retrievals_attempted_land');
        a590=strcmp(varname,'aod550_retrievals_attempted_sea');
        a600=strcmp(varname,'aod550_good_LZA_retrievals_attempted');
        a610=strcmp(varname,'aod550_outlier_pixel_count');
        a620=strcmp(varname,'min_aod550_land');
        a630=strcmp(varname,'max_aod550_land');
        a640=strcmp(varname,'mean_aod550_land');
        a650=strcmp(varname,'std_dev_aod550_land');
        a660=strcmp(varname,'min_aod550_sea');
        a670=strcmp(varname,'max_aod550_sea');
        a680=strcmp(varname,'mean_aod550_sea');
        a690=strcmp(varname,'std_dev_aod550_sea');
        a700=strcmp(varname,'lat_band_aod550_retrievals_attempted_land');
        a710=strcmp(varname,'lat_band_aod550_retrievals_attempted_sea');
        a720=strcmp(varname,'lat_band_aod550_good_LZA_retrievals_attempted_land');
        a730=strcmp(varname,'lat_band_aod550_percent_high_quality_retrievals_land');
        a740=strcmp(varname,'lat_band_aod550_percent_medium_quality_retrievals_land');
        a750=strcmp(varname,'lat_band_aod550_percent_low_quality_retrievals_land');
        a760=strcmp(varname,'lat_band_aod550_percent_no_retrievals_land');
        a770=strcmp(varname,'lat_band_aod550_good_LZA_retrievals_attempted_sea');
        a780=strcmp(varname,'lat_band_aod550_percent_high_quality_retrievals_sea');
        a790=strcmp(varname,'lat_band_aod550_percent_medium_quality_retrievals_sea');
        a800=strcmp(varname,'lat_band_aod550_percent_low_quality_retrievals_sea');
        a810=strcmp(varname,'lat_band_aod550_percent_no_retrievals_sea');
        a820=strcmp(varname,'lat_band_min_aod550_land');
        a830=strcmp(varname,'lat_band_max_aod550_land');
        a840=strcmp(varname,'lat_band_mean_aod550_land');
        a850=strcmp(varname,'lat_band_std_dev_aod550_land');
        a860=strcmp(varname,'lat_band_min_aod550_sea');
        a870=strcmp(varname,'lat_band_max_aod550_sea');
        a880=strcmp(varname,'lat_band_mean_aod550_sea');
        a890=strcmp(varname,'lat_band_std_dev_aod550_sea');
        if (a10==1)            
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)]);
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
                AODS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AODS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AODS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                AODS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AODS.valid_range=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                AODS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                AODS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AODS.units=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                AODS.resolution=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AODS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AODS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AODS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                AODS.ancillary_variables=attname2;
            end
        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)]);
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQFS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQFS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQFS.Unsigned=attname2;
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
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DQFS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'flag_masks');
            if(a1==1)
                DQFS.flag_masks=attname2;
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
            a1=strcmp(attname1,'percent_high_quality_retrieval_qf');
            if(a1==1)
                DQFS.pct_high_quality_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'percent_medium_quality_retrieval_qf');
            if(a1==1)
                DQFS.pct_medium_quality_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'percent_low_quality_retrieval_qf');
            if(a1==1)
                DQFS.pct_low_quality_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_retrieval_qf');
            if(a1==1)
                DQFS.pct_no_retrieval_qf=attname2;
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
        elseif (a160==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SunGlintS.long_name=attname2;
            end
        elseif (a170==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SunGlintBS.long_name=attname2;
            end
        elseif (a240==1)
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
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_solar_zenith_angle_data');
            if(a1==1)
                AlgoS.input_ABI_L2_auxiliary_solar_zenith_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_solar_azimuth_angle_data');
            if(a1==1)
                AlgoS.input_ABI_L2_auxiliary_solar_azimuth_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_sun_satellite_relative_azimuth_angle_data');
            if(a1==1)
                AlgoS.input_ABI_L2_aux_sun_satellite_relative_azimuth_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_total_precipitable_water_data');
            if(a1==1)
                AlgoS.input_ABI_L2_total_precipitable_water_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_1_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_reflectance_band_1_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_2_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_reflectance_band_2_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_3_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_reflectance_band_3_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_4_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_reflectance_band_4_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_5_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_reflectance_band_5_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_6_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_reflectance_band_6_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_4_level_cloud_mask_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_4_level_cloud_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_5_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_reflectance_band_5_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_6_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_reflectance_band_6_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_binary_snow_mask_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_binary_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_global_snow_mask_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_global_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_total_precipitable_water_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_total_precipitable_water_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_total_column_ozone_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_total_column_ozone_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_wind_vector_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_wind_vector_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_pressure_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_pressure_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_geopotential_height_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_geopotential_height_data=attname2;
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
                ProcessParamS.long_name=attname2;
            end
            a1=strcmp(attname1,'L2_processing_parm_version');
            if(a1==1)
                ProcessParamS.L2_processing_parm_version=attname2;
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
        elseif (a270==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                RLZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RLZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RLZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                RLZAS.bounds=attname2;
            end
        elseif (a280==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                QLZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                QLZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                QLZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                QLZAS.bounds=attname2;
            end
         elseif (a290==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                RLZABS.long_name=attname2;
            end
         elseif (a300==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                QLZABS.long_name=attname2;
            end
        elseif (a310==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                RSZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RSZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RSZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                RSZAS.bounds=attname2;
            end
        elseif (a320==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                QSZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                QSZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                QSZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                QSZAS.bounds=attname2;
            end
         elseif (a330==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                RSZABS.long_name=attname2;
            end
         elseif (a340==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                QSZABS.long_name=attname2;
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
        elseif (a500==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AODWaveS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AODWaveS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AODWaveS.units=attname2;
            end
        elseif (a510==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LandSenBandWS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LandSenBandWS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LandSenBandWS.units=attname2;
            end
        elseif (a520==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SeaSenBandWS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SeaSenBandWS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SeaSenBandWS.units=attname2;
            end
        elseif (a530==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LandSenBandIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LandSenBandIDS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LandSenBandIDS.units=attname2;
            end
        elseif (a540==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SeaSenBandIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SeaSenBandIDS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SeaSenBandIDS.units=attname2;
            end
        elseif (a550==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatitudeBandS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatitudeBandS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatitudeBandS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LatitudeBandS.axis=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                LatitudeBandS.bounds=attname2;
            end
        elseif (a560==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatitudeBandBoundS.long_name=attname2;
            end
       elseif (a570==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SnowFreeLandIceFreeSeaS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SnowFreeLandIceFreeSeaS.standard_name=attname2;
            end
        elseif (a580==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_RET_ATT_LandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_RET_ATT_LandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_RET_ATT_LandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_RET_ATT_LandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_RET_ATT_LandS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_RET_ATT_LandS.grid_mapping=attname2;
            end
        elseif (a590==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_RET_ATT_SeaS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_RET_ATT_SeaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_RET_ATT_SeaS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_RET_ATT_SeaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_RET_ATT_SeaS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_RET_ATT_SeaS.grid_mapping=attname2;
            end
        elseif (a600==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_Good_LZA_RET_ATTS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_Good_LZA_RET_ATTS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_Good_LZA_RET_ATTS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_Good_LZA_RET_ATTS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_Good_LZA_RET_ATTS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_Good_LZA_RET_ATTS.grid_mapping=attname2;
            end
        elseif (a610==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_OutlierPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_OutlierPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_OutlierPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_OutlierPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_OutlierPixelS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_OutlierPixelS.grid_mapping=attname2;
            end
        elseif (a620==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_LandStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AOD550_LandStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_LandStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AOD550_LandStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_LandStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_LandStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_LandStatS.cell_methods1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_LandStatS.grid_mapping1=attname2;
            end
        elseif (a630==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_LandStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AOD550_LandStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_LandStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AOD550_LandStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_LandStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_LandStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_LandStatS.cell_methods2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_LandStatS.grid_mapping2=attname2;
            end
        elseif (a640==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_LandStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AOD550_LandStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_LandStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AOD550_LandStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_LandStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_LandStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_LandStatS.cell_methods3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_LandStatS.grid_mapping3=attname2;
            end
        elseif (a650==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_LandStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AOD550_LandStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_LandStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AOD550_LandStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_LandStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_LandStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_LandStatS.cell_methods4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_LandStatS.grid_mapping4=attname2;
            end
        elseif (a660==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_SeaStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AOD550_SeaStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_SeaStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AOD550_SeaStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_SeaStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_SeaStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_SeaStatS.cell_methods1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_SeaStatS.grid_mapping1=attname2;
            end
        elseif (a670==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_SeaStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AOD550_SeaStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_SeaStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AOD550_SeaStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_SeaStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_SeaStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_SeaStatS.cell_methods2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_SeaStatS.grid_mapping2=attname2;
            end
        elseif (a680==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_SeaStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AOD550_SeaStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_SeaStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AOD550_SeaStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_SeaStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_SeaStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_SeaStatS.cell_methods3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_SeaStatS.grid_mapping3=attname2;
            end
        elseif (a690==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AOD550_SeaStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AOD550_SeaStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AOD550_SeaStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AOD550_SeaStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AOD550_SeaStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AOD550_SeaStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AOD550_SeaStatS.cell_methods4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AOD550_SeaStatS.grid_mapping4=attname2;
            end
        elseif (a700==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_RET_ATT_LandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_RET_ATT_LandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_RET_ATT_LandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_RET_ATT_LandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_RET_ATT_LandS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_RET_ATT_LandS.grid_mapping=attname2;
            end
        elseif (a710==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_RET_ATT_SeaS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_RET_ATT_SeaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_RET_ATT_SeaS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_RET_ATT_SeaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_RET_ATT_SeaS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_RET_ATT_SeaS.grid_mapping=attname2;
            end
        elseif (a720==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_LandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_LandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_LandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_LandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_LandS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_LandS.grid_mapping=attname2;
            end
        elseif (a730==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_LandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_LandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_LandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_LandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_LandS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_LandS.grid_mapping=attname2;
            end
        elseif (a740==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_LandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_LandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_LandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_LandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_LandS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_LandS.grid_mapping=attname2;
            end
        elseif (a750==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_LandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_LandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_LandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_LandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_LandS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_LandS.grid_mapping=attname2;
            end
        elseif (a760==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_LandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_LandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_LandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_LandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_LandS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_LandS.grid_mapping=attname2;
            end
        elseif (a770==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_SeaS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_SeaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_SeaS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_SeaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_SeaS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_GRET_ATT_SeaS.grid_mapping=attname2;
            end
        elseif (a780==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_SeaS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_SeaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_SeaS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_SeaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_SeaS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_HQRET_ATT_SeaS.grid_mapping=attname2;
            end
        elseif (a790==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_SeaS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_SeaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_SeaS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_SeaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_SeaS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_MQRET_ATT_SeaS.grid_mapping=attname2;
            end
        elseif (a800==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_SeaS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_SeaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_SeaS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_SeaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_SeaS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_LQRET_ATT_SeaS.grid_mapping=attname2;
            end
        elseif (a810==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_SeaS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_SeaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_SeaS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_SeaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_SeaS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LZA_NRET_ATT_SeaS.grid_mapping=attname2;
            end
        elseif (a820==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LandStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatBand_AOD550_LandStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LandStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LatBand_AOD550_LandStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LandStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LandStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LandStatS.cell_methods1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LandStatS.grid_mapping1=attname2;
            end
        elseif (a830==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LandStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatBand_AOD550_LandStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LandStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LatBand_AOD550_LandStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LandStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LandStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LandStatS.cell_methods2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LandStatS.grid_mapping2=attname2;
            end
        elseif (a840==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LandStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatBand_AOD550_LandStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LandStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LatBand_AOD550_LandStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LandStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LandStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LandStatS.cell_methods3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LandStatS.grid_mapping3=attname2;
            end
         elseif (a850==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_LandStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatBand_AOD550_LandStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_LandStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LatBand_AOD550_LandStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_LandStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_LandStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_LandStatS.cell_methods4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_LandStatS.grid_mapping4=attname2;
            end
        elseif (a860==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_SeaStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatBand_AOD550_SeaStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_SeaStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LatBand_AOD550_SeaStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_SeaStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_SeaStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_SeaStatS.cell_methods1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_SeaStatS.grid_mapping1=attname2;
            end
        elseif (a870==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_SeaStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatBand_AOD550_SeaStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_SeaStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LatBand_AOD550_SeaStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_SeaStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_SeaStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_SeaStatS.cell_methods2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_SeaStatS.grid_mapping2=attname2;
            end
        elseif (a880==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_SeaStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatBand_AOD550_SeaStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_SeaStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LatBand_AOD550_SeaStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_SeaStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_SeaStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_SeaStatS.cell_methods3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_SeaStatS.grid_mapping3=attname2;
            end
         elseif (a890==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatBand_AOD550_SeaStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatBand_AOD550_SeaStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatBand_AOD550_SeaStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LatBand_AOD550_SeaStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatBand_AOD550_SeaStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LatBand_AOD550_SeaStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LatBand_AOD550_SeaStatS.cell_methods4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LatBand_AOD550_SeaStatS.grid_mapping4=attname2;
            end
       else
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end   
        end
    end
    if(idebug==1)
        disp(' ')
    end
    if flag
       if(a10==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            AODV=AOD;
            FillValue=AODS.FillValue;
            scale=AODS.scale_factor;
            offset=AODS.add_offset;
            [nrows,ncols]=size(AOD);
            [AODV,numnanvals] = ReplaceFillValues(AODV,FillValue);
             level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=AODV(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           AODV(ik,jk)=corval;
                      end
                   end
               end
               scale2=double(scale);
               offset2=double(offset);
               AODV2=AODV'*scale2+offset2;
               AODS.values=AODV2;
               clear AODV AODV2
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
        if(a160==1)
            SunGlintS.values=sunglint_angle;
        end
        if(a170==1)
            SunGlintBS.values=sunglint_angle_bounds;
        end

        if(a240==1)
            AlgoS.values='null';
        end
        if(a250==1)
            ProcessParamS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProdVersionContainerS.values=algorithm_product_version_container;
        end
        if(a270==1)
            RLZAS.value=retrieval_local_zenith_angle;
        end
        if(a280==1)
            QLZAS.value=quantitative_local_zenith_angle;
        end
        if(a290==1)
            RLZABS.value=retrieval_local_zenith_angle_bounds;
        end
        if(a300==1)
            QLZABS.value=quantitative_local_zenith_angle_bounds;
        end
        if(a310==1)
            RSZAS.values=retrieval_solar_zenith_angle;
        end
        if(a320==1)
            QSZAS.values=quantitative_solar_zenith_angle;
        end
        if(a330==1)
            RSZABS.values=retrieval_solar_zenith_angle_bounds;
        end
        if(a340==1)
            QSZABS.values=quantitative_solar_zenith_angle_bounds;
        end
        if(a460==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors;          
        end
        if(a470==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
        end
        if(a500==1)
            AODWaveS.values=aod_product_wavelength;
        end
        if(a510==1)
            LandSenBandWS.values=land_sensor_band_wavelengths;
        end
        if(a520==1)
            SeaSenBandWS.values=sea_sensor_band_wavelengths;
        end
        if(a530==1)
            LandSenBandIDS.values=land_sensor_band_ids;
        end
        if(a540==1)
            SeaSenBandIDS.values=sea_sensor_band_ids;
        end
        if(a550==1)
            LatitudeBandS.values=latitude_bands;
        end
        if(a560==1)
            LatitudeBandBoundS.values=latitude_band_bounds;            
        end
        if(a570==1)
            SnowFreeLandIceFreeSeaS.values=snow_free_land_and_ice_free_sea; 
        end
        if(a580==1)
            AOD550_RET_ATT_LandS.values=aod550_retrievals_attempted_land; 
        end
        if(a590==1)
            AOD550_RET_ATT_SeaS.values=aod550_retrievals_attempted_sea;
        end
        if(a600==1)
            AOD550_Good_LZA_RET_ATTS.values=aod550_good_LZA_retrievals_attempted;
        end
        if(a610==1)
            AOD550_OutlierPixelS.values=aod550_outlier_pixel_count;
        end
        if(a620==1)
            AOD550_LandStatS.values1=min_aod550_land;
        end
        if(a630==1)
            AOD550_LandStatS.values2=max_aod550_land;
        end
        if(a640==1)
            AOD550_LandStatS.values3=mean_aod550_land;
        end
        if(a650==1)
            AOD550_LandStatS.values4=std_dev_aod550_land;
        end
        if(a660==1)
            AOD550_SeaStatS.values1=min_aod550_sea;
        end
        if(a670==1)
            AOD550_SeaStatS.values2=max_aod550_sea;
        end
        if(a680==1)
            AOD550_SeaStatS.values3=mean_aod550_sea;
        end
        if(a690==1)
            AOD550_SeaStatS.values4=std_dev_aod550_sea;
        end
        if(a700==1)
            LatBand_AOD550_RET_ATT_LandS.values=lat_band_aod550_retrievals_attempted_land;
        end
        if(a710==1)
            LatBand_AOD550_RET_ATT_SeaS.values=lat_band_aod550_retrievals_attempted_sea;
        end
        if(a720==1)
            LatBand_AOD550_LZA_GRET_ATT_LandS.values=lat_band_aod550_good_LZA_retrievals_attempted_land;
        end
        if(a730==1)
            LatBand_AOD550_LZA_HQRET_ATT_LandS.values=lat_band_aod550_percent_high_quality_retrievals_land;
        end
        if(a740==1)
            LatBand_AOD550_LZA_MQRET_ATT_LandS.values=lat_band_aod550_percent_medium_quality_retrievals_land;
        end
        if(a750==1)
            LatBand_AOD550_LZA_LQRET_ATT_LandS.values=lat_band_aod550_percent_low_quality_retrievals_land;
        end
        if(a760==1)
            LatBand_AOD550_LZA_NRET_ATT_LandS.values=lat_band_aod550_percent_no_retrievals_land;
        end
        if(a770==1)
            LatBand_AOD550_LZA_GRET_ATT_SeaS.values=lat_band_aod550_good_LZA_retrievals_attempted_sea;
        end
        if(a780==1)
            LatBand_AOD550_LZA_HQRET_ATT_SeaS.values=lat_band_aod550_percent_high_quality_retrievals_sea;
        end
        if(a790==1)
            LatBand_AOD550_LZA_MQRET_ATT_SeaS.values=lat_band_aod550_percent_medium_quality_retrievals_sea;
        end
        if(a800==1)
            LatBand_AOD550_LZA_LQRET_ATT_SeaS.values=lat_band_aod550_percent_low_quality_retrievals_sea;
        end
        if(a810==1)
            LatBand_AOD550_LZA_NRET_ATT_SeaS.values=lat_band_aod550_percent_no_retrievals_sea;
        end
        if(a820==1)
            LatBand_AOD550_LandStatS.values1=lat_band_min_aod550_land;
        end
        if(a830==1)
            LatBand_AOD550_LandStatS.values2=lat_band_max_aod550_land;
        end
        if(a840==1)
            LatBand_AOD550_LandStatS.values3=lat_band_mean_aod550_land;
        end
        if(a850==1)
            LatBand_AOD550_LandStatS.values4=lat_band_std_dev_aod550_land;
        end
        if(a860==1)
            LatBand_AOD550_SeaStatS.values1=lat_band_min_aod550_sea;
        end
        if(a870==1)
            LatBand_AOD550_SeaStatS.values2=lat_band_max_aod550_sea;
        end
        if(a880==1)
            LatBand_AOD550_SeaStatS.values3=lat_band_mean_aod550_sea;
        end
        if(a890==1)
            LatBand_AOD550_SeaStatS.values4=lat_band_std_dev_aod550_sea;
        end
    end
end
if(idebug==1)
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp('________________________________________________________')
    disp(' '),disp(' ')
end
% Close the file
netcdf.close(ncid);
fprintf(fid,'%s\n','Finished Reading Aerosol Optical Depth data');
[iper]=strfind(GOESFileName,'.');

is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='AODS AODWaveS LandSenBandWS SeaSenBandWS tS yS xS tBS goesImagerS';
    varstr2=' MetaDataS DQFS yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS ';
    varstr3=' AlgoS AlgoProdVersionContainerS LandSenBandIDS SeaSenBandIDS';
    varstr4=' GoesWaveBand GOESFileName RLZAS QLZAS LatitudeBandS LatitudeBandBoundS';
    varstr5=' GRBErrorsS L0ErrorsS SnowFreeLandIceFreeSeaS';
    varstr6=' RSZAS RSZABS AOD550_RET_ATT_LandS AOD550_RET_ATT_SeaS';
    varstr7=' QSZAS QSZABS LatBand_AOD550_LZA_GRET_ATT_LandS LatBand_AOD550_LZA_RET_ATT_LandS';
    varstr8=' LatBand_AOD550_LZA_HQRET_ATT_LandS LatBand_AOD550_LZA_MQRET_ATT_LandS LatBand_AOD550_LZA_LQRET_ATT_LandS';
    varstr9=' LatBand_AOD550_LZA_NRET_ATT_LandS LatBand_AOD550_LZA_GRET_ATT_SeaS LatBand_AOD550_LZA_HQRET_ATT_SeaS';
    varstr10=' LatBand_AOD550_LZA_MQRET_ATT_SeaS LatBand_AOD550_LZA_LQRET_ATT_SeaS LatBand_AOD550_LZA_NRET_ATT_SeaS';
    varstr11=' AOD550_LandStatS AOD550_SeaStatS AOD550_Good_LZA_RET_ATTS AOD550_OutlierPixelS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7,varstr8);
    varstr=strcat(varstr,varstr9,varstr10,varstr11);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    savestr1=strcat('User saved Aerosol data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr1);
else
    savestr2=strcat('User did not save Aerosol data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr2);
end
% Get the image west and east edges
westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
southEdge=double(GeoSpatialS.geospatial_southbound_latitude);
geostr1=strcat('West Edge Lon=',num2str(westEdge,6),...
    '-East Edge Lon=',num2str(eastEdge,6));
fprintf(fid,'%s\n',geostr1);
geostr2=strcat('South Edge Lat=',num2str(southEdge,6),...
    '-North Edge Lat=',num2str(northEdge,6));
fprintf(fid,'%s\n',geostr2);
[numrows,numcols]=size(AODS.values);
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=(northEdge-southEdge)/numcols;
GeoRef.CellExtentInLongitude=abs((eastEdge-westEdge))/numrows;
datastr1=strcat('Aerosol Data array dimensions nrows=',num2str(numrows),...
    '-ncols=',num2str(numcols));
fprintf(fid,'%s\n',datastr1);
% Display the Aerosol Optical Depth Data
[imatch]=strfind(GOESFileName,'_e');
is=1;
ie=imatch(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('AerosolOpticalDepth-',filename);
[AOD1DSF,sgoodfrac]=DisplayConusAerosolOpticalDepth(titlestr);
titlestr=strcat('AOD-DataQuality-Factors-',filename);
DisplayConusAerosolOpticalDepthDQF(titlestr)
% Make a histogram plot of the AOD values
titlestr=strcat('AerosolOpticalDepthHistogram-',filename);
[ValidAOD]=PlotAODHistogram(AOD1DSF,sgoodfrac,titlestr);
titlestr=strcat('AODCumilDist-',filename);
PlotAODCumilDist(ValidAOD,sgoodfrac,titlestr);
fprintf(fid,'%s\n','Finished Processing Aerosol Optical Depth data');
disp('-----Finished Aerosol Data-----');
end