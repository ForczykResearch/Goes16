function ReadClearSkyMask()
% Modified: This function will read in the GOES Cloud Top Temperature Data
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. I wrote this since can't find a function in the
% built-in set of netCDF functions included in MATLAB that displays all 
% header info of the file (equivalent to the old 'ncdump' function). 
%
% Replace the string 'filename.nc' with the file name you want to load.
% Make sure that the nc-file is located in the same folder as this script.
% This file reads the clear sky mask data
% stored as 16 bit unsigned values
% Written By: Stephen Forczyk
% Created: Nov 28,2020
% Revised: Jan 21,2021 made changes to add output to PDF report
% Classification: Unclassified

global MetaDataS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global CloudTopPressureS CloudMaskPtsS;
global NumClearPixelsS NumProbClearPixelsS NumProbCloudyPixelsS;
global NumCloudyPixelsS;
global PctClearPixelsS PctProbClearPixelsS PctProbCloudyPixelsS;
global PctCloudyPixelsS PctTerminatorPixelsS;
global RTM_BT_AllSkyS RTM_BT_ClearSkyS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global RLZAS QLZAS RLZABS QLZABS;
global RSZAS TSZAS RSZABS TSZABS;
global RTMBT_CWS RTMBT_BIDS;
global GRBErrorsS L0ErrorsS;
global BCMS;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global pctclearpix pctprobclearpix pctprobcloudypix pctcloudypix;
global idebug isavefiles;
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath fid gridpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start reading Clear Sky Mask data-----');

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
BCMS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],'Unsigned',[],...
    'valid_range',[],'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'flag_values',[],'flag_meanings',[],'ancillary_variables',[],...
    'clear_pixel_definition',[],'probably_clear_pixel_definition',[],...
    'probably_cloudy_pixel_definition',[],'cloudy_pixel_definition',[]);
