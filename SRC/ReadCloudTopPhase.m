function ReadCloudTopPhase()
% Modified: This function will read in the GOES ABI-L2-Cloud Top Phase Data
% this replaces the realier Rev0 version which was created in error
% Written By: Stephen Forczyk
% Created: April 19,2021
% Revised: ------
% Classification: Unclassified

global BandDataS MetaDataS;
global PhaseS CloudyPixS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand MapFormFactor;
global GOESFileName SZAS SZABS;
global Algo2S ProcessParamTS AlgoProductTS Error1S ;
global idebug;
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;
global fid isavefiles;

fprintf(fid,'\n');
fprintf(fid,'%s\n','**************Start reading Cloud Top Phase data***************');

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
PhaseS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'Unsigned',[],'valid_range',[],'units',[],'resolution',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'ancillary_variables',[],...
    'number_of_cloud_top_phase_category_values',[],...
    'percent_clear_sky',[],'percent_liquid_water',[],...
    'percent_super_cooled_liquid_water',[],'percent_mixed_phase',[],...
    'percent_ice',[],'percent_unknown',[]);
DQFS=struct('values',[],'valid_range',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'flag_values',[],'flag_meanings',[],...
    'long_name',[],'standard_name',[],'FillValue',[],...
    'number_of_overall_qf_values',[],'percent_overall_good_quality_qf',[],...
    'percent_overall_degraded_quality_qf',[],...
    'number_of_L1b_qf_values',[],'percent_good_quality_L1b_data_qf',[],...
    'percent_degraded_quality_L1b_data_qf',[],...
    'number_of_beta_ratio_qf_values',[],...
    'percent_good_quality_beta_ratio_qf',[],...
    'percent_degraded_quality_beta_ratio_qf',[],...
    'number_of_ice_cloud_qf_values',[],...
    'pct_ice_cloud_determ_based_on_strong_rad_signal_qf',[],...
    'pct_ice_cloud_determ_based_on_weak_rad_signal_qf',[],...
    'number_of_surface_emissivity_qf_values',[],...
    'percent_good_quality_surface_emissivity_qf',[],...
    'percent_degraded_quality_surface_emissivity_qf',[],...
    'number_of_LZA_qf_values',[],'percent_good_within_LZA_threshold_qf',[],...
    'percent_degraded_due_to_LZA_threshold_exceeded_qf',[]);
CloudyPixS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[]);
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

BandDataS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);

AlgoS=struct('values',[],'long_name',[],'input_ABI_L2_auxiliary_solar_zenith_angle_data',[],...
    'input_ABI_L1b_radiance_band_data',[]);
AlgoProductTS=struct('values',[],'long_name',[],'algorithm_version',[],'product_version',[]);
SZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
SZABS=struct('values',[],'long_name',[]);
Algo2S=struct('values',[],'long_name',[],...
    'input_ABI_L1b_radiance_band_4_2km_data',[],...
    'input_ABI_L1b_radiance_band_10_2km_data',[],...
    'input_ABI_L1b_radiance_band_11_2km_data',[],...
    'input_ABI_L1b_radiance_band_14_2km_data',[],...
    'input_ABI_L1b_radiance_band_15_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'input_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...
    'input_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_10_data',[],...
    'input_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_11_data',[],...
    'input_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_14_data',[],...
    'input_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_15_data',[],...
    'input_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_10_prof_data',[],...
    'input_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_11_prof_data',[],...
    'input_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_14_prof_data',[],...
    'input_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_15_prof_data',[],...
    'input_dynamic_ancillary_NWP_temperature_profile_data',[],...
    'input_dynamic_ancillary_NWP_pressure_profile_data',[],...
    'input_dynamic_ancillary_NWP_tropopause_level_index_data',[],...
    'input_dynamic_ancillary_NWP_derived_surface_index_data',[]);
