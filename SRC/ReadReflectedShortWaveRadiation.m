function ReadReflectedShortWaveRadiation()
% Modified: This function will read in the GOES ABI-L2-Reflected ShortWave
% Radiation
% Written By: Stephen Forczyk
% Created: April 23,2021
% Revised: April 26,2021 added LatS and LonS structs which were missed
% Classification: Unclassified

global BandDataS MetaDataS;
global RSRS DQFS tS tBS ;
global SatDataS GeoSpatialS;
global lat_imageS lat_image_BS;
global lon_imageS lon_image_BS;
global LatS LonS;
global GoesWaveBand MapFormFactor;
global GOESFileName ;
global RLZAS QLZAS RLZABS QLZABS;
global RSZAS QSZAS RSZABS QSZABS;
global RSRProdWaveS RSRProdWaveBS;
global RetPixCountS LZAPixCountS OutlierPixCountS;
global ImageCloudFracS SZAStatS RSRStatS;
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
fprintf(fid,'%s\n','**************Start reading Reflected ShortWave Radiatiom data***************');

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
RSRS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'unsigned',[],'valid_range',[],'units',[],'resolution',[],'scale_factor',[],...
    'add_offset',[],'coordinates',[],'grid_mapping',[],'cell_methods',[],...
    'ancillary_variables',[]);

DQFS=struct('values',[],'valid_range',[],'units',[],'cell_methods',[],...
    'coordinates',[],'grid_mapping',[],'flag_values',[],'flag_meanings',[],...
    'long_name',[],'standard_name',[],'FillValue',[],'unsigned',[],...
    'number_of_qf_values',[],'percent_good_quality_qf',[],...
    'percent_degraded_quality_or_invalid_qf',[]);
 
RLZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
QLZAS=RLZAS;
RLZABS=struct('values',[],'long_name',[]);
QLZABS=RLZABS;
RSZAS=RLZAS;
QSZAS=RLZAS;
RSZABS=RLZABS;
QSZABS=RLZABS;
LatS=struct('values',[],'long_name',[],'standard_name',[],'scale_factor',[],...
    'add_offset',[],'units',[],'axis',[]);
LonS=LatS;
RSRProdWaveS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
RSRProdWaveBS=RLZABS;
RetPixCountS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
LZAPixCountS=RetPixCountS;
OutlierPixCountS=RetPixCountS;
ImageCloudFracS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],'units',[],...
    'valid_range',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
SZAStatS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
RSRStatS=SZAStatS;
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
tBS=struct('values',[],'long_name',[]);
ProcessParamTS=struct('values',[],'long_name',[],'L2_processing_parm_version',[]);
lat_imageS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[]);
lat_image_BS=struct('values',[],'long_name',[]);
lon_imageS=lat_imageS;
lon_image_BS=lat_image_BS;
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

AlgoProductTS=struct('values',[],'long_name',[],'algorithm_version',[],'product_version',[]);

