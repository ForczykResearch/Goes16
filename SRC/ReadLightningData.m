function ReadLightningData()
% Modified: This function will read in the GOES GLM-L2-Lighting-Data
% Written By: Stephen Forczyk
% Created: August 3,2020
% Revised: Mar 16,2021 added code to decode variables missed earlier
% Revised: Mar 17,2021 continued adding code to decode values
% Revised: Mar 20,2021 added call to routine PlotLightningFlashAreaHistogram
%          and a test to skip plotting histogram charts is less than 101
%          flashes detected
% Classification: Unclassified

global BandDataS MetaDataS;
global SatDataS GoesLatLonProjS;
global AlgoS GoesWaveBand; 
global GOESFileName;
global NumFlashes NumGroups NumEvents;
global Algo2S AlgoProductTS Error1S ;
global EventIDS EventTimeS EventLocS EventEnergyS;
global GroupIDS GQFS FlashDataS FlashData2S FlashQFS;
global FlashFrTimeOffsetFES FlashFrTimeOffsetLES;
global FlashStartTimes FlashEndTimes;
global FlashMinEnergy FlashMaxEnergy FlashMinDuration FlashMaxDuration;
global GroupFrameTimeOffsetS GroupLatS GroupLonS;
global GroupAreaS GroupEnergyS GroupParentFlashIDS;
global EventCountS GroupCountS FlashCountS;
global GroupArea GroupEnergy FlashArea GroupPixels FlashPixels;
global ProductTimeS LightningWaveS NavL1bS YawFlipFlagS LonFOVS LatFOVS;
global ProcessParamVersionContainerS;
global westEdge eastEdge northEdge southEdge;
global isavefiles;
global FlashEnergy FlashDuration FlashLats FlashLons;
global idebug ;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16CloudTopTemppath GOES16Lightningpath;
global fid;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;


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

EventIDS=struct('values',[],'long_name',[],'unsigned',[],'units',[]);
EventTimeS=struct('values',[],'long_name',[],'standard_name',[],'unsigned',[],...
    'scale_factor',[],'add_offset',[],'units',[],'axis',[]);
EventLocS=struct('values1',[],'long_name1',[],'standard_name1',[],'unsigned1',[],...
    'scale_factor1',[],'add_offset1',[],'units1',[],'axis1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'unsigned2',[],...
    'scale_factor2',[],'add_offset2',[],'units2',[],'axis2',[]);
EventEnergyS=struct('values1',[],'FillValue',[],'long_name1',[],'standard_name1',[],...
    'unsigned1',[],'scale_factor1',[],'add_offset1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'unsigned2',[],'units2',[]);
GroupIDS=struct('values1',[],'long_name1',[],'unsigned1',[],'units1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'unsigned2',[],...
    'scale_factor2',[],'add_offset2',[],'units2',[],'axis2',[]);
GroupFrameTimeOffsetS=struct('values',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'scale_factor',[],'add_offset',[],'units',[],'axis',[],...
    'valid_range',[]);
GroupLatS=struct('values',[],'long_name',[],'standard_name',[],...
    'units',[],'axis',[]);
GroupLonS=GroupLatS;
EventCountS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
GroupCountS=EventCountS;
FlashCountS=EventCountS;
GroupEnergyS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'unsigned',[],'scale_factor',[],'add_offset',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[],...
    'ancillary_variables',[],'cell_measures',[]);
GroupAreaS=struct('values',[],'long_name',[],'FillValue',[],'Unsigned',[],...
    'valid_range',[],'scale_factor',[],'add_offset',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
GroupParentFlashIDS=struct('values',[],'long_name',[],'Unsigned',[],'units',[]);
GQFS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'unsigned',[],'valid_range',[],'units',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'pct_good_quality_qf',[],'pct_deg_due_to_const_events_out_of_time_order',[],...
    'pct_deg_due_to_group_const_event_count_exceeds_thresh_qf',[],...
    'pct_deg_due_to_group_duration_exceeds_threshold_qf',[]);
FlashDataS=struct('values1',[],'long_name1',[],'unsigned1',[],'units1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'unsigned2',[],...
    'scale_factor2',[],'add_offset2',[],'units2',[],'axis2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'unsigned3',[],...
    'scale_factor3',[],'add_offset3',[],'units3',[]);
