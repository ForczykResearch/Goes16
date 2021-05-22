function ReadABIFullDiskMultiband(indx)
% Modified: This function will read in the GOES ABI-L2-CMI Data
% This is Multiband data (r,g,b) for  Full Disk
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. I wrote this since can't find a function in the
% built-in set of netCDF functions included in MATLAB that displays all 
% header info of the file (equivalent to the old 'ncdump' function). 
%
% Replace the string 'filename.nc' with the file name you want to load.
% Make sure that the nc-file is located in the same folder as this script
% Written by: Stephen Forczyk
% Created: August 30,2020
% Revised: Jan 7,2021 added debug print capability and PDF file content
% ability
% Classification: Unclassified
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName MapFormFactor;
global CMI_C01S DQF_C01S;
global CMI_C02S DQF_C02S;
global CMI_C03S DQF_C03S;
global CMI_C04S DQF_C04S;
global CMI_C05S DQF_C05S;
global CMI_C06S DQF_C06S;
global CMI_C07S DQF_C07S;
global CMI_C08S DQF_C08S;
global CMI_C09S DQF_C09S;
global CMI_C10S DQF_C10S;
global CMI_C11S DQF_C11S;
global CMI_C12S DQF_C12S;
global CMI_C13S DQF_C13S;
global CMI_C14S DQF_C14S;
global CMI_C15S DQF_C15S;
global CMI_C16S DQF_C16S;
global MBandDataS MBandiDS;
global OutPixelCountS;
global ReflectanceB1S ReflectanceB2S ReflectanceB3S ReflectanceB4S;
global ReflectanceB5S ReflectanceB6S ReflectanceB7S ReflectanceB8S;
global ReflectanceB9S ReflectanceB10S ReflectanceB11S ReflectanceB12S;
global ReflectanceB13S ReflectanceB14S ReflectanceB15S ReflectanceB16S;
global BrightTempBand07S BrightTempBand08S BrightTempBand09S BrightTempBand10S;
global BrightTempBand11S BrightTempBand12S BrightTempBand13S BrightTempBand14S;
global BrightTempBand15S BrightTempBand16S GRB_ErrorS L0_ErrorS;
global Dynamic_Algo_ContainerS Algo_Product_ContainerS;
global xImgS xImgBS SatDataS GeoSpatialS;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global isaveGOESLightningData isaveCMI idebug isavefiles;
% additional paths needed for mapping
global fid;
global matpath1 mappath GOES16path;
global jpegpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

fprintf(fid,'\n');
userstr1='******Start Processing CONUS Level MultiBand data*****';
fprintf(fid,'%s\n',userstr1);

[nc_filenamesuf,path]=uigetfile('*nc','Select One GOES Multiband Data File');% SMF Modification
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
CMIS=struct('values',[],'fill',[],'bit_depth',[],'valid_range',[],...
    'scale_factor',[],'add_offset',[],'resolution',[],'grid_mapping',[],...
    'ancillary_variables',[],'long_name',[],'standard_name',[]); 
CMI_C01S=struct('values1',[],'fill',[],'long_name',[],'standard_name',[],...
    'Unsigned',[],'sensor_band_bit_depth',[],'downsampling_method',[],...
    'valid_range',[],'scale_factor',[],'add_offset',[],'units',[],...
    'resolution',[],'coordinates',[],'grid_mapping',[],'cell_methods',[],...
    'ancillary_variables',[]);
CMI_C02S=CMI_C01S;
CMI_C03S=CMI_C01S;
CMI_C04S=CMI_C01S;
CMI_C05S=CMI_C01S;
CMI_C06S=CMI_C01S;
CMI_C07S=CMI_C01S;
CMI_C08S=CMI_C01S;
CMI_C09S=CMI_C01S;
CMI_C10S=CMI_C10S;
CMI_C11S=CMI_C11S;
CMI_C12S=CMI_C12S;
CMI_C13S=CMI_C13S;
CMI_C14S=CMI_C14S;
CMI_C15S=CMI_C15S;
CMI_C16S=CMI_C16S;
DQFS=struct('values',[],'fill',[],'valid_range',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'flag_values',[],'flag_meanings',[],...
    'number_of_qf_values',[],'long_name',[],'standard_name',[],...
    'percent_good_pixel_qf',[],'percent_conditionally_usable_pixel_qf',[],...
    'percent_out_of_range_pixel_qf',[],'percent_no_value_pixel_qf',[],...
    'percent_focal_plane_temperature_threshold_exceeded_qf',[]);
DQF_C01S=struct('values',[],'fill',[],'valid_range',[],'units',[],'unsigned',[],...
    'coordinates',[],'grid_mapping',[],'flag_values',[],'flag_meanings',[],...
    'number_of_qf_values',[],'long_name',[],'standard_name',[],...
    'percent_good_pixel_qf',[],'percent_conditionally_usable_pixel_qf',[],...
    'percent_out_of_range_pixel_qf',[],'percent_no_value_pixel_qf',[],...
    'percent_focal_plane_temperature_threshold_exceeded_qf',[]);
DQF_C02S=DQF_C01S;
DQF_C03S=DQF_C01S;
DQF_C04S=DQF_C01S;
DQF_C05S=DQF_C01S;
DQF_C06S=DQF_C01S;
DQF_C07S=DQF_C01S;
DQF_C08S=DQF_C01S;
DQF_C09S=DQF_C01S;
DQF_C10S=DQF_C01S;
DQF_C11S=DQF_C01S;
DQF_C12S=DQF_C01S;
DQF_C13S=DQF_C01S;
DQF_C14S=DQF_C01S;
DQF_C15S=DQF_C01S;
DQF_C16S=DQF_C01S;
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[],'grid_mapping_name',[]);
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
MBandDataS=struct('values1',[],'long_name1',[],'standard_name1',[],'units1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'units2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'units3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'units4',[],...
    'values5',[],'long_name5',[],'standard_name5',[],'units5',[],...
    'values6',[],'long_name6',[],'standard_name6',[],'units6',[],...
    'values7',[],'long_name7',[],'standard_name7',[],'units7',[],...
    'values8',[],'long_name8',[],'standard_name8',[],'units8',[],...
    'values9',[],'long_name9',[],'standard_name9',[],'units9',[],...
    'values10',[],'long_name10',[],'standard_name10',[],'units10',[],...
    'values11',[],'long_name11',[],'standard_name11',[],'units11',[],...
    'values12',[],'long_name12',[],'standard_name12',[],'units12',[],...
    'values13',[],'long_name13',[],'standard_name13',[],'units13',[],...
    'values14',[],'long_name14',[],'standard_name14',[],'units14',[],...
    'values15',[],'long_name15',[],'standard_name15',[],'units15',[],...
    'values16',[],'long_name16',[],'standard_name16',[],'units16',[]);
MBandiDS=struct('values1',[],'long_name1',[],'standard_name1',[],'units1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'units2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'units3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'units4',[],...
    'values5',[],'long_name5',[],'standard_name5',[],'units5',[],...
    'values6',[],'long_name6',[],'standard_name6',[],'units6',[],...
    'values7',[],'long_name7',[],'standard_name7',[],'units7',[],...
    'values8',[],'long_name8',[],'standard_name8',[],'units8',[],...
    'values9',[],'long_name9',[],'standard_name9',[],'units9',[],...
    'values10',[],'long_name10',[],'standard_name10',[],'units10',[],...
    'values11',[],'long_name11',[],'standard_name11',[],'units11',[],...
    'values12',[],'long_name12',[],'standard_name12',[],'units12',[],...
    'values13',[],'long_name13',[],'standard_name13',[],'units13',[],...
    'values14',[],'long_name14',[],'standard_name14',[],'units14',[],...
    'values15',[],'long_name15',[],'standard_name15',[],'units15',[],...
    'values16',[],'long_name16',[],'standard_name16',[],'units16',[]);