Error1S=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'valid_range2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[]);
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
        a10=strcmp(varname,'Phase');
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
        a160=strcmp(varname,'total_number_cloudy_pixels');
        a210=strcmp(varname,'algorithm_dynamic_input_data_container');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a290=strcmp(varname,'solar_zenith_angle');
        a300=strcmp(varname,'solar_zenith_angle_bounds');
        a310=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a320=strcmp(varname,'percent_uncorrectable_L0_errors');
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
                PhaseS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PhaseS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PhaseS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PhaseS.units=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                PhaseS.unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PhaseS.valid_range=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                PhaseS.resolution=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PhaseS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PhaseS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PhaseS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                PhaseS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                PhaseS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                PhaseS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_cloud_top_phase_category_values');
            if(a1==1)
                PhaseS.number_of_cloud_top_phase_category_values=attname2;
            end
            a1=strcmp(attname1,'percent_clear_sky');
            if(a1==1)
                PhaseS.percent_clear_sky=attname2;
            end
            a1=strcmp(attname1,'percent_liquid_water');
            if(a1==1)
                PhaseS.percent_liquid_water=attname2;
            end
            a1=strcmp(attname1,'percent_super_cooled_liquid_water');
            if(a1==1)
                PhaseS.percent_super_cooled_liquid_water=attname2;
            end
            a1=strcmp(attname1,'percent_mixed_phase');
            if(a1==1)
                PhaseS.percent_mixed_phase=attname2;
            end
            a1=strcmp(attname1,'percent_ice');
            if(a1==1)
                PhaseS.percent_ice=attname2;
            end
            a1=strcmp(attname1,'percent_unknown');
            if(a1==1)
                PhaseS.percent_unknown=attname2;
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
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
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
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQFS.unsigned=attname2;
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
            a1=strcmp(attname1,'number_of_overall_qf_values');
            if(a1==1)
                DQFS.number_of_overall_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQFS.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_overall_good_quality_qf');
            if(a1==1)
                DQFS.percent_overall_good_quality_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_overall_degraded_quality_qf');
            if(a1==1)
                DQFS.percent_overall_degraded_quality_qf=attname2;
            end 
            a1=strcmp(attname1,'number_of_L1b_qf_values');
            if(a1==1)
                DQFS.number_of_L1b_qf_values=attname2;
            end 
            a1=strcmp(attname1,'percent_good_quality_L1b_data_qf');
            if(a1==1)
                DQFS.percent_good_quality_L1b_data_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_degraded_quality_L1b_data_qf');
            if(a1==1)
                DQFS.percent_degraded_quality_L1b_data_qf=attname2;
            end 
            a1=strcmp(attname1,'number_of_beta_ratio_qf_values');
            if(a1==1)
                DQFS.number_of_beta_ratio_qf_values=attname2;
            end 
            a1=strcmp(attname1,'percent_good_quality_beta_ratio_qf');
            if(a1==1)
                DQFS.percent_good_quality_beta_ratio_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_degraded_quality_beta_ratio_qf');
            if(a1==1)
                DQFS.percent_degraded_quality_beta_ratio_qf=attname2;
            end 
            a1=strcmp(attname1,'number_of_ice_cloud_qf_values');
            if(a1==1)
                DQFS.number_of_ice_cloud_qf_values=attname2;
            end 
            a1=strcmp(attname1,'percent_ice_cloud_determination_based_on_strong_radiative_signal_qf');
            if(a1==1)
                DQFS.pct_ice_cloud_determ_based_on_strong_rad_signal_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_ice_cloud_determination_based_on_weak_radiative_signal_qf');
            if(a1==1)
                DQFS.pct_ice_cloud_determ_based_on_weak_rad_signal_qf=attname2;
            end 
            a1=strcmp(attname1,'number_of_surface_emissivity_qf_values');
            if(a1==1)
                DQFS.number_of_surface_emissivity_qf_values=attname2;
            end 
            a1=strcmp(attname1,'percent_good_quality_surface_emissivity_qf');
            if(a1==1)
                DQFS.percent_good_quality_surface_emissivity_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_degraded_quality_surface_emissivity_qf');
            if(a1==1)
                DQFS.percent_degraded_quality_surface_emissivity_qf=attname2;
            end 
            a1=strcmp(attname1,'number_of_LZA_qf_values');
            if(a1==1)
                DQFS.number_of_LZA_qf_values=attname2;
            end 
            a1=strcmp(attname1,'percent_good_within_LZA_threshold_qf');
            if(a1==1)
                DQFS.percent_good_within_LZA_threshold_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_degraded_due_to_LZA_threshold_exceeded_qf');
            if(a1==1)
                DQFS.percent_degraded_due_to_LZA_threshold_exceeded_qf=attname2;
            end 
        elseif (a30==1)
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
                CloudyPixS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudyPixS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudyPixS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudyPixS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudyPixS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudyPixS.cell_methods=attname2;
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
                Algo2S.long_name=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_4_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L1b_radiance_band_4_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_10_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L1b_radiance_band_10_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_11_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L1b_radiance_band_11_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_14_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L1b_radiance_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_15_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L1b_radiance_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_4_level_cloud_mask_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_4_level_cloud_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_10_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_10_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_11_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_11_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_14_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_14_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_prod_CRTM_clear_sky_rad_band_15_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_14_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_14_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_trans_band_14_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_15_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_trans_band_15_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_16_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_trans_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_10_profile_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_10_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_11_profile_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_11_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_14_profile_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_14_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_15_profile_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_prod_CRTM_cloudy_sky_rad_band_15_prof_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_pressure_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_pressure_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_temperature_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_temperature_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_temperature_inversion_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_temperature_inversion_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_geopotential_height_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_geopotential_height_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_pressure_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_pressure_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_level_index_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_surface_level_index_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_tropopause_level_index_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_tropopause_level_index_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_geopotential_height_derived_surface_index_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_derived_surface_index_data=attname2;
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
                ProcessParamTS.long_name=attname2;
            end
            a1=strcmp(attname1,'L2_processing_parm_version');
            if(a1==1)
                ProcessParamTS.L2_processing_parm_version=attname2;
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
                AlgoProductTS.long_name=attname2;
            end
            a1=strcmp(attname1,'algorithm_version');
            if(a1==1)
                AlgoProductTS.algorithm_version=attname2;
            end
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                AlgoProductTS.product_version=attname2;
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
                SZABS.long_name=attname2;
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
                Error1S.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                Error1S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                Error1S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                Error1S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                Error1S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                Error1S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                Error1S.cell_methods1=attname2;
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
                Error1S.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                Error1S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                Error1S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                Error1S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                Error1S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                Error1S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                Error1S.cell_methods2=attname2;
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
        disp(' ')
    end
    
    if flag

        if(varname=='y')
            eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
            yS.values=y;
        end
        if(varname=='x')
            eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
            xS.values=x;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])  
        if(a10==1)
            FillValue=PhaseS.FillValue;
            PhaseS.values=Phase; 
            PVal=PhaseS.values;
            [PVal,numnanvals] = ReplaceFillValues(PVal,FillValue);
            PhaseS.values=PVal; 
        end
        if(a20==1)
            DQFS.values=DQF;
        end
        if(varname=='t')
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
            CloudyPixS.values=total_number_cloudy_pixels;
        end
        if(a210==1)
            Algo2S.values=algorithm_dynamic_input_data_container;
        end

        if(a250==1)
            ProcessParamTS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProductTS.values=algorithm_product_version_container;
        end

        if(a290==1)
            SZAS.values=solar_zenith_angle;
        end
        if(a300==1)
            SZABS.values=solar_zenith_angle_bounds;
        end
        if(a310==1)
            Error1S.values1=percent_uncorrectable_GRB_errors;
        end
        if(a320==1)
            Error1S.values2=percent_uncorrectable_L0_errors;
        end

    end