CloudMaskPtsS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
NumClearPixelsS=CloudMaskPtsS;
NumProbClearPixelsS=NumClearPixelsS;
NumProbCloudyPixelsS=NumClearPixelsS;
NumCloudyPixelsS=NumClearPixelsS;
PctClearPixelsS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'valid_range',[],'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
PctProbClearPixelsS=PctClearPixelsS;
PctProbCloudyPixelsS=PctClearPixelsS;
PctCloudyPixelsS=PctClearPixelsS;
PctTerminatorPixelsS=PctClearPixelsS;
RTM_BT_AllSkyS=struct('values1',[],'long_name1',[],'FillValue1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],'units3',[],...
    'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'FillValue4',[],'units4',[],...
    'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
RTM_BT_ClearSkyS=RTM_BT_AllSkyS;
RLZAS=struct('value',[],'long_name',[],'standard_name',[],...
    'units',[],'bounds',[]);
QLZAS=RLZAS;
RLZABS=struct('value',[],'long_name',[]);
QLZABS=struct('value',[],'long_name',[]);
RSZABS=RLZABS;
TSZABS=RLZABS;
RSZAS=RLZAS;
TSZAS=RLZAS;
RTMBT_CWS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
RTMBT_BIDS=RTMBT_CWS;
PressureS=struct('values',[],'long_name',[],'standard_name',[],...
    'FillValue',[],'Unsigned',[],'valid_range',[],'scale_factor',[],'add_offset',[],...
    'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],'cell_methods',[],...
    'ancillary_variables',[]);
DQFS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'percent_good_quality_qf',[],'percent_invalid_due_to_not_geolocated_qf',[],...
    'percent_degraded_due_to_LZA_threshold_exceeded_qf',[],...
    'pct_inval_due_to_bad_or_missing_input_band_14_bright_temp_qf',[],...
    'percent_degraded_due_to_bad_input_band_7_pixel_qf',[],...
    'percent_degraded_due_to_failed_band_2_tests_qf',[],...
    'percent_degraded_due_to_other_bad_bands_qf',[]);
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
OutlierPixelsS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
AlgoS=struct('values',[],'long_name',[],'input_ABI_L2_auxiliary_solar_zenith_angle_data',[],...
    'inp_ABI_L2_auxiliary_scattering_angle_data',[],...
    'inp_ABI_L2_auxiliary_sunglint_angle_data',[],...
    'inp_ABI_L1b_radiance_band_7_2km_data',[],...
    'inp_ABI_L1b_radiance_band_14_2km_data',[],...
    'inp_ABI_L2_brightness_temperature_band_9_2km_data',[],...
    'inp_ABI_L2_brightness_temperature_band_10_2km_data',[],...;
    'inp_ABI_L2_brightness_temperature_band_11_2km_data',[],...
    'inp_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'inp_ABI_L2_brightness_temperature_band_15_2km_data',[],...
    'inp_ABI_L2_brightness_temperature_band_16_2km_data',[],...
    'inp_ABI_L2_intermediate_product_reflectance_band_2_2km_data',[],...;
    'inp_ABI_L2_intermediate_product_reflectance_band_4_2km_data',[],...
    'inp_ABI_L2_intermediate_product_reflectance_band_5_2km_data',[],...
    'inp_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...;
    'inp_ABI_L2_interm_product_CRTM_clear_sky_radiance_band_7_data',[],...
    'inp_ABI_L2_interm_product_CRTM_clear_sky_radiance_band_14_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_14_prof_data',[],...;
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_7_prof_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_bright_temp_band_15_data',[],...
    'inp_dynamic_ancillary_global_snow_mask_data',[],...;
    'inp_dynamic_ancillary_NWP_snow_mask_data',[],...
    'inp_dynamic_ancillary_NWP_surface_temperature_data',[],...
    'inp_dynamic_ancillary_NWP_total_precipitable_water_data',[],...;
    'inp_dynamic_ancillary_NWP_total_column_ozone_data',[],...
    'inp_dynamic_ancillary_NWP_surface_level_index_data',[],...
    'inp_dynamic_ancillary_NWP_tropopause_level_index_data',[]);

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
        a10=strcmp(varname,'BCM');
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
        a160=strcmp(varname,'total_number_of_cloud_mask_points');
        a170=strcmp(varname,'number_of_clear_pixels');
        a180=strcmp(varname,'number_of_probably_clear_pixels');
        a190=strcmp(varname,'number_of_probably_cloudy_pixels');
        a200=strcmp(varname,'number_of_cloudy_pixels');
        a210=strcmp(varname,'algorithm_dynamic_input_data_container');
        a220=strcmp(varname,'percent_clear_pixels');
        a230=strcmp(varname,'percent_probably_clear_pixels');
        a240=strcmp(varname,'percent_probably_cloudy_pixels');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'percent_cloudy_pixels');
        a280=strcmp(varname,'percent_terminator_pixels');
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
        a490=strcmp(varname,'min_obs_modeled_diff_RTM_BT_comparison_bands_all_sky');
        a500=strcmp(varname,'max_obs_modeled_diff_RTM_BT_comparison_bands_all_sky');
        a510=strcmp(varname,'mean_obs_modeled_diff_RTM_BT_comparison_bands_all_sky');
        a520=strcmp(varname,'std_dev_obs_modeled_diff_RTM_BT_comparison_bands_all_sky');
        a530=strcmp(varname,'min_obs_modeled_diff_RTM_BT_comparison_bands_clear_sky');
        a540=strcmp(varname,'max_obs_modeled_diff_RTM_BT_comparison_bands_clear_sky');
        a550=strcmp(varname,'mean_obs_modeled_diff_RTM_BT_comparison_bands_clear_sky');
        a560=strcmp(varname,'std_dev_obs_modeled_diff_RTM_BT_comparison_bands_clear_sky');
        a570=strcmp(varname,'retrieval_local_zenith_angle');
        a580=strcmp(varname,'quantitative_local_zenith_angle');
        a590=strcmp(varname,'retrieval_local_zenith_angle_bounds');
        a600=strcmp(varname,'quantitative_local_zenith_angle_bounds');
        a610=strcmp(varname,'retrieval_solar_zenith_angle');
        a620=strcmp(varname,'twilight_solar_zenith_angle');
        a630=strcmp(varname,'retrieval_solar_zenith_angle_bounds');
        a640=strcmp(varname,'twilight_solar_zenith_angle_bounds');
        a650=strcmp(varname,'RTM_BT_comparison_wavelengths');
        a660=strcmp(varname,'RTM_BT_comparison_band_ids');
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
                BCMS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BCMS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BCMS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');

            a1=strcmp(attname1,'resolution');
            if(a1==1)
                BCMS.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BCMS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                BCMS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BCMS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                BCMS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BCMS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BCMS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BCMS.coordinates=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                BCMS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                BCMS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'clear_pixel_definition');
            if(a1==1)
                BCMS.clear_pixel_definition=attname2;
            end
            a1=strcmp(attname1,'probably_clear_pixel_definition');
            if(a1==1)
                BCMS.probably_clear_pixel_definition=attname2;
            end
            a1=strcmp(attname1,'probably_cloudy_pixel_definition');
            if(a1==1)
                BCMS.probably_cloudy_pixel_definition=attname2;
            end
            a1=strcmp(attname1,'cloudy_pixel_definition');
            if(a1==1)
                BCMS.cloudy_pixel_definition=attname2;
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
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQFS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DQFS.cell_methods=attname2;
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
            a1=strcmp(attname1,'percent_good_quality_qf');
            if(a1==1)
                DQFS.percent_good_quality_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_not_geolocated_or_algorithm_non_execution_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_not_geolocated_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_LZA_threshold_exceeded_qf');
            if(a1==1)
                DQFS.percent_degraded_due_to_LZA_threshold_exceeded_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_bad_or_missing_input_band_14_brightness_temperature_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_bad_or_missing_input_band_14_bright_temp_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_bad_input_band_7_pixel_qf');
            if(a1==1)
                DQFS.percent_degraded_due_to_bad_input_band_7_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_degraded_due_to_failed_band_2_tests_qf');
            if(a1==1)
                DQFS.percent_degraded_due_to_failed_band_2_tests_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_nonconvergent_retrieval_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_nonconvergent_retrieval_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_degraded_due_to_other_bad_bands_qf');
            if(a1==1)
                DQFS.percent_degraded_due_to_other_bad_bands_qf=attname2;
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
                CloudMaskPtsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudMaskPtsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudMaskPtsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudMaskPtsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudMaskPtsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudMaskPtsS.cell_methods=attname2;
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
                NumClearPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumClearPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumClearPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumClearPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumClearPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumClearPixelsS.cell_methods=attname2;
            end
         elseif (a180==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                NumProbClearPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumProbClearPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumProbClearPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumProbClearPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumProbClearPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumProbClearPixelsS.cell_methods=attname2;
            end
        elseif (a190==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                NumProbCloudyPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumProbCloudyPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumProbCloudyPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumProbCloudyPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumProbCloudyPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumProbCloudyPixelsS.cell_methods=attname2;
            end
        elseif (a200==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                NumCloudyPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumCloudyPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumCloudyPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumCloudyPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumCloudyPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumCloudyPixelsS.cell_methods=attname2;
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
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_solar_zenith_angle_data');
            if(a1==1)
                AlgoS.input_ABI_L2_auxiliary_solar_zenith_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_scattering_angle_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_auxiliary_scattering_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_sunglint_angle_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_auxiliary_sunglint_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_7_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L1b_radiance_band_7_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_14_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L1b_radiance_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_14_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_14_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_9_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_brightness_temperature_band_9_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_10_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_brightness_temperature_band_10_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_11_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_brightness_temperature_band_11_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_brightness_temperature_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_15_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_brightness_temperature_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_16_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_brightness_temperature_band_16_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_2_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_intermediate_product_reflectance_band_2_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_4_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_intermediate_product_reflectance_band_4_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_5_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_intermediate_product_reflectance_band_5_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_4_level_cloud_mask_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_intermediate_product_4_level_cloud_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_7_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_product_CRTM_clear_sky_radiance_band_7_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_14_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_product_CRTM_clear_sky_radiance_band_14_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_16_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_16_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_7_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_7_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_brightness_temperature_band_14_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_bright_temp_band_14_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_brightness_temperature_band_15_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_bright_temp_band_15_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_global_snow_mask_data');
            if(a1==1)
                AlgoS.inp_dynamic_ancillary_global_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_snow_mask_data');
            if(a1==1)
                AlgoS.inp_dynamic_ancillary_NWP_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_temperature_data');
            if(a1==1)
                AlgoS.inp_dynamic_ancillary_NWP_surface_temperature_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_total_precipitable_water_data');
            if(a1==1)
                AlgoS.inp_dynamic_ancillary_NWP_total_precipitable_water_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_total_column_ozone_data');
            if(a1==1)
                AlgoS.inp_dynamic_ancillary_NWP_total_column_ozone_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_level_index_data');
            if(a1==1)
                AlgoS.inp_dynamic_ancillary_NWP_surface_level_index_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_tropopause_level_index_data');
            if(a1==1)
                AlgoS.inp_dynamic_ancillary_NWP_tropopause_level_index_data=attname2;
            end
        elseif (a220==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PctClearPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PctClearPixelsS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PctClearPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PctClearPixelsS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PctClearPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PctClearPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PctClearPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PctClearPixelsS.cell_methods=attname2;
            end
        elseif (a230==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PctProbClearPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PctProbClearPixelsS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PctProbClearPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PctProbClearPixelsS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PctProbClearPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PctProbClearPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PctProbClearPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PctProbClearPixelsS.cell_methods=attname2;
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
                PctProbCloudyPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PctProbCloudyPixelsS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PctProbCloudyPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PctProbCloudyPixelsS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PctProbCloudyPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PctProbCloudyPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PctProbCloudyPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PctProbCloudyPixelsS.cell_methods=attname2;
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
                PctCloudyPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PctCloudyPixelsS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PctCloudyPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PctCloudyPixelsS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PctCloudyPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PctCloudyPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PctCloudyPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PctCloudyPixelsS.cell_methods=attname2;
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
                PctTerminatorPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PctTerminatorPixelsS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PctTerminatorPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PctTerminatorPixelsS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PctTerminatorPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PctTerminatorPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PctTerminatorPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PctTerminatorPixelsS.cell_methods=attname2;
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
         elseif (a490==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                RTM_BT_AllSkyS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RTM_BT_AllSkyS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTM_BT_AllSkyS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RTM_BT_AllSkyS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RTM_BT_AllSkyS.cell_methods1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RTM_BT_AllSkyS.grid_mapping1=attname2;
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
                RTM_BT_AllSkyS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RTM_BT_AllSkyS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTM_BT_AllSkyS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RTM_BT_AllSkyS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RTM_BT_AllSkyS.cell_methods2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RTM_BT_AllSkyS.grid_mapping2=attname2;
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
                RTM_BT_AllSkyS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RTM_BT_AllSkyS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTM_BT_AllSkyS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RTM_BT_AllSkyS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RTM_BT_AllSkyS.cell_methods3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RTM_BT_AllSkyS.grid_mapping3=attname2;
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
                RTM_BT_AllSkyS.long_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RTM_BT_AllSkyS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTM_BT_AllSkyS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RTM_BT_AllSkyS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RTM_BT_AllSkyS.cell_methods4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RTM_BT_AllSkyS.grid_mapping4=attname2;
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
                RTM_BT_ClearSkyS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RTM_BT_ClearSkyS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTM_BT_ClearSkyS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RTM_BT_ClearSkyS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RTM_BT_ClearSkyS.cell_methods1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RTM_BT_ClearSkyS.grid_mapping1=attname2;
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
                RTM_BT_ClearSkyS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RTM_BT_ClearSkyS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTM_BT_ClearSkyS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RTM_BT_ClearSkyS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RTM_BT_ClearSkyS.cell_methods2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RTM_BT_ClearSkyS.grid_mapping2=attname2;
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
                RTM_BT_ClearSkyS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RTM_BT_ClearSkyS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTM_BT_ClearSkyS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RTM_BT_ClearSkyS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RTM_BT_ClearSkyS.cell_methods3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RTM_BT_ClearSkyS.grid_mapping3=attname2;
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
                RTM_BT_ClearSkyS.long_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RTM_BT_ClearSkyS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTM_BT_ClearSkyS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RTM_BT_ClearSkyS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RTM_BT_ClearSkyS.cell_methods4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RTM_BT_ClearSkyS.grid_mapping4=attname2;
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
                RLZABS.long_name=attname2;
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
                QLZABS.long_name=attname2;
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
                TSZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TSZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TSZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                TSZAS.bounds=attname2;
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
                RSZABS.long_name=attname2;
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
                TSZABS.long_name=attname2;
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
                RTMBT_CWS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RTMBT_CWS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTMBT_CWS.units=attname2;
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
                RTMBT_BIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RTMBT_BIDS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RTMBT_BIDS.units=attname2;
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
    if(idebug==1)
        disp(' ')
    end
    if flag
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
        if(a10==1)
% Replace The Fill Values with NaNs
             [nrows,ncols]=size(BCM);
             FillValue=BCMS.FillValue;
             numnan=0;
             for ix=1:nrows
                 for jy=1:ncols
                     nowvalue=BCM(ix,jy);
                     if(nowvalue==FillValue)
                         BCM(ix,jy)=NaN;
                         numnan=numnan+1;
                     end
                 end
             end
             BCMS.values=BCM; 
        end
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
            CloudMaskPtsS.values=total_number_of_cloud_mask_points;
        end
        if(a170==1)
            NumClearPixelsS.values=number_of_clear_pixels;
        end
        if(a180==1)
            NumProbClearPixelsS.values=number_of_probably_clear_pixels;
        end
        if(a190==1)
            NumProbCloudyPixelsS.values=number_of_probably_cloudy_pixels;
        end
        if(a200==1)
            NumCloudyPixelsS.values=number_of_cloudy_pixels;
        end
        if(a210==1)
            AlgoS.values=[];
        end
        if(a220==1)
            PctClearPixelsS.values=percent_clear_pixels;
        end
        if(a230==1)
             PctProbClearPixelsS.values=percent_probably_clear_pixels;
        end
        if(a240==1)
             PctProbCloudyPixelsS.values=percent_probably_cloudy_pixels;
        end
        if(a250==1)
            ProcessParamS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProdVersionContainerS.values=algorithm_product_version_container;
        end
        if(a270==1)
             PctCloudyPixelsS.values=percent_cloudy_pixels;
        end
        if(a280==1)
             PctTerminatorPixelsS.values=percent_terminator_pixels;
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
%         if(a420==1)
%             LZAS.values=local_zenith_angle;
%         end
%         if(a430==1)
%             LZABS.values=local_zenith_angle_bounds;
%         end
%         if(a440==1)
%             SZAS.values=solar_zenith_angle;
%         end
%         if(a450==1)
%             SZABS.values=solar_zenith_angle_bounds;          
%         end
        if(a460==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors;          
        end
        if(a470==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
        end
        if(a480==1)
            CloudPixelsS.values=cloud_pixels;
        end
        if(a490==1)
            RTM_BT_AllSkyS.values1=min_obs_modeled_diff_RTM_BT_comparison_bands_all_sky;
        end
        if(a500==1)
            RTM_BT_AllSkyS.values2=max_obs_modeled_diff_RTM_BT_comparison_bands_all_sky;
        end
        if(a510==1)
            RTM_BT_AllSkyS.values3=mean_obs_modeled_diff_RTM_BT_comparison_bands_all_sky;
        end
        if(a520==1)
            RTM_BT_AllSkyS.values4=std_dev_obs_modeled_diff_RTM_BT_comparison_bands_all_sky;
        end
        if(a530==1)
            RTM_BT_ClearSkyS.values1=min_obs_modeled_diff_RTM_BT_comparison_bands_clear_sky;
        end
        if(a540==1)
            RTM_BT_ClearSkyS.values2=max_obs_modeled_diff_RTM_BT_comparison_bands_clear_sky;
        end
        if(a550==1)
            RTM_BT_ClearSkyS.values3=mean_obs_modeled_diff_RTM_BT_comparison_bands_clear_sky;
        end
        if(a560==1)
            RTM_BT_ClearSkyS.values4=std_dev_obs_modeled_diff_RTM_BT_comparison_bands_clear_sky;
        end
        if(a570==1)
            RLZAS.value=retrieval_local_zenith_angle;
        end
        if(a580==1)
            QLZAS.value=quantitative_local_zenith_angle;
        end
        if(a590==1)
            RLZABS.value=retrieval_local_zenith_angle_bounds;
        end
        if(a600==1)
            QLZABS.value=quantitative_local_zenith_angle_bounds;
        end
        if(a610==1)
            RSZAS.value=retrieval_solar_zenith_angle;
        end
        if(a620==1)
            TSZAS.value=twilight_solar_zenith_angle;
        end
        if(a630==1)
            RSZABS.value=retrieval_solar_zenith_angle_bounds;
        end
        if(a640==1)
            TSZABS.value=twilight_solar_zenith_angle_bounds;
        end
        if(a650==1)
            RTMBT_CWS.values=RTM_BT_comparison_wavelengths;
        end
        if(a660==1)
            RTMBT_BIDS.values=RTM_BT_comparison_band_ids;
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
fprintf(fid,'%s\n','Finished reading Clear Sky Mask data');
% Get some basic data on the Cloud Mask
maskstr1='------- Retrieving Some Stats On Cloud Mask Data------';
disp(maskstr1);
fprintf(fid,'%s\n',maskstr1);
numclearpix=NumClearPixelsS.values;
pctclearpix=100*PctClearPixelsS.values;
maskstr2=strcat('Num Clear Pixels=',num2str(numclearpix),'-pct total pix=',...
    num2str(pctclearpix,6));
disp(maskstr2);
fprintf(fid,'%s\n',maskstr2);
numprobclearpix=NumProbClearPixelsS.values;
pctprobclearpix=100*PctProbClearPixelsS.values;
maskstr3=strcat('Num Prob Clear Pixels=',num2str(numprobclearpix),'-pct total pix=',...
    num2str(pctprobclearpix,6));
disp(maskstr3);
fprintf(fid,'%s\n',maskstr3);
numprobcloudypix=NumProbCloudyPixelsS.values;
pctprobcloudypix=100*PctProbCloudyPixelsS.values;
maskstr4=strcat('Num Prob Cloudy Pixels=',num2str(numprobcloudypix),'-pct total pix=',...
    num2str(pctprobcloudypix,6));
disp(maskstr4);
fprintf(fid,'%s\n',maskstr4);
numcloudypix=NumCloudyPixelsS.values;
pctcloudypix=100*PctCloudyPixelsS.values;
maskstr5=strcat('Num Cloudy Pixels=',num2str(numcloudypix),'-pct total pix=',...
    num2str(pctcloudypix,6));
disp(maskstr5);
fprintf(fid,'%s\n',maskstr5);
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='BCM MetaDataS  DQFS tS yS xS tBS goesImagerS';
    varstr2=' yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS ';
    varstr3=' AlgoS   AlgoProdVersionContainerS OutlierPixelsS';
    varstr4=' GoesWaveBand GOESFileName RLZAS QLZAS RLZABS QLZABS';
    varstr5=' GRBErrorsS L0ErrorsS RSZAS TSZAS RSZABS TSZABS';
    varstr6=' RTMBT_CWS RTMBT_BIDS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6);
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
[numrows,numcols]=size(BCM);
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=[(northEdge-southEdge)/numcols];
GeoRef.CellExtentInLongitude=[abs((eastEdge-westEdge))/numrows];
datastr1=strcat('Cloudy Mask dimensions nrows=',num2str(numrows),...
    '-ncols=',num2str(numcols));
fprintf(fid,'%s\n',datastr1);
% Display the Clear Sky Cloud Mask
is=1;
[ix]=strfind(GOESFileName,'_e');
ie=ix(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('ClearSky-Mask-Data-',filename);
DisplayClearSkyMask(BCM,titlestr)
fprintf(fid,'%s\n','----Finished Processing Sky Mask-----');
fprintf(fid,'\n');
end