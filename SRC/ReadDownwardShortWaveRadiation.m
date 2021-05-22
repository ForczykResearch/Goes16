function ReadDownwardShortWaveRadiation()
% This function will read to downward shortwave radiation data collected by
% GOES
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. 
% Written By: Stephen Forczyk
% Created: Feb 23,2021
% Revised: Feb 24,2021 continued coding
% Revised: Feb 25,2021 finished coding basic read portion of routine
% Classification: Unclassified

global MetaDataS;
global DSRS DSRWaveS DSRWaveBS ImageCloudFracS;
global DQFS;
global RetPixelCountS LZAPixelCountS OutlierPixelCountS;
global LatS LonS;
global tS yS xS tBS goesImagerS LatImgS LatImgBS;
global LonImgS LonImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global RSZAS QSZAS RSZABS QSZABS;
global RLZAS RLZABS;
global SZAStatS DSRStatS;
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
fprintf(fid,'%s\n','-----Start reading Downwards Short Wave Radiation----');

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
DSRS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'unsigned',[],'valid_range',[],'scale_factor',[],'add_offset',[],...
    'units',[],'resolution',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'ancillary_variables',[]);
SZAStatS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],'valid_range1',[],...
    'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],'valid_range2',[],...
    'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],'valid_range3',[],...
    'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],'valid_range4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
DSRStatS=SZAStatS;
RLZABS=struct('value',[],'long_name',[]);
QLZAS=struct('value',[],'long_name',[],'standard_name',[],...
    'units',[],'bounds',[]);
QLZABS=struct('value',[],'long_name',[]);
RLZAS=struct('value',[],'long_name',[],'standard_name',[]);
RSZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
QSZAS=RSZAS;
RSZABS=struct('values',[],'long_name',[]);
QSZABS=RSZABS;
DSRWaveS=struct('values',[],'long_name',[],'standard_name',[],'bounds',[]);
DSRWaveBS=struct('values',[],'long_name',[]);
RetPixelCountS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
LZAPixelCountS=RetPixelCountS;
OutlierPixelCountS=RetPixelCountS;
ImageCloudFracS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'valid_range',[],'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
DQFS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'unsigned',[],'valid_range',[],'units',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],...
    'flag_values',[],'flag_meanings',[],'number_of_qf_values',[],...
    'percent_good_quality_qf',[],...
    'percent_degraded_quality_or_invalid_qf',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
LatS=struct('values',[],'long_name',[],'standard_name',[],'scale_factor',[],...
    'add_offset',[],'units',[],'axis',[]);
LonS=LatS;
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[]);
goesImagerS=struct('values',[],'long_name',[],'perspective_point_height',[],...
    'semi_major_axis',[],'semi_minor_axis',[],'inverse_flattening',[],...
    'latitude_of_projection_origin',[],'longitude_of_projection_origin',[],...
    'sweep_angle_axis',[]);