end

if(idebug==1)
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp('________________________________________________________')
    disp(' '),disp(' ')
end
netcdf.close(ncid);
fprintf(fid,'%s\n','Finished reading Cloud Top Phase Data');
%Now write a Matlab file containing the decoded data
%use the original file name with a .mat extension
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='PhaseS CloudyPixS DQFS tS yS xS tBS goesImagerS yImgS yImgBS';
    varstr2=' xImgS xImgBS SatDataS GeoSpatialS';
    varstr3=' AlgoS GoesWaveBand SZAS SZABS GOESFileName';
    varstr4=' Algo2S ProcessParamTS AlgoProductTS Error1S';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
else
    dispstr=strcat('Did Not Save Matlab File-',MatFileName);
    disp(dispstr);
end
% Get some stats on the Phase Data
PhaseValues=PhaseS.values;
[nrows,ncols]=size(PhaseValues);
PhaseValues1D=reshape(PhaseValues,nrows*ncols,1);
minPhaseValue=min(PhaseValues1D);
maxPhaseValue=max(PhaseValues1D);
a1=isnan(PhaseValues1D);
numnans=sum(a1);
numtotpix=nrows*ncols;
fracNaN=numnans/numtotpix;
goodfrac=1-fracNaN;

statstr1=strcat('Min Phase Value=',num2str(minPhaseValue),'-Max Value=',num2str(maxPhaseValue));
fprintf(fid,'%s\n',statstr1);
statstr2=strcat('Frac Of Pixels Returning Valid Phase=',num2str(goodfrac,6),'-Frac That are NaN=',num2str(fracNaN,6));
fprintf(fid,'%s\n',statstr2);
% Display the Cloud Top Phase on an Earth Map
[imatch]=strfind(GOESFileName,'_e');
is=1;
ie=imatch(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
% Establish the MapFormFactor from the file name
[idash]=strfind(GOESFileName,'-');
numdash=length(idash);
is=idash(2)+1;
ie=idash(3)-1;
neumonic=GOESFileName(is:ie);
neumoniclen=length(neumonic);
neumonicstr='C';
if(neumoniclen==5)
    neumonicstr=neumonic(5:5);
elseif(neumoniclen==6)
    neumonicstr=neumonic(5:6);
end
a1=strcmp(neumonicstr,'F');
a2=strcmp(neumonicstr,'C');
a3=strcmp(neumonicstr,'M1');
a4=strcmp(neumonicstr,'M2');
if(a1==1)
    MapFormFactor='Full-Disk';
    itype=1;
elseif(a2==1)
    MapFormFactor='Conus';
    itype=2;
elseif(a3==1)
    MapFormFactor='Meso1';
    itype=3;
elseif(a4==1)
    MapFormFactor='Meso2';
    itype=4;
end
titlestr=strcat('CloudTopPhases-',filename);
DisplayCloudTopPhaseData(titlestr,itype)
% Display a Histogram of the CloudTop Temp distribution
titlestr=strcat('CloudTopPhaseHist-',filename);
PlotCloudTopPhaseHistogram(titlestr,neumonic)


end