FlashData2S=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'units1',[],'axis1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'units2',[],'axis2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],'unsigned3',[],...
    'valid_range3',[],'scale_factor3',[],'add_offset3',[],'units3',[],...
    'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'unsigned4',[],'valid_range4',[],'scale_factor4',[],'add_offset4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_measures4',[],...
    'cell_methods4',[],'ancillary_variables4',[]);
FlashQFS=struct('values',[],'long_name',[],'standard_name',[],'unsigned',[],...
    'valid_range',[],'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],'percent_good_quality_qf',[],...
    'pct_degraded_due_flash_events_out_of_time_order_qf',[],...
    'pct_degraded_due_to_flash_event_count_exceeds_thresh_qf',[],...
    'pct_degraded_due_to_flash_duration_exceeds_threshold_qf',[]);
FlashFrTimeOffsetFES=struct('values',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'scale_factor',[],'add_offset',[],'units',[],'axis',[]);
FlashFrTimeOffsetLES=FlashFrTimeOffsetFES;
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
    'L1b_processing_parm_version',[]);
SatDataS=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'FillValue1',[],'units1',[],'values2',[],'long_name2',[],'standard_name2',[],...
    'FillValue2',[],'units2',[],'values3',[],'long_name3',[],'standard_name3',[],...
    'FillValue3',[],'units3',[]);
GoesLatLonProjS=struct('values',[],'long_name',[],'grid_mapping_name',[],...
    'semi_major_axis',[],'semi_minor_axis',[],'inverse_flattening',[],'longitude_of_prime_meridian',[]);
BandDataS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
AlgoS=struct('values',[],'long_name',[],'input_GLM_L0_data',[],...
    'input_GLM_L1b_data',[]);
AlgoProductTS=struct('values',[],'long_name',[],'algorithm_version',[],'product_version',[]);
Algo2S=struct('values',[],'long_name',[],'input_ABI_L1b_radiance_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_15_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_16_2km_data',[],...
    'input_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...
    'input_ABI_L2_intermediate_product_cloud_type_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_trans_band_14_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_trans_band_15_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_trans_band_16_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_14_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_15_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_16_profile_data',[],...
    'input_dynamic_ancillary_NWP_surface_pressure_data',[],...
    'input_dynamic_ancillary_NWP_surface_temperature_data',[],...
    'input_dynamic_ancillary_NWP_tropopause_temperature_data',[],...
    'input_dynamic_ancillary_NWP_temperature_profile_data',[],...
    'input_dynamic_ancillary_NWP_temperature_inversion_profile_data',[],...
    'input_dynamic_ancillary_NWP_geopotential_height_profile_data',[],...
    'input_dynamic_ancillary_NWP_pressure_profile_data',[],...
    'input_dynamic_ancillary_NWP_surface_level_index_data',[],...
    'input_dynamic_ancillary_NWP_tropopause_level_index_data',[]);
Error1S=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[]);

fprintf(fid,'%s\n','Start Reading Lightning Data');
% Get information about the contents of the file.
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);