OutPixelCountS=struct('values1',[],'long_name1',[],'fillvalue1',[],...
    'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'fillvalue2',[],...
    'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'fillvalue3',[],...
    'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'fillvalue4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[],...
    'values5',[],'long_name5',[],'fillvalue5',[],...
    'units5',[],'coordinates5',[],'grid_mapping5',[],'cell_methods5',[],...
    'values6',[],'long_name6',[],'fillvalue6',[],...
    'units6',[],'coordinates6',[],'grid_mapping6',[],'cell_methods6',[],...
    'values7',[],'long_name7',[],'fillvalue7',[],...
    'units7',[],'coordinates7',[],'grid_mapping7',[],'cell_methods7',[],...
    'values8',[],'long_name8',[],'fillvalue8',[],...
    'units8',[],'coordinates8',[],'grid_mapping8',[],'cell_methods8',[],...
    'values9',[],'long_name9',[],'fillvalue9',[],...
    'units9',[],'coordinates9',[],'grid_mapping9',[],'cell_methods9',[],...
    'values10',[],'long_name10',[],'fillvalue10',[],...
    'units10',[],'coordinates10',[],'grid_mapping10',[],'cell_methods10',[],...
    'values11',[],'long_name11',[],'fillvalue11',[],...
    'units11',[],'coordinates11',[],'grid_mapping11',[],'cell_methods11',[],...
    'values12',[],'long_name12',[],'fillvalue12',[],...
    'units12',[],'coordinates12',[],'grid_mapping12',[],'cell_methods12',[],...   
    'values13',[],'long_name13',[],'fillvalue13',[],...
    'units13',[],'coordinates13',[],'grid_mapping13',[],'cell_methods13',[],...
    'values14',[],'long_name14',[],'fillvalue14',[],...
    'units14',[],'coordinates14',[],'grid_mapping14',[],'cell_methods14',[],... 
    'values15',[],'long_name15',[],'fillvalue15',[],...
    'units15',[],'coordinates15',[],'grid_mapping15',[],'cell_methods15',[],...
    'values16',[],'long_name16',[],'fillvalue16',[],...
    'units16',[],'coordinates16',[],'grid_mapping16',[],'cell_methods16',[]);
ReflectanceS=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'FillValue1',[],'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],...
    'cell_methods1',[],'values2',[],'long_name2',[],'standard_name2',[],...
    'FillValue2',[],'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],...
    'cell_methods2',[],'values3',[],'long_name3',[],'standard_name3',[],...
    'FillValue3',[],'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],...
    'cell_methods3',[],'values4',[],'long_name4',[],'standard_name4',[],...
    'FillValue4',[],'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],...
    'cell_methods4',[]);
ReflectanceB1S=ReflectanceS;
ReflectanceB2S=ReflectanceS;
ReflectanceB3S=ReflectanceS;
ReflectanceB4S=ReflectanceS;
ReflectanceB5S=ReflectanceS;
ReflectanceB6S=ReflectanceS;
ReflectanceB7S=ReflectanceS;
ReflectanceB8S=ReflectanceS;
ReflectanceB9S=ReflectanceS;
ReflectanceB10S=ReflectanceS;
ReflectanceB11S=ReflectanceS;
ReflectanceB12S=ReflectanceS;
ReflectanceB13S=ReflectanceS;
ReflectanceB14S=ReflectanceS;
ReflectanceB15S=ReflectanceS;
ReflectanceB16S=ReflectanceS;
AlgoS=struct('values',[],'long_name',[],'input_ABI_L2_auxiliary_solar_zenith_angle_data',[],...
    'input_ABI_L1b_radiance_band_data',[]);
BrightTempBand07S=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
BrightTempBand08S=BrightTempBand07S;
BrightTempBand09S=BrightTempBand07S;
BrightTempBand10S=BrightTempBand07S;
BrightTempBand11S=BrightTempBand07S;
BrightTempBand12S=BrightTempBand07S;
BrightTempBand13S=BrightTempBand07S;
BrightTempBand14S=BrightTempBand07S;
BrightTempBand15S=BrightTempBand07S;
BrightTempBand16S=BrightTempBand07S;
ErrorS=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'valid_range2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[]);
GRB_ErrorS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
L0_ErrorS=GRB_ErrorS;
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
Dynamic_Algo_ContainerS=struct('values',[],'long_name',[],'ABI_L2_aux_solar_zenith_angle_data',[],...
    'ABI_L1b_radiance_band_1_1km_data',[],'ABI_L1b_radiance_band_1_2km_data',[],...
    'ABI_L1b_radiance_band_2_half_km_data',[],'ABI_L1b_radiance_band_2_2km_data',[],...
    'ABI_L1b_radiance_band_3_1km_data',[],'ABI_L1b_radiance_band_3_2km_data',[],...
    'ABI_L1b_radiance_band_4_2km_data',[],'ABI_L1b_radiance_band_5_1km_data',[],...
    'ABI_L1b_radiance_band_5_2km_data',[],'ABI_L1b_radiance_band_6_2km_data',[],...
    'ABI_L1b_radiance_band_7_2km_data',[],'ABI_L1b_radiance_band_8_2km_data',[],...
    'ABI_L1b_radiance_band_9_2km_data',[],'ABI_L1b_radiance_band_10_2km_data',[],...
    'ABI_L1b_radiance_band_11_2km_data',[],'ABI_L1b_radiance_band_12_2km_data',[],...
    'ABI_L1b_radiance_band_13_2km_data',[],'ABI_L1b_radiance_band_14_2km_data',[],...
    'ABI_L1b_radiance_band_15_2km_data',[],'ABI_L1b_radiance_band_16_2km_data',[]);
Algo_Product_ContainerS=struct('values',[],'long_name',[],'algorithm_version',[],...
    'product_version',[]);
