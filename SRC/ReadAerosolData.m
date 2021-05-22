function ReadAerosolData()
% Modified: This function will read in the GOES measured Aerosol Data
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. 
% Written By: Stephen Forczyk
% Created: Feb 7,2021
% Revised: Feb 8,2021 completed adding code to read data
% 
% Classification: Unclassified

global MetaDataS;
global AerosolS SmokeS DustS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS ;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS RLZABS RSZAS QSZAS RSZABS QSZABS;
global LatitudeS LatitudeBoundsS;
global NumGoodSZAPixelS NumGoodLZAPixelS NumRetrievalS;
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
fprintf(fid,'%s\n','-----Start reading Aerosol Data----');
iReport(62,1)=iReport(62,1)+1;
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
AerosolS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'valid_range',[],'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'ancillary_variables',[]);
SmokeS=AerosolS;
DustS=AerosolS;
RSZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
QSZAS=RSZAS;
RSZABS=struct('values',[],'long_name',[]);
QSZABS=RSZABS;
NumGoodSZAPixelS=struct('values',[],'long_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
NumGoodLZAPixelS=NumGoodSZAPixelS;
NumRetrievalS=struct('values1',[],'long_name1',[],'FillValue1',[],...
    'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],...
    'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],...
    'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'FillValue4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
TPWRS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
TRVS=TPWRS;
TotPixRS=TPWRS;
RROutPixCountS=TPWRS;
RainRateS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
SZAS=struct('value',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
SZABS=struct('value',[],'long_name',[]);
RLZABS=struct('value',[],'long_name',[]);
QLZAS=struct('value',[],'long_name',[],'standard_name',[],...
    'units',[],'bounds',[]);
QLZABS=struct('value',[],'long_name',[]);
RLZAS=struct('value',[],'long_name',[],'standard_name',[]);

LatitudeS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
LatitudeBoundsS=struct('values',[],'long_name',[]);
DQFS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],'flag_masks',[],...
    'flag_values',[],'flag_meanings',[],'number_of_smoke_detection_qf_values',[],...
    'pct_good_smoke_detection_retrieval_qf',[],...
    'pct_inval_smoke_detection_due_to_snow_ice_clouds_qf',[],...
    'number_of_dust_detection_qf_values',[],...
    'pct_good_dust_detection_retrieval_qf',[],...
    'pct_inval_dust_detection_due_to_snow_ice_clouds_qf',[],...
    'number_of_smoke_confidence_qf_values',[],...
    'pct_low_confidence_smoke_detection_qf',[],...
    'pct_medium_confidence_smoke_detection_qf',[],...
    'pct_high_confidence_smoke_detection_qf',[],...
    'pct_low_confidence_dust_detection_qf',[],...
    'number_of_dust_confidence_qf_values',[],...
    'pct_medium_confidence_dust_detection_qf',[],...
    'pct_high_confidence_dust_detection_qf',[],...
    'number_of_sun_glint_qf_values',[],...
    'pct_out_of_sun_glint_qf',[],...
    'pct_within_sun_glint_qf',[],...
    'number_of_SZA_VZA_qf_values',[],...
    'pct_within_solar_and_satellite_zenith_angle_range_qf',[],...
    'pct_outside_solar_or_satellite_zenith_angle_range_qf',[]);
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
    'input_ABI_L2_auxiliary_sunglint_angle_data',[],...
    'input_ABI_L2_aux_sun_satellite_relative_azimuth_angle_data',[],...
    'input_ABI_L1b_radiance_band_4_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_7_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_13_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_15_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_1_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_2_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_3_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_4_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_5_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_6_2km_data',[],...
    'input_ABI_L2_intermediate_product_cloud_mask_info_flag_data',[],...
    'input_ABI_L2_intermediate_product_binary_snow_mask_data',[],...
    'input_dynamic_ancillary_global_snow_mask_data',[]);
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
        a10=strcmp(varname,'Aerosol');
        a11=strcmp(varname,'Smoke');
        a12=strcmp(varname,'Dust');
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
        a160=strcmp(varname,'number_good_LZA_pixels');
        a170=strcmp(varname,'number_good_SZA_pixels');
        a180=strcmp(varname,'number_of_good_smoke_retrievals');
        a190=strcmp(varname,'number_of_good_dust_retrievals');
        a200=strcmp(varname,'number_of_good_retrievals_where_smoke_detected');
        a210=strcmp(varname,'number_of_good_retrievals_where_dust_detected');
        a220=strcmp(varname,'mean_rainfall_rate');
        a230=strcmp(varname,'standard_deviation_rainfall_rate');
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
                AerosolS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AerosolS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AerosolS.units=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AerosolS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                AerosolS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AerosolS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AerosolS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AerosolS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AerosolS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                AerosolS.resolution=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                AerosolS.ancillary_variables=attname2;
            end
        elseif (a11==1)
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
                SmokeS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SmokeS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SmokeS.units=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                SmokeS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                SmokeS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SmokeS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SmokeS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SmokeS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SmokeS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                SmokeS.resolution=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                SmokeS.ancillary_variables=attname2;
            end
        elseif (a12==1)
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
                DustS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DustS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DustS.units=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DustS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                DustS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DustS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DustS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DustS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DustS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                DustS.resolution=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                DustS.ancillary_variables=attname2;
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
            a1=strcmp(attname1,'number_of_smoke_detection_qf_values');
            if(a1==1)
                DQFS.number_of_smoke_detection_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_smoke_detection_retrieval_qf');
            if(a1==1)
                DQFS.pct_good_smoke_detection_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_smoke_detection_due_to_snow_ice_clouds_or_bad_source_data_qf');
            if(a1==1)
                DQFS.pct_inval_smoke_detection_due_to_snow_ice_clouds_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_smoke_confidence_qf_values');
            if(a1==1)
                DQFS.number_of_smoke_confidence_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_low_confidence_smoke_detection_qf');
            if(a1==1)
                DQFS.pct_low_confidence_smoke_detection_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_medium_confidence_smoke_detection_qf');
            if(a1==1)
                DQFS.pct_medium_confidence_smoke_detection_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_high_confidence_smoke_detection_qf');
            if(a1==1)
                DQFS.pct_high_confidence_smoke_detection_qf=attname2;
            end 
            a1=strcmp(attname1,'number_of_dust_detection_qf_values');
            if(a1==1)
                DQFS.number_of_dust_detection_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_dust_detection_retrieval_qf');
            if(a1==1)
                DQFS.pct_good_dust_detection_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_dust_detection_due_to_snow_ice_clouds_or_bad_source_data_qf');
            if(a1==1)
                DQFS.pct_inval_dust_detection_due_to_snow_ice_clouds_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_dust_confidence_qf_values');
            if(a1==1)
                DQFS.number_of_dust_confidence_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_low_confidence_dust_detection_qf');
            if(a1==1)
                DQFS.pct_low_confidence_dust_detection_qf=attname2;
            end
            a1=strcmp(attname1,'percent_medium_confidence_dust_detection_qf');
            if(a1==1)
                DQFS.pct_medium_confidence_dust_detection_qf=attname2;
            end
            a1=strcmp(attname1,'percent_high_confidence_dust_detection_qf');
            if(a1==1)
                DQFS.pct_high_confidence_dust_detection_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_sun_glint_qf_values');
            if(a1==1)
                DQFS.number_of_sun_glint_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_sun_glint_qf');
            if(a1==1)
                DQFS.pct_out_of_sun_glint_qf=attname2;
            end
            a1=strcmp(attname1,'percent_within_sun_glint_qf');
            if(a1==1)
                DQFS.pct_within_sun_glint_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_SZA_VZA_qf_values');
            if(a1==1)
                DQFS.number_of_SZA_VZA_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_within_solar_and_satellite_zenith_angle_range_qf');
            if(a1==1)
                DQFS.pct_within_solar_and_satellite_zenith_angle_range_qf=attname2;
            end
            a1=strcmp(attname1,'percent_outside_solar_or_satellite_zenith_angle_range_qf');
            if(a1==1)
                DQFS.pct_outside_solar_or_satellite_zenith_angle_range_qf=attname2;
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
                NumGoodLZAPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumGoodLZAPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumGoodLZAPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumGoodLZAPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumGoodLZAPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumGoodLZAPixelS.cell_methods=attname2;
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
                NumGoodSZAPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumGoodSZAPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumGoodSZAPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumGoodSZAPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumGoodSZAPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumGoodSZAPixelS.cell_methods=attname2;
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
                NumRetrievalS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumRetrievalS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumRetrievalS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumRetrievalS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumRetrievalS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumRetrievalS.cell_methods1=attname2;
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
                NumRetrievalS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumRetrievalS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumRetrievalS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumRetrievalS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumRetrievalS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumRetrievalS.cell_methods2=attname2;
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
                NumRetrievalS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumRetrievalS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumRetrievalS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumRetrievalS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumRetrievalS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumRetrievalS.cell_methods3=attname2;
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
                NumRetrievalS.long_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NumRetrievalS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NumRetrievalS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NumRetrievalS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NumRetrievalS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NumRetrievalS.cell_methods4=attname2;
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
                RainRateS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RainRateS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RainRateS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RainRateS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RainRateS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RainRateS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                 RainRateS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RainRateS.cell_methods3=attname2;
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
                RainRateS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RainRateS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RainRateS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RainRateS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RainRateS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RainRateS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                 RainRateS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RainRateS.cell_methods4=attname2;
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
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_sunglint_angle_data');
            if(a1==1)
                AlgoS.input_ABI_L2_auxiliary_sunglint_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_sun_satellite_relative_azimuth_angle_data');
            if(a1==1)
                AlgoS.input_ABI_L2_aux_sun_satellite_relative_azimuth_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_4_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L1b_radiance_band_4_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_7_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_7_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_13_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_13_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_15_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_15_2km_data=attname2;
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
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_mask_info_flag_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_cloud_mask_info_flag_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_binary_snow_mask_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_binary_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_global_snow_mask_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_global_snow_mask_data=attname2;
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
            AerosolSV=Aerosol;
            FillValue=AerosolS.FillValue;
            [AerosolSV,numnanvals] = ReplaceFillValues(AerosolSV,FillValue);
            AerosolSV=AerosolSV';
            AerosolS.values=AerosolSV;
            clear AerosolSV
        end
        if(a11==1)
            SmokeSV=Smoke;
            FillValue=SmokeS.FillValue;
            [SmokeSV,numnanvals] = ReplaceFillValues(SmokeSV,FillValue);
            SmokeSV=SmokeSV';
            SmokeS.values=SmokeSV;
            clear SmokeSV
        end
        if(a12==1)
            DustSV=Dust;
            FillValue=DustS.FillValue;
            [DustSV,numnanvals] = ReplaceFillValues(DustSV,FillValue);
            DustSV=DustSV';
            DustS.values=DustSV;
            clear DustSV
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
            NumGoodLZAPixelS.values=number_good_LZA_pixels;
        end
        if(a170==1)
            NumGoodSZAPixelS.values=number_good_SZA_pixels;
        end
        if(a180==1)
            NumRetrievalS.values1=number_of_good_smoke_retrievals;
        end
        if(a190==1)
            NumRetrievalS.values2=number_of_good_dust_retrievals;
        end
        if(a200==1)
            NumRetrievalS.values3=number_of_good_retrievals_where_smoke_detected;
        end
        if(a210==1)
            NumRetrievalS.values4=number_of_good_retrievals_where_dust_detected;
        end
        if(a220==1)
            RainRateS.values3=mean_rainfall_rate;
        end
        if(a230==1)
            RainRateS.values4=standard_deviation_rainfall_rate; 
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
            ab=1;
        end
        if(a460==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors;          
        end
        if(a470==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
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
fprintf(fid,'%s\n','Finished Reading Aerosol data');
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='Aerosol Smoke Dust MetaDataS DQFS tS yS xS tBS goesImagerS';
    varstr2=' yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS ';
    varstr3=' AlgoS AlgoProdVersionContainerS TPWRS TRVS';
    varstr4=' GoesWaveBand GOESFileName RLZAS QLZAS';
    varstr5=' GRBErrorsS L0ErrorsS ';
    varstr6=' RSZAS RSZABS';
    varstr7=' QSZAS QSZABS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7);
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
[numrows,numcols]=size(AerosolS.values);
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=(northEdge-southEdge)/numcols;
GeoRef.CellExtentInLongitude=abs((eastEdge-westEdge))/numrows;
datastr1=strcat('Aerosol array dimensions nrows=',num2str(numrows),...
    '-ncols=',num2str(numcols));
fprintf(fid,'%s\n',datastr1);
% Display the Aerosol Data
[imatch]=strfind(GOESFileName,'_e');
is=1;
ie=imatch(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('AerosolMaskData-',filename);
DisplayAerosolMask(titlestr)
titlestr=strcat('SmokeMaskData-',filename);
DisplaySmokeMask(titlestr)
titlestr=strcat('DustMaskData-',filename);
DisplayDustMask(titlestr)
titlestr=strcat('CompositeMaskData-',filename);
DisplayCompositeAerosolMask(titlestr)
% titlestr=strcat('RainfallRateHist-',filename);
% [ValidRainFallRate]=PlotRainfallRateHistogram(RainFallRate1DSF,sgoodfrac,titlestr);
% titlestr=strcat('RainFallRateCumilDist-',filename);
% PlotRainFallRateCumilDist(ValidRainFallRate,sgoodfrac,titlestr)
fprintf(fid,'%s\n','Finished Processing Aerosol data');
disp('-----Finished Aerosol Data-----');
end