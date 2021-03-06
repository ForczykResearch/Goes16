% This script will take ABI-L1b files and distribute them to a desired set
% of folders. The downloaded files were optained from a Redstone download
% site
% Written By: Stephen Forczyk
% Created: April 1,2021
% Revised:------
% Classification: Unclassified

global FileList DataPaths PartialPaths FinalPaths;
global CalendarFileName;

global fid;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;

global holdpath matlabpath basepath finalpaths;

DataPaths=cell(17,8);
DataPaths{1,1}='Sensor';
DataPaths{1,2}='Process Level';
DataPaths{1,3}='CoreName';
DataPaths{1,4}='WaveBandName';
DataPaths{1,5}='Band';
DataPaths{1,6}='MapForm';
DataPaths{1,7}='Description';
DataPaths{1,8}='FinalFolder';
DataPaths{2,1}='ABI';
DataPaths{2,2}='L1b';
DataPaths{2,3}='ABI-L1b-RadF';
DataPaths{2,4}='M6C01';
DataPaths{2,5}='1';
DataPaths{2,6}='Full_Disk';
DataPaths{2,7}='\ABI_L1b_Radiance\Full_Disk\Band01';
DataPaths{3,1}='ABI';
DataPaths{3,2}='L1b';
DataPaths{3,3}='ABI-L1b-RadF';
DataPaths{3,4}='M6C02';
DataPaths{3,5}='2';
DataPaths{3,6}='Full_Disk';
DataPaths{3,7}='\ABI_L1b_Radiance\Full_Disk\Band02';
DataPaths{4,1}='ABI';
DataPaths{4,2}='L1b';
DataPaths{4,3}='ABI-L1b-RadF';
DataPaths{4,4}='M6C03';
DataPaths{4,5}='3';
DataPaths{4,6}='Full_Disk';
DataPaths{4,7}='\ABI_L1b_Radiance\Full_Disk\Band03';
DataPaths{5,1}='ABI';
DataPaths{5,2}='L1b';
DataPaths{5,3}='ABI-L1b-RadF';
DataPaths{5,4}='M6C04';
DataPaths{5,5}='4';
DataPaths{5,6}='Full_Disk';
DataPaths{5,7}='\ABI_L1b_Radiance\Full_Disk\Band04';
DataPaths{6,1}='ABI';
DataPaths{6,2}='L1b';
DataPaths{6,3}='ABI-L1b-RadF';
DataPaths{6,4}='M6C05';
DataPaths{6,5}='5';
DataPaths{6,6}='Full_Disk';
DataPaths{6,7}='\ABI_L1b_Radiance\Full_Disk\Band05';
DataPaths{7,1}='ABI';
DataPaths{7,2}='L1b';
DataPaths{7,3}='ABI-L1b-RadF';
DataPaths{7,4}='M6C06';
DataPaths{7,5}='6';
DataPaths{7,6}='Full_Disk';
DataPaths{7,7}='\ABI_L1b_Radiance\Full_Disk\Band06';
DataPaths{8,1}='ABI';
DataPaths{8,2}='L1b';
DataPaths{8,3}='ABI-L1b-RadF';
DataPaths{8,4}='M6C07';
DataPaths{8,5}='7';
DataPaths{8,6}='Full_Disk';
DataPaths{8,7}='\ABI_L1b_Radiance\Full_Disk\Band07';
DataPaths{9,1}='ABI';
DataPaths{9,2}='L1b';
DataPaths{9,3}='ABI-L1b-RadF';
DataPaths{9,4}='M6C08';
DataPaths{9,5}='8';
DataPaths{9,6}='Full_Disk';
DataPaths{9,7}='\ABI_L1b_Radiance\Full_Disk\Band08';
DataPaths{10,1}='ABI';
DataPaths{10,2}='L1b';
DataPaths{10,3}='ABI-L1b-RadF';
DataPaths{10,4}='M6C09';
DataPaths{10,5}='9';
DataPaths{10,6}='Full_Disk';
DataPaths{10,7}='\ABI_L1b_Radiance\Full_Disk\Band09';
DataPaths{11,1}='ABI';
DataPaths{11,2}='L1b';
DataPaths{11,3}='ABI-L1b-RadF';
DataPaths{11,4}='M6C10';
DataPaths{11,5}='10';
DataPaths{11,6}='Full_Disk';
DataPaths{11,7}='\ABI_L1b_Radiance\Full_Disk\Band10';
DataPaths{12,1}='ABI';
DataPaths{12,2}='L1b';
DataPaths{12,3}='ABI-L1b-RadF';
DataPaths{12,4}='M6C11';
DataPaths{12,5}='11';
DataPaths{12,6}='Full_Disk';
DataPaths{12,7}='\ABI_L1b_Radiance\Full_Disk\Band11';
DataPaths{13,1}='ABI';
DataPaths{13,2}='L1b';
DataPaths{13,3}='ABI-L1b-RadF';
DataPaths{13,4}='M6C12';
DataPaths{13,5}='12';
DataPaths{13,6}='Full_Disk';
DataPaths{13,7}='\ABI_L1b_Radiance\Full_Disk\Band12';
DataPaths{14,1}='ABI';
DataPaths{14,2}='L1b';
DataPaths{14,3}='ABI-L1b-RadF';
DataPaths{14,4}='M6C13';
DataPaths{14,5}='13';
DataPaths{14,6}='Full_Disk';
DataPaths{14,7}='\ABI_L1b_Radiance\Full_Disk\Band13';
DataPaths{15,1}='ABI';
DataPaths{15,2}='L1b';
DataPaths{15,3}='ABI-L1b-RadF';
DataPaths{15,4}='M6C14';
DataPaths{15,5}='14';
DataPaths{15,6}='Full_Disk';
DataPaths{15,7}='\ABI_L1b_Radiance\Full_Disk\Band14';
DataPaths{16,1}='ABI';
DataPaths{16,2}='L1b';
DataPaths{16,3}='ABI-L1b-RadF';
DataPaths{16,4}='M6C15';
DataPaths{16,5}='15';
DataPaths{16,6}='Full_Disk';
DataPaths{16,7}='\ABI_L1b_Radiance\Full_Disk\Band15';
DataPaths{17,1}='ABI';
DataPaths{17,2}='L1b';
DataPaths{17,3}='ABI-L1b-RadF';
DataPaths{17,4}='M6C16';
DataPaths{17,5}='16';
DataPaths{17,6}='Full_Disk';
DataPaths{17,7}='\ABI_L1b_Radiance\Full_Disk\Band16';
DataPaths{18,1}='ABI';
DataPaths{18,2}='L1b';
DataPaths{18,3}='ABI-L1b-RadC';
DataPaths{18,4}='M6C01';
DataPaths{18,5}='1';
DataPaths{18,6}='Conus';
DataPaths{18,7}='\ABI_L1b_Radiance\Conus\Band01';
DataPaths{19,1}='ABI';
DataPaths{19,2}='L1b';
DataPaths{19,3}='ABI-L1b-RadC';
DataPaths{19,4}='M6C02';
DataPaths{19,5}='2';
DataPaths{19,6}='Conus';
DataPaths{19,7}='\ABI_L1b_Radiance\Conus\Band02';
DataPaths{20,1}='ABI';
DataPaths{20,2}='L1b';
DataPaths{20,3}='ABI-L1b-RadC';
DataPaths{20,4}='M6C03';
DataPaths{20,5}='3';
DataPaths{20,6}='Conus';
DataPaths{20,7}='\ABI_L1b_Radiance\Conus\Band03';
DataPaths{21,1}='ABI';
DataPaths{21,2}='L1b';
DataPaths{21,3}='ABI-L1b-RadC';
DataPaths{21,4}='M6C04';
DataPaths{21,5}='4';
DataPaths{21,6}='Conus';
DataPaths{21,7}='\ABI_L1b_Radiance\Conus\Band04';
DataPaths{22,1}='ABI';
DataPaths{22,2}='L1b';
DataPaths{22,3}='ABI-L1b-RadC';
DataPaths{22,4}='M6C05';
DataPaths{22,5}='5';
DataPaths{22,6}='Conus';
DataPaths{22,7}='\ABI_L1b_Radiance\Conus\Band05';
DataPaths{23,1}='ABI';
DataPaths{23,2}='L1b';
DataPaths{23,3}='ABI-L1b-RadC';
DataPaths{23,4}='M6C06';
DataPaths{23,5}='6';
DataPaths{23,6}='Conus';
DataPaths{23,7}='\ABI_L1b_Radiance\Conus\Band06';
DataPaths{24,1}='ABI';
DataPaths{24,2}='L1b';
DataPaths{24,3}='ABI-L1b-RadC';
DataPaths{24,4}='M6C07';
DataPaths{24,5}='7';
DataPaths{24,6}='Conus';
DataPaths{24,7}='\ABI_L1b_Radiance\Conus\Band07';
DataPaths{25,1}='ABI';
DataPaths{25,2}='L1b';
DataPaths{25,3}='ABI-L1b-RadC';
DataPaths{25,4}='M6C08';
DataPaths{25,5}='8';
DataPaths{25,6}='Conus';
DataPaths{25,7}='\ABI_L1b_Radiance\Conus\Band08';
DataPaths{26,1}='ABI';
DataPaths{26,2}='L1b';
DataPaths{26,3}='ABI-L1b-RadC';
DataPaths{26,4}='M6C09';
DataPaths{26,5}='9';
DataPaths{26,6}='Conus';
DataPaths{26,7}='\ABI_L1b_Radiance\Conus\Band09';
DataPaths{27,1}='ABI';
DataPaths{27,2}='L1b';
DataPaths{27,3}='ABI-L1b-RadC';
DataPaths{27,4}='M6C10';
DataPaths{27,5}='10';
DataPaths{27,6}='Conus';
DataPaths{27,7}='\ABI_L1b_Radiance\Conus\Band10';
DataPaths{28,1}='ABI';
DataPaths{28,2}='L1b';
DataPaths{28,3}='ABI-L1b-RadC';
DataPaths{28,4}='M6C11';
DataPaths{28,5}='11';
DataPaths{28,6}='Conus';
DataPaths{28,7}='\ABI_L1b_Radiance\Conus\Band11';
DataPaths{29,1}='ABI';
DataPaths{29,2}='L1b';
DataPaths{29,3}='ABI-L1b-RadC';
DataPaths{29,4}='M6C12';
DataPaths{29,5}='12';
DataPaths{29,6}='Conus';
DataPaths{29,7}='\ABI_L1b_Radiance\Conus\Band12';
DataPaths{30,1}='ABI';
DataPaths{30,2}='L1b';
DataPaths{30,3}='ABI-L1b-RadC';
DataPaths{30,4}='M6C13';
DataPaths{30,5}='13';
DataPaths{30,6}='Conus';
DataPaths{30,7}='\ABI_L1b_Radiance\Conus\Band13';
DataPaths{31,1}='ABI';
DataPaths{31,2}='L1b';
DataPaths{31,3}='ABI-L1b-RadC';
DataPaths{31,4}='M6C14';
DataPaths{31,5}='14';
DataPaths{31,6}='Conus';
DataPaths{31,7}='\ABI_L1b_Radiance\Conus\Band14';
DataPaths{32,1}='ABI';
DataPaths{32,2}='L1b';
DataPaths{32,3}='ABI-L1b-RadC';
DataPaths{32,4}='M6C14';
DataPaths{32,5}='15';
DataPaths{32,6}='Conus';
DataPaths{32,7}='\ABI_L1b_Radiance\Conus\Band15';
DataPaths{33,1}='ABI';
DataPaths{33,2}='L1b';
DataPaths{33,3}='ABI-L1b-RadC';
DataPaths{33,4}='M6C16';
DataPaths{33,5}='16';
DataPaths{33,6}='Conus';
DataPaths{33,7}='\ABI_L1b_Radiance\Conus\Band16';
DataPaths{34,1}='ABI';
DataPaths{34,2}='L1b';
DataPaths{34,3}='ABI-L1b-RadM1';
DataPaths{34,4}='M6C01';
DataPaths{34,5}='1';
DataPaths{34,6}='Meso1';
DataPaths{34,7}='\ABI_L1b_Radiance\Meso1\Band01';
DataPaths{35,1}='ABI';
DataPaths{35,2}='L1b';
DataPaths{35,3}='ABI-L1b-RadM1';
DataPaths{35,4}='M6C02';
DataPaths{35,5}='2';
DataPaths{35,6}='Meso1';
DataPaths{35,7}='\ABI_L1b_Radiance\Meso1\Band02';
DataPaths{36,1}='ABI';
DataPaths{36,2}='L1b';
DataPaths{36,3}='ABI-L1b-RadM1';
DataPaths{36,4}='M6C03';
DataPaths{36,5}='3';
DataPaths{36,6}='Meso1';
DataPaths{36,7}='\ABI_L1b_Radiance\Meso1\Band03';
DataPaths{37,1}='ABI';
DataPaths{37,2}='L1b';
DataPaths{37,3}='ABI-L1b-RadM1';
DataPaths{37,4}='M6C04';
DataPaths{37,5}='4';
DataPaths{37,6}='Meso1';
DataPaths{37,7}='\ABI_L1b_Radiance\Meso1\Band04';
DataPaths{38,1}='ABI';
DataPaths{38,2}='L1b';
DataPaths{38,3}='ABI-L1b-RadM1';
DataPaths{38,4}='M6C05';
DataPaths{38,5}='5';
DataPaths{38,6}='Meso1';
DataPaths{38,7}='\ABI_L1b_Radiance\Meso1\Band05';
DataPaths{39,1}='ABI';
DataPaths{39,2}='L1b';
DataPaths{39,3}='ABI-L1b-RadM1';
DataPaths{39,4}='M6C06';
DataPaths{39,5}='6';
DataPaths{39,6}='Meso1';
DataPaths{39,7}='\ABI_L1b_Radiance\Meso1\Band06';
DataPaths{40,1}='ABI';
DataPaths{40,2}='L1b';
DataPaths{40,3}='ABI-L1b-RadM1';
DataPaths{40,4}='M6C07';
DataPaths{40,5}='7';
DataPaths{40,6}='Meso1';
DataPaths{40,7}='\ABI_L1b_Radiance\Meso1\Band07';
DataPaths{41,1}='ABI';
DataPaths{41,2}='L1b';
DataPaths{41,3}='ABI-L1b-RadM1';
DataPaths{41,4}='M6C08';
DataPaths{41,5}='8';
DataPaths{41,6}='Meso1';
DataPaths{41,7}='\ABI_L1b_Radiance\Meso1\Band08';
DataPaths{42,1}='ABI';
DataPaths{42,2}='L1b';
DataPaths{42,3}='ABI-L1b-RadM1';
DataPaths{42,4}='M6C09';
DataPaths{42,5}='9';
DataPaths{42,6}='Meso1';
DataPaths{42,7}='\ABI_L1b_Radiance\Meso1\Band09';
DataPaths{43,1}='ABI';
DataPaths{43,2}='L1b';
DataPaths{43,3}='ABI-L1b-RadM1';
DataPaths{43,4}='M6C10';
DataPaths{43,5}='10';
DataPaths{43,6}='Meso1';
DataPaths{43,7}='\ABI_L1b_Radiance\Meso1\Band10';
DataPaths{44,1}='ABI';
DataPaths{44,2}='L1b';
DataPaths{44,3}='ABI-L1b-RadM1';
DataPaths{44,4}='M6C11';
DataPaths{44,5}='11';
DataPaths{44,6}='Meso1';
DataPaths{44,7}='\ABI_L1b_Radiance\Meso1\Band11';
DataPaths{45,1}='ABI';
DataPaths{45,2}='L1b';
DataPaths{45,3}='ABI-L1b-RadM1';
DataPaths{45,4}='M6C12';
DataPaths{45,5}='12';
DataPaths{45,6}='Meso1';
DataPaths{45,7}='\ABI_L1b_Radiance\Meso1\Band12';
DataPaths{46,1}='ABI';
DataPaths{46,2}='L1b';
DataPaths{46,3}='ABI-L1b-RadM1';
DataPaths{46,4}='M6C13';
DataPaths{46,5}='13';
DataPaths{46,6}='Meso1';
DataPaths{46,7}='\ABI_L1b_Radiance\Meso1\Band13';
DataPaths{47,1}='ABI';
DataPaths{47,2}='L1b';
DataPaths{47,3}='ABI-L1b-RadM1';
DataPaths{47,4}='M6C14';
DataPaths{47,5}='14';
DataPaths{47,6}='Meso1';
DataPaths{47,7}='\ABI_L1b_Radiance\Meso1\Band14';
DataPaths{48,1}='ABI';
DataPaths{48,2}='L1b';
DataPaths{48,3}='ABI-L1b-RadM1';
DataPaths{48,4}='M6C14';
DataPaths{48,5}='15';
DataPaths{48,6}='Meso1';
DataPaths{48,7}='\ABI_L1b_Radiance\Meso1\Band15';
DataPaths{49,1}='ABI';
DataPaths{49,2}='L1b';
DataPaths{49,3}='ABI-L1b-RadM1';
DataPaths{49,4}='M6C16';
DataPaths{49,5}='16';
DataPaths{49,6}='Meso1';
DataPaths{49,7}='\ABI_L1b_Radiance\Meso1\Band16';
DataPaths{50,1}='ABI';
DataPaths{50,2}='L1b';
DataPaths{50,3}='ABI-L1b-RadM2';
DataPaths{50,4}='M6C01';
DataPaths{50,5}='1';
DataPaths{50,6}='Meso2';
DataPaths{50,7}='\ABI_L1b_Radiance\Meso2\Band01';
DataPaths{51,1}='ABI';
DataPaths{51,2}='L1b';
DataPaths{51,3}='ABI-L1b-RadM2';
DataPaths{51,4}='M6C02';
DataPaths{51,5}='2';
DataPaths{51,6}='Meso2';
DataPaths{51,7}='\ABI_L1b_Radiance\Meso2\Band02';
DataPaths{52,1}='ABI';
DataPaths{52,2}='L1b';
DataPaths{52,3}='ABI-L1b-RadM2';
DataPaths{52,4}='M6C03';
DataPaths{52,5}='3';
DataPaths{52,6}='Meso2';
DataPaths{52,7}='\ABI_L1b_Radiance\Meso2\Band03';
DataPaths{53,1}='ABI';
DataPaths{53,2}='L1b';
DataPaths{53,3}='ABI-L1b-RadM2';
DataPaths{53,4}='M6C04';
DataPaths{53,5}='4';
DataPaths{53,6}='Meso2';
DataPaths{53,7}='\ABI_L1b_Radiance\Meso2\Band04';
DataPaths{54,1}='ABI';
DataPaths{54,2}='L1b';
DataPaths{54,3}='ABI-L1b-RadM2';
DataPaths{54,4}='M6C05';
DataPaths{54,5}='5';
DataPaths{54,6}='Meso2';
DataPaths{54,7}='\ABI_L1b_Radiance\Meso2\Band05';
DataPaths{55,1}='ABI';
DataPaths{55,2}='L1b';
DataPaths{55,3}='ABI-L1b-RadM2';
DataPaths{55,4}='M6C06';
DataPaths{55,5}='6';
DataPaths{55,6}='Meso2';
DataPaths{55,7}='\ABI_L1b_Radiance\Meso2\Band06';
DataPaths{56,1}='ABI';
DataPaths{56,2}='L1b';
DataPaths{56,3}='ABI-L1b-RadM2';
DataPaths{56,4}='M6C07';
DataPaths{56,5}='7';
DataPaths{56,6}='Meso2';
DataPaths{56,7}='\ABI_L1b_Radiance\Meso2\Band07';
DataPaths{57,1}='ABI';
DataPaths{57,2}='L1b';
DataPaths{57,3}='ABI-L1b-RadM2';
DataPaths{57,4}='M6C08';
DataPaths{57,5}='8';
DataPaths{57,6}='Meso2';
DataPaths{57,7}='\ABI_L1b_Radiance\Meso2\Band08';
DataPaths{58,1}='ABI';
DataPaths{58,2}='L1b';
DataPaths{58,3}='ABI-L1b-RadM2';
DataPaths{58,4}='M6C09';
DataPaths{58,5}='9';
DataPaths{58,6}='Meso2';
DataPaths{58,7}='\ABI_L1b_Radiance\Meso2\Band09';
DataPaths{59,1}='ABI';
DataPaths{59,2}='L1b';
DataPaths{59,3}='ABI-L1b-RadM2';
DataPaths{59,4}='M6C10';
DataPaths{59,5}='10';
DataPaths{59,6}='Meso2';
DataPaths{59,7}='\ABI_L1b_Radiance\Meso2\Band10';
DataPaths{60,1}='ABI';
DataPaths{60,2}='L1b';
DataPaths{60,3}='ABI-L1b-RadM2';
DataPaths{60,4}='M6C11';
DataPaths{60,5}='11';
DataPaths{60,6}='Meso2';
DataPaths{60,7}='\ABI_L1b_Radiance\Meso2\Band11';
DataPaths{61,1}='ABI';
DataPaths{61,2}='L1b';
DataPaths{61,3}='ABI-L1b-RadM2';
DataPaths{61,4}='M6C12';
DataPaths{61,5}='12';
DataPaths{61,6}='Meso2';
DataPaths{61,7}='\ABI_L1b_Radiance\Meso2\Band12';
DataPaths{62,1}='ABI';
DataPaths{62,2}='L1b';
DataPaths{62,3}='ABI-L1b-RadM2';
DataPaths{62,4}='M6C13';
DataPaths{62,5}='13';
DataPaths{62,6}='Meso2';
DataPaths{62,7}='\ABI_L1b_Radiance\Meso2\Band13';
DataPaths{63,1}='ABI';
DataPaths{63,2}='L1b';
DataPaths{63,3}='ABI-L1b-RadM2';
DataPaths{63,4}='M6C14';
DataPaths{63,5}='14';
DataPaths{63,6}='Meso2';
DataPaths{63,7}='\ABI_L1b_Radiance\Meso2\Band14';
DataPaths{64,1}='ABI';
DataPaths{64,2}='L1b';
DataPaths{64,3}='ABI-L1b-RadM2';
DataPaths{64,4}='M6C14';
DataPaths{64,5}='15';
DataPaths{64,6}='Meso2';
DataPaths{64,7}='\ABI_L1b_Radiance\Meso2\Band15';
DataPaths{65,1}='ABI';
DataPaths{65,2}='L1b';
DataPaths{65,3}='ABI-L1b-RadM2';
DataPaths{65,4}='M6C16';
DataPaths{65,5}='16';
DataPaths{65,6}='Meso2';
DataPaths{65,7}='\ABI_L1b_Radiance\Meso2\Band16';
CalendarFileName='CalendarDays.mat';
numpaths=length(DataPaths)-1;
PartialPaths=cell(numpaths,1);
FinalPaths=cell(numpaths,1);
for n=2:numpaths+1
    k=n-1;
    PartialPaths{k,1}=DataPaths{n,7};   
