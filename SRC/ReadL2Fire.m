function ReadL2Fire()
% Modified: This function will read in the ABI-L2-Fire data
% Written By: Stephen Forczyk
% Created: Sept 6,2020
% Revised: Oct 7,2020 added code to write data to fire summary file
% Revised: Oct 24,2020 added debug level printing to log file and ability
%          to save decode file into mat format (not a time saver)
% Revised: April 14,2021 added reference dtedpath
% Classification: Unclassified
global FireSummaryFile;
global idebug isavefiles;
global FullDTEDFilePaths;
global iPrimeRoads iCountyRoads iCommonRoads iStateRecRoads iUSRoads iStateRoads;
global iLakes;
global imatchState;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;

global BandDataS MetaDataS;
global CMIS DQF2S tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS SunGlintS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global TempS Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;
global EventIDS EventTimeS EventLocS EventEnergyS;
global GroupIDS GQFS FlashDataS FlashData2S FlashQFS;
global ProductTimeS LightningWaveS NavL1bS YawFlipFlagS LonFOVS LatFOVS;
global ProcessParamVersionContainerS AlgoProdVersionContS;
global AreaS MaskS PowerS DQFS PixelFireDataS;
global FireOutlierPixelS FireTempS FireAreaS FirePowerS AlgoDynamicInputDataS;
global GRB_ErrorsS L0_ErrorsS;
global westEdge eastEdge northEdge southEdge;
global westEdge1 eastEdge1 northEdge1 southEdge1;
global isaveGOESLightningData;
global FlashEnergy FlashDuration FlashLats FlashLons;
global CountyBoundaries StateFIPSFile;
global StateFIPSCodes FireDetails FireLabels;
global NationalCountiesShp;
global USAStatesShapeFileList USAStatesFileName;
% additional paths needed for mapping
global fid;
global matpath1 mappath GOES16path;
global jpegpath gridpath summarypath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16CloudTopTemppath GOES16Lightningpath;
global nationalshapepath countyshapepath dtedpath;

fprintf(fid,'\n');
fprintf(fid,'%s\n','////// Start Execution Of Routine ReadL2Fire //////');

[nc_filenamesuf,path]=uigetfile('*nc','Select One GOES Data File');% SMF Modification
GOESFileName=nc_filenamesuf;
GOESFileNamestr=strcat('User Selected File-',GOESFileName,'-to process');
fprintf(fid,'%60s\n',GOESFileNamestr);
nc_filename=strcat(path,nc_filenamesuf);
ncid=netcdf.open(nc_filename,'nowrite');
tic;
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
MetaDataS.data_type=[];
MetaDataS.bandID=[];
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
AreaS=struct('values',[],'long_name',[],'FillValue',[],'standard_name',[],...
        'Unsigned',[],'valid_range',[],'scale_factor',[],'add_offset',[],...
        'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
AlgoDynamicInputDataS=struct('values',[],'long_name',[],...
    'ABI_L2_aux_solar_zenith_angle_data',[],'ABI_L2_aux_sunglint_angle_data',[],...
    'ABI_radiance_band_7',[],'ABI_L2_bright_temp_band_7_2km_data',[],...
    'ABI_L2_bright_temp_band_14_2km_data',[],'ABI_L2_bright_temp_band_15_2km_data',[],...
    'ABI_L2_inter_product_reflec_band_2_2km_data',[],...
    'ABI_L2_inter_product_time_of_last_fire_data',[],...
    'dynamic_ancillary_NWP_total_precip_water_data',[]);
AlgoProdVersionContS=struct('values',[],'long_name',[],'algorithm_version',[],...
    'product_version',[]);
MaskS=struct('values',[],'FillValue',[],'long_name',[],'valid_range',[],'units',[],...
      'resolution',[],'coordinates',[],'grid_mapping',[],'cell_methods',[],'flag_values',[],...
      'flag_meanings',[],'ancillary_variables',[],'number_of_fire_categories',[],...
      'pct_good_fire_pixel',[],'pct_saturated_fire_pixel',[],'pct_cloud_contaminatd',[],...
      'pct_high_prob',[],'pct_med_prob',[],'pct_low_prob',[],'invalid_fire_modis',[]);
PowerS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
      'valid_range',[],'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
      'cell_measures',[],'cell_methods',[],'ancillary_variables',[]);
SunGlintS=struct('values1',[],'long_name1',[],'standard_name1',[],'units1',[],...
    'bounds1',[],'values2',[],'long_name2',[]);
PixelFireDataS=struct('values1',[],'long_name1',[],'FillValue1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],'units3',[],...
    'coordinates3',[],'grid_mapping3',[],'cell_methods3',[]);