Algo2S=struct('values',[],'long_name',[],...
    'input_ABI_L2_auxiliary_solar_zenith_angle_data',[],...
    'inp_ABI_L2_aux_sun_satellite_relative_azimuth_angle_data',[],...
    'inp_ABI_L2_aerosol_optical_depth_550nm_data',[],...
    'input_ABI_L2_cloud_top_phase_data',[],...
    'input_ABI_L2_cloud_effective_particle_size_data',[],...
    'input_ABI_L2_total_precipitable_water_data',[],...
    'input_ABI_L2_surface_albedo_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_1_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_2_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_3_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_4_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_5_2km_data',[],...
    'input_ABI_L2_intermediate_product_reflectance_band_6_2km_data',[],...
    'input_ABI_L2_intermediate_product_binary_snow_mask_data',[],...
    'input_ABI_L2_intermediate_product_fine_aerosol_data',[],...
    'input_ABI_L2_intermediate_product_cloud_optical_depth_data',[],...
    'input_ABI_L2_intermediate_product_cloud_top_height_data',[],...
    'input_dynamic_ancillary_global_snow_mask_data',[],...
    'input_dynamic_ancillary_NWP_total_precipitable_water_data',[],...
    'input_dynamic_ancillary_NWP_total_column_ozone_data',[]);
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
        a10=strcmp(varname,'RSR');
        a20=strcmp(varname,'DQF');
        a30=strcmp(varname,'t');
        a60=strcmp(varname,'time_bounds');
        a80=strcmp(varname,'lat_image');
        a90=strcmp(varname,'lat_image_bounds');
        a100=strcmp(varname,'lon_image');
        a110=strcmp(varname,'lon_image_bounds');
        a120=strcmp(varname,'nominal_satellite_subpoint_lat');
        a130=strcmp(varname,'nominal_satellite_subpoint_lon');
        a140=strcmp(varname,'nominal_satellite_height');
        a150=strcmp(varname,'geospatial_lat_lon_extent');
        a210=strcmp(varname,'algorithm_dynamic_input_data_container');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a310=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a320=strcmp(varname,'percent_uncorrectable_L0_errors');
        a330=strcmp(varname,'retrieval_local_zenith_angle');
        a340=strcmp(varname,'quantitative_local_zenith_angle');
        a350=strcmp(varname,'retrieval_local_zenith_angle_bounds');
        a360=strcmp(varname,'quantitative_local_zenith_angle_bounds');
        a370=strcmp(varname,'retrieval_solar_zenith_angle');
        a380=strcmp(varname,'quantitative_solar_zenith_angle');
        a390=strcmp(varname,'retrieval_solar_zenith_angle_bounds');
        a400=strcmp(varname,'quantitative_solar_zenith_angle_bounds');
        a410=strcmp(varname,'rsr_product_wavelength');
        a420=strcmp(varname,'rsr_product_wavelength_bounds');
        a430=strcmp(varname,'retrieval_pixel_count');
        a440=strcmp(varname,'lza_pixel_count');
        a450=strcmp(varname,'outlier_pixel_count');
        a460=strcmp(varname,'image_cloud_fraction');
        a470=strcmp(varname,'minimum_sza');
        a480=strcmp(varname,'maximum_sza');
        a490=strcmp(varname,'mean_sza');
        a500=strcmp(varname,'std_dev_sza');
        a510=strcmp(varname,'minimum_rsr');
        a520=strcmp(varname,'maximum_rsr');
        a530=strcmp(varname,'mean_rsr');
        a540=strcmp(varname,'std_dev_rsr');
        a550=strcmp(varname,'lat');
        a560=strcmp(varname,'lon');
        
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
                RSRS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RSRS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RSRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RSRS.units=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                RSRS.unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RSRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                RSRS.resolution=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RSRS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RSRS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RSRS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                RSRS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                RSRS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                RSRS.add_offset=attname2;
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
                DQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQFS.standard_name=attname2;
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
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DQFS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQFS.number_of_qf_values=attname2;
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
                lat_imageS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                lat_imageS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                lat_imageS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                lat_imageS.axis=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                lat_imageS.bounds=attname2;
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
                lat_image_BS.long_name=attname2;
            end
        elseif (a100==1)
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
                lon_imageS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                lon_imageS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                lon_imageS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                lon_imageS.axis=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                lon_imageS.bounds=attname2;
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
                lon_image_BS.long_name=attname2;
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
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_solar_zenith_angle_data');
            if(a1==1)
                Algo2S.input_ABI_L2_auxiliary_solar_zenith_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_sun_satellite_relative_azimuth_angle_data');
            if(a1==1)
                Algo2S.inp_ABI_L2_aux_sun_satellite_relative_azimuth_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_aerosol_optical_depth_550nm_data');
            if(a1==1)
                Algo2S.inp_ABI_L2_aerosol_optical_depth_550nm_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_cloud_top_phase_data');
            if(a1==1)
                Algo2S.input_ABI_L2_cloud_top_phase_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_cloud_effective_particle_size_data');
            if(a1==1)
                Algo2S.input_ABI_L2_cloud_effective_particle_size_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_total_precipitable_water_data');
            if(a1==1)
                Algo2S.input_ABI_L2_total_precipitable_water_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_surface_albedo_data');
            if(a1==1)
                Algo2S.input_ABI_L2_surface_albedo_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_1_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_reflectance_band_1_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_2_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_reflectance_band_2_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_3_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_reflectance_band_3_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_4_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_reflectance_band_4_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_5_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_reflectance_band_5_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_6_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_reflectance_band_6_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_binary_snow_mask_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_binary_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_fine_aerosol_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_fine_aerosol_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_optical_depth_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_cloud_optical_depth_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_top_height_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_cloud_top_height_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_global_snow_mask_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_global_snow_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_total_precipitable_water_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_total_precipitable_water_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_total_column_ozone_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_total_column_ozone_data=attname2;
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
                RLZABS.long_name=attname2;
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
                RSZABS.long_name=attname2;
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
                QSZABS.long_name=attname2;
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
                RSRProdWaveS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RSRProdWaveS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RSRProdWaveS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                RSRProdWaveS.bounds=attname2;
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
                RSRProdWaveBS.long_name=attname2;
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
                RetPixCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RetPixCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RetPixCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RetPixCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RetPixCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RetPixCountS.cell_methods=attname2;
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
                LZAPixCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LZAPixCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LZAPixCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LZAPixCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                LZAPixCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LZAPixCountS.cell_methods=attname2;
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
                OutlierPixCountS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutlierPixCountS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutlierPixCountS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutlierPixCountS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutlierPixCountS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutlierPixCountS.cell_methods=attname2;
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
                RSRStatS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RSRStatS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RSRStatS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RSRStatS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RSRStatS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RSRStatS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RSRStatS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RSRStatS.cell_methods1=attname2;
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
                RSRStatS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RSRStatS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RSRStatS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RSRStatS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RSRStatS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RSRStatS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RSRStatS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RSRStatS.cell_methods2=attname2;
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
                RSRStatS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RSRStatS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RSRStatS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RSRStatS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RSRStatS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RSRStatS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RSRStatS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RSRStatS.cell_methods3=attname2;
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
                RSRStatS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RSRStatS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RSRStatS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RSRStatS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RSRStatS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RSRStatS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RSRStatS.cell_methods4=attname2;
            end
         elseif (a550==1)
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
                LatS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatS.standard_name=attname2;
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
         elseif (a560==1)
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
                LonS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LonS.standard_name=attname2;
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
        if(a10==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            FillValue=RSRS.FillValue;
            RSRV=RSR;
           [RSRV2,numnanvals] = ReplaceFillValues(RSRV,FillValue);
           [nrows,ncols]=size(RSRV);
           level=(2^15)-1;
           for ik=1:nrows
               for jk=1:ncols
                  value=RSRV2(ik,jk);
                  if(value<0)
                       diff=level-abs(value);
                       corval=level+diff;
                       RSRV2(ik,jk)=corval;
                  end
               end
           end
           RSRV2=RSRV2'*scale+offset;
           RSRS.values=double(RSRV2); 
           clear RSRV2;
        end
        if(a550==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            lat=lat'*scale+offset;
            LatS.values=double(lat);
        end
        if(a560==1)
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            lon=lon'*scale+offset;
            LonS.values=double(lon);
        end

    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])  

        if(a20==1)
            DQFS.values=DQF;
        end
        if(varname=='t')
            tS.values=t;
        end
        if(a60==1)
            tBS.values=time_bounds;
        end
        if(a80==1)
            lat_imageS.values=lat_image;
        end
        if(a90==1)
            lat_image_BS.values=lat_image_bounds;
        end
        if(a100==1)
            lon_imageS.values=lon_image;
        end
        if(a110==1)
            lon_image_BS.values=lon_image_bounds;
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
            Algo2S.values=algorithm_dynamic_input_data_container;
        end
        if(a250==1)
            ProcessParamTS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProductTS.values=algorithm_product_version_container;
        end
        if(a310==1)
            Error1S.values1=percent_uncorrectable_GRB_errors;
        end
        if(a320==1)
            Error1S.values2=percent_uncorrectable_L0_errors;
        end
        if(a330==1)
            RLZAS.values=retrieval_local_zenith_angle;
        end
        if(a340==1)
            QLZAS.values=quantitative_local_zenith_angle;
        end
        if(a350==1)
            RLZABS.values=retrieval_local_zenith_angle_bounds;
        end
        if(a360==1)
            QLZABS.values=quantitative_local_zenith_angle_bounds;
        end
        if(a370==1)
            RSZAS.values=retrieval_solar_zenith_angle;
        end
        if(a380==1)
            QSZAS.values=quantitative_solar_zenith_angle;
        end
        if(a390==1)
            RSZABS.values=retrieval_solar_zenith_angle_bounds;
        end
        if(a400==1)
            QSZABS.values=quantitative_solar_zenith_angle_bounds;
        end
        if(a410==1)
            RSRProdWaveS.values=rsr_product_wavelength;
        end
        if(a420==1)
            RSRProdWaveBS.values=rsr_product_wavelength_bounds;
        end
        if(a430==1)
            RetPixCountS.values=retrieval_pixel_count;
        end
        if(a440==1)
            LZAPixCountS.values=lza_pixel_count;
        end
        if(a450==1)
            OutlierPixCountS.values=outlier_pixel_count;
        end
        if(a460==1)
            ImageCloudFracS.values=image_cloud_fraction;
        end
        if(a470==1)
            SZAStatS.values1=minimum_sza;
        end
        if(a480==1)
            SZAStatS.values2=maximum_sza;
        end
        if(a490==1)
            SZAStatS.values3=mean_sza;
        end
        if(a500==1)
            SZAStatS.values4=std_dev_sza;
        end
        if(a510==1)
            RSRStatS.values1=minimum_rsr;
        end
        if(a520==1)
            RSRStatS.values2=maximum_rsr;
        end
        if(a530==1)
            RSRStatS.values3=mean_rsr;
        end
        if(a540==1)
            RSRStatS.values4=std_dev_rsr;
        end
    end
