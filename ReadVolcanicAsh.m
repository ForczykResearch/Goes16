function ReadVolcanicAsh()
% This function will read the volcanic ash files from 
% GOES
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. 
% Written By: Stephen Forczyk
% Created: Feb 27,2021
% Revised: Feb 28,2021 continue coding basic read routine
% Classification: Unclassified

global MetaDataS;
global VAHS VAMLS ;
global AshMassLoadTotMassS CountAttAshRetS;
global AshHtOutlierPixCountS AshMassOutlierPixCountS;
global AshCloudHtStatS AshMassStatS AshExistConfAngS;
global DET_DQFS RET_DQFS;
global tS yS xS tBS goesImagerS;
global SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global RLZAS RLZABS;
global SZAS SZABS;
global GRBErrorsS L0ErrorsS;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global RasterLats RasterLons;
global idebug isavefiles;
global HiQualSLayerAsh;
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath fid gridpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start reading Volcanic Ash Data----');

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
VAHS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'unsigned',[],'valid_range',[],'scale_factor',[],'add_offset',[],...
    'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'ancillary_variables',[]);
VAMLS=VAHS;
AshMassLoadTotMassS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
CountAttAshRetS=struct('values',[],'long_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
AshHtOutlierPixCountS=CountAttAshRetS;
AshMassOutlierPixCountS=CountAttAshRetS;
AshCloudHtStatS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
AshMassStatS=AshCloudHtStatS;
AshExistConfAngS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
SZAS=AshExistConfAngS;
SZABS=struct('values',[],'long_name',[]);
RLZABS=struct('value',[],'long_name',[]);
QLZAS=struct('value',[],'long_name',[],'standard_name',[],...
    'units',[],'bounds',[]);
QLZABS=struct('value',[],'long_name',[]);
RLZAS=struct('value',[],'long_name',[],'standard_name',[]);

yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
DET_DQFS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'percent_overall_good_quality_qf',[],'percent_overall_bad_quality_qf',[],...
    'number_of_L1b_qf_values',[],'percent_good_source_L1b_data_qf',[],...
    'percent_invalid_source_L1b_data_qf',[],'number_of_LZA_qf_values',[],...
    'percent_good_within_LZA_threshold_qf',[],...
    'percent_degraded_due_to_LZA_threshold_exceeded_qf',[],...
    'number_of_confidence_levels_single_layer_ash',[],...
    'percent_high_confidence_single_layer_ash_qf',[],...
    'percent_moderate_confidence_single_layer_ash_qf',[],...
    'percent_low_confidence_single_layer_ash_qf',[],...
    'percent_very_low_confidence_single_layer_ash_qf',[],...
    'percent_single_layer_not_ash_qf',[],...
    'number_of_confidence_levels_multiple_layer_ash',[],...
    'percent_high_confidence_multiple_layer_ash_qf',[],...
    'percent_moderate_confidence_multiple_layer_ash_qf',[],...
    'percent_low_confidence_multiple_layer_ash_qf',[],...
    'percent_very_low_confidence_multiple_layer_ash_qf',[],...
    'percent_multiple_layer_not_ash_qf',[]);
