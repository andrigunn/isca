# Untar everything to a new folder
for a in `ls -1 *.tar.gz`; do mkdir ${a:0:39}_untar && tar -zxvf $a -C ${a:0:39}_untar; done

# Resample and  warp bands to be used to WGS from UTM
for a in *_untar; do
  (cd $a && \
    gdalwarp -t_srs EPSG:4326 *.pixel_qa.tif pixel_qa_wgs.tif && \
    gdal_merge.py -co "PHOTOMETRIC=RGB" -separate *_band{4,3,2}.tif -o L08_rgb.tif && \
    gdal_pansharpen.py *_band4.tif L08_rgb.tif L08_B4_pan_rgb.tif -r bilinear -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB);
done
mos_fn=LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa.tif cp $mos_fn ${mos_fn}_copy
#gdalwarp -tr 500 500  *_pixel_qa.tif pixel_qa_500.tif
#gdalwarp -t_srs EPSG:4326  LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500.tif LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500_wgs.tif
# gdalwarp -tr 500 500  *_pixel_qa.tif pixel_qa_500.tif && \  #
