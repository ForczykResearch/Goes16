function ReadSUVI_L1b_He303()
% This function will read in the GOES SUVI_L1B_He303
% data which is taken by the Solar Ultraviolet Imager at the He303 waveband
% which corresponds to 195.1 Angstroms
% Written By: Stephen Forczyk
% Created: May 15,2021
% Revised: 
% Classification: Unclassified

global BandDataS MetaDataS;
global RADS DQFS;
global IMSENUMBS CRPIX1S CRPIX2S CDELT1S CDELT2S;
global CUNIT1S CUNIT2S DSUNS ORIENTS CROTAS;
global SOLAR_B0S PC1_1S PC1_2S PC2_1S PC2_2S;
global CSYER1S CSYER2S WCS_NAMES CTYPE1S CTYPE2S;
global CRVAL1S CRVAL2S LONPOLES TIMESYSS;
global DATE_OBSS DATE_ENDS CMD_EXPS EXPTIMES;
global OBSGEO_XS OBSGEO_YS OBSGEO_ZS DSUN_OBSS;
global OBJECTS SCI_OBJS WAVEUNITS WAVELNTHS;
global IMG_MINS IMG_MAXS FILTER1S FILTER2S;
global GOOD_PIXS FIX_PIXS SAT_PIXS MISS_PIXS;
global IMGTIIS IMG_SDEVS EFF_AREAS APSELPOSS INSTRESPS;
global PHOT_ENGS RSUNS HGLT_OBSS HGLN_OBSS;
global HEEX_OBSS HEEY_OBSS HEEZ_OBSS;
global FILTPOS1S FILTPOS2S YAW_FLIPS CCD_READS ECLIPSES;
global CONTAMINS CONT_FLGS DATE_BKES DER_SNRS SAT_THRS;
global CCD_BIASS CCD_TMP1S CCD_TMP2S;
global DATE_DFMS NDFRAMESS DATE_DF0S DATE_DF1S DATE_DF2S;
global DATE_DF3S DATE_DF4S DATE_DF5S DATE_DF6S;
global DATE_DF7S DATE_DF8S DATE_DF9S;
global SOLCURR1S SOLCURR2S SOLCURR3S SOLCURR4S PCTL0ERRS;
global GoesWaveBand MapFormFactor GOESFileName Algo2S;
global idebug;
%additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;
global fid isavefiles;

fprintf(fid,'\n');
fprintf(fid,'%s\n','**************Start reading SUVI-L1b-H3-303 Solar Radiation data***************');

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
RADS=struct('values',[],'long_name',[],'sensor_bit_depth',[],'FillValue',[],...
    'valid_range',[],'units',[],'scale_factor',[],'add_offset',[]);

DQFS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'flag_values',[],'flag_meanings',[],...
    'FITS_flag_values',[]);
IMSENUMBS=struct('values',[],'long_name',[],'comment',[],'FillValue',[],...
    'valid_range',[],'units',[]);
CRPIX1S=IMSENUMBS;
CRPIX2S=IMSENUMBS;
CDELT1S=IMSENUMBS;
CDELT2S=IMSENUMBS;
DSUNS=IMSENUMBS;
CROTAS=IMSENUMBS;
SOLAR_B0S=IMSENUMBS;
PC1_1S=IMSENUMBS;
PC1_2S=IMSENUMBS;
PC2_1S=IMSENUMBS;
PC2_2S=IMSENUMBS;
CSYER1S=IMSENUMBS;
CSYER2S=IMSENUMBS;
CRVAL1S=IMSENUMBS;
CRVAL2S=IMSENUMBS;
LONPOLES=IMSENUMBS;
CMD_EXPS=IMSENUMBS;
EXPTIMES=IMSENUMBS;
OBSGEO_XS=IMSENUMBS;
OBSGEO_YS=IMSENUMBS;
OBSGEO_ZS=IMSENUMBS;
DSUN_OBSS=IMSENUMBS;
WAVELNTHS=IMSENUMBS;
IMG_MINS=IMSENUMBS;
IMG_MAXS=IMSENUMBS;
EFF_AREAS=IMSENUMBS;
NDFRAMESS=IMSENUMBS;
SOLCURR1S=IMSENUMBS;
SOLCURR2S=IMSENUMBS;
SOLCURR3S=IMSENUMBS;
SOLCURR4S=IMSENUMBS;
PCTL0ERRS=IMSENUMBS;
DATE_OBSS=struct('values',[],'long_name',[],'comment',[],'FillValue',[],...
    'units',[],'DString',[]);
DATE_ENDS=DATE_OBSS;
DATE_DFMS=DATE_OBSS;
DATE_BKES=DATE_OBSS;
DATE_DF0S=DATE_OBSS;
DATE_DF1S=DATE_OBSS;
DATE_DF2S=DATE_OBSS;
DATE_DF3S=DATE_OBSS;
DATE_DF4S=DATE_OBSS;
DATE_DF5S=DATE_OBSS;
DATE_DF6S=DATE_OBSS;
DATE_DF7S=DATE_OBSS;
DATE_DF8S=DATE_OBSS;
DATE_DF9S=DATE_OBSS;
ORIENTS=struct('values',[],'long_name',[],'comment',[]);
CUNIT1S=ORIENTS;
CUNIT2S=ORIENTS;
WCS_NAMES=ORIENTS;
TIMESYSS=ORIENTS;
OBJECTS=ORIENTS;
SCI_OBJS=ORIENTS;
WAVEUNITS=ORIENTS;
FILTER1S=ORIENTS;
FILTER2S=ORIENTS;
GOOD_PIXS=struct('values',[],'long_name',[],'comment',[],'FillValue',[],'units',[]);
FIX_PIXS=GOOD_PIXS;
SAT_PIXS=GOOD_PIXS;
MISS_PIXS=GOOD_PIXS;
IMGTIIS=GOOD_PIXS;
IMG_SDEVS=GOOD_PIXS;

