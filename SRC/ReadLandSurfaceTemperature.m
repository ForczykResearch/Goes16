function ReadLandSurfaceTemperature()
% Modified: This function will read in the GOES Land Surface Temperature

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
% Created: Dec 24,2020
% Revised: Jan 24,2021 added global to contain LSTS valid range
% Classification: Unclassified

global BandDataS MetaDataS;
global LSTS LSTStatS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS ;
global PressureS OutlierPixelsS CloudMaskPtsS;
global NumClearPixelsS NumProbClearPixelsS NumProbCloudyPixelsS;
global NumCloudyPixelsS TotPixLSTRS NumGoodRetS OutPixCS;
global PctClearPixelsS PctProbClearPixelsS PctProbCloudyPixelsS;
global PctCloudyPixelsS PctTerminatorPixelsS;
global RTM_BT_AllSkyS RTM_BT_ClearSkyS;
global TQPixelsS NumDaySSTPixelsS NumNightSSTPixelsS NumTwilightSSTPixelsS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global RLZAS QLZAS RLZABS QLZABS;
global RSZAS TSZAS RSZABS TSZABS;
global SZAS SZABS;
global DSZAS NSZAS TSZAS;
global DSZABS NSZABS ;
global SST_EBS;
global RTMBT_CWS RTMBT_BIDS;
global GRBErrorsS L0ErrorsS;
global SSTS SeaSurfOutlierPixelS SeaSurfTempS;
global SST_Night_Only_EBS Reynolds_SSTS;
global westEdge eastEdge northEdge southEdge;
global LSTSMinValidValue LSTSMaxValidValue;
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

fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start reading Land Surface Temperature data-----');
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
LSTS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],'Unsigned',[],...
    'valid_range',[],'scale_factor',[],'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'ancillary_variables',[],'add_offset',[]);