% Get information about the contents of the file
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
        a10=strcmp(varname,'CMI_C01');
        a20=strcmp(varname,'DQF_C01');
        a30=strcmp(varname,'CMI_C02');
        a40=strcmp(varname,'DQF_C02');
        a50=strcmp(varname,'CMI_C03');
        a60=strcmp(varname,'DQF_C03');
        a70=strcmp(varname,'CMI_C04');
        a80=strcmp(varname,'DQF_C04');
        a90=strcmp(varname,'CMI_C05');
        a100=strcmp(varname,'DQF_C05');
        a110=strcmp(varname,'CMI_C06');
        a120=strcmp(varname,'DQF_C06');
        a130=strcmp(varname,'CMI_C07');
        a140=strcmp(varname,'DQF_C07');
        a150=strcmp(varname,'CMI_C08');
        a160=strcmp(varname,'DQF_C08');
        a170=strcmp(varname,'CMI_C09');
        a180=strcmp(varname,'DQF_C09');
        a190=strcmp(varname,'CMI_C10');
        a200=strcmp(varname,'DQF_C10');
        a210=strcmp(varname,'CMI_C11');
        a220=strcmp(varname,'DQF_C11');
        a230=strcmp(varname,'CMI_C12');
        a240=strcmp(varname,'DQF_C12');
        a250=strcmp(varname,'CMI_C13');
        a260=strcmp(varname,'DQF_C13');
        a270=strcmp(varname,'CMI_C14');
        a280=strcmp(varname,'DQF_C14');
        a290=strcmp(varname,'CMI_C15');
        a300=strcmp(varname,'DQF_C15');
        a310=strcmp(varname,'CMI_C16');
        a320=strcmp(varname,'DQF_C16');
        a330=strcmp(varname,'t');
        a340=strcmp(varname,'y');
        a350=strcmp(varname,'x');
        a360=strcmp(varname,'time_bounds');
        a370=strcmp(varname,'goes_imager_projection');
        a380=strcmp(varname,'y_image');
        a390=strcmp(varname,'y_image_bounds');
        a400=strcmp(varname,'x_image');
        a410=strcmp(varname,'x_image_bounds');
        a420=strcmp(varname,'nominal_satellite_subpoint_lat');
        a430=strcmp(varname,'nominal_satellite_subpoint_lon');
        a440=strcmp(varname,'nominal_satellite_height');
        a450=strcmp(varname,'geospatial_lat_lon_extent');
        a460=strcmp(varname,'band_wavelength_C01');
        a470=strcmp(varname,'band_wavelength_C02');
        a480=strcmp(varname,'band_wavelength_C03');
        a490=strcmp(varname,'band_wavelength_C04');
        a500=strcmp(varname,'band_wavelength_C05');
        a510=strcmp(varname,'band_wavelength_C06');
        a520=strcmp(varname,'band_wavelength_C07');
        a530=strcmp(varname,'band_wavelength_C08');
        a540=strcmp(varname,'band_wavelength_C09');
        a550=strcmp(varname,'band_wavelength_C10');
        a560=strcmp(varname,'band_wavelength_C11');
        a570=strcmp(varname,'band_wavelength_C12');
        a580=strcmp(varname,'band_wavelength_C13');
        a590=strcmp(varname,'band_wavelength_C14');
        a600=strcmp(varname,'band_wavelength_C15');
        a610=strcmp(varname,'band_wavelength_C16');
        a620=strcmp(varname,'band_id_C01');
        a630=strcmp(varname,'band_id_C02');
        a640=strcmp(varname,'band_id_C03');
        a650=strcmp(varname,'band_id_C04');
        a660=strcmp(varname,'band_id_C05');
        a670=strcmp(varname,'band_id_C06');
        a680=strcmp(varname,'band_id_C07');
        a690=strcmp(varname,'band_id_C08');
        a700=strcmp(varname,'band_id_C09');
        a710=strcmp(varname,'band_id_C10');
        a720=strcmp(varname,'band_id_C11');
        a730=strcmp(varname,'band_id_C12');
        a740=strcmp(varname,'band_id_C13');
        a750=strcmp(varname,'band_id_C14');
        a760=strcmp(varname,'band_id_C15');
        a770=strcmp(varname,'band_id_C16');
        a780=strcmp(varname,'outlier_pixel_count_C01');
        a790=strcmp(varname,'min_reflectance_factor_C01');
        a800=strcmp(varname,'max_reflectance_factor_C01');
        a810=strcmp(varname,'mean_reflectance_factor_C01');
        a820=strcmp(varname,'std_dev_reflectance_factor_C01');
        a830=strcmp(varname,'outlier_pixel_count_C02');
        a840=strcmp(varname,'min_reflectance_factor_C02');
        a850=strcmp(varname,'max_reflectance_factor_C02');
        a860=strcmp(varname,'mean_reflectance_factor_C02');
        a870=strcmp(varname,'std_dev_reflectance_factor_C02');
        a880=strcmp(varname,'outlier_pixel_count_C03');
        a890=strcmp(varname,'min_reflectance_factor_C03');
        a900=strcmp(varname,'max_reflectance_factor_C03');
        a910=strcmp(varname,'mean_reflectance_factor_C03');
        a920=strcmp(varname,'std_dev_reflectance_factor_C03');
        a930=strcmp(varname,'outlier_pixel_count_C04');
        a940=strcmp(varname,'min_reflectance_factor_C04');
        a950=strcmp(varname,'max_reflectance_factor_C04');
        a960=strcmp(varname,'mean_reflectance_factor_C04');
        a970=strcmp(varname,'std_dev_reflectance_factor_C04');
        a980=strcmp(varname,'outlier_pixel_count_C05');
        a990=strcmp(varname,'min_reflectance_factor_C05');
        a1000=strcmp(varname,'max_reflectance_factor_C05');
        a1010=strcmp(varname,'mean_reflectance_factor_C05');
        a1020=strcmp(varname,'std_dev_reflectance_factor_C05');
        a1030=strcmp(varname,'outlier_pixel_count_C06');
        a1040=strcmp(varname,'min_reflectance_factor_C06');
        a1050=strcmp(varname,'max_reflectance_factor_C06');
        a1060=strcmp(varname,'mean_reflectance_factor_C06');
        a1070=strcmp(varname,'std_dev_reflectance_factor_C06');
        a1080=strcmp(varname,'outlier_pixel_count_C07');
        a1090=strcmp(varname,'min_reflectance_factor_C07');
        a1100=strcmp(varname,'max_reflectance_factor_C07');
        a1110=strcmp(varname,'mean_reflectance_factor_C07');
        a1120=strcmp(varname,'std_dev_reflectance_factor_C07');
        a1130=strcmp(varname,'min_brightness_temperature_C07');
        a1140=strcmp(varname,'max_brightness_temperature_C07');
        a1150=strcmp(varname,'mean_brightness_temperature_C07');
        a1160=strcmp(varname,'std_dev_brightness_temperature_C07');
        a1170=strcmp(varname,'outlier_pixel_count_C08');
        a1180=strcmp(varname,'min_brightness_temperature_C08');
        a1190=strcmp(varname,'max_brightness_temperature_C08');
        a1200=strcmp(varname,'mean_brightness_temperature_C08');
        a1210=strcmp(varname,'std_dev_brightness_temperature_C08');
        a1220=strcmp(varname,'outlier_pixel_count_C09');
        a1230=strcmp(varname,'min_brightness_temperature_C09');
        a1240=strcmp(varname,'max_brightness_temperature_C09');
        a1250=strcmp(varname,'mean_brightness_temperature_C09');
        a1260=strcmp(varname,'std_dev_brightness_temperature_C09');
        a1270=strcmp(varname,'outlier_pixel_count_C10');
        a1280=strcmp(varname,'min_brightness_temperature_C10');
        a1290=strcmp(varname,'max_brightness_temperature_C10');
        a1300=strcmp(varname,'mean_brightness_temperature_C10');
        a1310=strcmp(varname,'std_dev_brightness_temperature_C10');
        a1320=strcmp(varname,'outlier_pixel_count_C11');
        a1330=strcmp(varname,'min_brightness_temperature_C11');
        a1340=strcmp(varname,'max_brightness_temperature_C11');
        a1350=strcmp(varname,'mean_brightness_temperature_C11');
        a1360=strcmp(varname,'std_dev_brightness_temperature_C11');
        a1370=strcmp(varname,'outlier_pixel_count_C12');
        a1380=strcmp(varname,'min_brightness_temperature_C12');
        a1390=strcmp(varname,'max_brightness_temperature_C12');
        a1400=strcmp(varname,'mean_brightness_temperature_C12');
        a1410=strcmp(varname,'std_dev_brightness_temperature_C12');
        a1420=strcmp(varname,'outlier_pixel_count_C13');
        a1430=strcmp(varname,'min_brightness_temperature_C13');
        a1440=strcmp(varname,'max_brightness_temperature_C13');
        a1450=strcmp(varname,'mean_brightness_temperature_C13');
        a1460=strcmp(varname,'std_dev_brightness_temperature_C13');
        a1470=strcmp(varname,'outlier_pixel_count_C14');
        a1480=strcmp(varname,'min_brightness_temperature_C14');
        a1490=strcmp(varname,'max_brightness_temperature_C14');
        a1500=strcmp(varname,'mean_brightness_temperature_C14');
        a1510=strcmp(varname,'std_dev_brightness_temperature_C14');
        a1520=strcmp(varname,'outlier_pixel_count_C15');
        a1530=strcmp(varname,'min_brightness_temperature_C15');
        a1540=strcmp(varname,'max_brightness_temperature_C15');
        a1550=strcmp(varname,'mean_brightness_temperature_C15');
        a1560=strcmp(varname,'std_dev_brightness_temperature_C15');
        a1570=strcmp(varname,'outlier_pixel_count_C16');
        a1580=strcmp(varname,'min_brightness_temperature_C16');
        a1590=strcmp(varname,'max_brightness_temperature_C16');
        a1600=strcmp(varname,'mean_brightness_temperature_C16');
        a1610=strcmp(varname,'std_dev_brightness_temperature_C16');
        a1620=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a1630=strcmp(varname,'percent_uncorrectable_L0_errors');
        a1640=strcmp(varname,'dynamic_algorithm_input_data_container');
        a1650=strcmp(varname,'algorithm_product_version_container');

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
                CMI_C01S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C01S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C01S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C01S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C01S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C01S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C01S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C01S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C01S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C01S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C01S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C01S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C01S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C01S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C01S.cell_methods=attname2;
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
                DQF_C01S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C01S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C01S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C01S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C01S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C01S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C01S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C01S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C01S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C01S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C01S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C01S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C01S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C01S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C01S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C01S.unsigned=attname2;
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
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CMI_C02S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C02S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C02S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C02S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C02S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C02S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C02S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C02S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C02S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C02S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C02S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C02S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C02S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C02S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C02S.cell_methods=attname2;
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
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_C02S.fill=attname2;
            end

            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C02S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C02S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C02S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C02S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C02S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C02S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C02S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C02S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C02S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C02S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C02S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C02S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C02S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C02S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C02S.unsigned=attname2;
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
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CMI_C03S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C03S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C03S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C03S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C03S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C03S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C03S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C03S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C03S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C03S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C03S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C03S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C03S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C03S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C03S.cell_methods=attname2;
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
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_C03S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C03S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C03S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C03S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C03S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C03S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C03S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C03S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C03S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C03S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C03S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C03S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C03S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C03S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C03S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C03S.unsigned=attname2;
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
                CMI_C04S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C04S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C04S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C04S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C04S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C04S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C04S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C04S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C04S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C04S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C04S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C04S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C04S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C04S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C04S.cell_methods=attname2;
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
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_C04S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C04S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C04S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C04S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C04S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C04S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C04S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C04S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C04S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C04S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C04S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C04S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C04S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C04S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C04S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C04S.unsigned=attname2;
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
                CMI_C05S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C05S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C05S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C05S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C05S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C05S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C05S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C05S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C05S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C05S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C05S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C05S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C05S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C05S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C05S.cell_methods=attname2;
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
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_C05S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C05S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C05S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C05S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C05S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C05S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C05S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C05S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C05S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C05S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C05S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C05S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C05S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C05S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C05S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C05S.unsigned=attname2;
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
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CMI_C06S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C06S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C06S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C06S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C06S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C06S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C06S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C06S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C06S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C06S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C06S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C06S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C06S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C06S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C06S.cell_methods=attname2;
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
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_C06S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C06S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C06S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C06S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C06S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C06S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C06S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C06S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C06S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C06S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C06S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C06S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C06S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C06S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C06S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C06S.unsigned=attname2;
            end 
         elseif (a130==1)
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
                CMI_C07S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C07S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C07S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C07S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C07S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C07S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C07S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C07S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C07S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C07S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C07S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C07S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C07S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C07S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C07S.cell_methods=attname2;
            end
        elseif (a140==1)
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
                DQF_C07S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C07S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C07S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C07S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C07S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C07S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C07S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C07S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C07S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C07S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C07S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C07S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C07S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C07S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C07S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C07S.unsigned=attname2;
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
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CMI_C08S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C08S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C08S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C08S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C08S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C08S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C08S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C08S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C08S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C08S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C08S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C08S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C08S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C08S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C08S.cell_methods=attname2;
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
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_C08S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C08S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C08S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C08S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C08S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C08S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C08S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C08S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C08S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C08S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C08S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C08S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C08S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C08S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C08S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C08S.unsigned=attname2;
            end
         elseif (a170==1)
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
                CMI_C09S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C09S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C09S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C09S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C09S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C09S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C09S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C09S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C09S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C09S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C09S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C09S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C09S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C09S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C09S.cell_methods=attname2;
            end
        elseif (a180==1)
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
                DQF_C09S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C09S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C09S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C09S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C09S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C09S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C09S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C09S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C09S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C09S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C09S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C09S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C09S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C09S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C09S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C09S.unsigned=attname2;
            end 
         elseif (a190==1)
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
                CMI_C10S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C10S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C10S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C10S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C10S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C10S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C10S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C10S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C10S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C10S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C10S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C10S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C10S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C10S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C10S.cell_methods=attname2;
            end
        elseif (a200==1)
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
                DQF_C10S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C10S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C10S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C10S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C10S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C10S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C10S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C10S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C10S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C10S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C10S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C10S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C10S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C10S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C10S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C10S.unsigned=attname2;
            end 
         elseif (a210==1)
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
                CMI_C11S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C11S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C11S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C11S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C11S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C11S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C11S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C11S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C11S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C11S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C11S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C11S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C11S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C11S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C11S.cell_methods=attname2;
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
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_C11S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C11S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C11S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C11S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C11S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C11S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C11S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C11S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C11S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C11S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C11S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C11S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C11S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C11S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C11S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C11S.unsigned=attname2;
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
                CMI_C12S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C12S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C12S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C12S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C12S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C12S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C12S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C12S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C12S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C12S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C12S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C12S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C12S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C12S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C12S.cell_methods=attname2;
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
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF_C12S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C12S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C12S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C12S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C12S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C12S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C12S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C12S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C12S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C12S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C12S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C12S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C12S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C12S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C12S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C12S.unsigned=attname2;
            end 
         elseif (a250==1)
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
                CMI_C13S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C13S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C13S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C13S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C13S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C13S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C13S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C13S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C13S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C13S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C13S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C13S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C13S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C13S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C13S.cell_methods=attname2;
            end
        elseif (a260==1)
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
                DQF_C13S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C13S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C13S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C13S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C13S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C13S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C13S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C13S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C13S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C13S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C13S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C13S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C13S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C13S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C13S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C13S.unsigned=attname2;
            end 
         elseif (a270==1)
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
                CMI_C14S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C14S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C14S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C14S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C14S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C14S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C14S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C14S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C14S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C14S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C14S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C14S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C14S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C14S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C14S.cell_methods=attname2;
            end
        elseif (a280==1)
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
                DQF_C14S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C14S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C14S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C14S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C14S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C14S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C14S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C14S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C14S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C14S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C14S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C14S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C14S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C14S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C14S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C14S.unsigned=attname2;
            end
         elseif (a290==1)
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
                CMI_C15S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C15S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C15S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C15S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C15S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C15S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C15S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C15S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C15S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C15S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C15S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C15S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C15S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C15S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C15S.cell_methods=attname2;
            end
        elseif (a300==1)
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
                DQF_C15S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C15S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C15S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C15S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C15S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C15S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C15S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C15S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C15S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C15S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C15S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C15S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C15S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C15S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C15S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C15S.unsigned=attname2;
            end
         elseif (a310==1)
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
                CMI_C16S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CMI_C16S.fill=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CMI_C16S.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CMI_C16S.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                CMI_C16S.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                CMI_C16S.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                CMI_C16S.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CMI_C16S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                CMI_C16S.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                CMI_C16S.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                CMI_C16S.sensor_band_bit_depth=attname2;
            end
            a1=strcmp(attname1,'downsampling_method');
            if(a1==1)
                CMI_C16S.downsampling_method=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CMI_C16S.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CMI_C16S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CMI_C16S.cell_methods=attname2;
            end
        elseif (a320==1)
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
                DQF_C16S.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF_C16S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF_C16S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF_C16S.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF_C16S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF_C16S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF_C16S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF_C16S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF_C16S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF_C16S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQF_C16S.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQF_C16S.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQF_C16S.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQF_C16S.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF_C16S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF_C16S.unsigned=attname2;
            end 
        elseif (a330==1)
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
        elseif (a340==1)
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
        elseif (a350==1)
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
        elseif (a360==1)
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
        elseif (a370==1)
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
       elseif (a380==1)
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
                yImgBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yImgBS.units=attname2;
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
                xImgBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xImgBS.units=attname2;
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
                MBandDataS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units1=attname2;
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
                MBandDataS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units2=attname2;
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
                MBandDataS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units3=attname2;
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
                MBandDataS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units4=attname2;
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
                MBandDataS.long_name5=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name5=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units5=attname2;
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
                MBandDataS.long_name6=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name6=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units6=attname2;
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
                MBandDataS.long_name7=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name7=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units7=attname2;
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
                MBandDataS.long_name8=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name8=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units8=attname2;
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
                MBandDataS.long_name9=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name9=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units9=attname2;
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
                MBandDataS.long_name10=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name10=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units10=attname2;
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
                MBandDataS.long_name11=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name11=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units11=attname2;
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
                MBandDataS.long_name12=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name12=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units12=attname2;
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
                MBandDataS.long_name13=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name13=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units13=attname2;
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
                MBandDataS.long_name14=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name14=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units14=attname2;
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
                MBandDataS.long_name15=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name15=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units15=attname2;
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
                MBandDataS.long_name16=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandDataS.standard_name16=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandDataS.units16=attname2;
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
                MBandiDS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units1=attname2;
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
                MBandiDS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units2=attname2;
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
                MBandiDS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units3=attname2;
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
                MBandiDS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units4=attname2;
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
                MBandiDS.long_name5=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name5=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units5=attname2;
            end
        elseif (a670==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MBandiDS.long_name6=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name6=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units6=attname2;
            end
        elseif (a680==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MBandiDS.long_name7=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name7=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units7=attname2;
            end
        elseif (a690==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MBandiDS.long_name8=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name8=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units8=attname2;
            end
        elseif (a700==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MBandiDS.long_name9=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name9=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units9=attname2;
            end
        elseif (a710==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MBandiDS.long_name10=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name10=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units10=attname2;
            end
        elseif (a720==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MBandiDS.long_name11=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name11=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units11=attname2;
            end
        elseif (a730==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MBandiDS.long_name12=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name12=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units12=attname2;
            end
        elseif (a740==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MBandiDS.long_name13=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name13=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units13=attname2;
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
                MBandiDS.long_name14=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name14=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units14=attname2;
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
                MBandiDS.long_name15=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name15=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units15=attname2;
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
                MBandiDS.long_name16=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MBandiDS.standard_name16=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MBandiDS.units16=attname2;
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
                OutPixelCountS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods1=attname2;
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
                ReflectanceB1S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB1S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB1S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB1S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB1S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB1S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB1S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB1S.cell_methods1=attname2;
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
                ReflectanceB1S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB1S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB1S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB1S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB1S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB1S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB1S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB1S.cell_methods2=attname2;
            end
        elseif (a810==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB1S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB1S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB1S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB1S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB1S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB1S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB1S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB1S.cell_methods3=attname2;
            end
        elseif (a820==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB1S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB1S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB1S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB1S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB1S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB1S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB1S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB1S.cell_methods4=attname2;
            end
        elseif (a830==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods2=attname2;
            end
        elseif (a840==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB2S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB2S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB2S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB2S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB2S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB2S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB2S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB2S.cell_methods1=attname2;
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
                ReflectanceB2S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB2S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB2S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB2S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB2S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB2S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB2S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB2S.cell_methods2=attname2;
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
                ReflectanceB2S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB2S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB2S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB2S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB2S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB2S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB2S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB2S.cell_methods3=attname2;
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
                ReflectanceB2S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB2S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB2S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB2S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB2S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB2S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB2S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB2S.cell_methods4=attname2;
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
                OutPixelCountS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods3=attname2;
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
                ReflectanceB3S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB3S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB3S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB3S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB3S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB3S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB3S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB3S.cell_methods1=attname2;
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
                ReflectanceB3S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB3S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB3S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB3S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB3S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB3S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB3S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB3S.cell_methods2=attname2;
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
                ReflectanceB3S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB3S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB3S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB3S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB3S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB3S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB3S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB3S.cell_methods3=attname2;
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
                ReflectanceB3S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB3S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB3S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB3S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB3S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB3S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB3S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB3S.cell_methods4=attname2;
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
                OutPixelCountS.long_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods4=attname2;
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
                ReflectanceB4S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB4S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB4S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB4S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB4S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB4S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB4S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB4S.cell_methods1=attname2;
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
                ReflectanceB4S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB4S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB4S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB4S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB4S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB4S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB4S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB4S.cell_methods2=attname2;
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
                ReflectanceB4S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB4S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB4S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB4S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB4S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB4S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB4S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB4S.cell_methods3=attname2;
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
                ReflectanceB4S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB4S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB4S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB4S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB4S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB4S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB4S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB4S.cell_methods4=attname2;
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
                OutPixelCountS.long_name5=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue5=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units5=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates5=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping5=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods5=attname2;
            end
        elseif (a990==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB5S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB5S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB5S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB5S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB5S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB5S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB5S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB5S.cell_methods1=attname2;
            end
        elseif (a1000==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB5S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB5S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB5S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB5S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB5S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB5S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB5S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB5S.cell_methods2=attname2;
            end
        elseif (a1010==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB5S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB5S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB5S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB5S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB5S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB5S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB5S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB5S.cell_methods3=attname2;
            end
        elseif (a1020==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB5S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB5S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB5S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB5S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB5S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB5S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB5S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB5S.cell_methods4=attname2;
            end
        elseif (a1030==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name6=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue6=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units6=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates6=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping6=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods6=attname2;
            end
        elseif (a1040==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB6S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB6S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB6S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB6S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB6S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB6S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB6S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB6S.cell_methods1=attname2;
            end
        elseif (a1050==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB6S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB6S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB6S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB6S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB6S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB6S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB6S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB6S.cell_methods2=attname2;
            end
        elseif (a1060==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB6S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB6S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB6S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB6S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB6S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB6S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB6S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB6S.cell_methods3=attname2;
            end
        elseif (a1070==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB6S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB6S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB6S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB6S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB6S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB6S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB6S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB6S.cell_methods4=attname2;
            end
        elseif (a1080==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name7=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue7=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units7=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates7=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping7=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods7=attname2;
            end
        elseif (a1090==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB7S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB7S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB7S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB7S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB7S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB7S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB7S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB7S.cell_methods1=attname2;
            end
        elseif (a1100==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB7S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB7S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB7S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB7S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB7S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB7S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB7S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB7S.cell_methods2=attname2;
            end
        elseif (a1110==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB7S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB7S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB7S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB7S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB7S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB7S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB7S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB7S.cell_methods3=attname2;
            end
        elseif (a1120==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ReflectanceB7S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ReflectanceB7S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ReflectanceB7S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ReflectanceB7S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ReflectanceB7S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ReflectanceB7S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ReflectanceB7S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ReflectanceB7S.cell_methods4=attname2;
            end
        elseif (a1130==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand07S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand07S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand07S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand07S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand07S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand07S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand07S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand07S.cell_methods1=attname2;
            end
        elseif (a1140==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand07S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand07S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand07S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand07S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand07S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand07S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand07S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand07S.cell_methods2=attname2;
            end
        elseif (a1150==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand07S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand07S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand07S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand07S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand07S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand07S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand07S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand07S.cell_methods3=attname2;
            end
        elseif (a1160==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand07S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand07S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand07S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand07S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand07S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand07S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand07S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand07S.cell_methods4=attname2;
            end
        elseif (a1170==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name8=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue8=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units8=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates8=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping8=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods8=attname2;
            end
        elseif (a1180==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand08S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand08S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand08S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand08S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand08S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand08S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand08S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand08S.cell_methods1=attname2;
            end
        elseif (a1190==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand08S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand08S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand08S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand08S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand08S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand08S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand08S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand08S.cell_methods2=attname2;
            end
        elseif (a1200==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand08S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand08S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand08S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand08S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand08S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand08S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand08S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand08S.cell_methods3=attname2;
            end
        elseif (a1210==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand08S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand08S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand08S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand08S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand08S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand08S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand08S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand08S.cell_methods4=attname2;
            end
        elseif (a1220==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name9=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue9=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units9=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates9=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping9=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods9=attname2;
            end
        elseif (a1230==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand09S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand09S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand09S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand09S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand09S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand09S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand09S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand09S.cell_methods1=attname2;
            end
        elseif (a1240==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand09S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand09S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand09S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand09S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand09S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand09S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand09S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand09S.cell_methods2=attname2;
            end
        elseif (a1250==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand09S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand09S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand09S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand09S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand09S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand09S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand09S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand09S.cell_methods3=attname2;
            end
        elseif (a1260==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand09S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand09S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand09S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand08S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand09S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand09S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand09S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand09S.cell_methods4=attname2;
            end
        elseif (a1270==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name10=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue10=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units10=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates10=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping10=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods10=attname2;
            end
        elseif (a1280==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand10S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand10S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand10S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand10S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand10S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand10S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand10S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand10S.cell_methods1=attname2;
            end
        elseif (a1290==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand10S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand10S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand10S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand10S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand10S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand10S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand10S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand10S.cell_methods2=attname2;
            end
        elseif (a1300==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand10S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand10S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand10S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand10S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand10S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand10S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand10S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand10S.cell_methods3=attname2;
            end
        elseif (a1310==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand10S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand10S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand10S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand10S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand10S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand10S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand10S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand10S.cell_methods4=attname2;
            end
        elseif (a1320==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name11=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue11=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units11=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates11=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping11=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods11=attname2;
            end
        elseif (a1330==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand11S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand11S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand11S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand11S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand11S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand11S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand11S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand11S.cell_methods1=attname2;
            end
        elseif (a1340==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand11S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand11S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand11S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand11S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand11S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand11S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand11S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand11S.cell_methods2=attname2;
            end
        elseif (a1350==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand11S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand11S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand11S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand11S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand11S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand11S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand11S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand11S.cell_methods3=attname2;
            end
        elseif (a1360==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand11S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand11S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand11S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand11S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand11S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand11S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand11S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand11S.cell_methods4=attname2;
            end
        elseif (a1370==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name12=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue12=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units12=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates12=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping12=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods12=attname2;
            end
        elseif (a1380==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand12S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand12S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand12S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand12S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand12S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand12S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand12S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand12S.cell_methods1=attname2;
            end
        elseif (a1390==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand12S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand12S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand12S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand12S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand12S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand12S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand12S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand12S.cell_methods2=attname2;
            end
        elseif (a1400==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand12S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand12S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand12S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand12S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand12S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand12S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand12S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand12S.cell_methods3=attname2;
            end
        elseif (a1410==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand12S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand12S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand12S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand12S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand12S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand12S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand12S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand12S.cell_methods4=attname2;
            end
        elseif (a1420==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name13=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue13=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units13=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates13=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping13=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods13=attname2;
            end
        elseif (a1430==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand13S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand13S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand13S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand13S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand13S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand13S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand13S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand13S.cell_methods1=attname2;
            end
        elseif (a1440==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand13S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand13S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand13S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand13S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand13S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand13S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand13S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand13S.cell_methods2=attname2;
            end
        elseif (a1450==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand13S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand13S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand13S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand13S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand13S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand13S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand13S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand13S.cell_methods3=attname2;
            end
        elseif (a1460==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand13S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand13S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand13S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand13S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand13S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand13S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand13S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand13S.cell_methods4=attname2;
            end
        elseif (a1470==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name14=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue14=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units14=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates14=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping14=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods14=attname2;
            end
        elseif (a1480==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand14S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand14S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand14S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand14S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand14S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand14S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand14S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand14S.cell_methods1=attname2;
            end
        elseif (a1490==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand14S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand14S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand14S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand14S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand14S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand14S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand14S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand14S.cell_methods2=attname2;
            end
        elseif (a1500==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand14S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand14S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand14S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand14S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand14S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand14S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand14S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand14S.cell_methods3=attname2;
            end
        elseif (a1510==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand14S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand14S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand14S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand13S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand14S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand14S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand14S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand14S.cell_methods4=attname2;
            end
        elseif (a1520==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name15=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue15=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units15=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates15=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping15=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods15=attname2;
            end
        elseif (a1530==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand15S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand15S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand15S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand15S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand15S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand15S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand15S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand15S.cell_methods1=attname2;
            end
        elseif (a1540==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand15S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand15S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand15S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand15S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand15S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand15S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand15S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand15S.cell_methods2=attname2;
            end
        elseif (a1550==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand15S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand15S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand15S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand15S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand15S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand15S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand15S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand15S.cell_methods3=attname2;
            end
        elseif (a1560==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand15S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand15S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand15S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand15S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand15S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand15S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand15S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand15S.cell_methods4=attname2;
            end
        elseif (a1570==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutPixelCountS.long_name16=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutPixelCountS.fillvalue16=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutPixelCountS.units16=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutPixelCountS.coordinates16=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutPixelCountS.grid_mapping16=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutPixelCountS.cell_methods16=attname2;
            end
        elseif (a1580==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand16S.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand16S.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand16S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand16S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand16S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand16S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand16S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand16S.cell_methods1=attname2;
            end
        elseif (a1590==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand16S.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand16S.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand16S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand16S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand16S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand16S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand16S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand16S.cell_methods2=attname2;
            end
        elseif (a1600==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand16S.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand16S.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand16S.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand16S.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand16S.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand16S.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand16S.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand16S.cell_methods3=attname2;
            end
        elseif (a1610==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BrightTempBand16S.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BrightTempBand16S.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                BrightTempBand16S.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                BrightTempBand16S.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BrightTempBand16S.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                BrightTempBand16S.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                BrightTempBand16S.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                BrightTempBand16S.cell_methods4=attname2;
            end
        elseif (a1620==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GRB_ErrorS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GRB_ErrorS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GRB_ErrorS.units=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                GRB_ErrorS.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                GRB_ErrorS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                GRB_ErrorS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                GRB_ErrorS.cell_methods=attname2;
            end
        elseif (a1630==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                L0_ErrorS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                L0_ErrorS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                L0_ErrorS.units=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                L0_ErrorS.valid_range=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                L0_ErrorS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                L0_ErrorS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                L0_ErrorS.cell_methods=attname2;
            end
        elseif (a1640==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                Dynamic_Algo_ContainerS.long_name=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_solar_zenith_angle_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L2_aux_solar_zenith_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_1_1km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_1_1km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_1_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_1_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_2_half_km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_2_half_km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_2_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_2_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_3_1km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_3_1km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_3_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_3_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_4_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_4_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_5_1km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_5_1km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_5_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_5_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_6_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_6_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_7_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_7_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_8_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_8_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_9_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_9_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_10_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_10_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_11_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_11_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_12_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_12_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_13_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_13_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_14_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_15_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_16_2km_data');
            if(a1==1)
                Dynamic_Algo_ContainerS.ABI_L1b_radiance_band_16_2km_data=attname2;
            end
        elseif (a1650==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                Algo_Product_ContainerS.long_name=attname2;
            end
            a1=strcmp(attname1,'algorithm_version');
            if(a1==1)
                Algo_Product_ContainerS.algorithm_version=attname2;
            end
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                Algo_Product_ContainerS.product_version=attname2;
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
        eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
        if(varname=='CMI_C01')
            CMI_C01S.values1=CMI_C01;
        end
        if(varname=='CMI_C02')
            CMI_C02S.values1=CMI_C02;
        end
        if(varname=='CMI_C03')
            CMI_C03S.values1=CMI_C03;
        end
        if(varname=='CMI_C04')
            CMI_C04S.values1=CMI_C04;
        end
        if(varname=='CMI_C05')
            CMI_C05S.values1=CMI_C05;
        end
        if(varname=='CMI_C06')
            CMI_C06S.values1=CMI_C06;
        end
        if(varname=='CMI_C07')
            CMI_C07S.values1=CMI_C07;
        end
        if(varname=='CMI_C08')
            CMI_C08S.values1=CMI_C08;
        end
        if(varname=='CMI_C09')
            CMI_C09S.values1=CMI_C09;
        end
        if(varname=='CMI_C10')
            CMI_C10S.values1=CMI_C10;
        end
        if(varname=='CMI_C11')
            CMI_C11S.values1=CMI_C11;
        end
        if(varname=='CMI_C12')
            CMI_C12S.values1=CMI_C12;
        end
        if(varname=='CMI_C13')
            CMI_C13S.values1=CMI_C13;
        end
        if(varname=='CMI_C14')
            CMI_C14S.values1=CMI_C14;
        end
        if(varname=='CMI_C15')
            CMI_C15S.values1=CMI_C15;
        end
        if(varname=='CMI_C16')
            CMI_C16S.values1=CMI_C16;
        end
        if(varname=='t')
            tS.values=t;
        end
        if(varname=='y')
            yS.values=y;
        end
        if(varname=='x')
            xS.values=x;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a20==1)
            DQF_C01S.values=DQF_C01;
        end
        if(a40==1)
            DQF_C02S.values=DQF_C02;
        end
        if(a60==1)
            DQF_C03S.values=DQF_C03;
        end
        if(a80==1)
            DQF_C04S.values=DQF_C04;
        end
        if(a100==1)
            DQF_C05S.values=DQF_C05;
        end
        if(a120==1)
            DQF_C06S.values=DQF_C06;
        end
        if(a140==1)
            DQF_C07S.values=DQF_C07;
        end
        if(a160==1)
            DQF_C08S.values=DQF_C08;
        end
        if(a180==1)
            DQF_C09S.values=DQF_C09;
        end
        if(a200==1)
            DQF_C10S.values=DQF_C10;
        end
        if(a220==1)
            DQF_C11S.values=DQF_C11;
        end
        if(a240==1)
            DQF_C12S.values=DQF_C12;
        end
        if(a260==1)
            DQF_C13S.values=DQF_C13;
        end
        if(a280==1)
            DQF_C14S.values=DQF_C14;
        end
        if(a300==1)
            DQF_C15S.values=DQF_C15;
        end
        if(a320==1)
            DQF_C16S.values=DQF_C16;
        end
        if(varname=='t')
            tS.values=t;
        end
        if(varname=='y')
            yS.values=y;
        end
        if(a360==1)
            tBS.values=time_bounds;
        end
        if(a370==1)
            goesImagerS.values=goes_imager_projection;
        end
        if(a380==1)
            yImgS.values=y_image;
        end
        if(a390==1)
            yImgBS.values=y_image_bounds;
        end
        if(a400==1)
            xImgS.values=x_image;
        end
        if(a410==1)
            xImgBS.values=x_image_bounds;
        end
        if(a420==1)
            val=nominal_satellite_subpoint_lat;
            SatDataS.values1=val;
        end
        if(a430==1)
            val=nominal_satellite_subpoint_lon;
            SatDataS.values2=val;
        end
        if(a440==1)
            val=nominal_satellite_height;
            SatDataS.values3=val;
        end
        if(a450==1)
            GeoSpatialS.values=geospatial_lat_lon_extent;
        end
        if(a460==1)
            MBandDataS.values1=band_wavelength_C01;
        end
        if(a470==1)
            MBandDataS.values2=band_wavelength_C02;
        end
        if(a480==1)
            MBandDataS.values3=band_wavelength_C03;
        end
        if(a490==1)
            MBandDataS.values4=band_wavelength_C04;
        end
        if(a500==1)
            MBandDataS.values5=band_wavelength_C05;
        end
        if(a510==1)
            MBandDataS.values6=band_wavelength_C06;
        end
        if(a520==1)
            MBandDataS.values7=band_wavelength_C07;
        end
        if(a530==1)
            MBandDataS.values8=band_wavelength_C08;
        end
        if(a540==1)
            MBandDataS.values9=band_wavelength_C09;
        end
        if(a550==1)
            MBandDataS.values10=band_wavelength_C10;
        end
        if(a560==1)
            MBandDataS.values11=band_wavelength_C11;
        end
        if(a570==1)
            MBandDataS.values12=band_wavelength_C12;
        end
        if(a580==1)
            MBandDataS.values13=band_wavelength_C13;
        end
        if(a590==1)
            MBandDataS.values14=band_wavelength_C14;
        end
        if(a600==1)
            MBandDataS.values15=band_wavelength_C15;
        end
        if(a610==1)
            MBandDataS.values16=band_wavelength_C16;
        end
        if(a620==1)
            MBandiDS.values1=band_id_C01;
        end
        if(a630==1)
            MBandiDS.values2=band_id_C02;
        end
        if(a640==1)
            MBandiDS.values3=band_id_C03;
        end
        if(a650==1)
            MBandiDS.values4=band_id_C04;
        end
        if(a660==1)
            MBandiDS.values5=band_id_C05;
        end
        if(a670==1)
            MBandiDS.values6=band_id_C06;
        end
        if(a680==1)
            MBandiDS.values7=band_id_C07;
        end
        if(a690==1)
            MBandiDS.values8=band_id_C08;
        end
        if(a700==1)
            MBandiDS.values9=band_id_C09;
        end
        if(a710==1)
            MBandiDS.values10=band_id_C10;
        end
        if(a720==1)
            MBandiDS.values11=band_id_C11;
        end
        if(a730==1)
            MBandiDS.values12=band_id_C12;
        end
        if(a740==1)
            MBandiDS.values13=band_id_C13;
        end
        if(a750==1)
            MBandiDS.values14=band_id_C14;
        end
        if(a760==1)
            MBandiDS.values15=band_id_C15;
        end
        if(a770==1)
            MBandiDS.values16=band_id_C16;
        end
        if(a780==1)
            OutPixelCountS.values1=outlier_pixel_count_C01;
        end
        if(a790==1)
            ReflectanceB1S.values1=min_reflectance_factor_C01;
        end
        if(a800==1)
            ReflectanceB1S.values2=max_reflectance_factor_C01;
        end
        if(a810==1)
            ReflectanceB1S.values3=mean_reflectance_factor_C01;
        end
        if(a820==1)
            ReflectanceB1S.values4=std_dev_reflectance_factor_C01;
        end
        if(a830==1)
            OutPixelCountS.values2=outlier_pixel_count_C02;
        end
        if(a840==1)
            ReflectanceB2S.values1=min_reflectance_factor_C02;
        end
        if(a850==1)
            ReflectanceB2S.values2=max_reflectance_factor_C02;
        end
        if(a860==1)
            ReflectanceB2S.values3=mean_reflectance_factor_C02;
        end
        if(a870==1)
            ReflectanceB2S.values4=std_dev_reflectance_factor_C02;
        end
        if(a880==1)
            OutPixelCountS.values3=outlier_pixel_count_C03;
        end
        if(a890==1)
            ReflectanceB3S.values1=min_reflectance_factor_C03;
        end
        if(a900==1)
            ReflectanceB3S.values2=max_reflectance_factor_C03;
        end
        if(a910==1)
            ReflectanceB3S.values3=mean_reflectance_factor_C03;
        end
        if(a920==1)
            ReflectanceB3S.values4=std_dev_reflectance_factor_C03;
        end
        if(a930==1)
            OutPixelCountS.values4=outlier_pixel_count_C04;
        end
        if(a940==1)
            ReflectanceB4S.values1=min_reflectance_factor_C04;
        end
        if(a950==1)
            ReflectanceB4S.values2=max_reflectance_factor_C04;
        end
        if(a960==1)
            ReflectanceB4S.values3=mean_reflectance_factor_C04;
        end
        if(a970==1)
            ReflectanceB4S.values4=std_dev_reflectance_factor_C04;
        end
        if(a980==1)
            OutPixelCountS.values5=outlier_pixel_count_C05;
        end
        if(a990==1)
            ReflectanceB5S.values1=min_reflectance_factor_C05;
        end
        if(a1000==1)
            ReflectanceB5S.values2=max_reflectance_factor_C05;
        end
        if(a1010==1)
            ReflectanceB5S.values3=mean_reflectance_factor_C05;
        end
        if(a1020==1)
            ReflectanceB5S.values4=std_dev_reflectance_factor_C05;
        end
        if(a1030==1)
            OutPixelCountS.values6=outlier_pixel_count_C06;
        end
        if(a1040==1)
            ReflectanceB6S.values1=min_reflectance_factor_C06;
        end
        if(a1050==1)
            ReflectanceB6S.values2=max_reflectance_factor_C06;
        end
        if(a1060==1)
            ReflectanceB6S.values3=mean_reflectance_factor_C06;
        end
        if(a1070==1)
            ReflectanceB6S.values4=std_dev_reflectance_factor_C06;
        end
        if(a1080==1)
            OutPixelCountS.values7=outlier_pixel_count_C07;
        end
        if(a1090==1)
            ReflectanceB7S.values1=min_reflectance_factor_C07;
        end
        if(a1100==1)
            ReflectanceB7S.values2=max_reflectance_factor_C07;
        end
        if(a1110==1)
            ReflectanceB7S.values3=mean_reflectance_factor_C07;
        end
        if(a1120==1)
            ReflectanceB7S.values4=std_dev_reflectance_factor_C07;
        end
        if(a1130==1)
            BrightTempBand07S.values1=min_brightness_temperature_C07;
        end
        if(a1140==1)
            BrightTempBand07S.values2=max_brightness_temperature_C07;
        end
        if(a1150==1)
            BrightTempBand07S.values3=mean_brightness_temperature_C07;
        end
        if(a1160==1)
            BrightTempBand07S.values4=std_dev_brightness_temperature_C07 ;
        end
        if(a1170==1)
            OutPixelCountS.values8=outlier_pixel_count_C08;
        end
        if(a1180==1)
            BrightTempBand08S.values1=min_brightness_temperature_C08;
        end
        if(a1190==1)
            BrightTempBand08S.values2=max_brightness_temperature_C08;
        end
        if(a1200==1)
            BrightTempBand08S.values3=mean_brightness_temperature_C08;
        end
        if(a1210==1)
            BrightTempBand08S.values4=std_dev_brightness_temperature_C08;
        end
        if(a1220==1)
            OutPixelCountS.values9=outlier_pixel_count_C09;
        end
        if(a1230==1)
            BrightTempBand09S.values1=min_brightness_temperature_C09;
        end
        if(a1240==1)
            BrightTempBand09S.values2=max_brightness_temperature_C09;
        end
        if(a1250==1)
            BrightTempBand09S.values3=mean_brightness_temperature_C09;
        end
        if(a1260==1)
            BrightTempBand09S.values4=std_dev_brightness_temperature_C09;
        end
        if(a1270==1)
            OutPixelCountS.values10=outlier_pixel_count_C10;
        end
        if(a1280==1)
            BrightTempBand10S.values1=min_brightness_temperature_C10;
        end
        if(a1290==1)
            BrightTempBand10S.values2=max_brightness_temperature_C10;
        end
        if(a1300==1)
            BrightTempBand10S.values3=mean_brightness_temperature_C10;
        end
        if(a1310==1)
            BrightTempBand10S.values4=std_dev_brightness_temperature_C10;
        end
        if(a1320==1)
            OutPixelCountS.values11=outlier_pixel_count_C11;
        end
        if(a1330==1)
            BrightTempBand11S.values1=min_brightness_temperature_C11;
        end
        if(a1340==1)
            BrightTempBand11S.values2=max_brightness_temperature_C11;
        end
        if(a1350==1)
            BrightTempBand11S.values3=mean_brightness_temperature_C11;
        end
        if(a1360==1)
            BrightTempBand11S.values4=std_dev_brightness_temperature_C11;
        end
        if(a1370==1)
            OutPixelCountS.values12=outlier_pixel_count_C12;
        end
        if(a1380==1)
            BrightTempBand12S.values1=min_brightness_temperature_C12;
        end
        if(a1390==1)
            BrightTempBand12S.values2=max_brightness_temperature_C12;
        end
        if(a1400==1)
            BrightTempBand12S.values3=mean_brightness_temperature_C12;
        end
        if(a1410==1)
            BrightTempBand12S.values4=std_dev_brightness_temperature_C12;
        end
        if(a1420==1)
            OutPixelCountS.values13=outlier_pixel_count_C13;
        end
        if(a1430==1)
            BrightTempBand13S.values1=min_brightness_temperature_C13;
        end
        if(a1440==1)
            BrightTempBand13S.values2=max_brightness_temperature_C13;
        end
        if(a1450==1)
            BrightTempBand13S.values3=mean_brightness_temperature_C13;
        end
        if(a1460==1)
            BrightTempBand13S.values4=std_dev_brightness_temperature_C13;
        end
        if(a1470==1)
            OutPixelCountS.values14=outlier_pixel_count_C14;
        end
        if(a1480==1)
            BrightTempBand14S.values1=min_brightness_temperature_C14;
        end
        if(a1490==1)
            BrightTempBand14S.values2=max_brightness_temperature_C14;
        end
        if(a1500==1)
            BrightTempBand14S.values3=mean_brightness_temperature_C14;
        end
        if(a1510==1)
            BrightTempBand14S.values4=std_dev_brightness_temperature_C14;
        end
        if(a1520==1)
            OutPixelCountS.values15=outlier_pixel_count_C15;
        end
        if(a1530==1)
            BrightTempBand15S.values1=min_brightness_temperature_C15;
        end
        if(a1540==1)
            BrightTempBand15S.values2=max_brightness_temperature_C15;
        end
        if(a1550==1)
            BrightTempBand15S.values3=mean_brightness_temperature_C15;
        end
        if(a1560==1)
            BrightTempBand15S.values4=std_dev_brightness_temperature_C15;
        end
        if(a1570==1)
            OutPixelCountS.values16=outlier_pixel_count_C16;
        end
        if(a1580==1)
            BrightTempBand16S.values1=min_brightness_temperature_C16;
        end
        if(a1590==1)
            BrightTempBand16S.values2=max_brightness_temperature_C16;
        end
        if(a1600==1)
            BrightTempBand16S.values3=mean_brightness_temperature_C16;
        end
        if(a1610==1)
            BrightTempBand16S.values4=std_dev_brightness_temperature_C16;
        end
        if(a1620==1)
            GRB_ErrorS.values=percent_uncorrectable_GRB_errors;
        end
        if(a1630==1)
            L0_ErrorS.values=percent_uncorrectable_L0_errors;
        end
        if(a1640==1)
            Dynamic_Algo_ContainerS.values=dynamic_algorithm_input_data_container;
        end
        if(a1650==1)
            Algo_Product_ContainerS.values=algorithm_product_version_container;
        end


    end
end
if(idebug==1)
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp('________________________________________________________')
    disp(' '),disp(' ')
end
% Now write a Matlab file containing the decoded data
% use the original file name with a .mat extension
if(isavefiles==1)
    [iper]=strfind(GOESFileName,'.');
    is=1;
    ie=iper(1)-1;
    MatFileName=strcat(GOESFileName(is:ie),'.mat');
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='CMI_C01S DQF_C01S CMI_C02S DQF_C02S CMI_C03S DQF_C03S';
    varstr2=' CMI_C04S DQF_C04S CMI_C05S DQF_C05S CMI_C06S DQF_C06S';
    varstr3=' CMI_C07S DQF_C07S CMI_C08S DQF_C08S CMI_C09S DQF_C09S';
    varstr4=' CMI_C10S DQF_C10S CMI_C11S DQF_C11S CMI_C12S DQF_C12S';
    varstr5=' CMI_C13S DQF_C13S CMI_C14S DQF_C14S CMI_C15S DQF_C15S';
    varstr6=' CMI_C16S DQF_C16S tS yS xS tBS goesImagerS yImgS yImgBS';
    varstr7=' xImgS xImgBS SatDataS GeoSpatialS  MBandDataS MBandiDS OutPixelCountS';
    varstr8=' ReflectanceB1S ReflectanceB2S ReflectanceB3S ReflectanceB4S';
    varstr9=' ReflectanceB5S ReflectanceB6S ReflectanceB7S BrightTempBand07S';
    varstr10=' BrightTempBand08S BrightTempBand09S BrightTempBand10S';
    varstr11=' BrightTempBand11S BrightTempBand12S BrightTempBand13S';
    varstr12=' BrightTempBand14S BrightTempBand15S BrightTempBand16S';
    varstr13=' GRB_ErrorS L0_ErrorS Dynamic_Algo_ContainerS Algo_Product_ContainerS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7);
    varstr=strcat(varstr,varstr8,varstr9,varstr10,varstr11,varstr12,varstr13);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
end
netcdf.close(ncid);
userstr2='******Finished Processing CONUS Level MultiBand data*****';
fprintf(fid,'%s\n',userstr2);
% Now get to work making a 3 color image
[CMI] = Make3ColorImage(CMI_C02S,CMI_C03S,CMI_C01S);
CMI=CMI';
[numrows,numcols]=size(CMI);
fprintf(fid,'%s\n','Created 3 Color CMI data');
disp('Created 3 Color CMI data')
CMI1D=reshape(CMI,numrows*numcols,1);
CMI1DS=sort(CMI1D);
a1=isnan(CMI1DS);
numnan=sum(a1);
numpts=numrows*numcols-numnan;
meanCMI=mean(CMI1DS,'omitnan');
minCMI=min(CMI1DS);% 'omitnan' qualifier deleted because of long run times
maxCMI=max(CMI1DS);% 'omitnan' qualifier deleted because of long run times
numpts99=round(.99*numpts);
CMI99=CMI1DS(numpts99,1);
numpts95=round(.95*numpts);
CMI95=CMI1DS(numpts95,1);
imagestr1=strcat('CMI data had-',num2str(numrows),'-rows and-',num2str(numcols),...
    '-columns of data');
fprintf(fid,'%s\n',imagestr1);
imagestr2=strcat('CMI min=',num2str(minCMI),'-mean-',num2str(meanCMI),'-maxCMI-',...
    num2str(maxCMI),'-CMI99=',num2str(CMI99));
fprintf(fid,'%s\n',imagestr2);
disp(imagestr1);
disp(imagestr2);
% Get the image west and east edges
westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
southEdge=double(GeoSpatialS.geospatial_southbound_latitude);

GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=((northEdge-southEdge)/numrows);
GeoRef.CellExtentInLongitude=(abs((eastEdge-westEdge))/numcols);
LatInc=GeoRef.CellExtentInLatitude;
LonInc=GeoRef.CellExtentInLongitude;
% Check to the see if the image size is different than the raster size
[OutputImage] = ResizeImage(CMI,GeoRef);
LatCMI=zeros(GeoRef.RasterSize(1,1),GeoRef.RasterSize(1,2));
LonCMI=zeros(GeoRef.RasterSize(1,1),GeoRef.RasterSize(1,2));
nrows=GeoRef.RasterSize(1,1);
ncols=GeoRef.RasterSize(1,2);
for i=1:nrows
    for j=1:ncols
        LatCMI(i,j)=southEdge+LatInc*(i-1);
        LonCMI(i,j)=westEdge+LonInc*(j-1);
    end
end
% Display the Full Disk Mulitband CMI Data
[iunder]=strfind(GOESFileName,'_');
is=iunder(3)+1;
ie=iunder(4)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('TrueColor-FullDisk-',filename);
MapFormFactor='Full Disk';
DisplayCMIFullDiskData(OutputImage,titlestr)
titlestr=strcat('TrueColor-CMI-RGBCumilDist-',filename);
PlotRGBHistogram(CMI1DS,titlestr)
% Now plot the cumilative distribution
titlestr=strcat('TrueColor-CMI-RGBCumilDist-',filename);
PlotRGBCumilDist(CMI1DS,titlestr)
end