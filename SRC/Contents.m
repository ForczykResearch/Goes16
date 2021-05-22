% CODE
%
% Files
%   AddRecordFireSummaryFile               - This will add a record to the fire SummaryFile
%   AnalyzeReadGoes16Datasets              - This routine will get a quick analysis of the program source code
%   atmos                                  - Find gas properties in the 1976 Standard Atmosphere.
%   CalculateGeodCoordFromXYPos            - This function is intended to calculate the Geodetic Coordinates of the XY
%   CalculateGeodCoordFromXYPosRev1        - This function is intended to calculate the Geodetic Coordinates of the XY
%   ClipImageValues                        - This function will clip a GOES16/17 image to values between lowval and
%   colornames                             - Convert between RGB values and color names: from RGB to names, and names to RGB.
%   CreateAerosolDataAlgoDesc              - This function will create a report section that will desribe
%   CreateAshParticleSizePieChart          - This function will show the calculated ash particle sizes
%   CreateDayTable                         - This script will create a day to month-day table
%   CreateDayTableSpare                    - This script will create a day to month-day table
%   CreateDQF_CloudTopTemps_PieChart       - This function will show selected DQF struct for cloud top temps
%   CreateDQF_LVM_PieChart                 - This function will show selected DQF_Overall values for the LVM Metric
%   CreateDQF_LVT_PieChart                 - This function will show selected DQF_Overall values for the LVT Metric
%   CreateDQF_StabilityIndex_PieChart      - This function will show the causes of invalid pixels in
%   CreateDQF_TPW_PieChart                 - This function will show selected DQF_Overall values for the TPW Metric
%   CreateDQFPieChart                      - This function will show selecte DQF that cause pixel rejections
%   CreateFireCatalog                      - This executive script is to read a folder full of fire hot spot data
%   CreateFireSummaryFile                  - Create A Fire SummaryFile to hold previous fire detections
%   CreateMountainShapefile                - Create a New shapeFile for just mounts
%   CreatePDFReportHeader                  - This function will create the initial "boilerplate" header info
%   CreatePDFReportHeaderRev3              - This function will create the initial "boilerplate" header info
%   CreateRainfallRateDQFPieChart          - This function will show selecte DQF that cause pixel rejections for the
%   CS_read_netCDF                         - %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   CustomTOC                              - 
%   densityalt                             - Returns altitude corresponding to the given array of air densities
%   DisplayABIL2CountyFireData             - Display various types of fire data for the ABI-L2-FireData set
%   DisplayABIL2DetailedFireData           - Display various types of fire data for the ABI-L2-FireData set
%   DisplayABIL2FireData                   - Display various types of fire data for the ABI-L2-FireData set
%   DisplayABIL2StateFireData              - Display various types of fire data for the ABI-L2-FireData set
%   DisplayABIL2SuperDetailedFireData      - Display various types of fire data for the ABI-L2-FireData set
%   DisplayAerosolMask                     - Display the aerosol mask from the GOES16/17 data
%   DisplayClearSkyMask                    - Display the clear sky mask from the GOES16/17 data
%   DisplayCloudTopHeights                 - Display the cloud top heights from the GOES16/17 data
%   DisplayCloudTopHeightsRev3             - Display the cloud top heights from the GOES16/17 data
%   DisplayCloudTopPhaseData               - Display the Refelected ShortWave Radiation (RSR) values
%   DisplayCloudTopPressureRev3            - Display the cloud top pressure from the GOES16/17 data
%   DisplayCloudTopTemps                   - Display the cloud top temperatures from the GOES16/17 data
%   DisplayCloudTopTempsRev1               - Display the cloud top temperatures from the GOES16/17 data
%   DisplayCMIConusData                    - Display the CMI Moisture Data from the GOES16/17 data
%   DisplayCMIConusDataRev2                - Display the CMI Moisture Data from the GOES16/17 data
%   DisplayCMIData                         - Display the CMI Moisture Data from the GOES16/17 data
%   DisplayCMIDataRev2                     - Display the CMI Moisture Data from the GOES16 data
%   DisplayCMIFullDiskData                 - Display the CMI Moisture Data from the GOES16/17 data
%   DisplayCMIMesoDataRev2                 - Display the CMI Moisture Data from the GOES16/17 data
%   DisplayCompositeAerosolMask            - Display the a composite aerosol mask. This composite
%   DisplayCONUS_LVM                       - Display the Legacy Vertical Moisture Profile (LVM) data on a CONUS Grid
%   DisplayCONUS_LVT                       - Display the Legacy Vertical Temperature Profile (LVT) data on a CONUS Grid
%   DisplayCONUS_TPW                       - Display the Total Precipitable Water (TPW) data on a CONUS Grid
%   DisplayCONUS_TPW_DQF                   - Display the Total Precipitable Water (TPW) DQF Factors on a grid
%   DisplayConusAerosolOpticalDepth        - Display the Aerosol Optical Depth data on a CONUS Grid
%   DisplayConusAerosolOpticalDepthDQF     - Display the Aerosol Optical Depth DQF data on a CONUS Grid
%   DisplayConusCAPEStabilityIndex         - Display the CAPE Index Stability Data on a CONUS Grid
%   DisplayConusCompositeStability         - Display a composite measure of the 5 stability indices on a CONUS map
%   DisplayConusDSR                        - Display the Downwards Short Wave Radiation on CONUS scale
%   DisplayConusKIStabilityIndex           - Display the K Index (KI) Stability Data on a CONUS Grid
%   DisplayConusLightningData              - Display the CMI Moisture Data from the GOES16/17 data
%   DisplayConusLIStabilityIndex           - Display the Lift Index (LI) Stability Data on a CONUS Grid
%   DisplayCONUSOpticalDepth               - Display the Optical Cloud Depth on a CONUS Grid
%   DisplayCONUSOpticalParticleSizes       - Display the Optical Cloud Particle Sizes on a CONUS Grid
%   DisplayConusSIStabilityIndex           - Display the Showalter Index Stability Data on a CONUS Grid
%   DisplayConusTTStabilityIndex           - Display the Total Total Index Stability Data on a CONUS Grid
%   DisplayDetailed3DFireHotSpots          - Display fire hot spo locations on top of a DEM map on a 1 x 1 deg 
%   DisplayDetailed3DFireHotSpotsRev1      - Display fire hot spo locations on top of a DEM map on a 1 x 1 deg 
%   DisplayDuskMask                        - Display the dusk mask from the GOES16/17 data
%   DisplayDustMask                        - Display the dust mask from the GOES16/17 data
%   DisplayLandSurfaceTemps                - Display the Land Surface Temps from the GOES16/17 data
%   DisplayLightningConusData              - Display the CMI Moisture Data from the GOES16/17 data
%   DisplayRadianceData                    - Display the Radiance Data from the GOES16/17 data
%   DisplayRadianceDataRev2                - Display the Radiance Data from the GOES16/17 data
%   DisplayRainFallRate                    - Display the RainFall Rate on a Full Disk Grid
%   DisplayRSRData                         - Display the Refelected ShortWave Radiation (RSR) values
%   DisplaySeaSurfaceTemps                 - Display the Sea Surface Temps from the GOES16/17 data
%   DisplaySmokeMask                       - Display the smoke mask from the GOES16/17 data
%   DisplaySUVIRadData                     - Display the SUVI (RAD) values
%   DisplayVolcanicAshHeightFullDiskData   - Display the Volcanic Ash Height Data from the GOES16/17 data
%   DisplayVolcanicMassLoadingFullDiskData - Display the Volcanic Ash MASS lOADING Data from the GOES16/17 data
%   DisplayVolcanicMassLoadingHiQualFD     - Display the Volcanic Ash MASS lOADING Data from the GOES16/17 data
%   DistributeDownloadedGOESFiles          - This script will take ABI-L1b files and distribute them to a desired set
%   DownloadGoesDataFromRedstone           - Test download from HTTP-Rev2 is designed to use a select case
%   FindLatTemps                           - This function will find the mean temperature for a latitude band running
%   Fixedpathdefinition_gui                - created to allow user to set paths for the GOES16 data reader
%   getfilelist                            - generates a list of files with specified suffix under topDir.
%   GetFireHeightFromDEM                   - This routine will get the height of the fire location based on the
%   GetGOESDateTimeString                  - Decode the filename to arrive at the GOES startscan,end scan or file
%   GetGOESGrid                            - This routine will read a NetCDF file that has the GOES Lat Lon Grid already precomputed 
%   GetStateAndCountyFromLatAndLon         - This routine will go through each State and County in the US to find the 
%   GetSubDirsFirstLevelOnly               - This function was created to get a listing of just file folders contained
%   ImportMesoRadianceGridFile             - This script will import a Meso grid File
%   InsertPageBreak                        - This routine is to test inserting a pagebreak before a table
%   Inside                                 - Find those points (xi,yi) who are inside the polygon
%   install_GOES16Reader                   - Install
%   is_leap_year                           - 
%   linspace                               - linspace - Generate linearly spaced vector
%   Make3ColorImage                        - This function will take the GOES 16/17 data using channels 01/02/03 to
%   MakeDateFolderList                     - This folder is intended to make a list of folders in odered by date
%   MakeNewImageFolder                     - This routine will create a new labelled folder to hold a GOES 16 set
%   MyStrcat2                              - 
%   MyStrcatV73                            - Create a cmdstring to save selected variables. The qualstr will save it
%   ParsefullList                          - This function will parse through the output of a call to websave
%   ParseRedstonefullList                  - This function will parse through the output of a call to websave
%   pathdefinition_gui5a                   - created to allow user to set paths for the OSC Tool
%   pathdist                               - uses the distance function to calculate cumulative distance
%   PlotAerosolCumilDist                   - This routine will plot the cumilative distribution of the Aerosol
%   PlotAerosolParticleSizeHistogram       - This routine will plot a histogram of the Aerosol Particle Size
%   PlotAODCumilDist                       - This routine will plot the cumilative distribution of the AOD
%   PlotAODHistogram                       - This routine will plot a histogram of the AOD metric
%   PlotAshCloudHeightHistogram            - This routine will plot a histogram of volcanic ash cloud heights
%   PlotAshCloudVAMLHistogram              - This routine will plot a histogram of volcanic ash cloud mass loading
%   PlotCAPEStabilityCumilDist             - This routine will plot the cumilative distribution of the CAPE Index
%   PlotCAPEStabilityIndexHistogram        - This routine will plot a histogram of the CAPE Stability Index
%   PlotCloudDepthCumilDist                - This routine will plot the cumilative distribution of the Cloud Optical
%   PlotCloudOpticalDepthHistogram         - This routine will plot a histogram of the Cloud Optical Depth
%   PlotCloudParticleSizeCumilDist         - This routine will plot the cumilative distribution of the Aerosol
%   PlotCloudParticleSizeHistogram         - This routine will plot a histogram of the Cloud Particle Size
%   PlotCloudSUVIRadCumilDist              - This routine will plot the cumilative SUVI Rad Metric
%   PlotCloudTopHeightsCumilDist           - This routine will plot the cumilative distribution of cloud top heights
%   PlotCloudTopHeightsHistogram           - This routine will plot a histogram of the CloudTop Heights
%   PlotCloudTopPhaseHistogram             - This routine will plot a histogram of the Cloud Top Phase Histograms
%   PlotCloudTopPresssureHistogram         - This routine will plot a histogram of the CloudTop Pressure Values
%   PlotCloudTopPressureCumilDist          - This routine will plot the cumilative distribution of cloud top pressure
%   PlotCloudTopTempCumilDist              - This routine will plot the cumilative distribution of cloud top
%   PlotCloudTopTempHistogram              - This routine will plot a histogram of the Cloud Top Temperatures
%   PlotCMICumilDist                       - This routine will plot the cumilative distribution of the cloud
%   PlotCMIHistogram                       - This routine will plot a histogram of the CMI reflectance
%   PlotDerivedWindsVelHistogram           - This routine will plot a histogram of the Derived Winds Velocity
%   PlotDSRCumilDist                       - This routine will plot the cumilative distribution of the DSR metric
%   PlotDSRHistogram                       - This routine will plot a histogram of the Downward Shortwave Radiation
%   PlotFlashEnergyCumilDist               - This routine will plot the cumilative distribution of the GLM2 Flash
%   PlotKIStabilityCumilDist               - This routine will plot the cumilative distribution of the K Index
%   PlotKIStabilityIndexHistogram          - This routine will plot a histogram of the KI Stability Index
%   PlotLandSurfaceTempCumilDist           - This routine will plot the cumilative distribution of the land surface
%   PlotLandSurfTempHistogram              - This routine will plot a histogram of the Land Surface Temp
%   PlotLICumilDist                        - This routine will plot the cumilative distribution of the Li Index
%   PlotLightningFlashAreaHistogram        - This routine will plot a histogram of the Lightning Flash Area values
%   PlotLightningFlashEnergyHistogram      - This routine will plot a histogram of the Lightning Flash Energy values
%   PlotLIStabilityIndexHistogram          - This routine will plot a histogram of the LI Stability Index
%   PlotLVMCumilDist                       - This routine will plot the cumilative distribution of the LVM metric
%   PlotLVMHistogram                       - This routine will plot a histogram of LVM values for one
%   PlotLVTCumilDist                       - This routine will plot the cumilative distribution of the LVT metric
%   PlotLVTHistogram                       - This routine will plot a histogram of LVT values for one
%   PlotMeanTempByLat                      - This routine will plot the mean temperature by Latitude
%   PlotRadianceCumilDist                  - This routine will plot the cumilative distribution of the cloud radiance
%   PlotRadianceHistogram                  - This routine will plot a histogram of the Randiance
%   PlotRainFallRateCumilDist              - This routine will plot the cumilative distribution of the Rainfall Rate
%   PlotRainfallRateHistogram              - This routine will plot a histogram of the Rainfall Rate
%   PlotRGBCumilDist                       - This routine will plot the cumilative distribution of the RGB
%   PlotRGBHistogram                       - This routine will plot a histogram of the multiband true color
%   PlotRSRCumilDist                       - This routine will plot the cumilative distribution of the RSR
%   PlotRSRHistogram                       - This routine will plot a histogram of Reflected Solar Radiation 
%   PlotSeaSurfaceTempCumilDist            - This routine will plot the cumilative distribution of the sea surface
%   PlotSeaSurfTempHistogram               - This routine will plot a histogram of the Sea Surface Temp
%   PlotSeaSurfTempHistogramRev1           - This routine will plot a histogram of the Sea Surface Temp
%   PlotSIStabilityCumilDist               - This routine will plot the cumilative distribution of the Showalter Stability Index
%   PlotSIStabilityIndexHistogram          - This routine will plot a histogram of the SI Stability Index
%   PlotSUVIRadCumilDist                   - This routine will plot the cumilative SUVI Rad Metric
%   PlotSUVIRadHistogram                   - This routine will plot a histogram of the RAD values for one of
%   PlotTPWCumilDist                       - This routine will plot the cumilative distribution of the TPW
%   PlotTPWHistogram                       - This routine will plot a histogram of the TPW metric
%   PlotTTCumilDist                        - This routine will plot the cumilative distribution of the TT Index
%   PlotTTStabilityIndexHistogram          - This routine will plot a histogram of the TT Stability Index
%   PlotVAHCumilDist                       - This routine will plot the cumilative distribution of the VAH metric
%   PlotVAMLCumilDist                      - This routine will plot the cumilative distribution of the VAML metric
%   PlotWindSpeedCumilDist                 - This routine will plot the cumilative distribution of the derived wind
%   PlotWindSpeedVsLocation                - This routine will plot the wind speed and direction over a geographic
%   PlotWindSpeedVsLocationRev1            - This routine will plot the wind speed and direction over a geographic
%   ProcessOneGOESImage                    - This routine will process one GOES-16/17 satellite images
%   ReadABIConusMultiband                  - Modified: This function will read in the GOES ABI-L2-CMI Data
%   ReadABIFullDiskMultiband               - Modified: This function will read in the GOES ABI-L2-CMI Data
%   ReadABIL1Radiance                      - Modified: This function will read in the GOES ABI-L1-Radiance Data
%   ReadABIL2CMI                           - Modified: This function will read in the GOES ABI-L2-CMI Data
%   ReadABIMesoMultiband                   - Modified: This function will read in the GOES ABI-L2-Multiband Data
%   ReadAerosolData                        - Modified: This function will read in the GOES measured Aerosol Data
%   ReadAerosolOpticalDepthData            - Modified: This function will read in the GOES measured Aerosol Optical Depth Data
%   ReadClearSkyMask                       - Modified: This function will read in the GOES Cloud Top Temperature Data
%   ReadCloudOpticalDepth                  - Modified: This function will read in the GOES measured Cloud Optical
%   ReadCloudParticleSize                  - Modified: This function will read in the GOES measured Cloud Aerosol
%   ReadCloudTopHeights                    - Modified:File Reader into a function By Stephen Forczyk
%   ReadCloudTopHeightsRev1                - Modified:File Reader into a function By Stephen Forczyk
%   ReadCloudTopPhase                      - Modified: This function will read in the GOES ABI-L2-Cloud Top Phase Data
%   ReadCloudTopPressure                   - Modified: This function will read in the GOES Cloud Top Pressure Data
%   ReadCloudTopPressureRev1               - Modified: This function will read in the GOES Cloud Top Pressure Data
%   ReadCloudTopTemp                       - Modified: This function will read in the GOES ABI-L2-Cloud Top Temp Data
%   ReadCloudTopTemperature                - Modified: This function will read in the GOES Cloud Top Temperature Data
%   ReadCloudTopTempRev1                   - Modified: This function will read in the GOES ABI-L2-Cloud Top Temp Data
%   ReadConusABIL2CMI                      - Modified: This function will read in the GOES ABI-L2-CMI Data
%   ReadDerivedMotionWinds                 - Modified: This function will read in the GOES Derived Motion Wind Data
%   ReadDerivedStabilityIndices            - Modified: This function will read in the GOES calculated
%   ReadDownwardShortWaveRadiation         - This function will read to downward shortwave radiation data collected by
%   ReadGOES16Datasets                     - This executive script is to read a wide range of GOES16/17 Data products
%   ReadGOES16RasterFile                   - This script will read a text file to create a full set of Lat/Lon Raster
%   ReadL2Fire                             - Modified: This function will read in the ABI-L2-Fire data
%   ReadLandSurfaceTemperature             - Modified: This function will read in the GOES Land Surface Temperature
%   ReadLargeGridFile                      - This script will read a large text file to import it
%   ReadLightningData                      - Modified: This function will read in the GOES GLM-L2-Lighting-Data
%   ReadLVM                                - Modified: This function will read in the GOES calculated
%   ReadLVT                                - Modified: This function will read in the GOES calculated
%   ReadManyL2FireFiles                    - Modified: This function will read in the ABI-L2-Fire data for multiple
%   ReadMesoscale1ABIL2CMI                 - Modified: This function will read in the GOES ABI-L2-CMI Data
%   ReadNetCDFFile                         - Modified:File Reader into a function By Stephen Forczyk
%   ReadRainFallRate                       - Modified: This function will read in the GOES calculate RainFall Rate
%   ReadReflectedShortWaveRadiation        - Modified: This function will read in the GOES ABI-L2-Reflected ShortWave
%   ReadSeaSurfaceTemperature              - Modified: This function will read in the GOES Sea Surface Temperature
%   ReadSUVI_L1b_Fe093                     - This function will read in the GOES SUVI_L1B_Fe093
%   ReadSUVI_L1b_Fe131                     - This function will read in the GOES SUVI_L1B_Fe131
%   ReadSUVI_L1b_Fe171                     - This function will read in the GOES SUVI_L1B_Fe171
%   ReadSUVI_L1b_Fe195                     - This function will read in the GOES SUVI_L1B_Fe171
%   ReadSUVI_L1b_Fe284                     - This function will read in the GOES SUVI_L1B_Fe284
%   ReadSUVI_L1b_He303                     - This function will read in the GOES SUVI_L1B_He303
%   ReadTotalPrecipWater                   - Modified: This function will read in the GOES calculated
%   ReadVolcanicAsh                        - This function will read the volcanic ash files from 
%   RemoveBlanks                           - This function will remove blanks from anywhere in a string
%   RemoveUnderScores                      - Remove underscores from a text string and replace with dashes
%   ReplaceFillValues                      - The purpose of this routine is to replace the fill values in a GOES 16
%   ReplaceFillValues3                     - The purpose of this routine is to replace the fill values in a GOES 16
%   ReportTester                           - This executive script is perform quick testing of Matlab Report Functions
%   ReprojectLandsat8Imagery               - This script will read a Landsat Image file reproject it and plot it
%   ResizeImage                            - This routine will adjust the image size to match the reaster size
%   rgb                                    - returns the RGB triple of the 949 most common names for colors,
%   rgbmap                                 - creates color maps from any list of colors given as their common
%   SaveGoes16ReaderFixedPreferenceFile    - This function will save the fixed paths for the GOES 16 Reader
%   scalebar                               - places a graphical reference scale on a map. This function was
%   SetImageFolders                        - The purpose of this routine is to set up the image paths for the
%   SetScreenCoordinates                   - This routine will set the lower left hand coordinate of plot
%   SetUpExtraColors                       - The purpose of this routine is to set up extra colors to be used in
%   SetUpGoes16FixedDataPaths              - This script will set up the fixed paths to use in the ReadGOES16Datasets
%   SetUpGoesWaveBandData                  - Set up some fixed data for the GOES Wavebands
%   ShapeFilePOIExplorer                   - This script will read a shapefile and extract data from it
%   TestDownloadGOES16Data                 - Test download of GOES 16 data
%   TestGeoCoordFunction                   - This script will test the CalculateGeoCoord Function
%   TestHTTP                               - Test download from HTTP
%   TestHTTPRev1                           - Test download from HTTP-Rev1 is designed to use a select case
%   TestHTTPRev2                           - Test download from HTTP-Rev2 is designed to use a select case
%   TestHTTPRev3                           - Test download from HTTP-Rev3 is designed to use a select case
%   ToolboxChecker                         - this function will check if the the user has a particular toolbox
%   tropos                                 - Stripped-down version of atmos, applicable only to the troposphere
%   uisetdate2                             - Interactive date selection. This function is based on MATLAB's
%   UpdateMessageBox                       - This function will update the message box with a new line of text