FireOutlierPixelS=struct('values1',[],'long_name1',[],'FillValue1',[],...
    'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'units2',[],'coordinates2',[],...
    'grid_mapping2',[],'cell_methods2',[],'values3',[],'long_name3',[],...
    'FillValue3',[],'units3',[],'coordinates3',[],'grid_mapping3',[]);
FireTempS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
FireAreaS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
FirePowerS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
GRB_ErrorsS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
L0_ErrorsS=GRB_ErrorsS;
GQFS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'unsigned',[],'valid_range',[],'units',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'pct_good_quality_qf',[],'pct_deg_due_to_const_events_out_of_time_order',[],...
    'pct_deg_due_to_group_const_event_count_exceeds_thresh_qf',[],...
    'pct_deg_due_to_group_duration_exceeds_threshold_qf',[]);
ProductTimeS=struct('values1',[],'long_name1',[],'standard_name1',[],'units1',[],...
    'axis1',[],'bounds1',[],'values2',[],'long_name2',[],...
    'values3',[],'long_name3',[],'units3',[],...
    'values4',[],'lomg_name4',[],'units4',[]);
LightningWaveS=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'units1',[],'bounds1',[],'values2',[],'long_name2',[]);
NavL1bS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
YawFlipFlagS=struct('values',[],'long_name',[],'unsigned',[],'FillValue',[],...
    'valid_range',[],'units',[],'coordinates',[],'cell_methods',[],'flag_values',[],...
    'flag_meanings',[]);
LatFOVS=struct('values1',[],'long_name1',[],'standard_name1',[],'units1',[],...
    'axis1',[],'bounds1',[],'values2',[],'long_name2',[]);
LonFOVS=struct('values1',[],'long_name1',[],'standard_name1',[],'units1',[],...
    'axis1',[],'bounds1',[],'values2',[],'long_name2',[]);
ProcessParamVersionContainerS=struct('values',[],'long_name',[],...
    'L2_processing_parm_version',[]);
DQFS=struct('values',[],'valid_range',[],'units',[],'unsigned',[],...
    'coordinates',[],'grid_mapping',[],'flag_values',[],'flag_meanings',[],...
    'number_of_qf_values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'percent_good_quality_fire_pixel_qf',[],...
    'percent_good_fire_free_land_pixel_qf',[],...
    'percent_invalid_due_to_opaque_cloud_pixel_qf',[],...
    'percent_invalid_due_to_LZA_threshold_exceeded',[],...
    'percent_invalid_due_to_bad_input_data_qf',[],...
    'percent_invalid_due_to_algorithm_failure_qf',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[]);
CloudPixelsS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
CloudTopTS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...;
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
ProcessParamTS=struct('values',[],'long_name',[],'L2_processing_parm_version',[]);
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
OutlierPS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
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
AlgoS=struct('values',[],'long_name',[],'input_GLM_L0_data',[],...
    'input_GLM_L1b_data',[]);
AlgoProductTS=struct('values',[],'long_name',[],'algorithm_version',[],'product_version',[]);
LZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
LZABS=struct('values',[],'long_name',[]);
SZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
SZABS=struct('values',[],'long_name',[]);
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
TempS=struct('values',[],'long_name',[],'standard_name',[],'unsigned',[],'valid_range',[],...
    'scale_factor',[],'add_offset',[],'units',[],'resolution',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],'FillValue',[],'cell_measures',[]);

Error1S=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[]);

