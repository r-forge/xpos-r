##
 # FILE convertAll.r
 # AUTHOR olivier crespo
 # https://r-forge.r-project.org/projects/xpos-r/convertBruceFormat
 ###############################################################################
 #
 # main algorithm, used for any fromat
 # which intend to convert 1 data set for 1 time period only
 #
 ###############################################################################
 # if you are running the script in linux for linux use of the files, that's fine
 # if you are running the script in windows for windows use of the files, that's fine
 # BUT if you are running the script in linux for windows use of the files
 # you'll face some formating problem
 # we thought about fixing that, but if you intend to use it on windows,
 # I guess you can afford to run the script on windows ...
 ###############################################################################

## USER JOB
 # INITIALISE YOUR DATA PATHS AND NAMES
 ###############################################################################
 # so far you write them hard in the code
 # separated with "/" even for windows
 # finish all paths and folder name with "/"
 ###############################################################################
init_paths <- function()
{
	# in which folder to read the data
	input <- "/home/csag/crespo/Desktop/AquaCrop/Inputs/cccma_cgcm3_1/";

	# in which folder to write out the data
	output <- "/home/csag/crespo/Desktop/AquaCrop/Test/"

	# what are the name of the data folders
	folder <- list	(	"tmn"=	"tmin/",	# folder name for minimal temperatures
				"tmx"=	"tmax/",	# folder name for maximal temperatures
				"ppt"=	"ppt/"		# folder name for precipitation
			);	

return(list("input"=input,"output"=output,"folder"=folder));
}
## USER JOB
 # STATION NAMES - from one to multiple stations
 ###############################################################################
 # temp and prec are separated because they are different in some cases
 ###############################################################################
init_stations <- function()
{
stations <- list(#	list(	"temp"="0725756AW.txt",		# name for temp data file
#				"prec"="0725756AW.txt",		# name for prec data file (could be the same)
#				"inLand"=TRUE),			# is the station in land (TRUE) or on the coast (FALSE)
#			list(	"temp"="CHOKWE.txt",
#				"prec"="CHOKWE.txt",
#				"inLand"=TRUE),
			list(	"temp"="SUSSUNDENGA.txt",
				"prec"="SUSSUNDENGA.txt",
				"inLand"=TRUE)
#			list(	"temp"="XAI-XAI.txt",
#				"prec"="XAI-XAI.txt",
#				"inLand"=FALSE)
		);

return(stations);
}
## USER JOB 
 # GC MODELS NAMES
 ###############################################################################
 # you need it only for multiple GCMs routine conversion
 ###############################################################################
init_GCMs <- function()
{
GCMs <- list(	"obs"=	list(	"con"=	"obs"),
		"ncep"=	list(	"con"=	"ncep2.1"),
		"cccm"=	list(	"con"=	"cccma_cgcm3_1",
				"futA"=	"cccma_cgcm3_1-fa",
				"futB"=	"cccma_cgcm3_1-fb"),
		"cgcm"=	list(	"con"=	"mri_cgcm2_3_2a",
				"futA"=	"mri_cgcm2_3_2a-fa",
				"futB"=	"mri_cgcm2_3_2a-fb"),
		"cnrm"=	list(	"con"=	"cnrm_cm3",
				"futA"=	"cnrm_cm3-fa",
				"futB"=	"cnrm_cm3-fb"),
		"csiro35"=list(	"con"=	"csiro_mk3_5",
				"futA"=	"csiro_mk3_5-fa",
				"futB"=	"csiro_mk3_5-fb"),
		"echam"=list(	"con"=	"mpi_echam5",
				"futA"=	"mpi_echam5-fa",
				"futB"=	"mpi_echam5-fb"),
		"echo"=	list(	"con"=	"miub_echo_g",
				"futA"=	"miub_echo_g-fa",
				"futB"=	"miub_echo_g-fb"),
		"gfdl"=	list(	"con"=	"gfdl_cm2_0",
				"futA"=	"gfdl_cm2_0-fa",
				"futB"=	"gfdl_cm2_0-fb"),
		"giss"=	list(	"con"=	"giss_model_e_r",
				"futA"=	"giss_model_e_r-fa",
				"futB"=	"giss_model_e_r-fb"),
		"ipsl"=	list(	"con"=	"ipsl_cm4",
				"futA"=	"ipsl_cm4-fa",
				"futB"=	"ipsl_cm4-fb")
	);
return(GCMs);
}

##
 # CONVERSION ROUTINE FOR MULTIPLE GCMs
 ###############################################################################
 # N.B. the main conversion procedure is below
 # dealing with one station and one time period at a time
 ###############################################################################
 # default parameters are made to call only one station,
 # but put manyGcms=TRUE and you'll play with the lot
 # so far param model takes: "ap" (APSIM), "aq" (AQUACROP) and "all" for both
 ###############################################################################