RET_DQFS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_retrieval_status_qf_values',[],...
    'percent_good_retrieval_qf',[],'percent_failed_retrieval_qf',[],...
    'percent_not_attempted_retrieval_qf',[],...
    'number_of_retrieved_cloud_top_temperature_qf_values',[],...
    'percent_high_quality_retrieved_cloud_top_temperature_qf',[],...
    'percent_medium_quality_retrieved_cloud_top_temperature_qf',[],...
    'percent_low_quality_retrieved_cloud_top_temperature_qf',[],...
    'number_of_retrieved_cloud_emissivity_qf_values',[],...
    'percent_high_quality_retrieved_cloud_emissivity_qf',[],...
    'percent_medium_quality_retrieved_cloud_emissivity_qf',[],...
    'percent_low_quality_retrieved_cloud_emissivity_qf',[],...
    'number_of_retrieved_absorption_optical_depth_ratio_qf_values',[],...
    'pct_high_quality_retrieved_absorption_optical_depth_ratio_qf',[],...
    'pct_medium_quality_retrieved_absorption_optical_depth_ratio_qf',[],...
    'pct_low_quality_retrieved_absorption_optical_depth_ratio_qf',[],...
    'number_of_ash_particle_size_classifications',[],...
    'percent_ash_particle_size_lt_2um_qf',[],...
    'percent_ash_particle_size_ge_2um_lt_3um_qf',[],...
    'percent_ash_particle_size_ge_3um_lt_4um_qf',[],...
    'percent_ash_particle_size_ge_4um_lt_5um_qf',[],...
    'percent_ash_particle_size_ge_5um_lt_6um_qf',[],...
    'percent_ash_particle_size_ge_6um_lt_7um_qf',[],...
    'percent_ash_particle_size_ge_7um_lt_8um_qf',[],...
    'percent_ash_particle_size_ge_8um_lt_9um_qf',[],...
    'percent_ash_particle_size_ge_9um_lt_10um_qf',[],...
    'percent_ash_particle_size_ge_10um_qf',[],...
    'percent_ash_particle_size_invalid_qf',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);

yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[]);
goesImagerS=struct('values',[],'long_name',[],'perspective_point_height',[],...
    'semi_major_axis',[],'semi_minor_axis',[],'inverse_flattening',[],...
    'latitude_of_projection_origin',[],'longitude_of_projection_origin',[],...
    'sweep_angle_axis',[]);
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
    'input_ABI_L1b_radiance_band_10_2km_data',[],...
    'input_ABI_L1b_radiance_band_11_2km_data',[],...
    'input_ABI_L1b_radiance_band_13_2km_data',[],...
    'input_ABI_L1b_radiance_band_15_2km_data',[],...
    'input_ABI_L1b_radiance_band_16_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_13_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_15_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_16_2km_data',[],...  
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_10_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_11_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_13_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_15_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_16_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_10_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_11_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_13_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_15_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_16_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_10_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_11_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_13_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_15_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_16_profile_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_10_prof_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_11_prof_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_13_prof_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_15_prof_data',[],...
    'inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_16_prof_data',[],...
    'input_dynamic_ancillary_NWP_surface_temperature_data',[],...
    'input_dynamic_ancillary_NWP_temperature_profile_data',[],...
    'input_dynamic_ancillary_NWP_geopotential_height_profile_data',[],...
    'input_dynamic_ancillary_NWP_pressure_profile_data',[],...
    'input_dynamic_ancillary_NWP_tropopause_level_index_data',[],...
    'inp_dynam_ancil_NWP_geopoten_height_derived_surface_index_data',[]);
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
        a10=strcmp(varname,'VAH');
        a12=strcmp(varname,'VAML');
        a20=strcmp(varname,'DET_DQF');
        a22=strcmp(varname,'RET_DQF');
        a30=strcmp(varname,'t');
        a40=strcmp(varname,'y');
        a50=strcmp(varname,'x');
        a60=strcmp(varname,'time_bounds');
        a70=strcmp(varname,'goes_imager_projection');
        a80=strcmp(varname,'ash_mass_loading_total_mass');
        a90=strcmp(varname,'count_attempted_ash_retrievals');
        a100=strcmp(varname,'lon_image');
        a110=strcmp(varname,'lon_image_bounds');
        a120=strcmp(varname,'nominal_satellite_subpoint_lat');
        a130=strcmp(varname,'nominal_satellite_subpoint_lon');
        a140=strcmp(varname,'nominal_satellite_height');
        a150=strcmp(varname,'geospatial_lat_lon_extent');
        a240=strcmp(varname,'algorithm_dynamic_input_data_container');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'retrieval_local_zenith_angle');
        a280=strcmp(varname,'quantitative_local_zenith_angle');
        a290=strcmp(varname,'retrieval_local_zenith_angle_bounds');
        a310=strcmp(varname,'quantitative_local_zenith_angle_bounds');
        a370=strcmp(varname,'ash_cloud_height_minimum');
        a380=strcmp(varname,'ash_cloud_height_maximum');
        a390=strcmp(varname,'ash_cloud_height_mean');
        a400=strcmp(varname,'ash_cloud_height_standard_deviation');
        a410=strcmp(varname,'ash_cloud_height_outlier_pixel_count');
        a420=strcmp(varname,'ash_mass_loading_outlier_pixel_count');
        a460=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a470=strcmp(varname,'percent_uncorrectable_L0_errors');
        a540=strcmp(varname,'ash_mass_loading_minimum');
        a550=strcmp(varname,'ash_mass_loading_maximum');
        a560=strcmp(varname,'ash_mass_loading_mean');
        a570=strcmp(varname,'ash_mass_loading_standard_deviation');
        a580=strcmp(varname,'ash_existence_confidence_threshold_local_zenith_angle');
        a590=strcmp(varname,'solar_zenith_angle');
        a600=strcmp(varname,'solar_zenith_angle_bounds');
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
                VAHS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                VAHS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VAHS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                VAHS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                VAHS.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                VAHS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                VAHS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VAHS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                VAHS.unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VAHS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                VAHS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                VAHS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                VAHS.resolution=attname2;
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
                VAMLS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                VAMLS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VAMLS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                VAMLS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                VAMLS.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                VAMLS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                VAMLS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VAMLS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                VAMLS.unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VAMLS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                VAMLS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                VAMLS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                VAMLS.resolution=attname2;
            end            
        elseif (a20==1)
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
                DET_DQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DET_DQFS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DET_DQFS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DET_DQFS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DET_DQFS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DET_DQFS.coordinates=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DET_DQFS.unsigned=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DET_DQFS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DET_DQFS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DET_DQFS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DET_DQFS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DET_DQFS.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_overall_good_quality_qf');
            if(a1==1)
                DET_DQFS.percent_overall_good_quality_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_overall_bad_quality_qf');
            if(a1==1)
                DET_DQFS.percent_overall_bad_quality_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_L1b_qf_values');
            if(a1==1)
                DET_DQFS.number_of_L1b_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_source_L1b_data_qf');
            if(a1==1)
                DET_DQFS.percent_good_source_L1b_data_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_source_L1b_data_qf');
            if(a1==1)
                DET_DQFS.percent_invalid_source_L1b_data_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_LZA_qf_values');
            if(a1==1)
                DET_DQFS.number_of_LZA_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_within_LZA_threshold_qf');
            if(a1==1)
                DET_DQFS.percent_good_within_LZA_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_LZA_threshold_exceeded_qf');
            if(a1==1)
                DET_DQFS.percent_degraded_due_to_LZA_threshold_exceeded_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_confidence_levels_single_layer_ash');
            if(a1==1)
                DET_DQFS.number_of_confidence_levels_single_layer_ash=attname2;
            end
            a1=strcmp(attname1,'percent_high_confidence_single_layer_ash_qf');
            if(a1==1)
                DET_DQFS.percent_high_confidence_single_layer_ash_qf=attname2;
            end
            a1=strcmp(attname1,'percent_moderate_confidence_single_layer_ash_qf');
            if(a1==1)
                DET_DQFS.percent_moderate_confidence_single_layer_ash_qf=attname2;
            end
            a1=strcmp(attname1,'percent_low_confidence_single_layer_ash_qf');
            if(a1==1)
                DET_DQFS.percent_low_confidence_single_layer_ash_qf=attname2;
            end
            a1=strcmp(attname1,'percent_very_low_confidence_single_layer_ash_qf');
            if(a1==1)
                DET_DQFS.percent_very_low_confidence_single_layer_ash_qf=attname2;
            end
            a1=strcmp(attname1,'percent_single_layer_not_ash_qf');
            if(a1==1)
                DET_DQFS.percent_single_layer_not_ash_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_confidence_levels_multiple_layer_ash');
            if(a1==1)
                DET_DQFS.number_of_confidence_levels_multiple_layer_ash=attname2;
            end
            a1=strcmp(attname1,'percent_high_confidence_multiple_layer_ash_qf');
            if(a1==1)
                DET_DQFS.percent_high_confidence_multiple_layer_ash_qf=attname2;
            end
            a1=strcmp(attname1,'percent_moderate_confidence_multiple_layer_ash_qf');
            if(a1==1)
                DET_DQFS.percent_moderate_confidence_multiple_layer_ash_qf=attname2;
            end
            a1=strcmp(attname1,'percent_low_confidence_multiple_layer_ash_qf');
            if(a1==1)
                DET_DQFS.percent_low_confidence_multiple_layer_ash_qf=attname2;
            end
            a1=strcmp(attname1,'percent_very_low_confidence_multiple_layer_ash_qf');
            if(a1==1)
                DET_DQFS.percent_very_low_confidence_multiple_layer_ash_qf=attname2;
            end
            a1=strcmp(attname1,'percent_multiple_layer_not_ash_qf');
            if(a1==1)
                DET_DQFS.percent_multiple_layer_not_ash_qf=attname2;
            end
        elseif (a22==1)
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
                RET_DQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RET_DQFS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RET_DQFS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RET_DQFS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RET_DQFS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RET_DQFS.coordinates=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                RET_DQFS.unsigned=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RET_DQFS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RET_DQFS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                RET_DQFS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                RET_DQFS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_retrieval_status_qf_values');
            if(a1==1)
                RET_DQFS.number_of_retrieval_status_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_retrieval_qf');
            if(a1==1)
                RET_DQFS.percent_good_retrieval_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_failed_retrieval_qf');
            if(a1==1)
                RET_DQFS.percent_failed_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'percent_not_attempted_retrieval_qf');
            if(a1==1)
                RET_DQFS.percent_not_attempted_retrieval_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_retrieved_cloud_top_temperature_qf_values');
            if(a1==1)
                RET_DQFS.number_of_retrieved_cloud_top_temperature_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_high_quality_retrieved_cloud_top_temperature_qf');
            if(a1==1)
                RET_DQFS.percent_high_quality_retrieved_cloud_top_temperature_qf=attname2;
            end
            a1=strcmp(attname1,'percent_medium_quality_retrieved_cloud_top_temperature_qf');
            if(a1==1)
                RET_DQFS.percent_medium_quality_retrieved_cloud_top_temperature_qf=attname2;
            end
            a1=strcmp(attname1,'percent_low_quality_retrieved_cloud_top_temperature_qf');
            if(a1==1)
                RET_DQFS.percent_low_quality_retrieved_cloud_top_temperature_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_retrieved_cloud_emissivity_qf_values');
            if(a1==1)
                RET_DQFS.number_of_retrieved_cloud_emissivity_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_high_quality_retrieved_cloud_emissivity_qf');
            if(a1==1)
                RET_DQFS.percent_high_quality_retrieved_cloud_emissivity_qf=attname2;
            end
            a1=strcmp(attname1,'percent_medium_quality_retrieved_cloud_emissivity_qf');
            if(a1==1)
                RET_DQFS.percent_medium_quality_retrieved_cloud_emissivity_qf=attname2;
            end
            a1=strcmp(attname1,'percent_low_quality_retrieved_cloud_emissivity_qf');
            if(a1==1)
                RET_DQFS.percent_low_quality_retrieved_cloud_emissivity_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_retrieved_absorption_optical_depth_ratio_qf_values');
            if(a1==1)
                RET_DQFS.number_of_retrieved_absorption_optical_depth_ratio_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_high_quality_retrieved_absorption_optical_depth_ratio_qf');
            if(a1==1)
                RET_DQFS.pct_high_quality_retrieved_absorption_optical_depth_ratio_qf=attname2;
            end
            a1=strcmp(attname1,'percent_medium_quality_retrieved_absorption_optical_depth_ratio_qf');
            if(a1==1)
                RET_DQFS.pct_medium_quality_retrieved_absorption_optical_depth_ratio_qf=attname2;
            end
            a1=strcmp(attname1,'percent_low_quality_retrieved_absorption_optical_depth_ratio_qf');
            if(a1==1)
                RET_DQFS.pct_low_quality_retrieved_absorption_optical_depth_ratio_qf=attname2;
            end
            a1=strcmp(attname1,'number_of_ash_particle_size_classifications');
            if(a1==1)
                RET_DQFS.number_of_ash_particle_size_classifications=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_lt_2um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_lt_2um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_2um_lt_3um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_2um_lt_3um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_3um_lt_4um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_3um_lt_4um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_4um_lt_5um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_4um_lt_5um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_5um_lt_6um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_5um_lt_6um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_6um_lt_7um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_6um_lt_7um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_7um_lt_8um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_7um_lt_8um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_8um_lt_9um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_8um_lt_9um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_9um_lt_10um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_9um_lt_10um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_ge_10um_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_ge_10um_qf=attname2;
            end
            a1=strcmp(attname1,'percent_ash_particle_size_invalid_qf');
            if(a1==1)
                RET_DQFS.percent_ash_particle_size_invalid_qf=attname2;
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
                AshMassLoadTotMassS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshMassLoadTotMassS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshMassLoadTotMassS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 AshMassLoadTotMassS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                 AshMassLoadTotMassS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                 AshMassLoadTotMassS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                 AshMassLoadTotMassS.cell_methods=attname2;
            end
        elseif (a90==1)
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
                CountAttAshRetS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CountAttAshRetS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 CountAttAshRetS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                 CountAttAshRetS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                 CountAttAshRetS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                 CountAttAshRetS.cell_methods=attname2;
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
                LonImgS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LonImgS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LonImgS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LonImgS.axis=attname2;
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
                LonImgBS.long_name=attname2;
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
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_10_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L1b_radiance_band_10_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_11_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L1b_radiance_band_11_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_13_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L1b_radiance_band_13_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_15_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L1b_radiance_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_16_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L1b_radiance_band_16_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_13_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_13_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_15_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_16_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_brightness_temperature_band_16_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_10_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_10_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_11_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_11_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_13_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_13_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_15_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_16_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_10_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_10_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_11_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_11_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_13_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_13_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_15_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_10_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_10_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_11_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_11_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_13_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_13_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_15_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_15_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_16_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_10_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_10_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_11_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_11_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_13_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_13_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_15_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_15_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_16_profile_data');
            if(a1==1)
                AlgoS.inp_ABI_L2_interm_prod_CRTM_clear_sky_trans_band_16_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_temperature_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_surface_temperature_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_temperature_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_temperature_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_geopotential_height_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_geopotential_height_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_pressure_profile_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_pressure_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_tropopause_level_index_data');
            if(a1==1)
                AlgoS.input_dynamic_ancillary_NWP_tropopause_level_index_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_geopotential_height_derived_surface_index_data');
            if(a1==1)
                AlgoS.inp_dynam_ancil_NWP_geopoten_height_derived_surface_index_data=attname2;
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
                AshCloudHtStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshCloudHtStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshCloudHtStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AshCloudHtStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshCloudHtStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshCloudHtStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshCloudHtStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshCloudHtStatS.cell_methods1=attname2;
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
                AshCloudHtStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshCloudHtStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshCloudHtStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AshCloudHtStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshCloudHtStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshCloudHtStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshCloudHtStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshCloudHtStatS.cell_methods2=attname2;
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
                AshCloudHtStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshCloudHtStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshCloudHtStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AshCloudHtStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshCloudHtStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshCloudHtStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshCloudHtStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshCloudHtStatS.cell_methods3=attname2;
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
                AshCloudHtStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshCloudHtStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshCloudHtStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AshCloudHtStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshCloudHtStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshCloudHtStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshCloudHtStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshCloudHtStatS.cell_methods4=attname2;
            end
        elseif (a410==1)
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
                AshHtOutlierPixCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshHtOutlierPixCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshHtOutlierPixCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshHtOutlierPixCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshHtOutlierPixCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshHtOutlierPixCountS.cell_methods=attname2;
            end
        elseif (a420==1)
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
                AshMassOutlierPixCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshMassOutlierPixCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshMassOutlierPixCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshMassOutlierPixCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshMassOutlierPixCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshMassOutlierPixCountS.cell_methods=attname2;
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
                AshMassStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshMassStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshMassStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AshMassStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshMassStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshMassStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshMassStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshMassStatS.cell_methods1=attname2;
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
                AshMassStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshMassStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshMassStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AshMassStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshMassStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshMassStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshMassStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshMassStatS.cell_methods2=attname2;
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
                AshMassStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshMassStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshMassStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AshMassStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshMassStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshMassStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshMassStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshMassStatS.cell_methods3=attname2;
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
                AshMassStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshMassStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                AshMassStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                AshMassStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshMassStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                AshMassStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                AshMassStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                AshMassStatS.cell_methods4=attname2;
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
                AshExistConfAngS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                AshExistConfAngS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                AshExistConfAngS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                AshExistConfAngS.bounds=attname2;
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
                SZABS.long_name=attname2;
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
           FillValue=VAHS.FillValue;
           [VAHV,numnanvals] = ReplaceFillValues(VAH,FillValue);
           [nrows,ncols]=size(VAHV);
           level=(2^15)-1;
           for ik=1:nrows
               for jk=1:ncols
                  value=VAHV(ik,jk);
                  if(value<0)
                       diff=level-abs(value);
                       corval=level+diff;
                       VAHV(ik,jk)=corval;
                  end
               end
           end
           VAHV2=VAHV'*scale+offset;
           VAHS.values=double(VAHV2); 
           clear VAHV VAHV2;
        end
        if(a12==1)
           eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
           FillValue=VAMLS.FillValue;
           [VAMLV,numnanvals] = ReplaceFillValues(VAML,FillValue);
           [nrows,ncols]=size(VAMLV);
           level=(2^15)-1;
           for ik=1:nrows
               for jk=1:ncols
                  value=VAMLV(ik,jk);
                  if(value<0)
                       diff=level-abs(value);
                       corval=level+diff;
                       VAMLV(ik,jk)=corval;
                  end
               end
           end
           VAMLV2=VAMLV'*scale+offset;
           VAMLS.values=double(VAMLV2); 
           clear VAMLV VAMLV2;
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
            DET_DQFS.values=DET_DQF;
        end
        if(a22==1)
            RET_DQFS.values=RET_DQF;
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
            AshMassLoadTotMassS.values=ash_mass_loading_total_mass;
        end
        if(a90==1)
            CountAttAshRetS.values=count_attempted_ash_retrievals;
        end
        if(a100==1)
            LonImgS.values=lon_image;
        end
        if(a110==1)
            LonImgBS.values=lon_image_bounds;
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
        if(a370==1)
            AshCloudHtStatS.values1=ash_cloud_height_minimum;
        end
        if(a380==1)
            AshCloudHtStatS.values2=ash_cloud_height_maximum;
        end
        if(a390==1)
            AshCloudHtStatS.values3=ash_cloud_height_mean;
        end
        if(a400==1)
            AshCloudHtStatS.values4=ash_cloud_height_standard_deviation;
        end
        if(a410==1)
            AshHtOutlierPixCountS.values=ash_cloud_height_outlier_pixel_count;
        end
        if(a420==1)
            AshMassOutlierPixCountS.values=ash_mass_loading_outlier_pixel_count;
        end
        if(a460==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors;          
        end
        if(a470==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
        end
        if(a540==1)
            AshMassStatS.values1=ash_mass_loading_minimum;
        end
        if(a550==1)
            AshMassStatS.values2=ash_mass_loading_maximum;
        end
        if(a560==1)
            AshMassStatS.values3=ash_mass_loading_mean;
        end
        if(a570==1)
            AshMassStatS.values4=ash_mass_loading_standard_deviation;
        end
        if(a580==1)
            AshExistConfAngS.values=ash_existence_confidence_threshold_local_zenith_angle;
        end
        if(a590==1)
            SZAS.values=solar_zenith_angle;
        end
        if(a600==1)
            SZABS.values=solar_zenith_angle_bounds;
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
fprintf(fid,'%s\n','Finished Reading Volcanic Ash data');

[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='VAHS VAMLS MetaDataS DET_DQFS RET_DQFS';
    varstr2=' tS yS xS tBS goesImagerS';
    varstr3=' SatDataS GeoSpatialS ';
    varstr4=' AlgoS AlgoProdVersionContainerS';
    varstr5=' GoesWaveBand GOESFileName RLZAS QLZAS';
    varstr6=' GRBErrorsS L0ErrorsS AshMassLoadTotMassS CountAttAshRetS';
    varstr7=' AshHtOutlierPixCountS AshMassOutlierPixCountS';
    varstr8=' AshCloudHtStatS AshMassStatS AshExistConfAngS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7,varstr8);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    savestr1=strcat('User saved Volcanic Ash data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr1);
else
    savestr2=strcat('User did not save Volcanic Ash data to file-',MatFileName);
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
[numrows,numcols]=size(VAHS.values);
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=(northEdge-southEdge)/numcols;
GeoRef.CellExtentInLongitude=abs((eastEdge-westEdge))/numrows;
datastr1=strcat('VAHS array dimensions nrows=',num2str(numrows),...
    '-ncols=',num2str(numcols));
fprintf(fid,'%s\n',datastr1);
% Get the unique value flags for the DET_RET variable
DETV= DET_DQFS.values;
uvals=unique(DETV);
numuvals=length(uvals);
UValCount=zeros(numuvals,3);
UValCell=cell(numuvals,2);
ntotpix=numrows*numcols;
for kk=1:numuvals
   nowval=uvals(kk,1);
   [ihit,jhit]=find(DETV==nowval);
   nhit=length(ihit);
   UValCount(kk,1)=nhit;
   UValCount(kk,2)=nowval;
   UValCount(kk,3)=nhit/ntotpix;
   UValCell{kk,1}=num2str(nowval);
   UValCell{kk,2}=dec2bin(nowval,16);
end
ab=1;
% Make Up a Mask array just for hi quality single layer ash
HiQualSLayerAsh=zeros(numrows,numcols);
for jj=1:numrows
    for kk=1:numcols
       nowval=DETV(jj,kk);
       if(nowval==0)
           HiQualSLayerAsh(jj,kk)=1;
       end
    end
end
% Display the Volcanic Ash data
% start with the ash cloud heights and particle sizes
[imatch]=strfind(GOESFileName,'_e');
is=1;
ie=imatch(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('Volcanic-Ash-Height-',filename);
[VAHS1DSF,sgoodfrac]=DisplayVolcanicAshHeightFullDiskData(titlestr);
titlestr=strcat('Ash-Cloud-Height-Hist-',filename);
[ValidVAH]=PlotAshCloudHeightHistogram(VAHS1DSF,sgoodfrac,titlestr);
titlestr=strcat('VAH-CumilDist-',filename);
PlotVAHCumilDist(ValidVAH,sgoodfrac,titlestr)
% Now plot the volcanic ash cloud mass loading
titlestr=strcat('Volcanic-Ash-MassLoading-',filename);
[VAM1DSF,sgoodfrac]=DisplayVolcanicMassLoadingFullDiskData(titlestr);
titlestr=strcat('Ash-Cloud-MassLoading-Hist-',filename);
[ValidVAML]=PlotAshCloudVAMLHistogram(VAM1DSF,sgoodfrac,titlestr);
titlestr=strcat('VAML-CumilDist-',filename);
PlotVAMLCumilDist(ValidVAML,sgoodfrac,titlestr);
% Now plot the Volcanic Ash Mass Loading again using just Hi Quality pixels
titlestr=strcat('Volcanic-Ash-HiQual-MassLoading-',filename);
DisplayVolcanicMassLoadingHiQualFD(titlestr)
fprintf(fid,'%s\n','Finished reading Volcanic Ash Data');
disp('-----Finished Processing Volcanic Ash Data-----');
end