LSTStatS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
NumDaySSTPixelsS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
NumNightSSTPixelsS=NumDaySSTPixelsS;
NumTwilightSSTPixelsS=NumDaySSTPixelsS;
CloudMaskPtsS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
NumClearPixelsS=CloudMaskPtsS;
NumProbClearPixelsS=NumClearPixelsS;
NumProbCloudyPixelsS=NumClearPixelsS;
NumCloudyPixelsS=NumClearPixelsS;
SeaSurfOutlierPixelS=NumClearPixelsS;
TQPixelsS=struct('values1',[],'long_name1',[],'FillValue1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],'units3',[],...
    'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'FillValue4',[],'units4',[],...
    'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
TotPixLSTRS=struct('values',[],'long_name',[],'FillValue',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[]);
NumGoodRetS=TotPixLSTRS;
OutPixCS=TotPixLSTRS;
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
DSZAS=RLZAS;
NSZAS=DSZAS;
RLZABS=struct('value',[],'long_name',[]);
QLZABS=struct('value',[],'long_name',[]);
RSZABS=RLZABS;
TSZABS=RLZABS;
RSZAS=RLZAS;
TSZAS=RLZAS;
SZAS=RLZAS;
SZABS=RLZABS;
DSZABS=struct('value',[],'long_name',[]);
NSZABS=DSZABS;
SST_EBS=struct('values1',[],'long_name1',[],'standard_name1',[],'units1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'units2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'units3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'units4',[]);
SeaSurfTempS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
SST_Night_Only_EBS=struct('values1',[],'long_name1',[],'FillValue1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],'units3',[],...
    'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'FillValue4',[],'units4',[],...
    'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
Reynolds_SSTS=SST_Night_Only_EBS;
RTMBT_CWS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
RTMBT_BIDS=RTMBT_CWS;
PressureS=struct('values',[],'long_name',[],'standard_name',[],...
    'FillValue',[],'Unsigned',[],'valid_range',[],'scale_factor',[],'add_offset',[],...
    'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],'cell_methods',[],...
    'ancillary_variables',[]);
DQFS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],'flag_masks',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'pct_good_retrieval_qf',[],'pct_valid_input_data_qf',[],...
    'pct_invalid_due_to_bad_or_missing_input_data_qf',[],...
    'pct_valid_clear_conditions_qf',[],...
    'pct_invalid_due_to_cloudy_conditions_qf',[],...
    'pct_valid_LZA_qf',[],...
    'pct_degraded_due_to_LZA_threshold_exceeded_qf',[],...
    'pct_valid_land_or_inland_water_surface_type_qf',[],...
    'pct_invalid_due_to_water_surface_type_qf',[],...
    'pct_valid_land_surface_temperature_qf',[],...
    'pct_invalid_due_to_out_of_range_land_surf_temp_qf',[],...
    'good_retrieval_qf_definition',[]);
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
    'inp_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'inp_ABI_L2_brightness_temperature_band_15_2km_data',[],...
    'inp_ABI_L2_total_precipitable_water_data',[],...
    'inp_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...
    'inp_ABI_L2_intermediate_product_binary_snow_mask_data',[],...
    'inp_dynamic_ancillary_NWP_total_precipitable_water_data',[]);


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
        a10=strcmp(varname,'LST');
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
        a240=strcmp(varname,'sea_surface_temp_outlier_pixel_count');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a440=strcmp(varname,'solar_zenith_angle');
        a450=strcmp(varname,'solar_zenith_angle_bounds');
        a460=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a470=strcmp(varname,'percent_uncorrectable_L0_errors');
        a570=strcmp(varname,'retrieval_local_zenith_angle');
        a580=strcmp(varname,'quantitative_local_zenith_angle');
        a590=strcmp(varname,'retrieval_local_zenith_angle_bounds');
        a600=strcmp(varname,'quantitative_local_zenith_angle_bounds');
        a610=strcmp(varname,'retrieval_solar_zenith_angle');
        a630=strcmp(varname,'retrieval_solar_zenith_angle_bounds');
        a750=strcmp(varname,'day_solar_zenith_angle');
        a760=strcmp(varname,'night_solar_zenith_angle');
        a770=strcmp(varname,'twilight_solar_zenith_angle');
        a780=strcmp(varname,'day_solar_zenith_angle_bounds');
        a790=strcmp(varname,'night_solar_zenith_angle_bounds');
        a800=strcmp(varname,'twilight_solar_zenith_angle_bounds');
        a850=strcmp(varname,'total_pixels_where_lst_is_retrieved');
        a860=strcmp(varname,'number_good_retrievals');
        a910=strcmp(varname,'min_lst');
        a920=strcmp(varname,'max_lst');
        a930=strcmp(varname,'mean_lst');
        a940=strcmp(varname,'standard_deviation_lst');
        a950=strcmp(varname,'outlier_pixel_count');
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
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LSTS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LSTS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LSTS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                LSTS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                LSTS.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LSTS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                LSTS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LSTS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                LSTS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LSTS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LSTS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LSTS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                LSTS.resolution=attname2;
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
            a1=strcmp(attname1,'percent_good_retrieval_qf');
            if(a1==1)
                DQFS.pct_good_retrieval_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_valid_input_data_qf');
            if(a1==1)
                DQFS.pct_valid_input_data_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_bad_or_missing_input_data_qf');
            if(a1==1)
                DQFS.pct_invalid_due_to_bad_or_missing_input_data_qf=attname2;
            end
            a1=strcmp(attname1,'percent_valid_clear_conditions_qf');
            if(a1==1)
                DQFS.pct_valid_clear_conditions_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_cloudy_conditions_qf');
            if(a1==1)
                DQFS.pct_invalid_due_to_cloudy_conditions_qf=attname2;
            end
            a1=strcmp(attname1,'percent_valid_LZA_qf');
            if(a1==1)
                DQFS.pct_valid_LZA_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_LZA_threshold_exceeded_qf');
            if(a1==1)
                DQFS.pct_degraded_due_to_LZA_threshold_exceeded_qf=attname2;
            end
            a1=strcmp(attname1,'percent_valid_land_or_inland_water_surface_type_qf');
            if(a1==1)
                DQFS.pct_valid_land_or_inland_water_surface_type_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_water_surface_type_qf');
            if(a1==1)
                DQFS.pct_invalid_due_to_water_surface_type_qf=attname2;
            end
            a1=strcmp(attname1,'percent_valid_land_surface_temperature_qf');
            if(a1==1)
                DQFS.pct_valid_land_surface_temperature_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_out_of_range_land_surface_temperature_qf');
            if(a1==1)
                DQFS.pct_invalid_due_to_out_of_range_land_surf_temp_qf=attname2;
            end
            a1=strcmp(attname1,'good_retrieval_qf_definition');
            if(a1==1)
                DQFS.good_retrieval_qf_definition=attname2;
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
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_brightness_temperature_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_15_2km_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_brightness_temperature_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_total_precipitable_water_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_total_precipitable_water_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_4_level_cloud_mask_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_intermediate_product_4_level_cloud_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_binary_snow_mask_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_intermediate_product_binary_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_total_precipitable_water_data');
            if(a1==1)
                AlgoS.inp_dynamic_ancillary_NWP_total_precipitable_water_data=attname2;
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
                SeaSurfOutlierPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SeaSurfOutlierPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SeaSurfOutlierPixelS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SeaSurfOutlierPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SeaSurfOutlierPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                SeaSurfOutlierPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SeaSurfOutlierPixelS.cell_methods=attname2;
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
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                SZAS.bounds=attname2;
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
                DSZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DSZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DSZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                DSZAS.bounds=attname2;
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
                NSZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                NSZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NSZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                NSZAS.bounds=attname2;
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
                DSZABS.long_name=attname2;
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
                NSZABS.long_name=attname2;
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
                TSZABS.long_name=attname2;
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
                TotPixLSTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TotPixLSTRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TotPixLSTRS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TotPixLSTRS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TotPixLSTRS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TotPixLSTRS.cell_methods=attname2;
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
                NumGoodRetS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumGoodRetS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumGoodRetS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumGoodRetS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumGoodRetS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumGoodRetS.cell_methods=attname2;
            end
        elseif (a910==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LSTStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LSTStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LSTStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LSTStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LSTStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LSTStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LSTStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LSTStatS.cell_methods1=attname2;
            end
        elseif (a920==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LSTStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LSTStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LSTStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LSTStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LSTStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LSTStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LSTStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LSTStatS.cell_methods2=attname2;
            end
        elseif (a930==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LSTStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LSTStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LSTStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LSTStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LSTStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LSTStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LSTStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LSTStatS.cell_methods3=attname2;
            end
        elseif (a940==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LSTStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LSTStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LSTStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LSTStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LSTStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LSTStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LSTStatS.cell_methods4=attname2;
            end
        elseif (a950==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixCS.long_name=attname2;
            end

            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixCS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixCS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixCS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixCS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixCS.cell_methods=attname2;
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
        if(a10==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            FillValue=LSTS.FillValue;
               [LST,numnanvals] = ReplaceFillValues(LST,FillValue);
               [nrows,ncols]=size(LST);
               level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=LST(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           LST(ik,jk)=corval;
                      end
                   end
               end
               LST2=LST'*scale+offset;
               LSTS.values=double(LST2); 
               clear LST2
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
        if(a240==1)
             SeaSurfOutlierPixelS.values=sea_surface_temp_outlier_pixel_count;
        end
        if(a250==1)
            ProcessParamS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProdVersionContainerS.values=algorithm_product_version_container;
        end
        if(a440==1)
            SZAS.value=solar_zenith_angle;
        end
        if(a450==1)
            SZABS.value=solar_zenith_angle_bounds;
        end
        if(a460==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors; 
        end
        if(a470==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
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
        if(a630==1)
            RSZABS.value=retrieval_solar_zenith_angle_bounds;
        end
        if(a750==1)
            DSZAS.value=day_solar_zenith_angle;
        end
        if(a760==1)
            NSZAS.value=night_solar_zenith_angle;
        end
        if(a770==1)
            TSZAS.value=twilight_solar_zenith_angle;
        end
        if(a780==1)
            DSZABS.value=day_solar_zenith_angle_bounds;
        end
        if(a790==1)
            NSZABS.value=night_solar_zenith_angle_bounds;
        end
        if(a800==1)
            TSZABS.value=twilight_solar_zenith_angle_bounds;
        end

       if(a850==1)
            TotPixLSTRS.values=total_pixels_where_lst_is_retrieved;
        end
        if(a860==1)
            NumGoodRetS.values=total_pixels_where_lst_is_retrieved;
        end
        if(a910==1)
            LSTStatS.values1=min_lst;
        end
        if(a920==1)
            LSTStatS.values2=max_lst;
        end
        if(a930==1)
            LSTStatS.values3=mean_lst;
        end
        if(a940==1)
            LSTStatS.values4=standard_deviation_lst;
        end
        if(a950==1)
            OutPixCS.values=outlier_pixel_count;
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
fprintf(fid,'%s\n','Finished reading Land Surface Temperature data');

[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='LSTS LSTStatS MetaDataS  DQFS tS yS xS tBS goesImagerS';
    varstr2=' yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS ';
    varstr3=' AlgoS AlgoProdVersionContainerS OutPixCS';
    varstr4=' GoesWaveBand GOESFileName RLZAS QLZAS RLZABS QLZABS';
    varstr5=' GRBErrorsS L0ErrorsS RSZAS RSZABS ProcessParamS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    savestr1=strcat('User saved Land Surface Temp data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr1);
else
    savestr2=strcat('User did not save Land Surface Temp data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr2);
end
ab=1;
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
[numrows,numcols]=size(LSTS.values);
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=[(northEdge-southEdge)/numcols];
GeoRef.CellExtentInLongitude=[abs((eastEdge-westEdge))/numrows];
datastr1=strcat('Land Temperature dimensions nrows=',num2str(numrows),...
    '-ncols=',num2str(numcols));
fprintf(fid,'%s\n',datastr1);
% Calculate a few global values for later use
LSTSMinValidValue=double(LSTStatS.valid_range1(1,1));
LSTSMaxValidValue=double(LSTStatS.valid_range1(1,2));
% Display the Land Surface Temps
[imatch]=strfind(GOESFileName,'_e');
is=1;
ie=imatch(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('LandSurfaceTemps-',filename);
ab=1;
[LST1DSF,goodfrac]=DisplayLandSurfaceTemps(titlestr);
ab=2;
titlestr=strcat('LandSurfaceTempHist-',filename);
PlotLandSurfTempHistogram(LST1DSF,goodfrac,titlestr)
fprintf(fid,'%s\n','Finished Processing Land Surface Temperature data');
disp('Finished Processing Land Surface Temperature data');
% Now plot the cumilative Land Surface Temperature distribution
titlestr=strcat('LandSurfaceTempsCumilDist-',filename);
PlotLandSurfaceTempCumilDist(LST1DSF,goodfrac,titlestr)
fprintf(fid,'%s\n','-----Finish reading Land Surface Temperature data-----');
fprintf(fid,'\n');
end