convert <- function(model,manyGCMs=FALSE)
{
### crop models
	if(model=="all") model <- 1;
	if(model=="ap") model <- 2;
	if(model=="aq") model <- 3;
	if (!is.numeric(model)){
		print("### ERROR: unknown target model");
		print("### targetModel available so far: 'ap' (APSIM), 'aq' (AQUACROP) or 'all' (both)");
		stop();
	}

### initialisation
	path <- init_paths();
	if (manyGCMs)	gcms <- init_GCMs();
	stations <- init_stations();

### multiple GCMs routine
	if(manyGCMs){
		for (g in 1:length(gcms)){
			for (p in 1:length(gcms[[g]])){
				print(paste(" --->  processing GCM: ",gcms[[g]][p],sep=""));
				for (s in 1:length(stations)){
					pathToStation <-	list(	"input"=paste(path$input,gcms[[g]][[p]],"/",sep=""),
									"output"=paste(path$output,gcms[[g]][[p]],"/",sep=""),
									"folder"=	list(	"tmn"=path$folder$tmn,
												"tmx"=path$folder$tmx,
												"ppt"=path$folder$ppt
											),
									"file"=		list(	"temp"=stations[[s]]$temp,
												"prec"=stations[[s]]$prec
											),
									"inland"=stations[[s]]$inLand
								);
					print(paste(" ----->  processing station: ",stations[[s]]$temp,sep=""));
					switch(model,
						{	# all
							convertOne("ap",pathToStation,FALSE);
							convertOne("aq",pathToStation,FALSE);
						},{	# apsim only
							convertOne("ap",pathToStation,FALSE);
						},{	# aquacrop only
							convertOne("aq",pathToStation,FALSE);
						}
					);
				}
			}	
		}
	}else{
### single GCM routine
		for (s in 1:length(stations)){
			pathToStation <-	list(	"input"=path$input,
							"output"=path$output,
							"folder"=	list(	"tmn"=path$folder$tmn,
										"tmx"=path$folder$tmx,
										"ppt"=path$folder$ppt
									),
							"file"=		list(	"temp"=stations[[s]]$temp,
										"prec"=stations[[s]]$prec
									),
							"inland"=stations[[s]]$inLand
						);
			print(paste(" ----->  processing station: ",stations[[s]]$temp,sep=""));
			switch(model,
				{	# all
					convertOne("ap",pathToStation,FALSE);
					convertOne("aq",pathToStation,FALSE);
				},{	# apsim only
					convertOne("ap",pathToStation,FALSE);
				},{	# aquacrop only
					convertOne("aq",pathToStation,FALSE);
				}
			);
		}
	}
print(" ... process completed ...");
}

##
 # CONVERT MAIN FUNCTION
 ###############################################################################
 # is the function to be called for any conversion
 # leave pathToStation NULL for one station
 # ##############################################################################
convertOne <- function(targetModel,pathToStation=NULL,seeSteps=FALSE)
{
### sources
	source("checkFunctions.r");
	source("bruceFormat.r");
	source("agriParameters.r");
	source("metTransformations.r");

	if(is.null(pathToStation)){
		print("### ERROR: no station specified !!");
		stop();
	}

### target models
	if(targetModel=="ap") targetModel <- 1;
	if(targetModel=="aq") targetModel <- 2;
	if (!is.numeric(targetModel)){
		print("### ERROR: unknown target model");
		print("### targetModel available so far: 'APSIM' or 'AQUACROP'");
		stop();
	}

## because so far, no crop model deal with missing data
 # 1: I am only interseted in the time period covered by tmn, tmx and ppt
	if(seeSteps)	print("... check unconsistencies ...");
	fileHead <- checkData(pathToStation);
	if(seeSteps)	print("... import data ...");
	data <- importData(pathToStation,fileHead);
## because so far, no crop model deal with missing data
 # 2: if there is any missing data (that I can spot) I will warn the user
	if(seeSteps)	print("... looking for missing data ...");
	data <- checkMissing(data);
	checkTmpRain(data);
## because so far, no crop model deal with missing data
 # 3: I need to make sure years are made of real number of days
	switch(fileHead$period$type+1,
		{	# 0 is for real
		},{	# 1 is for 365
			data <- transform_type1(data,fileHead);
		},{	# 2 is for 360
			data <- transform_type2(data,fileHead);
		}
	);

## then starts the crop model related operations
	switch(targetModel,
		{	                            #################### APSIM #
			source('convertToApsim.r');
			if(seeSteps)	print("... create years and julian days ...");
			data <- createYearJulianDays(data,fileHead);
			if(seeSteps)	print("... compute radiation ...");
			data <- compute_radn(data,fileHead$station,pathToStation$inland);
			if(seeSteps)	print("... compute tav and amp ...");
			data <- compute_tavNamp(data);
			if(seeSteps)	print("... format and write data into .met file ...");
			formatToMetFile(data,fileHead,pathToStation);
		},	# APSIM ####################
		{	                            ################# AQUACROP #
			# aquacrop deals with day, 10-days and monthly records
			# so far we deal only with day records
			source('convertToAquacrop.r');
			if(seeSteps)	print("... create years and julian days ...");
			data <- createYearJulianDays(data,fileHead);
			if(seeSteps)	print("... compute ETo ...");
			data <- compute_ETo(data,fileHead$station,pathToStation$inland);
			if(seeSteps)	print("... format and write data into .TMP, .PLU and .ETo files ...");
			formatToTMPFile(data,fileHead,pathToStation);
			formatToPLUFile(data,fileHead,pathToStation);
			formatToEToFile(data,fileHead,pathToStation);
		}	# AQUACROP #################
	);

if(seeSteps)	print("... conversion completed ...");
}

