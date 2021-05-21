function [OutputImage] = ResizeImage(InputImage,GeoRef)
% This routine will adjust the image size to match the reaster size
% the amount of adjustment should be small
% Written By: Stephen Forczyk
% Created: August 23,2020
% Revised: -----
% Classification: Unclassified
OutputImage=InputImage;
medval=median(median(InputImage));
[nrowsImage,ncolsImage]=size(InputImage);
RasterSize=GeoRef.RasterSize;
nrowsRaster=RasterSize(1,1);
ncolsRaster=RasterSize(1,2);  
if((nrowsImage==nrowsRaster) && (ncolsImage==ncolsRaster))
    OutputImage=InputImage;
else
    OutputImage=zeros(nrowsRaster,ncolsRaster);
    for i=1:nrowsRaster
        for j=1:ncolsRaster
            if((i<=nrowsImage) && (j<=ncolsImage))
                OutputImage(i,j)=InputImage(i,j);
            else
                OutputImage(i,j)=medval;
            end
                
        end
    end
end

end