end
holdpath='F:\Redstone\Goes16\ABI_L2\';
matlabpath='D:\Goes16\Matlab_Data\';
basepath='F:\Redstone\Goes16\Imagery';
eval(['cd ' matlabpath(1:length(matlabpath)-1)]);
load(CalendarFileName);
eval(['cd ' holdpath(1:length(holdpath)-1)]);
suffix='.nc';
outputFlag=1;
[ FileList ] = getfilelist(holdpath, suffix, outputFlag );
numfiles=length(FileList);
% Now get the date of these files
% Start by loading the Calender
eval(['cd ' matlabpath(1:length(matlabpath)-1)]);
load(CalendarFileName);
% Get the scan end date and time data based on the file name
x=FileList{1,1};
[filepath,GFileName,ext]=fileparts(FileList{1,1});
GOESFileName=strcat(GFileName,ext);
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
[idash]=strfind(MonthDayYearStr,'-');
numdash=length(idash);
numchar=length(MonthDayYearStr);
is=1;
ie=idash(1)-1;
if(ie>3)
    ie=3;
end
MonS=MonthDayYearStr(is:ie);
is=idash(1)+1;
ie=idash(2)-1;
DaySS=MonthDayYearStr(is:ie);
is=ie+2;
ie=numchar;
YearSS=MonthDayYearStr(is:ie);
datepath=strcat('\',MonS,DaySS,'_',YearSS);
% Now build All possible paths needed to store this data
FinalPaths=cell(numpaths,1);
igood=0;
ibad=0;
for n=1:numpaths
    nowPartial=PartialPaths{n,1};
    nowFinal=strcat(basepath,datepath,DataPaths{n+1,7});
    FinalPaths{n,1}=nowFinal;
    DataPaths{1+n,8}=nowFinal;
    A1=exist(nowFinal,'dir');
    if(A1~=7)
        [status, msg, msgID] = mkdir(nowFinal);
        if(status==1)
            dispstr=strcat('Made Folder-',nowFinal);
            disp(dispstr)
            igood=igood+1;
            DataPaths{1+n,8}=nowFinal;
        else
            dispstr=strcat('Did Not make Folder-',nowFinal);
            disp(dispstr)
            ibad=ibad+1;
        end
    else
        dispstr=strcat('Folder-',nowFinal,'----already exists---');
        disp(dispstr)
        igood=igood+1;
    end
    
end
ab=1;
% Now all the needed paths exist-time to copy each file to the desired
% folder
igoodcopy=0;
ibadcopy=0;
for n=1:numfiles
    nowFile=FileList{n,1};
    [filepath,GFileName,ext]=fileparts(FileList{n,1});
    GOESFileName=strcat(GFileName,ext);
    [iunder]=strfind(GOESFileName,'_');
    numunder=length(iunder);
    [idash]=strfind(GOESFileName,'-');
    numdash=length(idash);
    [m6]=strfind(GOESFileName,'-M6');
    numm6=length(m6);
% Get the channel or band number if it exists
    if(numm6==1)
        is=m6+1;
        ie=iunder(2)-1;
        bandstr=GOESFileName(is:ie);
        bandlen=length(bandstr);
        band=0;
        if(bandlen==5)
            bandstr1=bandstr(4:5);
            band=str2num(bandstr1);     
        end
    end
    ab=1;
% Look for a match of the CoreName
     for j=1:numpaths
         nowCoreName=char(DataPaths{1+j,3});
         nowWaveBand=char(DataPaths{1+j,4});
         a1=strfind(GOESFileName,nowCoreName);
         a2=isempty(a1);
         a3=strcmp(nowWaveBand,bandstr);
         if((a2==0)&& (a3==1))
             ab=3;
             correctPath=char(DataPaths{1+j,8});
             destfile=strcat(correctPath,'\',GOESFileName);
             sourcefile=nowFile;
             [status,msg,msgID] = copyfile(sourcefile,destfile);
             if(status==1)
                 dispstr=strcat('Correctly Copied File-',destfile);
                 disp(dispstr)
                 igoodcopy=igoodcopy+1;
             else
                 dispstr=strcat('Failed To Copy File-',destfile);
                 disp(dispstr)
                 ibadcopy=ibadcopy+1;
             end
         end
     end
    
end