APSELPOSS=struct('values',[],'long_name',[],'comment',[],'FillValue',[],...
    'valid_range',[],'units',[],'flag_values',[],'flag_meanings',[]);
FILTPOS1S=APSELPOSS;
FILTPOS2S=APSELPOSS;
YAW_FLIPS=APSELPOSS;
CCD_READS=APSELPOSS;
ECLIPSES=APSELPOSS;
CONT_FLGS=APSELPOSS;
INSTRESPS=struct('values',[],'long_name',[],'comment',[],'FillValue',[],...
    'valid_range',[],'units',[]);
PHOT_ENGS=INSTRESPS;
RSUNS=INSTRESPS;
HGLT_OBSS=RSUNS;
HGLN_OBSS=RSUNS;
HEEX_OBSS=RSUNS;
HEEY_OBSS=RSUNS;
HEEZ_OBSS=RSUNS;
CONTAMINS=RSUNS;
DER_SNRS=RSUNS;
SAT_THRS=RSUNS;
CCD_BIASS=RSUNS;
CCD_TMP1S=RSUNS;
CCD_TMP2S=RSUNS;
BandDataS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);

%AlgoProductTS=struct('values',[],'long_name',[],'algorithm_version',[],'product_version',[]);

Algo2S=struct('values',[],'long_name',[],...
    'input_SUVI_L0_data',[]);