disp(' '),disp(' '),disp(' ')
disp('________________________________________________________')
disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
disp(['VARIABLES CONTAINED IN THE netCDF FILE: ' nc_filename ])
disp(' ')
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
        a10=strcmp(varname,'event_id');
        a20=strcmp(varname,'event_time_offset');
        a30=strcmp(varname,'event_lat');
        a40=strcmp(varname,'event_lon');
        a50=strcmp(varname,'event_energy');
        a60=strcmp(varname,'event_parent_group_id');
        a70=strcmp(varname,'group_id');
        a80=strcmp(varname,'group_time_offset');
        a90=strcmp(varname,'group_quality_flag');
        a100=strcmp(varname,'flash_id');
        a110=strcmp(varname,'flash_time_offset_of_first_event');
        a120=strcmp(varname,'flash_time_offset_of_last_event');
        a130=strcmp(varname,'flash_lat');
        a140=strcmp(varname,'flash_lon');
        a150=strcmp(varname,'flash_area');
        a160=strcmp(varname,'flash_energy');
        a170=strcmp(varname,'flash_quality_flag');
        a180=strcmp(varname,'product_time');
        a190=strcmp(varname,'product_time_bounds');
        a200=strcmp(varname,'lightning_wavelength');
        a210=strcmp(varname,'lightning_wavelength_bounds');
        a220=strcmp(varname,'group_time_threshold');
        a230=strcmp(varname,'flash_time_threshold');
        a240=strcmp(varname,'percent_navigated_L1b_events');
        a250=strcmp(varname,'yaw_flip_flag');
        a260=strcmp(varname,'nominal_satellite_subpoint_lat');
        a270=strcmp(varname,'nominal_satellite_height');
        a280=strcmp(varname,'nominal_satellite_subpoint_lon');
        a290=strcmp(varname,'lon_field_of_view');
        a300=strcmp(varname,'lon_field_of_view_bounds');
        a310=strcmp(varname,'lat_field_of_view');
        a320=strcmp(varname,'lat_field_of_view_bounds');
        a330=strcmp(varname,'percent_uncorrectable_L0_errors');
        a340=strcmp(varname,'algorithm_dynamic_input_data_container');
        a350=strcmp(varname,'processing_parm_version_container');
        a360=strcmp(varname,'algorithm_product_version_container');
        a370=strcmp(varname,'group_frame_time_offset');
        a380=strcmp(varname,'group_lat');
        a390=strcmp(varname,'group_lon');
        a400=strcmp(varname,'group_area');
        a410=strcmp(varname,'group_energy');
        a420=strcmp(varname,'group_parent_flash_id');
        a430=strcmp(varname,'flash_frame_time_offset_of_first_event');
        a440=strcmp(varname,'flash_frame_time_offset_of_last_event');
        a450=strcmp(varname,'goes_lat_lon_projection');
        a460=strcmp(varname,'event_count');
        a470=strcmp(varname,'group_count');
        a480=strcmp(varname,'flash_count');
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
                EventIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                EventIDS.unsigned=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EventIDS.units=attname2;
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
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                EventTimeS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                EventTimeS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                EventTimeS.unsigned=attname2;
            end

            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                EventTimeS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                EventTimeS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EventTimeS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                EventTimeS.axis=attname2;
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
                EventLocS.add_offset1=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                EventLocS.scale_factor1=scale;
                flag = 1;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                EventLocS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                EventLocS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EventLocS.units1=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                EventLocS.axis1=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                EventLocS.unsigned1=attname2;
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
                EventLocS.add_offset2=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                EventLocS.scale_factor2=scale;
                flag = 1;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                EventLocS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                EventLocS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EventLocS.units2=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                EventLocS.axis2=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                EventLocS.unsigned2=attname2;
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
                EventEnergyS.add_offset1=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
                EventEnergyS.scale_factor1=scale;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                EventEnergyS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                EventEnergyS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EventEnergyS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                EventEnergyS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                EventEnergyS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                EventEnergyS.cell_methods1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                EventEnergyS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                EventEnergyS.unsigned1=attname2;
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
                EventEnergyS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                EventEnergyS.unsigned2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EventEnergyS.units2=attname2;
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
                GroupIDS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                GroupIDS.unsigned1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupIDS.units1=attname2;
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
                GroupIDS.add_offset2=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                GroupIDS.scale_factor2=scale;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GroupIDS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                GroupIDS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                GroupIDS.unsigned2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupIDS.units2=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                GroupIDS.axis2=attname2;
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
                GQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                GQFS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                GQFS.unsigned=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GQFS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GQFS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                GQFS.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                GQFS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                GQFS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                GQFS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                GQFS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                GQFS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                GQFS.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_quality_qf');
            if(a1==1)
                GQFS.pct_good_quality_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_group_constituent_events_out_of_time_order_or_parent_flash_abnormal_qf');
            if(a1==1)
                GQFS.pct_deg_due_to_const_events_out_of_time_order=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_group_constituent_event_count_exceeds_threshold_qf');
            if(a1==1)
                GQFS.pct_deg_due_to_group_const_event_count_exceeds_thresh_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_group_duration_exceeds_threshold_qf');
            if(a1==1)
                GQFS.pct_deg_due_to_group_duration_exceeds_threshold_qf=attname2;
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
                FlashDataS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                FlashDataS.unsigned1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashDataS.units1=attname2;
            end
        elseif (a110==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
                FlashDataS.add_offset2=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                FlashDataS.scale_factor2=scale;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FlashDataS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FlashDataS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashDataS.units2=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                FlashDataS.unsigned2=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                FlashDataS.axis2=attname2;
            end
        elseif (a120==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
                FlashDataS.add_offset3=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                FlashDataS.scale_factor3=scale;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FlashDataS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FlashDataS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashDataS.units3=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                FlashDataS.unsigned3=attname2;
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
                FlashData2S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FlashData2S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashData2S.units1=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                FlashData2S.axis1=attname2;
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
                FlashData2S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FlashData2S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashData2S.units2=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                FlashData2S.axis2=attname2;
            end
        elseif (a150==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
                FlashData2S.add_offset3=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                FlashData2S.scale_factor3=scale;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FlashData2S.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FlashData2S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                FlashData2S.unsigned3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FlashData2S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashData2S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FlashData2S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FlashData2S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FlashData2S.cell_methods3=attname2;
            end
        elseif (a160==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
                FlashData2S.add_offset4=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                FlashData2S.scale_factor4=scale;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FlashData2S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FlashData2S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FlashData2S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                FlashData2S.unsigned4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FlashData2S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashData2S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FlashData2S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FlashData2S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_measures');
            if(a1==1)
                FlashData2S.cell_measures4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FlashData2S.cell_methods4=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                FlashData2S.ancillary_variables4=attname2;
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
                FlashQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FlashQFS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FlashQFS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                FlashQFS.unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FlashQFS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashQFS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FlashQFS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FlashQFS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_measures');
            if(a1==1)
                FlashQFS.cell_measures4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FlashQFS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                FlashQFS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                FlashQFS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                FlashQFS.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'percent_good_quality_qf');
            if(a1==1)
                FlashQFS.percent_good_quality_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_flash_constituent_events_out_of_time_order_qf');
            if(a1==1)
                FlashQFS.pct_degraded_due_flash_events_out_of_time_order_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_flash_constituent_event_count_exceeds_threshold_qf');
            if(a1==1)
                FlashQFS.pct_degraded_due_to_flash_event_count_exceeds_thresh_qf=attname2;
            end
            a1=strcmp(attname1,'percent_degraded_due_to_flash_duration_exceeds_threshold_qf');
            if(a1==1)
                FlashQFS.pct_degraded_due_to_flash_duration_exceeds_threshold_qf=attname2;
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
               ProductTimeS.long_name1=attname2; 
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
               ProductTimeS.standard_name1=attname2; 
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               ProductTimeS.units1=attname2; 
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
               ProductTimeS.axis1=attname2; 
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
               ProductTimeS.bounds1=attname2; 
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
                ProductTimeS.long_name2=attname2;
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
               LightningWaveS.long_name1=attname2; 
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
               LightningWaveS.standard_name1=attname2; 
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               LightningWaveS.units1=attname2; 
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
               LightningWaveS.axis1=attname2; 
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
               LightningWaveS.bounds1=attname2; 
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
                LightningWaveS.long_name2=attname2;
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
                LightningWaveS.long_name3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LightningWaveS.units3=attname2;
            end
        elseif (a230==1)
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
                LightningWaveS.long_name4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LightningWaveS.units4=attname2;
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
                NavL1bS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NavL1bS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                NavL1bS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NavL1bS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NavL1bS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                NavL1bS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NavL1bS.cell_methods=attname2;
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
                YawFlipFlagS.long_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                YawFlipFlagS.unsigned=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                YawFlipFlagS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                YawFlipFlagS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                YawFlipFlagS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                YawFlipFlagS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                YawFlipFlagS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                YawFlipFlagS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                YawFlipFlagS.flag_meanings=attname2;
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
                LonFOVS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LonFOVS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LonFOVS.units1=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                LonFOVS.bounds1=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LonFOVS.axis1=attname2;
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
                LonFOVS.long_name2=attname2;
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
                LatFOVS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatFOVS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatFOVS.units1=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                LatFOVS.bounds1=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LatFOVS.axis1=attname2;
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
                LatFOVS.long_name2=attname2;
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
                AlgoS.long_name=attname2;
            end
            a1=strcmp(attname1,'input_GLM_L0_data');
            if(a1==1)
                AlgoS.input_GLM_L0_data=attname2;
            end
            a1=strcmp(attname1,'input_GLM_L1b_data');
            if(a1==1)
                AlgoS.input_GLM_L1b_data=attname2;
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
                ProcessParamVersionContainerS.long_name=attname2;
            end
            a1=strcmp(attname1,'L1b_processing_parm_version');
            if(a1==1)
                ProcessParamVersionContainerS.L1b_processing_parm_version=attname2;
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
        elseif (a370==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GroupFrameTimeOffsetS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                GroupFrameTimeOffsetS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                GroupFrameTimeOffsetS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                GroupFrameTimeOffsetS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                GroupFrameTimeOffsetS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupFrameTimeOffsetS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                GroupFrameTimeOffsetS.axis=attname2;
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
                GroupLatS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                GroupLatS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupLatS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                GroupLatS.axis=attname2;
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
                GroupLonS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                GroupLonS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupLonS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                GroupLonS.axis=attname2;
            end
        elseif (a400==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GroupAreaS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GroupAreaS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                GroupAreaS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                GroupAreaS.valid_range=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                GroupAreaS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                GroupAreaS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupAreaS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                GroupAreaS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                GroupAreaS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                GroupAreaS.cell_methods=attname2;
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
                GroupEnergyS.add_offset=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                GroupEnergyS.scale_factor=scale;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GroupEnergyS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                GroupEnergyS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GroupEnergyS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                GroupEnergyS.unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                GroupEnergyS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupEnergyS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                GroupEnergyS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                GroupEnergyS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_measures');
            if(a1==1)
                GroupEnergyS.cell_measures=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                GroupEnergyS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                GroupEnergyS.ancillary_variables=attname2;
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
                GroupParentFlashIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                GroupParentFlashIDS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupParentFlashIDS.units=attname2;
            end
        elseif (a430==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
                FlashFrTimeOffsetFES.add_offset=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                FlashFrTimeOffsetFES.scale_factor=scale;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FlashFrTimeOffsetFES.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FlashFrTimeOffsetFES.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                FlashFrTimeOffsetFES.Unsigned=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashFrTimeOffsetFES.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                FlashFrTimeOffsetFES.axis=attname2;
            end
        elseif (a440==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
                FlashFrTimeOffsetLES.add_offset=offset;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                FlashFrTimeOffsetLES.scale_factor=scale;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FlashFrTimeOffsetLES.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                FlashFrTimeOffsetLES.standard_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                FlashFrTimeOffsetLES.Unsigned=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashFrTimeOffsetLES.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                FlashFrTimeOffsetLES.axis=attname2;
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
                GoesLatLonProjS.long_name=attname2;
            end
            a1=strcmp(attname1,'grid_mapping_name');
            if(a1==1)
                GoesLatLonProjS.grid_mapping_name=attname2;
            end
            a1=strcmp(attname1,'semi_major_axis');
            if(a1==1)
                GoesLatLonProjS.semi_major_axis=attname2;
            end
            a1=strcmp(attname1,'semi_minor_axis');
            if(a1==1)
                GoesLatLonProjS.semi_minor_axis=attname2;
            end
            a1=strcmp(attname1,'inverse_flattening');
            if(a1==1)
                GoesLatLonProjS.inverse_flattening=attname2;
            end
            a1=strcmp(attname1,'longitude_of_prime_meridian');
            if(a1==1)
                GoesLatLonProjS.longitude_of_prime_meridian=attname2;
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
                EventCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                EventCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                EventCountS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EventCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                EventCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                EventCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                EventCountS.cell_methods=attname2;
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
                GroupCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GroupCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                GroupCountS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GroupCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                GroupCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                GroupCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                GroupCountS.cell_methods=attname2;
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
                FlashCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FlashCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                FlashCountS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FlashCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FlashCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FlashCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FlashCountS.cell_methods=attname2;
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
        if(a20==1)
            EventTimeS.values=event_time_offset;
        end
        if(a30==1)
            EventLocS.values1=event_lat;
        end
        if(a40==1)
            EventLocS.values2=event_lon;
        end
        if(a50==1)
            EventEnergyS.values1=event_energy;
            ab=1;
        end
        if(a80==1)
            GroupIDS.values2=group_time_offset;
        end
        if(a110==1)
            FlashDataS.values2=flash_time_offset_of_first_event;
        end
        if(a120==1)
            FlashDataS.values3=flash_time_offset_of_last_event;
        end
        if(a150==1)
            FlashData2S.values3=flash_area;
        end
        if(a160==1)
            FlashData2S.values4=flash_energy;
        end
        if(varname=='y')
            yS.values=y;
        end
        if(varname=='x')
            xS.values=x;
        end
        if(a370==1)
            GroupFrameTimeOffsetS.values=group_frame_time_offset;
        end
        if(a400==1)
            GroupAreaS.values=group_area;
        end
        if(a410==1)
            GroupEnergyS.values=group_energy;
        end
        if(a430==1)
            FlashFrTimeOffsetFES.values=flash_frame_time_offset_of_first_event;
        end
        if(a440==1)
            FlashFrTimeOffsetLES.values=flash_frame_time_offset_of_last_event;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])
        if(a10==1)
           EventIDS.values= event_id;
        end

        if(a60==1)
            EventEnergyS.values2=event_parent_group_id;
        end
        if(a70==1)
            GroupIDS.values1=group_id;
        end
        if(a90==1)
            GQFS.values=group_quality_flag;
        end
        if(a100==1)
            FlashDataS.values1=flash_id;
        end
        if(a120==1)
            val=nominal_satellite_subpoint_lat;
            SatDataS.values1=val;
        end
        if(a130==1)
            FlashData2S.values1=flash_lat;
        end
        if(a140==1)
            FlashData2S.values2=flash_lon;
        end
        if(a150==1)
            FlashData2S.values3=flash_area;
        end
        if(a170==1)
            FlashQFS.values=flash_quality_flag;
        end
        if(a180==1)
            ProductTimeS.values1=product_time;
        end
        if(a190==1)
            ProductTimeS.values2=product_time_bounds;
        end
        if(a200==1)
            LightningWaveS.values1=lightning_wavelength;
        end
        if(a210==1)
            LightningWaveS.values2=lightning_wavelength_bounds;
        end
        if(a220==1)
            LightningWaveS.values3=group_time_threshold;
        end
        if(a230==1)
            LightningWaveS.values4=flash_time_threshold;
        end
        if(a240==1)
            NavL1bS.values=percent_navigated_L1b_events;
        end
        if(a250==1)
            YawFlipFlagS.values=yaw_flip_flag;
        end
        if(a260==1)
            val=nominal_satellite_subpoint_lat;
            SatDataS.values1=val;
        end
        if(a270==1)
            SatDataS.values2=nominal_satellite_height;
        end
        if(a280==1)
           SatDataS.values3=nominal_satellite_subpoint_lon; 
        end
        if(a290==1)
            LonFOVS.values1=lon_field_of_view;
        end
        if(a300==1)
            LonFOVS.values2=lon_field_of_view_bounds;
        end
        if(a310==1)
            LatFOVS.values1=lat_field_of_view;
        end
        if(a320==1)
            LatFOVS.values2=lat_field_of_view_bounds;
        end
        if(a330==1)
            Error1S.values1=percent_uncorrectable_L0_errors;
        end
        if(a340==1)
            AlgoS.values=algorithm_dynamic_input_data_container;
        end
        if(a350==1)
            ProcessParamVersionContainerS.values=processing_parm_version_container;
        end
        if(a360==1)
            AlgoProductTS.values=algorithm_product_version_container;
        end
        if(a380==1)
            GroupLatS.values=group_lat;
        end
        if(a390==1)
            GroupLonS.values=group_lon;
        end
        if(a420==1)
            GroupParentFlashIDS.values=group_parent_flash_id;
        end
        if(a450==1)
            GoesLatLonProjS.values=goes_lat_lon_projection;
        end
        if(a460==1)
            EventCountS.values=event_count;
        end
        if(a470==1)
            GroupCountS.values=group_count;
        end
        if(a480==1)
            FlashCountS.values=flash_count;
        end
    end
end
disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
disp('________________________________________________________')
disp(' '),disp(' ')
% Close the file
netcdf.close(ncid);
fprintf(fid,'%s\n','Finished Reading Lightning data');
% Calculate the Boundaries that will be used for a future map
FlashLats=FlashData2S.values1;
FlashLons=FlashData2S.values2;
% westEdge=double(min(FlashLons))-5;
% eastEdge=double(max(FlashLons))+5;
% northEdge=double(max(FlashLats))+5;
% southEdge=double(min(FlashLats))-5;
% westEdge=round(westEdge);
% eastEdge=round(eastEdge);
% northEdge=round(northEdge);
% southEdge=round(southEdge);
% Pull out few more values into global arrays
FlashStartTimes=FlashDataS.values2;
FlashEndTimes=FlashDataS.values3;
FlashArea=FlashData2S.values3;
FlashPixels=FlashArea/1E8;
FlashEnergy=FlashData2S.values4;
GroupArea=GroupAreaS.values;
GroupEnergy=GroupEnergyS.values;
GroupPixels=GroupArea/1E8;
NumFlashes=length(FlashEnergy);
NumGroups=length(GroupEnergy);
NumEvents=EventCountS.values;
% Set these limits as the default values
westEdge=-130;
eastEdge=-30;
southEdge=-40;
northEdge=60;
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles>0)
%Now write a Matlab file containing the decoded data
%use the original file name with a .mat extension
    [iper]=strfind(GOESFileName,'.');
    is=1;
    ie=iper(1)-1;
    MatFileName=strcat(GOESFileName(is:ie),'.mat');
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='EventIDS EventTimeS EventLocS EventEnergyS GroupIDS';
    varstr2=' GQFS FlashDataS FlashData2S FlashQFS ProductTimeS FlashEnergy';
    varstr3=' LightningWaveS NavL1bS YawFlipFlagS SatDataS LonFOVS LatFOVS';
    varstr4=' Error1S AlgoS ProcessParamVersionContainerS AlgoProductTS';
    varstr5=' GoesWaveBand GOESFileName westEdge eastEdge northEdge southEdge';
    varstr6=' GroupAreaS GroupEnergyS GroupParentFlashIDS GroupEnergy';
    varstr7=' GroupFrameTimeOffsetS GroupLatS GroupLonS GroupArea';
    varstr8=' FlashStartTimes FlashEndTimes FlashLats FlashLons FlashArea FlashEnergy';
    varstr9=' FlashPixels GroupPixels';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6);
    varstr=strcat(varstr,varstr7,varstr8,varstr9);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
else
    dispstr=strcat('User choose to skip saving file-',MatFileName);
    disp(dispstr);
end
% Display the Lightning Data. If there are less than 101 Flashes skip the
% statistical plots
[iunder]=strfind(GOESFileName,'_');
is=iunder(3)+1;
ie=iunder(4)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('LightningFlashes-',filename);
DisplayConusLightningData(titlestr)
if(NumFlashes>101)
    titlestr=strcat('LightningFlashesEnergyHist-',filename);
    PlotLightningFlashEnergyHistogram(titlestr)
    titlestr=strcat('LightningFlashesEnergyCumilDist-',filename);
    PlotFlashEnergyCumilDist(titlestr)
    titlestr=strcat('LightningFlashesAreaHist-',filename);
    PlotLightningFlashAreaHistogram(titlestr)
elseif((iCreatePDFReport==1) && (RptGenPresent==1) && (NumFlashes<=101))    
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
    parastr100='----Statistical plots not added to report because too few flashes (<101) detected----.';
    p5 = Paragraph(parastr100);
    p5.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p5);
    add(rpt,chapter);
    fprintf(fid,'%s\n','Statistical Plots not added to report because of too few flashes');
end
end