LatImgS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'axis',[]);
LatImgBS=struct('values',[],'long_name',[]);
LonImgS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'axis',[]);
LonImgBS=struct('values',[],'long_name',[],'units',[]);
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
    'input_ABI_L2_aux_solar_zenith_angle_data',[],...
    'input_ABI_L2_aux_sun_satellite_relative_azimuth_angle_data',[],...
    'input_ABI_L2_aerosol_optical_depth_550nm_data',[],...
    'input_ABI_L2_cloud_top_phase_data',[],...
    'input_ABI_L2_cloud_effective_particle_size_data',[],...
    'input_ABI_L2_total_precipitable_water_data',[],...
    'input_ABI_L2_surface_albedo_data',[],...
    'input_ABI_L2_interm_product_reflect_band_1_2km_data',[],...  
    'input_ABI_L2_interm_product_reflect_band_2_2km_data',[],...
    'input_ABI_L2_interm_product_reflect_band_3_2km_data',[],...
    'input_ABI_L2_interm_product_reflect_band_4_2km_data',[],...
    'input_ABI_L2_interm_product_reflect_band_5_2km_data',[],...
    'input_ABI_L2_interm_product_reflect_band_6_2km_data',[],...
    'input_ABI_L2_interm_product_binary_snow_mask_data',[],...
    'input_ABI_L2_interm_product_fine_aerosol_data',[],...
    'input_ABI_L2_interm_product_cloud_optical_depth_data',[],...
    'input_ABI_L2_interm_product_cloud_top_height_data',[],...
    'input_dynamic_ancillary_global_snow_mask_data',[],...
    'input_dynamic_ancillary_NWP_total_precipitable_water_data',[],...
    'input_dynamic_ancillary_NWP_total_column_ozone_data',[]);
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
        a10=strcmp(varname,'DSR');
        a20=strcmp(varname,'DQF');
        a30=strcmp(varname,'t');
        a40=strcmp(varname,'lat');
        a50=strcmp(varname,'lon');
        a60=strcmp(varname,'time_bounds');
        a70=strcmp(varname,'goes_imager_projection');
        a80=strcmp(varname,'lat_image');
        a90=strcmp(varname,'lat_image_bounds');
        a100=strcmp(varname,'lon_image');
        a110=strcmp(varname,'lon_image_bounds');
        a120=strcmp(varname,'nominal_satellite_subpoint_lat');
        a130=strcmp(varname,'nominal_satellite_subpoint_lon');
        a140=strcmp(varname,'nominal_satellite_height');
        a150=strcmp(varname,'geospatial_lat_lon_extent');
        a160=strcmp(varname,'retrieval_solar_zenith_angle');
        a170=strcmp(varname,'quantitative_solar_zenith_angle');
        a180=strcmp(varname,'retrieval_solar_zenith_angle_bounds');
        a190=strcmp(varname,'quantitative_solar_zenith_angle_bounds');
        a200=strcmp(varname,'dsr_product_wavelength');
        a210=strcmp(varname,'dsr_product_wavelength_bounds');
        a240=strcmp(varname,'algorithm_dynamic_input_data_container');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'retrieval_local_zenith_angle');
        a280=strcmp(varname,'quantitative_local_zenith_angle');
        a290=strcmp(varname,'retrieval_local_zenith_angle_bounds');
        a310=strcmp(varname,'quantitative_local_zenith_angle_bounds');
        a330=strcmp(varname,'retrieval_pixel_count');
        a340=strcmp(varname,'lza_pixel_count');
        a350=strcmp(varname,'outlier_pixel_count');
        a360=strcmp(varname,'image_cloud_fraction');
        a370=strcmp(varname,'minimum_sza');
        a380=strcmp(varname,'maximum_sza');
        a390=strcmp(varname,'mean_sza');
        a400=strcmp(varname,'std_dev_sza');
        a460=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a470=strcmp(varname,'percent_uncorrectable_L0_errors');
        a500=strcmp(varname,'minimum_dsr');
        a510=strcmp(varname,'maximum_dsr');
        a520=strcmp(varname,'mean_dsr');
        a530=strcmp(varname,'std_dev_dsr');
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
                DSRS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DSRS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DSRS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                DSRS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                DSRS.add_offset=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
               DSRS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                DSRS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DSRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DSRS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DSRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DSRS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DSRS.coordinates=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                DSRS.resolution=attname2;
            end
        elseif (a20==1)
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
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DQFS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'percent_good_quality_qf');
            if(a1==1)
                DQFS.percent_good_quality_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_degraded_quality_or_invalid_qf');
            if(a1==1)
                DQFS.percent_degraded_quality_or_invalid_qf=attname2;
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
                LatS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                LatS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LatS.axis=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LatS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatS.standard_name=attname2;
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
                LonS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                LonS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LonS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LonS.axis=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LonS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LonS.standard_name=attname2;
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
                LatImgS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatImgS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatImgS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LatImgS.axis=attname2;
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
                LatImgBS.long_name=attname2;
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
                RSZABS.long_name=attname2;
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
                QSZABS.long_name=attname2;
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
                DSRWaveS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DSRWaveS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DSRWaveS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                DSRWaveS.bounds=attname2;
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
                DSRWaveBS.long_name=attname2;
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
                AlgoS.input_ABI_L2_aux_solar_zenith_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_sun_satellite_relative_azimuth_angle_data');
            if(a1==1)
                AlgoS.input_ABI_L2_aux_sun_satellite_relative_azimuth_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_aerosol_optical_depth_550nm_data');
            if(a1==1)
                AlgoS.input_ABI_L2_aerosol_optical_depth_550nm_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_cloud_top_phase_data');
            if(a1==1)
                AlgoS.input_ABI_L2_cloud_top_phase_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_cloud_effective_particle_size_data');
            if(a1==1)
                AlgoS.input_ABI_L2_cloud_effective_particle_size_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_total_precipitable_water_data');
            if(a1==1)
                AlgoS.input_ABI_L2_total_precipitable_water_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_surface_albedo_data');
            if(a1==1)
                AlgoS.input_ABI_L2_surface_albedo_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_1_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_reflect_band_1_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_2_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_reflect_band_2_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_3_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_reflect_band_3_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_4_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_reflect_band_4_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_5_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_reflect_band_5_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_6_2km_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_reflect_band_6_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_binary_snow_mask_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_binary_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_fine_aerosol_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_fine_aerosol_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_optical_depth_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_cloud_optical_depth_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_top_height_data');
            if(a1==1)
                AlgoS.input_ABI_L2_interm_product_cloud_top_height_data=attname2;
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
                RetPixelCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RetPixelCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RetPixelCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RetPixelCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RetPixelCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RetPixelCountS.cell_methods=attname2;
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
                LZAPixelCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LZAPixelCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LZAPixelCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LZAPixelCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LZAPixelCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LZAPixelCountS.cell_methods=attname2;
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
                OutlierPixelCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutlierPixelCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutlierPixelCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutlierPixelCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutlierPixelCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutlierPixelCountS.cell_methods=attname2;
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
                ImageCloudFracS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ImageCloudFracS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ImageCloudFracS.FillValue=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ImageCloudFracS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ImageCloudFracS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ImageCloudFracS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ImageCloudFracS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ImageCloudFracS.cell_methods=attname2;
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
                SZAStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SZAStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SZAStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SZAStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SZAStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SZAStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                SZAStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SZAStatS.cell_methods1=attname2;
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
                SZAStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SZAStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SZAStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SZAStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SZAStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SZAStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                SZAStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SZAStatS.cell_methods2=attname2;
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
                SZAStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SZAStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SZAStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SZAStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SZAStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SZAStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                SZAStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SZAStatS.cell_methods3=attname2;
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
                SZAStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SZAStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SZAStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SZAStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SZAStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SZAStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                SZAStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SZAStatS.cell_methods4=attname2;
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
                DSRStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DSRStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DSRStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DSRStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DSRStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DSRStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DSRStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DSRStatS.cell_methods1=attname2;
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
                DSRStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DSRStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DSRStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DSRStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DSRStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DSRStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DSRStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DSRStatS.cell_methods2=attname2;
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
                DSRStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DSRStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DSRStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DSRStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DSRStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DSRStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DSRStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DSRStatS.cell_methods3=attname2;
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
                DSRStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DSRStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DSRStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DSRStatS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DSRStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DSRStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DSRStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DSRStatS.cell_methods4=attname2;
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
           FillValue=DSRS.FillValue;
           [DSRV,numnanvals] = ReplaceFillValues(DSR,FillValue);
           [nrows,ncols]=size(DSRV);
           level=(2^15)-1;
           for ik=1:nrows
               for jk=1:ncols
                  value=DSRV(ik,jk);
                  if(value<0)
                       diff=level-abs(value);
                       corval=level+diff;
                       DSRV(ik,jk)=corval;
                  end
               end
           end
           DSRV2=DSRV'*scale+offset;
           DSRS.values=double(DSRV2); 
           clear DSRV DSRV2;
        end
        if(a40==1)
           eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
           latV=lat;
           [nrows,ncols]=size(latV);
           level=(2^15)-1;
           for ik=1:nrows
               for jk=1:ncols
                  value=latV(ik,jk);
                  if(value<0)
                       diff=level-abs(value);
                       corval=level+diff;
                       latV(ik,jk)=corval;
                  end
               end
           end
           latV2=latV'*scale+offset;
           LatS.values=double(latV2); 
           clear latV latV2;
        end
        if(a50==1)
           eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
           lonV=lon;
           [nrows,ncols]=size(lonV);
           level=(2^15)-1;
           for ik=1:nrows
               for jk=1:ncols
                  value=lonV(ik,jk);
                  if(value<0)
                       diff=level-abs(value);
                       corval=level+diff;
                       lonV(ik,jk)=corval;
                  end
               end
           end
           lonV2=lonV'*scale+offset;
           LonS.values=double(lonV2); 
           clear lonV lonV2;
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
            LatImgS.values=lat_image;
        end
        if(a90==1)
            LatImgBS.values=lat_image_bounds;
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
        if(a160==1)
            RSZAS.values=retrieval_solar_zenith_angle;
        end
        if(a170==1)
            QSZAS.values=quantitative_solar_zenith_angle;
        end
        if(a180==1)
            RSZABS.values=retrieval_solar_zenith_angle_bounds;
        end
        if(a190==1)
            QSZABS.values=quantitative_solar_zenith_angle_bounds;
        end
        if(a200==1)
            DSRWaveS.values=dsr_product_wavelength;
        end
        if(a210==1)
            DSRWaveBS.values=dsr_product_wavelength_bounds;
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
        if(a330==1)
            RetPixelCountS.values=retrieval_pixel_count;
        end
        if(a340==1)
            LZAPixelCountS.values=lza_pixel_count;
        end
        if(a350==1)
            OutlierPixelCountS.values=outlier_pixel_count;
        end
        if(a360==1)
            ImageCloudFracS.values=image_cloud_fraction;
        end
        if(a370==1)
            SZAStatS.values1=minimum_sza;
        end
        if(a380==1)
            SZAStatS.values2=maximum_sza;
        end
        if(a390==1)
            SZAStatS.values3=mean_sza;
        end
        if(a400==1)
            SZAStatS.values4=std_dev_sza;
        end
        if(a460==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors;          
        end
        if(a470==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
        end
        if(a500==1)
            DSRStatS.values1=minimum_dsr;
        end
        if(a510==1)
            DSRStatS.values2=maximum_dsr;
        end
        if(a520==1)
            DSRStatS.values3=mean_dsr;
        end
        if(a530==1)
            DSRStatS.values4=std_dev_dsr;
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
fprintf(fid,'%s\n','Finished DSR data');
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='DSRS DSRWaveS DSRWaveBS ImageCloudFracS MetaDataS';
    varstr2=' DQFS tS yS xS tBS goesImagerS';
    varstr3=' LatImgS LatImgBS LonImgS LonImgBS SatDataS GeoSpatialS ';
    varstr4=' AlgoS AlgoProdVersionContainerS';
    varstr5=' GoesWaveBand GOESFileName RLZAS QLZAS';
    varstr6=' GRBErrorsS L0ErrorsS LatS LonS';
    varstr7=' RetPixelCountS LZAPixelCountS OutlierPixelCountS';
    varstr8=' SZAStatS DSRStatS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7,varstr8);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    savestr1=strcat('User saved DSR data to file-',MatFileName);
    fprintf(fid,'%s\n',savestr1);
else
    savestr2=strcat('User did not save DSR data to file-',MatFileName);
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
[numrows,numcols]=size(DSRS.values);
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=(northEdge-southEdge)/numcols;
GeoRef.CellExtentInLongitude=abs((eastEdge-westEdge))/numrows;
datastr1=strcat('DSR array dimensions nrows=',num2str(numrows),...
    '-ncols=',num2str(numcols));
fprintf(fid,'%s\n',datastr1);
% Display the Downwards Shortwave Radiation Data
[imatch]=strfind(GOESFileName,'_e');
is=1;
ie=imatch(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('DSR-Map-',filename);
[DSR1DSF,sgoodfrac]=DisplayConusDSR(titlestr);
titlestr=strcat('DSR-Hist-',filename);
[ValidDSR]=PlotDSRHistogram(DSR1DSF,sgoodfrac,titlestr);
titlestr=strcat('DSR-CumilDist-',filename);
PlotDSRCumilDist(ValidDSR,sgoodfrac,titlestr)
fprintf(fid,'%s\n','Finished reading Downwards Short Wave Radiation');
disp('-----Finished Processing Downwards Short Wave Radiation Data-----');
end