end
if(idebug==1)
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp('________________________________________________________')
    disp(' '),disp(' ')
end
netcdf.close(ncid);
fprintf(fid,'%s\n','Finished reading Reflectd Shortwave Radiation Data');
%Now write a Matlab file containing the decoded data
%use the original file name with a .mat extension
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');

if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='RSRS DQFS tS tBS SatDataS GeoSpatialS';
    varstr2=' GoesWaveBand GOESFileName MapFormFactor';
    varstr3=' Algo2S ProcessParamTS AlgoProductTS Error1S';
    varstr4=' lat_imageS lat_image_BS lon_imageS lon_image_BS';
    varstr5=' RLZAS QLZAS RLZABS QLZABS';
    varstr6=' RSZAS QSZAS RSZABS QSZABS';
    varstr7=' RSRProdWaveS RSRProdWaveBS';
    varstr8=' RetPixCountS LZAPixCountS OutlierPixCountS';
    varstr9=' ImageCloudFracS SZAStatS RSRStatS LatS LonS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7,varstr8,varstr9);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
else
    dispstr=strcat('Did Not Save Matlab File-',MatFileName);
    disp(dispstr);
end
% Get some stats on the RSR Data
RSRValues=RSRS.values;
[nrows,ncols]=size(RSRValues);
RSRValues1D=reshape(RSRValues,nrows*ncols,1);
minRSRValue=min(RSRValues1D);
maxRSRValue=max(RSRValues1D);
a1=isnan(RSRValues1D);
numnans=sum(a1);
numtotpix=nrows*ncols;
fracNaN=numnans/numtotpix;
goodfrac=1-fracNaN;

statstr1=strcat('Min RSR Value=',num2str(minRSRValue),'-Max Value=',num2str(maxRSRValue));
fprintf(fid,'%s\n',statstr1);
statstr2=strcat('Frac Of Pixels Returning Valid RSR=',num2str(goodfrac,6),'-Frac That are NaN=',num2str(fracNaN,6));
fprintf(fid,'%s\n',statstr2);
% Display the RSR on an Earth Map
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
elseif(neumoniclen==4)
    neumonicstr=neumonic(4:4);
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
titlestr=strcat('RSR-TOA-',filename);
[nvals]=DisplayRSRData(titlestr,itype);
if(nvals>100)
% Display a Histogram of the RSR distribution
    titlestr=strcat('RSRHist-',filename);
    [ValidRSR]=PlotRSRHistogram(titlestr);
% Display the Cumiliative Distribution of the RSR Measurements
    titlestr=strcat('RSRCumilDist-',filename);
    PlotRSRCumilDist(ValidRSR,titlestr)
else
    dispstr='Could not analyze this RSR because fewer than 100 valid points returned';
    disp(dispstr)
    fprintf(fid,'%s\n',dispstr);
end


end

