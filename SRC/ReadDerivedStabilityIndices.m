function ReadDerivedStabilityIndices()
% Modified: This function will read in the GOES calculated
% derived stability index. This is one item in the LAP or
% Legacy Atmospheric Profile which contains a number of measurements.
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. 
% Written By: Stephen Forczyk
% Created: Feb 15,2021
% Revised: Feb 16,2021-continue writing decode portion of this routine
% Revised: Feb 17,2021-continue writing decode portion
% Classification: Unclassified

global MetaDataS;
global LIS CAPES TTS SIS KIS;
global FAPS;
global DQF_OverallS DQF_RetrievalS DQF_SkinTempS;
global TotAttRetS;
global CAPEOutlierPixelS LIOutlierPixelS KIOutlierPixelS;
global ShowOutlierPixelS TTIOutlierPixelS;
global CAPEStatS LIStatS TTStatS ShowStatS KIStatS;
global tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS  RLZABS;
global LatitudeS LatitudeBoundsS;
global SoundingWaveS SoundingWaveIDS;
global TotAttempRetS;
global MeanDiffSoundingBandS StdevDiffSoundingBandS;
global GRBErrorsS L0ErrorsS;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global RasterLats RasterLons;
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
fprintf(fid,'%s\n','-----Start reading Stabiity Index Data----');

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
% OutlierPixelCountS=struct('values',[],'long_name',[],'FillValue',[],...
%     'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
% TPWS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],'Unsigned',[],...
%     'valid_range',[],'scale_factor',[],'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
%     'cell_methods',[],'ancillary_variables',[],'add_offset',[]);
LIS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],'Unsigned',[],...
    'valid_range',[],'scale_factor',[],'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'ancillary_variables',[],'add_offset',[]);
CAPES=LIS;
TTS=LIS;
SIS=LIS;
KIS=LIS;
CAPEOutlierPixelS=struct('values',[],'long_name',[],'FillValue',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[]);
LIOutlierPixelS=CAPEOutlierPixelS;
KIOutlierPixelS=LIOutlierPixelS;
ShowOutlierPixelS=LIOutlierPixelS;
TTIOutlierPixelS=LIOutlierPixelS;
%MeanDiffSEBS=LIOutlierPixelS;
CAPEStatS=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'FillValue1',[],'valid_range1',[],'units1',[],'coordinates1',[],...
    'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],...
    'FillValue2',[],'valid_range2',[],'units2',[],'coordinates2',[],...
    'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],... 
    'FillValue3',[],'valid_range3',[],'units3',[],'coordinates3',[],...
    'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],... 
    'FillValue4',[],'valid_range4',[],'units4',[],'coordinates4',[],...
    'grid_mapping4',[],'cell_methods4',[]);
LIStatS=CAPEStatS;
TTStatS=CAPEStatS;
ShowStatS=CAPEStatS;
KIStatS=CAPEStatS;
TotAttRetS=struct('values',[],'long_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
FAPS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'axis',[]);
SoundingWaveS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
SoundingWaveIDS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
TotAttempRetS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
MeanDiffSoundingBandS=TotAttempRetS;
StdevDiffSoundingBandS=TotAttempRetS;
SZAS=struct('value',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
SZABS=struct('value',[],'long_name',[]);
RLZABS=struct('value',[],'long_name',[]);
QLZAS=struct('value',[],'long_name',[],'standard_name',[],...
    'units',[],'bounds',[]);
QLZABS=struct('value',[],'long_name',[]);
RLZAS=struct('value',[],'long_name',[],'standard_name',[]);
LatitudeS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
LatitudeBoundsS=struct('values',[],'long_name',[]);
DQF_OverallS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'pct_good_quality_qf',[],...
    'pct_inval_due_to_not_geolocated_or_retrieval_LZA_qf',[],...
    'pct_degraded_due_to_latitude_threshold_exceeded_qf',[],...
    'pct_degraded_due_to_quantitative_LZA_threshold_exceeded_qf',[],...
    'pct_inval_due_to_insuff_clear_pixels_in_field_of_regard_qf',[],...
    'pct_inval_due_to_missing_NWP_data_qf',[],...
    'pct_inval_due_to_missing_L1b_data_or_fatal_processing_error_qf',[],...
    'pct_inval_due_to_bad_NWP_surface_pressure_index_qf',[],...
    'pct_inval_due_to_indeterminate_land_surface_emissivity_qf',[],...
    'pct_inval_due_to_bad_TPW_sigma_pressure_level_index_qf',[],...
    'pct_inval_due_to_occurrence_of_not_a_number_qf',[]);