% Get information about the contents of the file.
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);
if(idebug==1)
    disp(' '),disp(' '),disp(' ')
    disp('________________________________________________________')
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp(['VARIABLES CONTAINED IN THE netCDF FILE: ' nc_filename ])
    dispstr=strcat('VARIABLES CONTAINED IN THE netCDF FILE:',nc_filename);
    disp(' ')
    fprintf(fid,'%s\n','________________________________________________________');
    fprintf(fid,'%s\n','^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~');
    fprintf(fid,'%s\n',dispstr);
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
        a10=strcmp(varname,'Area');
        a20=strcmp(varname,'Temp');
        a30=strcmp(varname,'Mask');
        a40=strcmp(varname,'Power');
        a50=strcmp(varname,'DQF');
        a60=strcmp(varname,'t');
        a70=strcmp(varname,'y');
        a80=strcmp(varname,'x');
        a90=strcmp(varname,'time_bounds');
        a100=strcmp(varname,'goes_imager_projection');
        a110=strcmp(varname,'y_image');
        a120=strcmp(varname,'y_image_bounds');
        a130=strcmp(varname,'x_image');
        a140=strcmp(varname,'x_image_bounds');
        a150=strcmp(varname,'nominal_satellite_subpoint_lat');
        a160=strcmp(varname,'nominal_satellite_subpoint_lon');
        a170=strcmp(varname,'nominal_satellite_height');
        a180=strcmp(varname,'geospatial_lat_lon_extent');
        a190=strcmp(varname,'sunglint_angle');
        a200=strcmp(varname,'sunglint_angle_bounds');
        a210=strcmp(varname,'local_zenith_angle');
        a220=strcmp(varname,'local_zenith_angle_bounds');
        a230=strcmp(varname,'solar_zenith_angle');
        a240=strcmp(varname,'solar_zenith_angle_bounds');
        a250=strcmp(varname,'total_number_of_pixels_with_fires_detected');
        a260=strcmp(varname,'total_number_of_pixels_with_fire_temperature');
        a270=strcmp(varname,'total_number_of_pixels_with_fire_radiative_power');
        a280=strcmp(varname,'fire_temperature_outlier_pixel_count');
        a290=strcmp(varname,'fire_area_outlier_pixel_count');
        a300=strcmp(varname,'fire_radiative_power_outlier_pixel_count');
        a310=strcmp(varname,'minimum_fire_temperature');
        a320=strcmp(varname,'maximum_fire_temperature');
        a330=strcmp(varname,'mean_fire_temperature');
        a340=strcmp(varname,'standard_deviation_fire_temperature');
        a350=strcmp(varname,'minimum_fire_area');
        a360=strcmp(varname,'maximum_fire_area');
        a370=strcmp(varname,'mean_fire_area');
        a380=strcmp(varname,'standard_deviation_fire_area');
        a390=strcmp(varname,'minimum_fire_radiative_power');
        a400=strcmp(varname,'maximum_fire_radiative_power');
        a410=strcmp(varname,'mean_fire_radiative_power');
        a420=strcmp(varname,'standard_deviation_fire_radiative_power');
        a430=strcmp(varname,'algorithm_dynamic_input_data_container');
        a440=strcmp(varname,'processing_parm_version_container');
        a450=strcmp(varname,'algorithm_product_version_container');
        a460=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a470=strcmp(varname,'percent_uncorrectable_L0_errors');
        if (a10==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                AreaS.add_offset = attname2;
                offset=attname2;
            end
            if strmatch('scale_factor',attname1)
                AreaS.scale_factor = attname2;
                scale=attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AreaS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AreaS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                AreaS.unsigned=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AreaS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AreaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                AreaS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AreaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AreaS.valid_range=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AreaS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AreaS.cell_methods=attname2;
            end
        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
                TempS.add_offset=attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                TempS.scale_factor=attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TempS.long_name=attname2;
                
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TempS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                TempS.unsigned=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TempS.units=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TempS.valid_range=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TempS.FillValue=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                TempS.resolution=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TempS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TempS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_measures');
            if(a1==1)
                TempS.cell_measures=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TempS.cell_methods=attname2;
            end
        elseif (a30==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            flag=0;
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MaskS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MaskS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                MaskS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MaskS.units=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                MaskS.resolution=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MaskS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                MaskS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MaskS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                MaskS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                MaskS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                MaskS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'number_of_fire_categories');
            if(a1==1)
                MaskS.number_of_fire_categories=attname2;
            end
            a1=strcmp(attname1,'percent_good_fire_pixel_or_temporally_filtered_good_fire_pixel');
            if(a1==1)
                MaskS.pct_good_fire_pixel=attname2;
            end
            a1=strcmp(attname1,'percent_saturated_fire_pixel_or_temporally_filtered_saturated_fire_pixel');
            if(a1==1)
                MaskS.pct_saturated_fire_pixel=attname2;
            end
            a1=strcmp(attname1,'percent_cloud_contaminated_fire_pixel_or_temporally_filtered_cloud_contaminated_fire_pixel');
            if(a1==1)
                MaskS.pct_cloud_contaminatd=attname2;
            end
            a1=strcmp(attname1,'percent_high_probability_fire_pixel_or_temporally_filtered_high_probability_fire_pixel');
            if(a1==1)
                MaskS.pct_high_prob=attname2;
            end
            a1=strcmp(attname1,'percent_medium_probability_fire_pixel_or_temporally_filtered_medium_probability_fire_pixel');
            if(a1==1)
                MaskS.pct_med_prob=attname2;
            end
            a1=strcmp(attname1,'percent_low_probability_fire_pixel_or_temporally_filtered_low_probability_fire_pixel');
            if(a1==1)
                MaskS.pct_low_prob=attname2;
            end
            a1=strcmp(attname1,'invalid_fire_MODIS_land_mask_types_definition');
            if(a1==1)
                MaskS.invalid_fire_modis=attname2;
            end
        elseif (a40==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            flag=0;
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PowerS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PowerS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PowerS.standard_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PowerS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PowerS.units=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                PowerS.resolution=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PowerS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PowerS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_measures');
            if(a1==1)
                PowerS.cell_measures=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PowerS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                PowerS.ancillary_variables=attname2;
            end
        elseif (a50==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            flag=0;
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQFS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQFS.unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQFS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQFS.units=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQFS.standard_name=attname2;
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
            a1=strcmp(attname1,'percent_good_quality_fire_pixel_qf');
            if(a1==1)
                DQFS.percent_good_quality_fire_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_good_fire_free_land_pixel_qf');
            if(a1==1)
                DQFS.percent_good_fire_free_land_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_opaque_cloud_pixel_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_opaque_cloud_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_surface_type_or_sunglint_or_LZA_threshold_exceeded_or_off_earth_or_missing_input_data_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_LZA_threshold_exceeded=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_bad_input_data_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_bad_input_data_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_algorithm_failure_qf');
            if(a1==1)
                DQFS.percent_invalid_due_to_algorithm_failure_qf=attname2;
            end
        elseif (a60==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            flag=0;
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                tS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                tS.standard_name=attname2;
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
                yS.add_offset=attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                yS.scale_factor=attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                yS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                yS.standard_name=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                yS.axis=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yS.units=attname2;
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
                xS.add_offset=attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                xS.scale_factor=attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                xS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                xS.standard_name=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                xS.axis=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xS.units=attname2;
            end
        elseif (a90==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            flag=0;
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                tBS.long_name=attname2;
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
                goesImagerS.long_name=attname2;
            end
            a1=strcmp(attname1,'grid_mapping_name');
            if(a1==1)
                goesImagerS.grid_mapping_name=attname2;
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
                yImgBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yImgBS.units=attname2;
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
                xImgBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xImgBS.units=attname2;
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
               GeoSpatialS.long_name=attname2; 
            end
            a1=strcmp(attname1,'geospatial_westbound_longitude');
            if(a1==1)
               GeoSpatialS.geospatial_westbound_longitude=attname2; 
               westEdge=double(attname2);
            end
            a1=strcmp(attname1,'geospatial_northbound_latitude');
            if(a1==1)
               GeoSpatialS.geospatial_northbound_latitude=attname2; 
               northEdge=double(attname2);
            end
            a1=strcmp(attname1,'geospatial_eastbound_longitude');
            if(a1==1)
               GeoSpatialS.geospatial_eastbound_longitude=attname2; 
               eastEdge=double(attname2);
            end
            a1=strcmp(attname1,'geospatial_southbound_latitude');
            if(a1==1)
               GeoSpatialS.geospatial_southbound_latitude=attname2; 
               southEdge=double(attname2);
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
                SunGlintS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SunGlintS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SunGlintS.units1=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                SunGlintS.bounds1=attname2;
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
               SunGlintS.long_name2=attname2; 
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
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                LZAS.bounds=attname2;
            end
        elseif (a220==1)
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
                LZABS.long_name=attname2;
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
        elseif (a240==1)
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
                SZABS.long_name=attname2;
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
                PixelFireDataS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PixelFireDataS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PixelFireDataS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PixelFireDataS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PixelFireDataS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PixelFireDataS.cell_methods1=attname2;
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
                PixelFireDataS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PixelFireDataS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PixelFireDataS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PixelFireDataS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PixelFireDataS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PixelFireDataS.cell_methods2=attname2;
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
                PixelFireDataS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PixelFireDataS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PixelFireDataS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PixelFireDataS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PixelFireDataS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PixelFireDataS.cell_methods3=attname2;
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
                FireOutlierPixelS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireOutlierPixelS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireOutlierPixelS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireOutlierPixelS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireOutlierPixelS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireOutlierPixelS.cell_methods1=attname2;
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
                FireOutlierPixelS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireOutlierPixelS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireOutlierPixelS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireOutlierPixelS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireOutlierPixelS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireOutlierPixelS.cell_methods2=attname2;
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
                FireOutlierPixelS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireOutlierPixelS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireOutlierPixelS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireOutlierPixelS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireOutlierPixelS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireOutlierPixelS.cell_methods3=attname2;
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
                FireTempS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FireTempS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireTempS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FireTempS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireTempS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireTempS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireTempS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireTempS.cell_methods1=attname2;
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
                FireTempS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FireTempS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireTempS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FireTempS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireTempS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireTempS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireTempS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireTempS.cell_methods2=attname2;
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
                FireTempS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FireTempS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireTempS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FireTempS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireTempS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireTempS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireTempS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireTempS.cell_methods3=attname2;
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
                FireTempS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FireTempS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireTempS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FireTempS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireTempS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireTempS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireTempS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireTempS.cell_methods4=attname2;
            end
         elseif (a350==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FireAreaS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FireAreaS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireAreaS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireAreaS.units1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FireAreaS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireAreaS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireAreaS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireAreaS.cell_methods1=attname2;
            end
         elseif (a360==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FireAreaS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FireAreaS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireAreaS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireAreaS.units2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FireAreaS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireAreaS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireAreaS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireAreaS.cell_methods2=attname2;
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
                FireAreaS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FireAreaS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireAreaS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireAreaS.units3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FireAreaS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireAreaS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireAreaS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireAreaS.cell_methods3=attname2;
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
                FireAreaS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FireAreaS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FireAreaS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FireAreaS.units4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FireAreaS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FireAreaS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FireAreaS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FireAreaS.cell_methods4=attname2;
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
                FirePowerS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FirePowerS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FirePowerS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FirePowerS.units1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FirePowerS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FirePowerS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FirePowerS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FirePowerS.cell_methods1=attname2;
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
                FirePowerS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FirePowerS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FirePowerS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FirePowerS.units2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FirePowerS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FirePowerS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FirePowerS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FirePowerS.cell_methods2=attname2;
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
                FirePowerS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FirePowerS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FirePowerS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FirePowerS.units3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FirePowerS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FirePowerS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FirePowerS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FirePowerS.cell_methods3=attname2;
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
                FirePowerS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FirePowerS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FirePowerS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FirePowerS.units4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FirePowerS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FirePowerS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FirePowerS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FirePowerS.cell_methods4=attname2;
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
                AlgoDynamicInputDataS.long_name=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_solar_zenith_angle_data');
            if(a1==1)
                AlgoDynamicInputDataS.ABI_L2_aux_solar_zenith_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_sunglint_angle_data');
            if(a1==1)
                AlgoDynamicInputDataS.ABI_L2_aux_sunglint_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_radiance_band_7');
            if(a1==1)
                AlgoDynamicInputDataS.ABI_radiance_band_7=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_7_2km_data');
            if(a1==1)
                AlgoDynamicInputDataS.ABI_L2_bright_temp_band_7_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                AlgoDynamicInputDataS.ABI_L2_bright_temp_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_15_2km_data');
            if(a1==1)
                AlgoDynamicInputDataS.ABI_L2_bright_temp_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_2_2km_data');
            if(a1==1)
                AlgoDynamicInputDataS.ABI_L2_inter_product_reflec_band_2_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_time_of_last_fire_data');
            if(a1==1)
                AlgoDynamicInputDataS.ABI_L2_inter_product_time_of_last_fire_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_total_precipitable_water_data');
            if(a1==1)
                AlgoDynamicInputDataS.dynamic_ancillary_NWP_total_precip_water_data=attname2;
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
                ProcessParamVersionContainerS.long_name=attname2;
            end
            a1=strcmp(attname1,'L2_processing_parm_version');
            if(a1==1)
                ProcessParamVersionContainerS.L2_processing_parm_version=attname2;
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
                AlgoProdVersionContS.long_name=attname2;
            end
            a1=strcmp(attname1,'algorithm_version');
            if(a1==1)
                AlgoProdVersionContS.algorithm_version=attname2;
            end
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                AlgoProdVersionContS.product_version=attname2;
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
                GRB_ErrorsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GRB_ErrorsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                GRB_ErrorsS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GRB_ErrorsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                GRB_ErrorsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                GRB_ErrorsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                GRB_ErrorsS.cell_methods=attname2;
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
                L0_ErrorsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                L0_ErrorsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                L0_ErrorsS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                L0_ErrorsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                L0_ErrorsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                L0_ErrorsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                L0_ErrorsS.cell_methods=attname2;
            end
        else
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
        end
    end
    if(idebug==1)
        disp(' ');
    end
    if flag
        eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
        if(a10==1)
            AreaS.values= Area;
        end
        if(a20==1)
            TempS.values=Temp;
        end
        if(a70==1)
            yS.values=y;
        end
        if(a80==1)
            xS.values=x;
        end
        if(a110==1)
            FlashDataS.values2=flash_time_offset_of_first_event;
        end
        if(a120==1)
            FlashDataS.values3=flash_time_offset_of_last_event;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])
        if(a30==1)
            MaskS.values=Mask;
        end
        if(a40==1)
            PowerS.values=Power;
        end
        if(a50==1)
            DQFS.values=DQF;
        end
        if(a60==1)
            tS.values=t;
        end
        if(a90==1)
            tBS.values=time_bounds;
        end
        if(a100==1)
            goesImagerS.values=goes_imager_projection;
        end
        if(a110==1)
            yImgS.values=y_image;
        end
        if(a120==1)
            yImgBS.values=y_image_bounds;
        end
        if(a130==1)
            xImgS.values=y_image;
        end
        if(a140==1)
            xImgBS.values=y_image_bounds;
        end
        if(a150==1)
            SatDataS.values1=nominal_satellite_subpoint_lat;
        end
        if(a160==1)
            SatDataS.values2=nominal_satellite_subpoint_lon;
        end
        if(a170==1)
            SatDataS.value3=nominal_satellite_height;
        end
        if(a180==1)
            GeoSpatialS.values=geospatial_lat_lon_extent;
        end
        if(a190==1)
            SunGlintS.values1=sunglint_angle;
        end
        if(a200==1)
            SunGlintS.values2=sunglint_angle_bounds;
        end
        if(a210==1)
            LZAS.values=local_zenith_angle;
        end
        if(a220==1)
            LZABS.values=local_zenith_angle_bounds;
        end
        if(a230==1)
            SZAS.values=solar_zenith_angle;
        end
        if(a240==1)
           SZABS.values=solar_zenith_angle_bounds; 
        end
        if(a250==1)
            PixelFireDataS.values1=total_number_of_pixels_with_fires_detected;
        end
        if(a260==1)
            PixelFireDataS.values2=total_number_of_pixels_with_fire_temperature;
        end
        if(a270==1)
            PixelFireDataS.values3=total_number_of_pixels_with_fire_radiative_power;
        end
        if(a280==1)
           FireOutlierPixelS.values1=fire_temperature_outlier_pixel_count; 
        end
        if(a290==1)
           FireOutlierPixelS.values2=fire_area_outlier_pixel_count; 
        end
        if(a300==1)
           FireOutlierPixelS.values3=fire_radiative_power_outlier_pixel_count;
        end
        if(a310==1)
            FireTempS.values1=minimum_fire_temperature;
        end
        if(a320==1)
            FireTempS.values2=maximum_fire_temperature;
        end
        if(a330==1)
            FireTempS.values3=mean_fire_temperature;
        end
        if(a340==1)
            FireTempS.values4=standard_deviation_fire_temperature;
        end
        if(a350==1)
            FireAreaS.values1=minimum_fire_area;
        end
        if(a360==1)
            FireAreaS.values2=maximum_fire_area;
        end
        if(a370==1)
            FireAreaS.values3=mean_fire_area;
        end
        if(a380==1)
            FireAreaS.values4=standard_deviation_fire_area;
        end
        if(a390==1)
            FirePowerS.values1=minimum_fire_radiative_power;
        end
        if(a400==1)
            FirePowerS.values2=maximum_fire_radiative_power;
        end
        if(a410==1)
            FirePowerS.values3=mean_fire_radiative_power;
        end
        if(a420==1)
            FirePowerS.values4=standard_deviation_fire_radiative_power;
        end
        if(a430==1)
            AlgoDynamicInputDataS.values=algorithm_dynamic_input_data_container;
        end
        if(a440==1)
            ProcessParamVersionContainerS.values=processing_parm_version_container;
        end
        if(a450==1)
            AlgoProdVersionContS.values=algorithm_product_version_container;
        end
        if(a460==1)
            GRB_ErrorsS.values=percent_uncorrectable_GRB_errors;
        end
        if(a470==1)
            L0_ErrorsS.values=percent_uncorrectable_L0_errors;
        end
    end
end
% disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
% disp('________________________________________________________')
% disp(' '),disp(' ')
% Close the file
netcdf.close(ncid);
fprintf(fid,'%s\n','^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~');
dispstr=strcat('closed file-',GOESFileName);
disp(dispstr)
fprintf(fid,'%s\n',dispstr);
elapsed_time=toc;
fprintf(fid,'\n');
timestr=strcat('Decoding time for file-',GOESFileName,'-was-',num2str(elapsed_time),...
    '-sec');
fprintf(fid,'%80s\n',timestr);
if(isavefiles>0)
% Now write a Matlab file containing the decoded data
% use the original file name with a .mat extension
    [iper]=strfind(GOESFileName,'.');
    is=1;
    ie=iper(1)-1;
    MatFileName=strcat(GOESFileName(is:ie),'.mat');
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='GOESFileName AreaS TempS MaskS PowerS DQFS';
    varstr2=' tS yS xS tBS goesImagerS yImgS yImgBS';
    varstr3=' xImgS xImgBS SatDataS GeoSpatialS SunGlintS LZAS';
    varstr4=' LZABS SZAS SZABS PixelFireDataS FireOutlierPixelS';
    varstr5=' FireTempS FireAreaS FirePowerS AlgoDynamicInputDataS';
    varstr6=' ProcessParamVersionContainerS AlgoProdVersionContS';
    varstr7=' GRB_ErrorsS L0_ErrorsS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Saved Decoded Data To Matlab File-',MatFileName);
    disp(dispstr);
    fprintf(fid,'%s\n',dispstr);
else
    dispstr=strcat('User choose to skip saving decoded data from file-',GOESFileName);
    disp(dispstr)
    fprintf(fid,'%s\n',dispstr);
end
% Calculate the Boundaries that will be used for a future map
% Get the county shape files
% Display the Fire Hot Spot Data
% Get the RasterLat lon values
eval(['cd ' gridpath(1:length(gridpath)-1)]);
gridfile='GOES16-CONUS-Lat-Lon-Boundaries.mat';
load(gridfile,'RasterLats','RasterLons');
FireTemp=TempS.values;
FireArea=AreaS.values;
[ibig,jbig]=find(FireTemp>500);
numbig=length(ibig);
dispstr=strcat('Number of pixels with FireTemp > 500=',num2str(numbig),'-pixels');
disp(dispstr)
% Get the Lat Lons of these fires
FireDetails=cell(1,1);
FireDetails{1,1}='State';
FireDetails{1,2}='County';
FireDetails{1,3}='FireLat';
FireDetails{1,4}='FireLon';
FireDetails{1,5}='Hot Temp';
FireDetails{1,6}='Hot Area';
FireDetails{1,7}='StateFP';
FireDetails{1,8}='CountyFP';
FireLabels=cell(1,1);
eval(['cd ' nationalshapepath(1:length(nationalshapepath)-1)]);
shapefilename=NationalCountiesShp;
S2=shaperead(shapefilename,'UseGeoCoords',true);
numrecords=length(S2);
if(numbig>0)
    dispstr=strcat('******A total of-',num2str(numbig),'-fires were found-list follows*****');
    fprintf(fid,'%80s\n',dispstr);
    FireLats=zeros(numbig,1);
    FireLons=zeros(numbig,1);
    FireHotTemps=zeros(numbig,1);
    FireHotAreas=zeros(numbig,1);
    firestr=strcat('  Fire#          StateName             CountyName       Lat        Lon       Temp         Area');
    fprintf(fid,'%50s\n',firestr);
    for m=1:numbig
        indx=ibig(m,1);
        indy=jbig(m,1);
        nowLat=RasterLats(indx,indy);
        nowLon=RasterLons(indx,indy);
        FireLats(m,1)=RasterLats(indx,indy);
        FireLons(m,1)=RasterLons(indx,indy);
        FireHotTemps(m,1)=FireTemp(indx,indy);
        FireHotAreas(m,1)=FireArea(indx,indy);
% Get the state and County of this fire
        [StateName,CountyName,StateFP,CountyFP] = GetStateAndCountyFromLatAndLon(FireLats(m,1),FireLons(m,1),m,S2);
        FireDetails{1+m,1}=StateName;
        FireDetails{1+m,2}=CountyName;
        FireDetails{1+m,3}=FireLats(m,1);
        FireDetails{1+m,4}=FireLons(m,1);
        FireDetails{1+m,5}=FireHotTemps(m,1);
        FireDetails{1+m,6}=FireHotAreas(m,1);
        FireDetails{1+m,7}=StateFP;
        FireDetails{1+m,8}=CountyFP;
        nowHot=FireHotTemps(m,1);
        FireLabels{m,1}=strcat(StateName,'-',CountyName,'-',num2str(nowHot,4),'-Deg-k');
        fprintf(fid,'% 5d',m);
        fprintf(fid,'%20s    %20s',StateName,CountyName);
        fprintf(fid,'%10.2f  %10.2f',FireLats(m,1),FireLons(m));
        fprintf(fid,'%10.2f  %12.0f\n',FireHotTemps(m,1),FireHotAreas(m));
    end
else
    dispstr='No large fires found';
    disp(dispstr)
end
[iunder]=strfind(GOESFileName,'_');
is=iunder(3)+1;
ie=iunder(4)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
fprintf(fid,'%s\n','////// Transferring Execution Of Routine ReadL2Fire //////');
titlestr=strcat('NationalFireHotSpotTemps-',filename);
% Check to see if a file called Deactive this feature for this release SMF
% Aril 14,2021
% eval(['cd ' summarypath(1:length(summarypath)-1)]);
% A=exist(FireSummaryFile);
% % If this file does not exist create it
% if(A==0)
%     CreateFireSummaryFile()
%     summaryfilestr='Created New SummaryFire File';
%     fprintf(fid,'% 20s\n',summaryfilestr);
% else
%     AddRecordFireSummaryFile()
%     summaryfilestr='Added Data From This GOES File To SummaryFire File';
%     fprintf(fid,'% 30s\n',summaryfilestr);
% end
itype=1;
warning('off');
dispstr='Build CONUS Level Fire Display Chart';
fprintf(fid,'% 30s\n',dispstr);
DisplayABIL2FireData(FireLats,FireLons,FireHotTemps,itype,titlestr)
warning('on');
northEdge=52.0;
tf=1;
while tf>0
    [indx,tf] = listdlg('PromptString',{'Select one fire for details'},...
    'SelectionMode','single','ListString',FireLabels,'ListSize',[240 300]);
    a1=isempty(indx);
    if(a1==0)
        eval(['cd ' countyshapepath(1:length(countyshapepath)-1)]);
        load('StateBoundingBoxes.mat','StateBoundaries');
        fireState=FireDetails{indx+1,1};
% Replace a blank in the state name by an underscore
        firestatedbl=double(fireState);
% look for a blank
        [iblank]=find(firestatedbl==32);
        numblank=length(iblank);
        a1=isempty(iblank);
        if(a1==0)
            for mm=1:numblank
                is=iblank(mm);
                ie=is;
                fireState(is:ie)='_';
            end
        end       
        fireCounty=FireDetails{indx+1,2};
        fireStateFP=FireDetails{indx+1,7};
        numentries=length(StateBoundaries);
        for kk=2:numentries
            nowState=char(StateBoundaries{kk,2});
            a1=strcmpi(nowState,fireState);
            if(a1==1)
                matchInd=kk;
                imatchState=kk;
                dispstr=strcat('User Selected Fire-',num2str(indx),'-in state-',fireState,...
                '-in county-',fireCounty);
                fprintf(fid,'% 30s\n',dispstr); 
            end
        end
 % test building a detailed DTED map
        LatC=FireLats(indx,1);
        LonC=FireLons(indx,1);
        latlim=[floor(LatC)+.01 ceil(LatC)-.01];
        lonlim=[floor(LonC)+.01 ceil(LonC)-.01];
        dtedfiles=dteds(latlim,lonlim,1);
% assign correct full file paths to each of these files
        numdted=length(dtedfiles);
        FullDTEDFilePaths=cell(numdted,1);
        prefix=dtedpath;
        for jj=1:numdted
            nowpath=char(dtedfiles{jj,1});
            nowlen=length(nowpath);
            [islash]=strfind(nowpath,'\');
            numslash=length(islash);
            longstr=nowpath(islash(1)+1:islash(2)-1);
            longstr2=upper(longstr);
            filestr=nowpath(islash(2)+1:nowlen);
            finalpath=strcat(prefix,longstr2,'\',filestr);
            FullDTEDFilePaths{jj,1}=finalpath;
        end

        southEdge1=floor(StateBoundaries{matchInd,5});
        northEdge1=ceil(StateBoundaries{matchInd,6});
        westEdge1=floor(StateBoundaries{matchInd,3});
        eastEdge1=ceil(StateBoundaries{matchInd,4});
        titlestr=strcat(fireState,'-StateLevelFireHotSpotTemps-',filename);
        dispstr='************* Build State Level Fire Chart **************';
        fprintf(fid,'%30s\n',dispstr); 
        dispstr=strcat('Name Of Plot is-',titlestr,'.jpg');
        fprintf(fid,'%50s\n',dispstr); 
        iPrimeRoads=1;
        iCountyRoads=1;
        iCommonRoads=0;
        iStateRecRoads=0;
        iUSRoads=0;
        iStateRoads=1;
        iLakes=1;
        DisplayABIL2StateFireData(FireLats,FireLons,FireHotTemps,itype,fireState,fireStateFP,indx,titlestr)
        itype=1;
        westEdge1=floor(LonC);
        eastEdge1=ceil(LonC);
        northEdge1=ceil(LatC);
        southEdge1=floor(LatC);
        titlestr=strcat(fireState,'-Detailed3DFireHotSpotTemps-',filename);
        dispstr='************* Build Detailed Fire DEM Chart **************';
        fprintf(fid,'%30s\n',dispstr); 
        dispstr=strcat('Name Of Plot is-',titlestr,'.jpg');
        fprintf(fid,'%50s\n',dispstr); 
        dispstr=strcat('DTED File Used-',finalpath);
        fprintf(fid,'%30s\n',dispstr);
        DisplayDetailed3DFireHotSpotsRev1(FireLats,FireLons,itype,fireState,fireStateFP,indx,titlestr)
        LatC=FireLats(indx,1);
        LonC=FireLons(indx,1);
        westEdge1=floor(LonC-1);
        eastEdge1=ceil(LonC+1);
        northEdge1=ceil(LatC+1);
        southEdge1=floor(LatC-1);
    end
end
fprintf(fid,'%s\n','////// Completed Execution Of Routine ReadL2Fire //////');
end

