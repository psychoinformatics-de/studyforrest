WWW_DIR = www
WWW_UPLOAD_URI=kumo.ovgu.de:/var/www/studyforrest/www
RSYNC_OPTS_UP = -rzlhv --delete --copy-links
DATADIR = www/data

prep:
	npm install bower
	node_modules/.bin/bower install bootstrap
	node_modules/.bin/bower install holderjs

upload:
	rsync $(RSYNC_OPTS_UP) $(WWW_DIR)/* $(WWW_UPLOAD_URI)/

data: $(DATADIR) $(DATADIR)/t1w.nii.gz $(DATADIR)/t2w.nii.gz \
      $(DATADIR)/swi_mag.nii.gz $(DATADIR)/angio.nii.gz \
      $(DATADIR)/7Tad_epi_grptmpl.nii.gz

$(DATADIR):
	mkdir -p $@

$(DATADIR)/t1w.nii.gz:
	wget -O $@ http://psydata.ovgu.de/forrest_gump/sub009/anatomy/highres001.nii.gz
	fslroi $@ $@ 40 190 45 275 130 210
	fslmaths $@ -thr 10 $@ -odt char

$(DATADIR)/t2w.nii.gz:
	wget -O $@ http://psydata.ovgu.de/forrest_gump/sub002/anatomy/other/t2w001.nii.gz
	fslroi $@ $@ 30 210 30 290 130 225
	fslmaths $@ -thr 15 $@ -odt char

$(DATADIR)/swi_mag.nii.gz:
	wget -O $@ http://psydata.ovgu.de/forrest_gump/sub016/anatomy/other/swi001_mag.nii.gz
	fslroi $@ $@ 80 350 30 420 40 410
	fslmaths $@ -s 30 $(DATADIR)/swi_bias
	fslmaths $@ -div $(DATADIR)/swi_bias -thr .7 -mul 100 $@ -odt char
	rm -f $(DATADIR)/swi_bias*

$(DATADIR)/angio.nii.gz:
	wget -O $@ http://psydata.ovgu.de/forrest_gump/sub012/angio/angio001.nii.gz
	fslmaths $@ -subsamp2 -s 20 $(DATADIR)/angio_bias
	fslmaths $@ -subsamp2 -div $(DATADIR)/angio_bias -mul 40 -thr 20 $@ -odt char
	rm -f $(DATADIR)/angio_bias*

$(DATADIR)/7Tad_epi_grptmpl.nii.gz:
	wget -O $@ http://psydata.ovgu.de/forrest_gump/templates/grpbold7Tad/brain.nii.gz

xtk/xtk.js:
	mkdir -p xtk
	wget -O $@ http://get.goxtk.com/xtk.js

xtk/xtk_xdat.gui.js:
	mkdir -p xtk
	wget -O $@ http://get.goxtk.com/xtk_xdat.gui.js