DQF_RetrievalS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'percent_good_retrieval_qf',[],...
    'percent_nonconvergent_retrieval_qf',[],...
    'percent_brightness_temp_residual_exceeds_threshold_qf',[],...
    'percent_incomplete_convergence_of_retrieval_qf',[],...
    'percent_unrealistic_retrieved_value_qf',[],...
    'pct_inval_radiative_transfer_model_brightness_temp_value_qf',[]);
DQF_SkinTempS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'pct_good_first_guess_skin_temp_qf',[],...
    'pct_first_guess_skin_temp_exceeds_upper_threshold_qf',[],...
    'pct_first_guess_skin_temp_exceeds_lower_threshold_qf',[]);
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
    'input_ABI_L2_brightness_temperature_band_7_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_8_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_9_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_10_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_11_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_12_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_13_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_15_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_16_2km_data',[],...
    'input_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...
    'input_dynamic_ancillary_NWP_surface_pressure_data',[],...
    'input_dynamic_ancillary_NWP_surface_temperature_data',[],...
    'input_dynamic_ancillary_NWP_temperature_profile_data',[],...
    'input_dynamic_ancillary_NWP_moisture_profile_data',[],...
    'input_dynamic_ancillary_NWP_wind_vector_profile_data',[],...
    'input_dynamic_ancillary_NWP_surface_level_index_data',[]);
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
        a10=strcmp(varname,'LI');
        a12=strcmp(varname,'CAPE');
        a14=strcmp(varname,'TT');
        a16=strcmp(varname,'SI');
        a18=strcmp(varname,'KI');
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
        a160=strcmp(varname,'final_air_pressure');
        a170=strcmp(varname,'CAPE_outlier_pixel_count');
        a180=strcmp(varname,'lifted_index_outlier_pixel_count');
        a190=strcmp(varname,'k_index_outlier_pixel_count');
        a200=strcmp(varname,'showalter_index_outlier_pixel_count');
        a210=strcmp(varname,'total_totals_index_outlier_pixel_count');
        a240=strcmp(varname,'algorithm_dynamic_input_data_container');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'retrieval_local_zenith_angle');
        a280=strcmp(varname,'quantitative_local_zenith_angle');
        a290=strcmp(varname,'retrieval_local_zenith_angle_bounds');
        a310=strcmp(varname,'quantitative_local_zenith_angle_bounds');
        a320=strcmp(varname,'minimum_CAPE');
        a330=strcmp(varname,'maximum_CAPE');
        a340=strcmp(varname,'mean_CAPE');
        a350=strcmp(varname,'standard_deviation_CAPE');
        a360=strcmp(varname,'minimum_lifted_index');
        a370=strcmp(varname,'maximum_lifted_index');
        a380=strcmp(varname,'mean_lifted_index');
        a390=strcmp(varname,'standard_deviation_lifted_index');
        a400=strcmp(varname,'total_attempted_retrievals');
        a410=strcmp(varname,'mean_obs_modeled_diff_sounding_emissive_bands');
        a420=strcmp(varname,'std_dev_obs_modeled_diff_sounding_emissive_bands');
        a460=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a470=strcmp(varname,'percent_uncorrectable_L0_errors');
        a570=strcmp(varname,'latitude');
        a580=strcmp(varname,'latitude_bounds');
        a750=strcmp(varname,'solar_zenith_angle');
        a780=strcmp(varname,'solar_zenith_angle_bounds');
        a800=strcmp(varname,'DQF_Overall');
        a810=strcmp(varname,'DQF_Retrieval');
        a820=strcmp(varname,'DQF_SkinTemp');
        a850=strcmp(varname,'minimum_total_totals_index');
        a860=strcmp(varname,'maximum_total_totals_index');
        a870=strcmp(varname,'mean_total_totals_index');
        a880=strcmp(varname,'standard_deviation_total_totals_index');
        a890=strcmp(varname,'minimum_showalter_index');
        a900=strcmp(varname,'maximum_showalter_index');
        a910=strcmp(varname,'mean_showalter_index');
        a920=strcmp(varname,'standard_deviation_showalter_index');
        a930=strcmp(varname,'minimum_k_index');
        a940=strcmp(varname,'maximum_k_index');
        a950=strcmp(varname,'mean_k_index');
        a960=strcmp(varname,'standard_deviation_k_index');
        a970=strcmp(varname,'sounding_emissive_wavelengths');
        a980=strcmp(varname,'sounding_emissive_band_ids');
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
                LIS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LIS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LIS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                LIS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                LIS.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LIS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                LIS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LIS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                LIS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LIS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LIS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LIS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                LIS.resolution=attname2;
            end
            a1=strcmp(attname1,'algorithm_type');
            if(a1==1)
                LIS.algorithm_type=attname2;
            end
        elseif(a12==1)
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
                CAPES.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CAPES.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CAPES.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CAPES.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CAPES.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CAPES.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CAPES.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CAPES.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CAPES.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CAPES.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CAPES.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CAPES.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CAPES.resolution=attname2;
            end
            a1=strcmp(attname1,'algorithm_type');
            if(a1==1)
                CAPES.algorithm_type=attname2;
            end
        elseif(a14==1)
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
                TTS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TTS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TTS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                TTS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                TTS.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TTS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                TTS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TTS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                TTS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TTS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TTS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TTS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                TTS.resolution=attname2;
            end
            a1=strcmp(attname1,'algorithm_type');
            if(a1==1)
                TTS.algorithm_type=attname2;
            end
        elseif(a16==1)
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
                SIS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SIS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SIS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                SIS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                SIS.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                SIS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                SIS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SIS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                SIS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SIS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SIS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SIS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                SIS.resolution=attname2;
            end
            a1=strcmp(attname1,'algorithm_type');
            if(a1==1)
                SIS.algorithm_type=attname2;
            end
        elseif(a18==1)
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
                KIS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                KIS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                KIS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                KIS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                KIS.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                KIS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                KIS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                KIS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                KIS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                KIS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                KIS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                KIS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                KIS.resolution=attname2;
            end
            a1=strcmp(attname1,'algorithm_type');
            if(a1==1)
                KIS.algorithm_type=attname2;
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
                FAPS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FAPS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FAPS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                FAPS.axis=attname2;
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
                CAPEOutlierPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CAPEOutlierPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CAPEOutlierPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CAPEOutlierPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CAPEOutlierPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CAPEOutlierPixelS.cell_methods=attname2;
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
                LIOutlierPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LIOutlierPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LIOutlierPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LIOutlierPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LIOutlierPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LIOutlierPixelS.cell_methods=attname2;
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
                KIOutlierPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                KIOutlierPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                KIOutlierPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                KIOutlierPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                KIOutlierPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                KIOutlierPixelS.cell_methods=attname2;
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
                ShowOutlierPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ShowOutlierPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ShowOutlierPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ShowOutlierPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ShowOutlierPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ShowOutlierPixelS.cell_methods=attname2;
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
                TTIOutlierPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TTIOutlierPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TTIOutlierPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TTIOutlierPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TTIOutlierPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TTIOutlierPixelS.cell_methods=attname2;
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
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_7_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_7_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_8_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_8_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_9_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_9_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_10_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_10_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_11_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_11_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_12_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_12_2km_data=attname2;
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
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_16_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_16_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_4_level_cloud_mask_data');
            if(a1==1)
                AlgoS.input_ABI_L2_intermediate_product_4_level_cloud_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_pressure_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_pressure_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_temperature_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_temperature_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_temperature_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_temperature_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_moisture_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_moisture_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_wind_vector_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_wind_vector_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_level_index_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_level_index_data=attname2;
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
                QLZABS.long_name=attname2;
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
                CAPEStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CAPEStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CAPEStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CAPEStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CAPEStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CAPEStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CAPEStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CAPEStatS.cell_methods1=attname2;
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
                CAPEStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CAPEStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CAPEStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CAPEStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CAPEStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CAPEStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CAPEStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CAPEStatS.cell_methods2=attname2;
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
                CAPEStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CAPEStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CAPEStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CAPEStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CAPEStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CAPEStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CAPEStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CAPEStatS.cell_methods3=attname2;
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
                CAPEStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CAPEStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CAPEStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CAPEStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CAPEStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CAPEStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CAPEStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CAPEStatS.cell_methods4=attname2;
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
                LIStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LIStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LIStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LIStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LIStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LIStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LIStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LIStatS.cell_methods1=attname2;
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
                LIStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LIStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LIStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LIStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LIStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LIStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LIStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LIStatS.cell_methods2=attname2;
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
                LIStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LIStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LIStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LIStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LIStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LIStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LIStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LIStatS.cell_methods3=attname2;
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
                LIStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LIStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LIStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LIStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LIStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LIStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LIStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LIStatS.cell_methods4=attname2;
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
                TotAttempRetS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TotAttempRetS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TotAttempRetS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TotAttempRetS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TotAttempRetS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TotAttempRetS.cell_methods=attname2;
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
                MeanDiffSoundingBandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MeanDiffSoundingBandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MeanDiffSoundingBandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MeanDiffSoundingBandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                MeanDiffSoundingBandS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MeanDiffSoundingBandS.cell_methods=attname2;
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
                StdevDiffSoundingBandS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                StdevDiffSoundingBandS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                StdevDiffSoundingBandS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                StdevDiffSoundingBandS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                StdevDiffSoundingBandS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                StdevDiffSoundingBandS.cell_methods=attname2;
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
                LatitudeS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatitudeS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatitudeS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                LatitudeS.bounds=attname2;
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
                LatitudeBoundsS.long_name=attname2;
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
                SZABS.long_name=attname2;
            end
        elseif (a800==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)]);
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_OverallS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_OverallS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_OverallS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_OverallS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_OverallS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_OverallS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_OverallS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_OverallS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DQF_OverallS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_OverallS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_OverallS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_OverallS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_OverallS.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_quality_qf');
            if(a1==1)
                DQF_OverallS.pct_good_quality_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_not_geolocated_or_retrieval_LZA_threshold_exceeded_qf');
            if(a1==1)
                DQF_OverallS.pct_inval_due_to_not_geolocated_or_retrieval_LZA_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_degraded_due_to_latitude_threshold_exceeded_qf');
            if(a1==1)
                DQF_OverallS.pct_degraded_due_to_latitude_threshold_exceeded_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_quantitative_LZA_threshold_exceeded_qf');
            if(a1==1)
                DQF_OverallS.pct_degraded_due_to_quantitative_LZA_threshold_exceeded_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_insufficient_clear_pixels_in_field_of_regard_qf');
            if(a1==1)
                DQF_OverallS.pct_inval_due_to_insuff_clear_pixels_in_field_of_regard_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_missing_NWP_data_qf');
            if(a1==1)
                DQF_OverallS.pct_inval_due_to_missing_NWP_data_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_missing_L1b_data_or_fatal_processing_error_qf');
            if(a1==1)
                DQF_OverallS.pct_inval_due_to_missing_L1b_data_or_fatal_processing_error_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_bad_NWP_surface_pressure_index_qf');
            if(a1==1)
                DQF_OverallS.pct_inval_due_to_bad_NWP_surface_pressure_index_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_indeterminate_land_surface_emissivity_qf');
            if(a1==1)
                DQF_OverallS.pct_inval_due_to_indeterminate_land_surface_emissivity_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_bad_TPW_sigma_pressure_level_index_qf');
            if(a1==1)
                DQF_OverallS.pct_inval_due_to_bad_TPW_sigma_pressure_level_index_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_occurrence_of_not_a_number_qf');
            if(a1==1)
                DQF_OverallS.pct_inval_due_to_occurrence_of_not_a_number_qf=attname2;
            end
        elseif (a810==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)]);
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_RetrievalS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_RetrievalS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_RetrievalS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_RetrievalS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_RetrievalS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_RetrievalS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_RetrievalS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_RetrievalS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DQF_RetrievalS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_RetrievalS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_RetrievalS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_RetrievalS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_RetrievalS.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_retrieval_qf');
            if(a1==1)
                DQF_RetrievalS.percent_good_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'percent_nonconvergent_retrieval_qf');
            if(a1==1)
                DQF_RetrievalS.percent_nonconvergent_retrieval_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_brightness_temp_residual_exceeds_threshold_qf');
            if(a1==1)
                DQF_RetrievalS.percent_brightness_temp_residual_exceeds_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_incomplete_convergence_of_retrieval_qf');
            if(a1==1)
                DQF_RetrievalS.percent_incomplete_convergence_of_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'percent_unrealistic_retrieved_value_qf');
            if(a1==1)
                DQF_RetrievalS.percent_unrealistic_retrieved_value_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_radiative_transfer_model_brightness_temp_value_qf');
            if(a1==1)
                DQF_RetrievalS.pct_inval_radiative_transfer_model_brightness_temp_value_qf=attname2;
            end
        elseif (a820==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)]);
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_SkinTempS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_SkinTempS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_SkinTempS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_SkinTempS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_SkinTempS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_SkinTempS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_SkinTempS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_SkinTempS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DQF_SkinTempS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_SkinTempS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_SkinTempS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_SkinTempS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_SkinTempS.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_first_guess_skin_temp_qf');
            if(a1==1)
                DQF_SkinTempS.pct_good_first_guess_skin_temp_qf=attname2;
            end
            a1=strcmp(attname1,'percent_first_guess_skin_temp_exceeds_upper_threshold_qf');
            if(a1==1)
                DQF_SkinTempS.pct_first_guess_skin_temp_exceeds_upper_threshold_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_first_guess_skin_temp_exceeds_lower_threshold_qf');
            if(a1==1)
                DQF_SkinTempS.pct_first_guess_skin_temp_exceeds_lower_threshold_qf=attname2;
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
                TTStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TTStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TTStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TTStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TTStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TTStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TTStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TTStatS.cell_methods1=attname2;
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
                TTStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TTStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TTStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TTStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TTStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TTStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TTStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TTStatS.cell_methods2=attname2;
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
                TTStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TTStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TTStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TTStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TTStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TTStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TTStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TTStatS.cell_methods3=attname2;
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
                TTStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TTStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TTStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TTStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TTStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TTStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TTStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TTStatS.cell_methods4=attname2;
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
                ShowStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ShowStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ShowStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ShowStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ShowStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ShowStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ShowStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ShowStatS.cell_methods1=attname2;
            end
         elseif (a900==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ShowStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ShowStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ShowStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ShowStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ShowStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ShowStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ShowStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ShowStatS.cell_methods2=attname2;
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
                ShowStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ShowStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ShowStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ShowStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ShowStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ShowStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ShowStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ShowStatS.cell_methods3=attname2;
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
                ShowStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ShowStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ShowStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ShowStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ShowStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ShowStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ShowStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ShowStatS.cell_methods4=attname2;
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
                KIStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                KIStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                KIStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                KIStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                KIStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                KIStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                KIStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                KIStatS.cell_methods1=attname2;
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
                KIStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                KIStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                KIStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                KIStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                KIStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                KIStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                KIStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                KIStatS.cell_methods2=attname2;
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
                KIStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                KIStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                KIStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                KIStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                KIStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                KIStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                KIStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                KIStatS.cell_methods3=attname2;
            end
         elseif (a960==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                KIStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                KIStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                KIStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                KIStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                KIStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                KIStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                KIStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                KIStatS.cell_methods4=attname2;
            end
         elseif (a970==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SoundingWaveS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SoundingWaveS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SoundingWaveS.units=attname2;
            end
        elseif (a980==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SoundingWaveIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SoundingWaveIDS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SoundingWaveIDS.units=attname2;
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
            FillValue=LIS.FillValue;
               [LIV,numnanvals] = ReplaceFillValues(LI,FillValue);
               [nrows,ncols]=size(LIV);
               level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=LIV(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           LIV(ik,jk)=corval;
                      end
                   end
               end
               LIV2=LIV'*scale+offset;
               LIS.values=double(LIV2); 
               clear LIV LIV2;
        end
        if(a12==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            FillValue=CAPES.FillValue;
               [CAPEV,numnanvals] = ReplaceFillValues(CAPE,FillValue);
               [nrows,ncols]=size(CAPEV);
               level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=CAPEV(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           CAPEV(ik,jk)=corval;
                      end
                   end
               end
               CAPEV2=CAPEV'*scale+offset;
               CAPES.values=double(CAPEV2); 
               clear CAPEV CAPEV2;
        end
        if(a14==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            FillValue=TTS.FillValue;
               [TTV,numnanvals] = ReplaceFillValues(TT,FillValue);
               [nrows,ncols]=size(TTV);
               level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=TTV(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           TTV(ik,jk)=corval;
                      end
                   end
               end
               TTV2=TTV'*scale+offset;
               TTS.values=double(TTV2); 
               clear TTV TTV2;
        end
        if(a16==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            FillValue=SIS.FillValue;
               [SIV,numnanvals] = ReplaceFillValues(SI,FillValue);
               [nrows,ncols]=size(SIV);
               level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=SIV(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           SIV(ik,jk)=corval;
                      end
                   end
               end
               SIV2=SIV'*scale+offset;
               SIS.values=double(SIV2); 
               clear SIV SIV2;
        end
        if(a18==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            FillValue=KIS.FillValue;
               [KIV,numnanvals] = ReplaceFillValues(KI,FillValue);
               [nrows,ncols]=size(KIV);
               level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=KIV(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           KIV(ik,jk)=corval;
                      end
                   end
               end
               KIV2=KIV'*scale+offset;
               KIS.values=double(KIV2); 
               clear KIV KIV2;
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
            FAPS.values=final_air_pressure;
        end
        if(a170==1)
            CAPEOutlierPixelS.values=CAPE_outlier_pixel_count;
        end
        if(a180==1)
            LIOutlierPixelS.values=lifted_index_outlier_pixel_count;
        end
        if(a190==1)
            KIOutlierPixelS.values=k_index_outlier_pixel_count;
        end
        if(a200==1)
            ShowOutlierPixelS.values=showalter_index_outlier_pixel_count;
        end
        if(a210==1)
            TTIOutlierPixelS.values=total_totals_index_outlier_pixel_count;
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
        if(a310==1)
            QLZABS.value=quantitative_local_zenith_angle_bounds;
        end
        if(a320==1)
            CAPEStatS.values1=minimum_CAPE;
        end
        if(a330==1)
            CAPEStatS.values2=maximum_CAPE;
        end
        if(a340==1)
            CAPEStatS.values3=mean_CAPE;
        end
        if(a350==1)
            CAPEStatS.values4=standard_deviation_CAPE;
        end
        if(a360==1)
            LIStatS.values1=minimum_lifted_index;
        end
        if(a370==1)
            LIStatS.values2=maximum_lifted_index;
        end
        if(a380==1)
            LIStatS.values3=mean_lifted_index;
        end
        if(a390==1)
            LIStatS.values4=standard_deviation_lifted_index;
        end
        if(a400==1)
             TotAttempRetS.values=total_attempted_retrievals;
             ab=1;
        end
        if(a410==1)
             MeanDiffSoundingBandS.values=mean_obs_modeled_diff_sounding_emissive_bands;
        end
        if(a420==1)
             StdevDiffSoundingBandS.values=std_dev_obs_modeled_diff_sounding_emissive_bands;
             ab=1;
        end
        if(a460==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors;          
        end
        if(a470==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
        end
        if(a570==1)
            LatitudeS.values=latitude;
        end
        if(a580==1)
            LatitudeBoundsS=latitude_bounds;
        end
        if(a750==1)
            SZAS.value=solar_zenith_angle;
        end
        if(a780==1)
            SZABS.value=solar_zenith_angle_bounds;
        end
        if(a800==1)
            DQF_OverallS.values=DQF_Overall;
        end
        if(a810==1)
            DQF_RetrievalS.values=DQF_Retrieval;
        end
        if(a820==1)
            DQF_SkinTempS.values=DQF_SkinTemp;
        end
        if(a850==1)
            TTStatS.values1=minimum_total_totals_index;
        end
        if(a860==1)
            TTStatS.values2=maximum_total_totals_index;
        end
        if(a870==1)
            TTStatS.values3=mean_total_totals_index;
        end
        if(a880==1)
            TTStatS.values4=standard_deviation_total_totals_index;
        end
        if(a890==1)
            ShowStatS.values1=minimum_showalter_index;
        end
        if(a900==1)
            ShowStatS.values2=maximum_showalter_index;
        end
        if(a910==1)
            ShowStatS.values3=mean_showalter_index;
        end
        if(a920==1)
            ShowStatS.values4=standard_deviation_showalter_index;
        end
        if(a930==1)
            KIStatS.values1=minimum_k_index;
        end
        if(a940==1)
            KIStatS.values2=maximum_k_index;
        end
        if(a950==1)
            KIStatS.values3=mean_k_index;
        end
        if(a960==1)
            KIStatS.values4=standard_deviation_k_index;
        end
        if(a970==1)
            SoundingWaveS.values=sounding_emissive_wavelengths;
        end
        if(a980==1)
            SoundingWaveIDS.values=sounding_emissive_band_ids;
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
fprintf(fid,'%s\n','Finished Reading Stability Index data');
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='LIS CAPES TTS SIS KIS MetaDataS  tS yS xS tBS goesImagerS';
    varstr2=' yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS ';
    varstr3=' AlgoS AlgoProdVersionContainerS LIS CAPES TTS SIS KIS';
    varstr4=' GoesWaveBand GOESFileName RLZAS QLZAS';
    varstr5=' GRBErrorsS L0ErrorsS LatitudeS LatitudeBoundsS';
    varstr6=' OutlierPixelCountS SoundingWaveS SoundingWaveIDS';
    varstr7=' TotAttempRetS MeanDiffSoundingBandS StdevDiffSoundingBandS';
    varstr8=' DQF_OverallS DQF_RetrievalS DQF_SkinTempS';
    varstr9=' CAPEOutlierPixelS LIOutlierPixelS KIOutlierPixelS';
    varstr10=' ShowOutlierPixelS TTIOutlierPixelS';
    varstr11=' CAPEStatS LIStatS TTStatS ShowStatS KIStatS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7,varstr8);
    varstr=strcat(varstr,varstr9,varstr10,varstr11);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    savestr1=strcat('User saved Stability Index data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr1);
else
    savestr2=strcat('User did not save Stability Index data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr2);
end
%fclose(fid);
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
[numrows,numcols]=size(LIS.values);
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=(northEdge-southEdge)/numcols;
GeoRef.CellExtentInLongitude=abs((eastEdge-westEdge))/numrows;
datastr1=strcat('Stability Index array dimensions nrows=',num2str(numrows),...
    '-ncols=',num2str(numcols));
fprintf(fid,'%s\n',datastr1);
% Display the Stability Index Data-Start with the Lift Index (LI)
[imatch]=strfind(GOESFileName,'_e');
is=1;
ie=imatch(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('LI-Stability-Index-',filename);
[LI1DSF,sgoodfrac]=DisplayConusLIStabilityIndex(titlestr);
titlestr=strcat('LI-Stability-Hist-',filename);
[ValidLI]=PlotLIStabilityIndexHistogram(LI1DSF,sgoodfrac,titlestr);
titlestr=strcat('LI-Stability-CumilDist-',filename);
PlotLICumilDist(ValidLI,sgoodfrac,titlestr)
% Continue Stability Index Data-with the Convective Available Potential Energy  (CAPE)
titlestr=strcat('CAPE-Stability-Index-',filename);
[CAPE1DSF,sgoodfrac]=DisplayConusCAPEStabilityIndex(titlestr);
titlestr=strcat('CAPE-Stability-IndexHist-',filename);
[ValidCAPE]=PlotCAPEStabilityIndexHistogram(CAPE1DSF,sgoodfrac,titlestr);
titlestr=strcat('CAPE-Stability-CumilDist-',filename);
PlotCAPEStabilityCumilDist(ValidCAPE,sgoodfrac,titlestr)
% Continue with the TT Stability index
titlestr=strcat('TT-Stability-Index-',filename);
[TT1DSF,sgoodfrac]=DisplayConusTTStabilityIndex(titlestr);
titlestr=strcat('TT-Stability-Hist-',filename);
[ValidTT]=PlotTTStabilityIndexHistogram(TT1DSF,sgoodfrac,titlestr);
titlestr=strcat('TT-Stability-CumilDist-',filename);
PlotTTCumilDist(ValidTT,sgoodfrac,titlestr)
% Continue with the Showalter (SI) Stability Index
titlestr=strcat('SI-Stability-Index-',filename);
[SI1DSF,sgoodfrac]=DisplayConusSIStabilityIndex(titlestr);
titlestr=strcat('SI-Stability-IndexHist-',filename);
[ValidSI]=PlotSIStabilityIndexHistogram(SI1DSF,sgoodfrac,titlestr);
titlestr=strcat('SI-Stability-CumilDist-',filename);
PlotSIStabilityCumilDist(ValidSI,sgoodfrac,titlestr)
% Conclude with the K Index (KI) Stabilirty Index
titlestr=strcat('KI-Stability-Index-',filename);
[KI1DSF,sgoodfrac]=DisplayConusKIStabilityIndex(titlestr);
titlestr=strcat('KI-Stability-Hist-',filename);
[ValidKI]=PlotKIStabilityIndexHistogram(KI1DSF,sgoodfrac,titlestr);
titlestr=strcat('KI-Stability-CumilDist-',filename);
PlotKIStabilityCumilDist(ValidKI,sgoodfrac,titlestr)
% DShow a composite stability metric which is based on the sum of the
% preceeding 5 metrics
titlestr=strcat('Composite-Stability-Index-',filename);
DisplayConusCompositeStability(titlestr)
fprintf(fid,'%s\n','-----Finished reading Stability Index Data----');
disp('-----Finished Processing Stability Data-----');
end