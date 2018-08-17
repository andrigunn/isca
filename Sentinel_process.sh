# Untar everything to a new folder
for a in `ls -1 *.zip`; do unzip $a ; done

# Resample and  warp bands to be used to WGS from UTM
for a in *.SAFE; do
  (cd $a && cd GRANULE && cd $(find . -name L2A*  -type d | sed 1q) && cd IMG_DATA && cd R60m && gdalwarp -t_srs EPSG:4326 *_SCL_60m.jp2 pixel_qa_wgs.tif);
done

#gdalwarp -tr 500 500  *_pixel_qa.tif pixel_qa_500.tif
#gdalwarp -t_srs EPSG:4326  LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500.tif LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500_wgs.tif
#gdalwarp -tr 500 500  *_pixel_qa.tif pixel_qa_500.tif && \  #

#gdalwarp -t_srs EPSG:4326 *.pixel_qa.tif pixel_qa_wgs.tif && \
#gdal_merge.py -co "PHOTOMETRIC=RGB" -separate *_band{4,3,2}.tif -o L08_rgb.tif && \
#gdal_pansharpen.py *_band4.tif L08_rgb.tif L08_B4_pan_rgb.tif -r bilinear -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB);

#mos_fn=LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa.tif cp $mos_fn ${mos_fn}_copy

#for a in *.SAFE; do echo $a; done