%Get information about the contents of the file.
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
        a10=strcmp(varname,'RAD');
        a20=strcmp(varname,'DQF');
        a30=strcmp(varname,'IMSENUMB');
        a40=strcmp(varname,'CRPIX1');
        a50=strcmp(varname,'CRPIX2');
        a60=strcmp(varname,'CDELT1');
        a70=strcmp(varname,'CDELT2');
        a80=strcmp(varname,'CUNIT1');
        a90=strcmp(varname,'CUNIT2');
        a100=strcmp(varname,'DIAM_SUN');
        a110=strcmp(varname,'ORIENT');
        a120=strcmp(varname,'CROTA');
        a130=strcmp(varname,'SOLAR_B0');
        a140=strcmp(varname,'PC1_1');
        a150=strcmp(varname,'PC1_2');
        a210=strcmp(varname,'algorithm_dynamic_input_data_container');
        a220=strcmp(varname,'PC2_1');
        a230=strcmp(varname,'PC2_2');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'CSYER1');
        a280=strcmp(varname,'CSYER2');
        a290=strcmp(varname,'WCSNAME');
        a330=strcmp(varname,'CTYPE1');
        a340=strcmp(varname,'CTYPE2');
        a350=strcmp(varname,'CRVAL1');
        a360=strcmp(varname,'CRVAL2');
        a370=strcmp(varname,'LONPOLE');
        a380=strcmp(varname,'TIMESYS');
        a390=strcmp(varname,'DATE-OBS');
        a400=strcmp(varname,'DATE-END');
        a410=strcmp(varname,'CMD_EXP');
        a420=strcmp(varname,'EXPTIME');
        a430=strcmp(varname,'OBSGEO-X');
        a440=strcmp(varname,'OBSGEO-Y');
        a450=strcmp(varname,'OBSGEO-Z');
        a460=strcmp(varname,'DSUN_OBS');
        a470=strcmp(varname,'OBJECT');
        a480=strcmp(varname,'SCI_OBJ');
        a490=strcmp(varname,'WAVEUNIT');
        a500=strcmp(varname,'WAVELNTH');
        a510=strcmp(varname,'IMG_MIN');
        a520=strcmp(varname,'IMG_MAX');
        a530=strcmp(varname,'FILTER1');
        a540=strcmp(varname,'FILTER2');
        a550=strcmp(varname,'GOOD_PIX');
        a560=strcmp(varname,'FIX_PIX');
        a570=strcmp(varname,'SAT_PIX');
        a580=strcmp(varname,'MISS_PIX');
        a590=strcmp(varname,'IMGTII');
        a600=strcmp(varname,'IMG_SDEV');
        a610=strcmp(varname,'EFF_AREA');
        a620=strcmp(varname,'APSELPOS');
        a630=strcmp(varname,'INSTRESP');
        a640=strcmp(varname,'PHOT_ENG');
        a650=strcmp(varname,'RSUN');
        a660=strcmp(varname,'HGLT_OBS');
        a670=strcmp(varname,'HGLN_OBS');
        a680=strcmp(varname,'HEEX_OBS');
        a690=strcmp(varname,'HEEY_OBS');
        a700=strcmp(varname,'HEEZ_OBS');
        a710=strcmp(varname,'FILTPOS1');
        a720=strcmp(varname,'FILTPOS2');
        a730=strcmp(varname,'YAW_FLIP');
        a740=strcmp(varname,'CCD_READ');
        a750=strcmp(varname,'ECLIPSE');
        a760=strcmp(varname,'CONTAMIN');
        a770=strcmp(varname,'CONT_FLG');
        a780=strcmp(varname,'DATE-BKE');
        a790=strcmp(varname,'DER_SNR');
        a800=strcmp(varname,'SAT_THR');
        a810=strcmp(varname,'CCD_BIAS');
        a820=strcmp(varname,'CCD_TMP1');
        a830=strcmp(varname,'CCD_TMP2');
        a840=strcmp(varname,'DATE-DFM');
        a850=strcmp(varname,'NDFRAMES');
        a860=strcmp(varname,'DATE-DF0');
        a870=strcmp(varname,'DATE-DF1');
        a880=strcmp(varname,'DATE-DF2');
        a890=strcmp(varname,'DATE-DF3');
        a900=strcmp(varname,'DATE-DF4');
        a910=strcmp(varname,'DATE-DF5');
        a920=strcmp(varname,'DATE-DF6');
        a930=strcmp(varname,'DATE-DF7');
        a940=strcmp(varname,'DATE-DF8');
        a950=strcmp(varname,'DATE-DF9');
        a960=strcmp(varname,'SOLCURR1');
        a970=strcmp(varname,'SOLCURR2');
        a980=strcmp(varname,'SOLCURR3');
        a990=strcmp(varname,'SOLCURR4');
        a1000=strcmp(varname,'PCTL0ERR');
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
                RADS.long_name=attname2;
            end
            a1=strcmp(attname1,'sensor_bit_depth');
            if(a1==1)
                RADS.sensor_bit_depth=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RADS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RADS.units=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RADS.valid_range=attname2;
            end

            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                RADS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                RADS.add_offset=attname2;
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
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQFS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQFS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'FITS_flag_values');
            if(a1==1)
                DQFS.FITS_flag_values=attname2;
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
                IMSENUMBS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                IMSENUMBS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                IMSENUMBS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               IMSENUMBS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                IMSENUMBS.valid_range=attname2;
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
            a1=strcmp(attname1,'units');
            if(a1==1)
                CRPIX1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CRPIX1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CRPIX1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CRPIX1S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CRPIX1S.valid_range=attname2;
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
            a1=strcmp(attname1,'units');
            if(a1==1)
                CRPIX2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CRPIX2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CRPIX2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CRPIX2S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CRPIX2S.valid_range=attname2;
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
            a1=strcmp(attname1,'units');
            if(a1==1)
                CDELT1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CDELT1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CDELT1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CDELT1S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CDELT1S.valid_range=attname2;
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
            a1=strcmp(attname1,'units');
            if(a1==1)
                CDELT2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CDELT2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CDELT2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CDELT2S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CDELT2S.valid_range=attname2;
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
            a1=strcmp(attname1,'units');
            if(a1==1)
                CUNIT1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CUNIT1S.comment=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CUNIT1S.long_name=attname2;
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
            a1=strcmp(attname1,'units');
            if(a1==1)
                CUNIT2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CUNIT2S.comment=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CUNIT2S.long_name=attname2;
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
            a1=strcmp(attname1,'units');
            if(a1==1)
                DSUNS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                DSUNS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DSUNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DSUNS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               DSUNS.valid_range=attname2;
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
                ORIENTS.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                ORIENTS.comment=attname2;
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
            a1=strcmp(attname1,'units');
            if(a1==1)
                CROTAS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CROTAS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CROTAS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CROTAS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CROTAS.valid_range=attname2;
            end
        elseif (a130==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SOLAR_B0S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                SOLAR_B0S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               SOLAR_B0S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               SOLAR_B0S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               SOLAR_B0S.valid_range=attname2;
            end
        elseif (a140==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PC1_1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                PC1_1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               PC1_1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               PC1_1S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               PC1_1S.valid_range=attname2;
            end
        elseif (a150==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PC1_2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                PC1_2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               PC1_2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               PC1_2S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               PC1_2S.valid_range=attname2;
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
            a1=strcmp(attname1,'input_SUVI_L0_data');
            if(a1==1)
                Algo2S.input_SUVI_L0_data=attname2;
            end

        elseif (a220==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PC2_1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                PC2_1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               PC2_1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               PC2_1S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               PC2_1S.valid_range=attname2;
            end
        elseif (a230==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PC2_2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                PC2_2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               PC2_2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               PC2_2S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               PC2_2S.valid_range=attname2;
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
        elseif (a270==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CSYER1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CSYER1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CSYER1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CSYER1S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CSYER1S.valid_range=attname2;
            end
        elseif (a280==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CSYER2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CSYER2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CSYER2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CSYER2S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CSYER2S.valid_range=attname2;
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
                WCS_NAMES.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                 WCS_NAMES.comment=attname2;
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
                CTYPE1S.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                 CTYPE1S.comment=attname2;
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
                CTYPE2S.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                 CTYPE2S.comment=attname2;
            end
         elseif (a350==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CRVAL1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                CRVAL1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CRVAL1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CRVAL1S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CRVAL1S.valid_range=attname2;
            end
         elseif (a360==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CRVAL2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               CRVAL2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CRVAL2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CRVAL2S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CRVAL2S.valid_range=attname2;
            end
         elseif (a370==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LONPOLES.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               LONPOLES.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               LONPOLES.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               LONPOLES.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               LONPOLES.valid_range=attname2;
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
                TIMESYSS.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                 TIMESYSS.comment=attname2;
            end
         elseif (a390==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_OBSS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_OBSS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_OBSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_OBSS.long_name=attname2;
            end
%             a1=strcmp(attname1,'valid_range');
%             if(a1==1)
%                DATE_OBSS.valid_range=attname2;
%             end
         elseif (a400==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_ENDS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_ENDS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_ENDS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_ENDS.long_name=attname2;
            end
%             a1=strcmp(attname1,'valid_range');
%             if(a1==1)
%                DATE_ENDS.valid_range=attname2;
%             end
         elseif (a410==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               CMD_EXPS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               CMD_EXPS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CMD_EXPS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CMD_EXPS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CMD_EXPS.valid_range=attname2;
            end
         elseif (a420==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               EXPTIMES.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               EXPTIMES.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               EXPTIMES.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               EXPTIMES.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               EXPTIMES.valid_range=attname2;
            end
            
         elseif (a430==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               OBSGEO_XS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               OBSGEO_XS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               OBSGEO_XS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               OBSGEO_XS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               OBSGEO_XS.valid_range=attname2;
            end
         elseif (a440==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               OBSGEO_YS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               OBSGEO_YS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               OBSGEO_YS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               OBSGEO_YS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               OBSGEO_YS.valid_range=attname2;
            end            
         elseif (a450==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               OBSGEO_ZS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               OBSGEO_ZS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               OBSGEO_ZS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               OBSGEO_ZS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               OBSGEO_ZS.valid_range=attname2;
            end                 
        elseif (a460==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               DSUN_OBSS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DSUN_OBSS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DSUN_OBSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DSUN_OBSS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               DSUN_OBSS.valid_range=attname2;
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
                OBJECTS.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                OBJECTS.comment=attname2;
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
                SCI_OBJS.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                SCI_OBJS.comment=attname2;
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
                WAVEUNITS.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                WAVEUNITS.comment=attname2;
            end
         elseif (a500==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               WAVELNTHS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               WAVELNTHS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               WAVELNTHS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               WAVELNTHS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               WAVELNTHS.valid_range=attname2;
            end      
         elseif (a510==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               IMG_MINS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               IMG_MINS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               IMG_MINS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               IMG_MINS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               IMG_MINS.valid_range=attname2;
            end      
         elseif (a520==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               IMG_MAXS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               IMG_MAXS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               IMG_MAXS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               IMG_MAXS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               IMG_MAXS.valid_range=attname2;
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
                FILTER1S.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                FILTER1S.comment=attname2;
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
                FILTER2S.long_name=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
                FILTER2S.comment=attname2;
            end
         elseif (a550==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               GOOD_PIXS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               GOOD_PIXS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               GOOD_PIXS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               GOOD_PIXS.long_name=attname2;
            end   
         elseif (a560==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               FIX_PIXS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               FIX_PIXS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               FIX_PIXS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               FIX_PIXS.long_name=attname2;
            end 
         elseif (a570==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               SAT_PIXS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               SAT_PIXS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               SAT_PIXS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               SAT_PIXS.long_name=attname2;
            end
         elseif (a580==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               MISS_PIXS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               MISS_PIXS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               MISS_PIXS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               MISS_PIXS.long_name=attname2;
            end 
         elseif (a590==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               IMGTIIS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               IMGTIIS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               IMGTIIS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               IMGTIIS.long_name=attname2;
            end 
         elseif (a600==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               IMG_SDEVS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               IMG_SDEVS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               IMG_SDEVS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               IMG_SDEVS.long_name=attname2;
            end 
         elseif (a610==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               EFF_AREAS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               EFF_AREAS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               EFF_AREAS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               EFF_AREAS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               EFF_AREAS.valid_range=attname2;
            end  
         elseif (a620==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               APSELPOSS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               APSELPOSS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               APSELPOSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               APSELPOSS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               APSELPOSS.valid_range=attname2;
            end 
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
               APSELPOSS.flag_values=attname2;
            end 
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
               APSELPOSS.flag_meanings=attname2;
            end 
         elseif (a630==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               INSTRESPS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               INSTRESPS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               INSTRESPS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               INSTRESPS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               INSTRESPS.valid_range=attname2;
            end 
          elseif (a640==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               PHOT_ENGS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               PHOT_ENGS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               PHOT_ENGS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               PHOT_ENGS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               PHOT_ENGS.valid_range=attname2;
            end 
          elseif (a650==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               RSUNS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               RSUNS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               RSUNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               RSUNS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               RSUNS.valid_range=attname2;
            end 
          elseif (a660==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               HGLT_OBSS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               HGLT_OBSS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               HGLT_OBSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               HGLT_OBSS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               HGLT_OBSS.valid_range=attname2;
            end 
          elseif (a670==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               HGLN_OBSS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               HGLN_OBSS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               HGLN_OBSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               HGLN_OBSS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               HGLN_OBSS.valid_range=attname2;
            end 
          elseif (a680==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               HEEX_OBSS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               HEEX_OBSS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               HEEX_OBSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               HEEX_OBSS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               HEEX_OBSS.valid_range=attname2;
            end 
          elseif (a690==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               HEEY_OBSS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               HEEY_OBSS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               HEEY_OBSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               HEEY_OBSS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               HEEY_OBSS.valid_range=attname2;
            end 
          elseif (a700==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               HEEZ_OBSS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               HEEZ_OBSS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               HEEZ_OBSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               HEEZ_OBSS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               HEEZ_OBSS.valid_range=attname2;
            end 
         elseif (a710==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               FILTPOS1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               FILTPOS1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               FILTPOS1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               FILTPOS1S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               FILTPOS1S.valid_range=attname2;
            end 
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
               FILTPOS1S.flag_values=attname2;
            end 
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
               FILTPOS1S.flag_meanings=attname2;
            end 
         elseif (a720==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               FILTPOS2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               FILTPOS2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               FILTPOS2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               FILTPOS2S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               FILTPOS2S.valid_range=attname2;
            end 
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
               FILTPOS2S.flag_values=attname2;
            end 
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
               FILTPOS2S.flag_meanings=attname2;
            end 
         elseif (a730==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               YAW_FLIPS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               YAW_FLIPS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               YAW_FLIPS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               YAW_FLIPS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               YAW_FLIPS.valid_range=attname2;
            end 
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
               YAW_FLIPS.flag_values=attname2;
            end 
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
               YAW_FLIPS.flag_meanings=attname2;
            end 
         elseif (a740==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               CCD_READS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               CCD_READS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CCD_READS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CCD_READS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CCD_READS.valid_range=attname2;
            end 
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
               CCD_READS.flag_values=attname2;
            end 
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
               CCD_READS.flag_meanings=attname2;
            end 
         elseif (a750==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               ECLIPSES.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               ECLIPSES.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               ECLIPSES.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               ECLIPSES.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               ECLIPSES.valid_range=attname2;
            end 
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
               ECLIPSES.flag_values=attname2;
            end 
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
               ECLIPSES.flag_meanings=attname2;
            end 
          elseif (a760==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               CONTAMINS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               CONTAMINS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CONTAMINS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CONTAMINS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CONTAMINS.valid_range=attname2;
            end 
         elseif (a770==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               CONT_FLGS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               CONT_FLGS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CONT_FLGS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CONT_FLGS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CONT_FLGS.valid_range=attname2;
            end 
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
               CONT_FLGS.flag_values=attname2;
            end 
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
               CONT_FLGS.flag_meanings=attname2;
            end
         elseif (a780==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               DATE_BKES.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_BKES.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_BKES.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_BKES.long_name=attname2;
            end 
          elseif (a790==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               DER_SNRS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DER_SNRS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DER_SNRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DER_SNRS.long_name=attname2;
            end 
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               DER_SNRS.valid_range=attname2;
            end
          elseif (a800==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               SAT_THRS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               SAT_THRS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               SAT_THRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               SAT_THRS.long_name=attname2;
            end 
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               SAT_THRS.valid_range=attname2;
            end 
          elseif (a810==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               CCD_BIASS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               CCD_BIASS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CCD_BIASS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CCD_BIASS.long_name=attname2;
            end 
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CCD_BIASS.valid_range=attname2;
            end 
          elseif (a820==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               CCD_TMP1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               CCD_TMP1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CCD_TMP1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CCD_TMP1S.long_name=attname2;
            end 
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CCD_TMP1S.valid_range=attname2;
            end 
          elseif (a830==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               CCD_TMP2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               CCD_TMP2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               CCD_TMP2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               CCD_TMP2S.long_name=attname2;
            end 
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               CCD_TMP2S.valid_range=attname2;
            end 
         elseif (a840==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DFMS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DFMS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DFMS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DFMS.long_name=attname2;
            end
         elseif (a850==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               NDFRAMESS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               NDFRAMESS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               NDFRAMESS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               NDFRAMESS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               NDFRAMESS.valid_range=attname2;
            end  
         elseif (a860==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF0S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF0S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF0S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF0S.long_name=attname2;
            end
         elseif (a870==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF1S.long_name=attname2;
            end
         elseif (a880==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF2S.long_name=attname2;
            end
         elseif (a890==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF3S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF3S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF3S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF3S.long_name=attname2;
            end
          elseif (a900==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF4S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF4S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF4S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF4S.long_name=attname2;
            end
          elseif (a910==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF5S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF5S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF5S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF5S.long_name=attname2;
            end
          elseif (a920==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF6S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF6S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF6S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF6S.long_name=attname2;
            end
          elseif (a930==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF7S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF7S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF7S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF7S.long_name=attname2;
            end
          elseif (a940==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF8S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF8S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF8S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF8S.long_name=attname2;
            end
         elseif (a950==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DATE_DF9S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               DATE_DF9S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               DATE_DF9S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               DATE_DF9S.long_name=attname2;
            end
         elseif (a960==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               SOLCURR1S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               SOLCURR1S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               SOLCURR1S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               SOLCURR1S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               SOLCURR1S.valid_range=attname2;
            end 
         elseif (a970==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               SOLCURR2S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               SOLCURR2S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               SOLCURR2S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               SOLCURR2S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               SOLCURR2S.valid_range=attname2;
            end 
          elseif (a980==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               SOLCURR3S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               SOLCURR3S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               SOLCURR3S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               SOLCURR3S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               SOLCURR3S.valid_range=attname2;
            end 
          elseif (a990==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               SOLCURR4S.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               SOLCURR4S.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               SOLCURR4S.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               SOLCURR4S.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               SOLCURR4S.valid_range=attname2;
            end 
        
          elseif (a1000==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
               PCTL0ERRS.units=attname2;
            end
            a1=strcmp(attname1,'comment');
            if(a1==1)
               PCTL0ERRS.comment=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
               PCTL0ERRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
               PCTL0ERRS.long_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
               PCTL0ERRS.valid_range=attname2;
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
            FillValue=RADS.FillValue;
            RADV=RAD;
           [RADV2,numnanvals] = ReplaceFillValues(RADV,FillValue);
           [nrows,ncols]=size(RADV);
           level=(2^15)-1;
           numneg1=0;
           numbig1=0;
           for ik=1:nrows
               for jk=1:ncols
                  value=RADV2(ik,jk);
                  if(value<0)
                       RADV2(ik,jk)=value*scale+offset;
                       numneg1=numneg1+1;
                  elseif(value>0)
                      numbig1=numbig1+1;
                      RADV2(ik,jk)=value*scale+offset;
                  end
               end
           end
           RADV2=RADV2';
           RADS.values=double(RADV2); 
           clear RSRV2;
        end


    else
        TF = contains(varname,'-');% This statement was added to deal with variable names 
                                   % that are not legal for matlab
        if(TF~=1)
            eval([varname '= double(netcdf.getVar(ncid,i));']) 
        else
            TVal=1;
        end
        if(a20==1)
            DQFS.values=DQF;
        end
        if(a30==1)
            IMSENUMBS.values=IMSENUMB;
        end
        if(a40==1)
            CRPIX1S.values=CRPIX1;
        end
        if(a50==1)
            CRPIX2S.values=CRPIX2;
        end
        if(a60==1)
            CDELT1S.values=CDELT1;
        end
        if(a70==1)
            CDELT2S.values=CDELT2;
        end
        if(a80==1)
            txt=char(CUNIT1');
            CUNIT1S.values=txt;
        end        
        if(a90==1)
            txt=char(CUNIT2');
            CUNIT2S.values=txt;
        end
        if(a100==1)
            DSUNS.values=DIAM_SUN;
        end
        if(a110==1)
            tx=char(ORIENT');
            ORIENTS.values=tx;
        end
        if(a120==1)
            CROTAS.values=CROTA;
        end
        if(a130==1)
            SOLAR_B0S.values=SOLAR_B0;
        end
        if(a140==1)
            PC1_1S.values=PC1_1;
        end
        if(a150==1)
            PC1_2S.values=PC1_2;
        end
        if(a210==1)
            Algo2S.values=algorithm_dynamic_input_data_container;
        end
        if(a220==1)
            PC2_1S.values=PC2_1;
        end
        if(a230==1)
            PC2_2S.values=PC2_2;
        end
        if(a250==1)
            ProcessParamTS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProductTS.values=algorithm_product_version_container;
        end
        if(a270==1)
            CSYER1S.values=CSYER1;
        end
        if(a280==1)
            CSYER2S.values=CSYER2;
        end
        if(a290==1)
            ans1=WCSNAME';
            WCS_NAMES.values=char(ans1);
        end
        if(a330==1)
            ans1=CTYPE1';
            CTYPE1S.values=char(ans1);
        end
        if(a340==1)
            ans1=CTYPE2';
            CTYPE2S.values=char(ans1);
        end
        if(a350==1)
            CRVAL1S.values=CRVAL1;
        end
        if(a360==1)
            CRVAL2S.values=CRVAL2;
        end
        if(a370==1)
            LONPOLES.values=LONPOLE;
        end
        if(a380==1)
            ans1=TIMESYS';
            TIMESYSS.values=char(ans1);
        end
        if(a390==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                TempVal2=TempVal/86400;
                DATE_OBSS.values=TempVal;
            else
                DATE_OBSS.values=varname;
            end
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_OBSS.DString=date1;
        end
        if(a400==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                TempVal2=TempVal/86400;
                DATE_ENDS.values=TempVal;
            else
                DATE_ENDS.values=varname;  
            end
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_ENDS.DString=date1;
        end
        if(a410==1)
            CMD_EXPS.values=CMD_EXP;
        end
        if(a420==1)
            EXPTIMES.values=EXPTIME;
        end
        if(a430==1)
            if(TF==1)
                TVal=netcdf.getVar(ncid,i);
                OBSGEO_XS.values=TVal;
            else
                OBSGEO_XS.values=varname;
            end
        end
        if(a440==1)
            if(TF==1)
                TVal=netcdf.getVar(ncid,i);
                OBSGEO_YS.values=TVal;
            else
                OBSGEO_YS.values=varname;
            end
        end
        if(a450==1)
            if(TF==1)
                TVal=netcdf.getVar(ncid,i);
                OBSGEO_ZS.values=TVal;
            else
                OBSGEO_ZS.values=varname;
            end            
        end
        if(a460==1)
            DSUN_OBSS.values=DSUN_OBS;
        end
        if(a470==1)
            ans1=OBJECT';
            OBJECTS.values=char(ans1);
        end
        if(a480==1)
            ans1=SCI_OBJ';
            SCI_OBJS.values=char(ans1);
        end
        if(a490==1)
            ans1=WAVEUNIT';
            WAVEUNITS.values=char(ans1);       
        end
        if(a500==1)
            WAVELNTHS.values=WAVELNTH;
        end
        if(a510==1)
            IMG_MINS.values=IMG_MIN;
        end
        if(a520==1)
            IMG_MAXS.values=IMG_MAX;
        end
        if(a530==1)
            ans1=FILTER1';
            FILTER1S.values=char(ans1);  
        end
        if(a540==1)
            ans1=FILTER2';
            FILTER2S.values=char(ans1); 
        end
        if(a550==1)
            GOOD_PIXS.values=GOOD_PIX;
        end
        if(a560==1)
            FIX_PIXS.values=FIX_PIX;
        end
        if(a570==1)
            SAT_PIXS.values=SAT_PIX;
        end
        if(a580==1)
            MISS_PIXS.values=MISS_PIX;
        end
        if(a590==1)
            IMGTIIS.values=IMGTII;
        end
        if(a600==1)
            IMG_SDEVS.values=IMG_SDEV;
        end
        if(a610==1)
            EFF_AREAS.values=EFF_AREA;
        end
        if(a620==1)
            APSELPOSS.values=APSELPOS;
        end
        if(a630==1)
            INSTRESPS.values=INSTRESP;
        end
        if(a640==1)
            PHOT_ENGS.values=PHOT_ENG;
        end
        if(a650==1)
            RSUNS.values=RSUN;
        end
        if(a660==1)
            HGLT_OBSS.values=HGLT_OBS;
        end
        if(a670==1)
            HGLN_OBSS.values=HGLN_OBS;
        end
        if(a680==1)
            HEEX_OBSS.values=HEEX_OBS;
        end
        if(a690==1)
            HEEY_OBSS.values=HEEY_OBS;
        end
        if(a700==1)
            HEEZ_OBSS.values=HEEZ_OBS;
        end
        if(a710==1)
            FILTPOS1S.values=FILTPOS1;
        end
        if(a720==1)
            FILTPOS2S.values=FILTPOS2;
        end
        if(a730==1)
            YAW_FLIPS.values=YAW_FLIP;
        end
        if(a740==1)
            CCD_READS.values=CCD_READ;
        end
        if(a750==1)
            ECLIPSES.values=ECLIPSE;
        end
        if(a760==1)
            CONTAMINS.values=CONTAMIN;
        end
        if(a770==1)
            CONT_FLGS.values=CONT_FLG;
        end
        if(a780==1)
            TempVal=netcdf.getVar(ncid,i);
            TempVal2=TempVal/86400;
            DATE_BKES.values=TVal;
            if(TempVal>0)
                base=datenum(2000,1,1.5);
                date1=datestr(TempVal2 + base);
                DATE_BKES.DString=date1;
            else
                DATE_BKES.DString='No Valid Date'; 
            end
        end
        if(a790==1)
            DER_SNRS.values=DER_SNR;
        end
        if(a800==1)
            SAT_THRS.values=SAT_THR;
        end
        if(a810==1)
            CCD_BIASS.values=CCD_BIAS;
        end
        if(a820==1)
            CCD_TMP1S.values=CCD_TMP1;
        end
        if(a830==1)
            CCD_TMP2S.values=CCD_TMP2;
        end
        if(a840==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                TempVal2=TempVal/86400;
                DATE_DFMS.values=TempVal;
            else
                DATE_DFMS.values=varname;
            end
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DFMS.DString=date1;
        end
        if(a850==1)
            NDFRAMESS.values=NDFRAMES;
        end
        if(a860==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                TempVal2=TempVal/86400;
                DATE_DF0S.values=TempVal;
            else
                DATE_DF0S.values=varname;
            end
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF0S.DString=date1;
        end
        if(a870==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                TempVal2=TempVal/86400;
                DATE_DF1S.values=TempVal;
            else
                DATE_DF1S.values=varname;
            end
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF1S.DString=date1;
        end
        if(a880==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                DATE_DF2S.values=TempVal;
            else
                DATE_DF2S.values=varname;
            end
            TempVal2=TempVal/86400;
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF2S.DString=date1;
        end
        if(a890==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                DATE_DF3S.values=TempVal;
            else
                DATE_DF3S.values=varname;
            end
            TempVal2=TempVal/86400;
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF3S.DString=date1;
        end
        if(a900==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                DATE_DF4S.values=TempVal;
            else
                DATE_DF4S.values=varname;
            end
            TempVal2=TempVal/86400;
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF4S.DString=date1;
        end
        if(a910==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                DATE_DF5S.values=TempVal;
            else
                DATE_DF5S.values=varname;
            end
            TempVal2=TempVal/86400;
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF5S.DString=date1;
        end
        if(a920==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                DATE_DF6S.values=TempVal;
            else
                DATE_DF6S.values=varname;
            end
            TempVal2=TempVal/86400;
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF6S.DString=date1;
        end
        if(a930==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                DATE_DF7S.values=TempVal;
            else
                DATE_DF7S.values=varname;
            end
            TempVal2=TempVal/86400;
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF7S.DString=date1;
        end
        if(a940==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                DATE_DF8S.values=TempVal;
            else
                DATE_DF8S.values=varname;
            end
            TempVal2=TempVal/86400;
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF8S.DString=date1;
        end
        if(a950==1)
            if(TF==1)
                TempVal=netcdf.getVar(ncid,i);
                DATE_DF9S.values=TempVal;
            else
                DATE_DF9S.values=varname;
            end
            TempVal2=TempVal/86400;
            base=datenum(2000,1,1.5);
            date1=datestr(TempVal2 + base);
            DATE_DF9S.DString=date1;
        end
        if(a960==1)
            SOLCURR1S.values=SOLCURR1;
        end
        if(a970==1)
            SOLCURR2S.values=SOLCURR2;
        end
        if(a980==1)
            SOLCURR3S.values=SOLCURR3;
        end
        if(a990==1)
            SOLCURR4S.values=SOLCURR4;
        end
        if(a1000==1)
            PCTL0ERRS.values=PCTL0ERR;
        end
    end
end
if(idebug==1)
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp('________________________________________________________')
    disp(' '),disp(' ')
end
netcdf.close(ncid);
fprintf(fid,'%s\n','Finished SUVI-L1b-He303 Data');
% Now write a Matlab file containing the decoded data
% use the original file name with a .mat extension
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='RADS DQFS IMSENUMBS CRPIX1S CRPIX2S';
    varstr2=' GoesWaveBand GOESFileName MapFormFactor';
    varstr3=' Algo2S CDELT1S CDELT2S SOLAR_B0S PC1_1S PC1_2S PC2_1S PC2_2S';
    varstr4=' CSYER1S CSYER2S WCS_NAMES CTYPE1S CTYPE2S';
    varstr5=' CRVAL1S CRVAL2S LONPOLES TIMESYSS';
    varstr6=' DATE_OBSS DATE_ENDS CMD_EXPS EXPTIMES';
    varstr7=' OBSGEO_XS OBSGEO_YS OBSGEO_ZS DSUN_OBSS';
    varstr8=' OBJECTS SCI_OBJS WAVEUNITS WAVELNTHS';
    varstr9=' IMG_MINS IMG_MAXS FILTER1S FILTER2S';
    varstr10=' GOOD_PIXS FIX_PIXS SAT_PIXS MISS_PIXS';
    varstr11=' IMGTIIS IMG_SDEVS EFF_AREAS APSELPOSS INSTRESPS';
    varstr12=' PHOT_ENGS RSUNS HGLT_OBSS HGLN_OBSS';
    varstr13=' HEEX_OBSS HEEY_OBSS HEEZ_OBSS';
    varstr14=' FILTPOS1S FILTPOS2S YAW_FLIPS CCD_READS ECLIPSES';
    varstr15=' CONTAMINS CONT_FLGS DATE_BKES DER_SNRS SAT_THRS';
    varstr16=' CCD_BIASS CCD_TMP1S CCD_TMP2S DATE_DFMS NDFRAMESS DATE_DF0S DATE_DF1S DATE_DF2S';
    varstr17=' DATE_DF3S DATE_DF4S DATE_DF5S DATE_DF6S DATE_DF7S DATE_DF8S DATE_DF9S';
    varstr18=' SOLCURR1S SOLCURR2S SOLCURR3S SOLCURR4S PCTL0ERRS Algo2S';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7,varstr8,varstr9,varstr10);
    varstr=strcat(varstr,varstr11,varstr12,varstr13,varstr14,varstr15,varstr16,varstr17,varstr18);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
else
    dispstr=strcat('Did Not Save Matlab File-',MatFileName);
    disp(dispstr);
end
%Get some stats on the RADS Data
RADValues=RADS.values;
[nrows,ncols]=size(RADValues);
RADValues1D=reshape(RADValues,nrows*ncols,1);
minRADValue=min(RADValues1D);
maxRADValue=max(RADValues1D);
a1=isnan(RADValues1D);
numnans=sum(a1);
numtotpix=nrows*ncols;
fracNaN=numnans/numtotpix;
goodfrac=1-fracNaN;

statstr1=strcat('Min RAD Value=',num2str(minRADValue),'-Max Value=',num2str(maxRADValue));
fprintf(fid,'%s\n',statstr1);
statstr2=strcat('Frac Of Pixels Returning Valid RAD=',num2str(goodfrac,6),'-Frac That are NaN=',num2str(fracNaN,6));
fprintf(fid,'%s\n',statstr2);
%Display RAD as an image-this is for the SUVI_L1b_He303 wavelength
[imatch]=strfind(GOESFileName,'_e');
is=1;
ie=imatch(1)-1;
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('RAD-Solar-',filename);
iband=6;
DisplaySUVIRadData(titlestr,iband)
titlestr=strcat('SUVI-RAD-',filename);
[RAD1DSF]=PlotSUVIRadHistogram(titlestr,iband);
titlestr=strcat('SUVIRadCumilDist-',filename);
PlotSUVIRadCumilDist(RAD1DSF,titlestr,iband)


end

