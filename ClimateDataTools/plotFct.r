#setwd("/home/crespo/Link to WinShared/SSAtmp/");
graphics.off();

pathDef <- "../../../FromTravel/12_AgMIP/2012-07_Sentinel/InLandIsT/SWA/obs/0446741.1.met";
figTitDef <- "Big Bend - Swaziland (1968-1992)";

monthDay <- array(c(31,28,31,30,31,30,31,31,30,31,30,31,29),dim=c(13,1));

m00	<- 1;
m01	<- monthDay[1,1];
m02	<- m01+monthDay[2,1];
m03	<- m02+monthDay[3,1];
m04	<- m03+monthDay[4,1];
m05	<- m04+monthDay[5,1];
m06	<- m05+monthDay[6,1];
m07	<- m06+monthDay[7,1];
m08	<- m07+monthDay[8,1];
m09	<- m08+monthDay[9,1];
m10	<- m09+monthDay[10,1];
m11	<- m10+monthDay[11,1];
m12	<- m11+monthDay[12,1];

yeaC 	<-	2;
julC	<-	3;
tmnC	<-	4;
tmxC	<-	5;
pptC	<-	6;
solC	<-	7;

##
 # is that year a leap year?
 ###############################################################################
is.leapYear <- function(year)
{
	## trusting R date class
	## otherwise there would be a conflict sooner or later anyway
	start <- as.Date(paste("01","01",year,sep="-"),"%d-%m-%Y");
	end <- as.Date(paste("31","12",year,sep="-"),"%d-%m-%Y");

	dayNo <- end-start +1;
	switch(dayNo-364,
		leap <- FALSE,
		leap <- TRUE
	);
return(leap);
}

################################################################################
# TOOLS TO COPY DEVICE INTO SPECIFIC GRAPHICAL FORMATS
################################################################################

## EPS
copyDev2eps <- function(title="title",file)
{
	dev.print(device=postscript,title=title,paper="special",horizontal=FALSE,file=file);
}

## JPG
copyDev2jpg <- function(file)
{
	savePlot(filename=file,type="jpeg",device=dev.cur());
}

## FIG
## HAS TO BE SMALLER THAN AN A4 FORMAT
copyDev2fig <- function(file)
{
	dev.print(device=xfig,file=file);
}

##############################################################################
load_obs <- function(path=pathDef){

	obs<-read.table(path,skip=24);

return(obs);
}

##############################################################################
temp_quantiles <- function(metDat,figTit=figTitDef)
{
	figTit <- paste("Temperatures (oC)",figTit,sep=" - ");

	## put NA on 29-FEB when leap year
	met365<-metDat;
	remove29feb <- FALSE;
	for(l in seq(dim(met365)[1],1,-1)){
		if(met365[l,julC]==366){
			remove29feb <- TRUE;
		}
		if(remove29feb==TRUE){
			if(met365[l,julC]==(31+29)){
				met365[l,julC]<-NA;
				remove29feb <- FALSE;
			}else{
				met365[l,julC]<-met365[l-1,julC];
			}
		}
	}

	# compute quantiles
	quaTmn <- array(NA,dim=c(365,3));
	quaTmx <- array(NA,dim=c(365,3));
	xDay<-1:365;
	for (day in xDay){
		quaTmn[day,]<-quantile(met365[met365[,julC]==day,tmnC],na.rm=T,probs=c(0.2,0.5,0.8));
		quaTmx[day,]<-quantile(met365[met365[,julC]==day,tmxC],na.rm=T,probs=c(0.2,0.5,0.8));
	}
	
	# plot
	x11(width=14,height=8);
	plot.new();
	par(mar=c(3,3,1,1));
	plot(	x=xDay,
		y=xDay,
		type="n",
		xlim=c(1,365),	# X limit
		ylim=c(min(quaTmn[,1]),max(quaTmx[,3])),
		axes=FALSE, xlab=FALSE
	);
	title(xlab=NULL,ylab=NULL,main=figTit);
	axis(1,	at=c(m00,m01,m02,m03,m04,m05,m06,m07,m08,m09,m10,m11,m12),
		labels=c("01-jan","31-jan","28-feb","31-mar","30-apr","31-may","30-jun","31-jul","31-aug","30-sep","31-oct","30-nov","31-dec")
	);
	axis(2,at=NULL); grid(nx=NA,ny=NULL);
	legend(	"bottomleft",
		legend=c("80th max temp (oC)","50th max temp (oC)","20th max temp (oC)","80th min temp (oC)","50th min temp (oC)","20th min temp (oC)","50th running ave (oC)",paste("na.rm=(",length(met365[is.na(met365[,tmnC]),tmnC]),",",length(met365[is.na(met365[,tmxC]),tmxC]),")",sep="")),
		col=c("red","red","red","blue","blue","blue","black","white"),
		lty=c(3,1,3,3,1,3,1,NULL),
		lwd=c(1,1,1,1,1,1,2,NULL)
	);

	lines(xDay,quaTmn[,1],type="l",lty=3,col="blue");
	lines(xDay,quaTmn[,2],type="l",lty=1,col="blue");
	lines(xDay,quaTmn[,3],type="l",lty=3,col="blue");
	lines(lowess(quaTmn[,2],f=1/12,iter=3),type="l",lty=1,lwd=2,col="black");	

	lines(xDay,quaTmx[,1],type="l",lty=3,col="red");
	lines(xDay,quaTmx[,2],type="l",lty=1,col="red");
	lines(xDay,quaTmx[,3],type="l",lty=3,col="red");
	lines(lowess(quaTmx[,2],f=1/12,iter=3),type="l",lty=1,lwd=2,col="black");	
}

##############################################################################
prec_perDay <- function(metDat,figTit=figTitDef)
{
	figTit <- paste("Precipitation (mm)",figTit,sep=" - ");

	## put NA on 29-FEB when leap year
	met365<-metDat;
	remove29feb <- FALSE;
	for(l in seq(dim(met365)[1],1,-1)){
		if(met365[l,julC]==366){
			remove29feb <- TRUE;
		}
		if(remove29feb==TRUE){
			if(met365[l,julC]==(31+29)){
				met365[l,julC]<-NA;
				remove29feb <- FALSE;
			}else{
				met365[l,julC]<-met365[l-1,julC];
			}
		}
	}
	# remove 0s
	met365[met365[,pptC]==0,pptC] <- NA;

	# compute quantiles
	quaPpt <- array(NA,dim=c(365,3));
	xDay<-1:365;
	for (day in xDay){
		quaPpt[day,]<-quantile(met365[met365[,julC]==day,pptC],na.rm=TRUE,probs=c(0.5,0.8,1));
	}

	# plot
	x11(width=14,height=8);
	plot.new();
	par(mar=c(3,3,1,1));
	plot(	x=xDay,
		y=xDay,
		type="n",
		xlim=c(1,365),	# X limit
		ylim=c(0,quantile(quaPpt[,3],probs=0.995,na.rm=TRUE)),
		axes=FALSE
	);
	title(xlab=NULL,ylab=NULL,main=figTit);
	axis(1,	at=c(m00,m01,m02,m03,m04,m05,m06,m07,m08,m09,m10,m11,m12),
		labels=c("01-jan","31-jan","28-feb","31-mar","30-apr","31-may","30-jun","31-jul","31-aug","30-sep","31-oct","30-nov","31-dec")
	);
	axis(2,at=NULL);
	legend(	"center",
		legend=c("max precipitation","80th precipitation","50th precipitation"),
		col=c("lightblue","lightblue","blue"),
		lty=c(3,1,1),
		lwd=c(1,2,1)
	);

#	lines(xDay,quaPpt[,1],type="l",lty=2,col="blue");
	lines(xDay,quaPpt[,3],type="h",lty=3,col="lightblue");
	lines(xDay,quaPpt[,2],type="h",lwd=2,col="lightblue");
	lines(xDay,quaPpt[,1],type="h",lwd=1,col="blue");

	# replace NAs with 0s
	quaPpt[is.na(quaPpt[,1]),1] <-0;
	quaPpt[is.na(quaPpt[,2]),2] <-0;
	quaPpt[is.na(quaPpt[,3]),3] <-0;
	lines(lowess(quaPpt[,3],f=1/12,iter=3),type="l",lty=3,col="lightblue");	
	lines(lowess(quaPpt[,2],f=1/12,iter=3),type="l",lty=1,col="lightblue");	
	lines(lowess(quaPpt[,1],f=1/12,iter=3),type="l",lty=1,col="blue");	
}

##############################################################################
prec_perMonth <- function(metDat,figTit=figTitDef)
{
	figTit <- paste("Precipitation (mm)",figTit,sep=" - ");

	# separate data per month
	monthData <- 	list(jan=NULL,feb=NULL,mar=NULL,apr=NULL,may=NULL,jun=NULL,jul=NULL,aug=NULL,sep=NULL,oct=NULL,noc=NULL,dec=NULL);
	monthWas <- 12; year <- 0;
	for (l in 1:dim(metDat)[1]){
		month <- as.numeric(format(as.Date(metDat[l,julC],origin=paste(metDat[l,yeaC],"01-01",sep="-")),"%m"));
		if(monthWas != month){
			# create a new year in that month
			if(monthWas==12){	year <- year + 1;}
			monthData[[month]] <- c(monthData[[month]],list("yea"=NULL));
			monthData[[month]][[year]] <- list("dat"=NULL,"no0"=NULL,"tot"=NULL);
		}
		monthWas <- month;
		monthData[[month]][[year]]$dat <- c(monthData[[month]][[year]]$dat,metDat[l,pptC]);
	}

	# compute monthly totals
	for(m in 1:length(monthData)){
		for(y in 1:length(monthData[[m]])){
			# no0
			monthData[[m]][[y]]$no0 <- array(NA,dim=length(monthData[[m]][[y]]$dat));
			for(l in 1:length(monthData[[m]][[y]]$dat)){
				if(monthData[[m]][[y]]$dat[l]!=0){monthData[[m]][[y]]$no0[l] <- monthData[[m]][[y]]$dat[l];}
			}
			monthData[[m]][[y]]$tot <- sum(monthData[[m]][[y]]$no0,na.rm=TRUE);
		}
	}

	# put it in matrix for plotting
	monthStat <- array(0,dim=c(6,12));
	for(m in 1:length(monthData)){
		tmp <- array(NA,dim=length(monthData[[m]]));
		for(y in 1:length(monthData[[m]])){
			monthStat[1,m] <- monthStat[1,m]+ifelse(is.na(monthData[[m]][[y]]$tot),0,monthData[[m]][[y]]$tot);
			tmp[y] <- ifelse(is.na(monthData[[m]][[y]]$tot),0,monthData[[m]][[y]]$tot);
		}
		monthStat[1,m] <- monthStat[1,m]/length(monthData[[m]]);
		monthStat[2:6,m] <- quantile(tmp,probs=c(0,0.2,0.5,0.8,1))
#		for(q in 2:6){
#			monthStat[q,m] <- monthStat[q,m]/length(monthData[[m]]);
#		}
	}
	aaa <-boxplot(monthStat[2:6,],plot=FALSE);
	aaa$stats[1:5,] <- monthStat[2:6,];

	# plot
	xMon <- 1:12;
	x11(width=14,height=8);
	plot.new();
	par(mar=c(3,3,2,1));
	bxp(aaa,outline=FALSE,boxfill="lightblue",names=FALSE,axes=FALSE,wiskcol="blue")
	title(xlab=NULL,ylab=NULL,main=figTit);
	axis(1,	at=c(1,2,3,4,5,6,7,8,9,10,11,12),
		labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	);
	axis(2,at=NULL);
	legend(	"top",
		legend=c("max monthly totals","80th monthly totals","50th monthly totals","20th monthly totals","min monthly totals","mean monthly totals"),
		col=c("black","lightblue","black","lightblue","black","red"),
		lty=c(1,1,1,1,1,1),
		lwd=c(1,2,2,2,1,2)
	);

	tmp <- array(NA,dim=(length(monthStat[1,])+2));
	tmp[2:(length(monthStat[1,])+1)] <- monthStat[1,]; 
	tmp[1] <- monthStat[1,length(monthStat[1,])];
	tmp[(length(monthStat[1,])+2)] <- monthStat[1,1];
#	lines(xMon,monthStat[1,],type="l",lty=1,lwd=2,col="red");
	lines(0:13,tmp,type="l",lty=1,lwd=2,col="red");
}

##############################################################################
prec_runMonth <- function(metDat,figTit=figTitDef)
{
	metDat <- as.matrix(metDat);

	# compute totals
	metCol <- dim(metDat)[2];
	winTot <- array(NA,dim=c(dim(metDat)[1],(metCol+2)));
	winTot[,1:metCol] <- metDat[,];
	for(d in 15:(dim(metDat)[1]-14)){
		window <- array(NA,dim=29);
		window[] <- metDat[(d-14):(d+14),pptC];
		winTot[d,(metCol+1)] <- length(window[window[]>0]);
		winTot[d,(metCol+2)] <- sum(window[]);
	}

	## put NA on 29-FEB when leap year
	met365<-winTot;
	remove29feb <- FALSE;
	for(l in seq(dim(met365)[1],1,-1)){
		if(met365[l,julC]==366){
			remove29feb <- TRUE;
		}
		if(remove29feb==TRUE){
			if(met365[l,julC]==(31+29)){
				met365[l,julC]<-NA;
				remove29feb <- FALSE;
			}else{
				met365[l,julC]<-met365[l-1,julC];
			}
		}
	}

	# compute quantiles
	quaPpt <- array(NA,dim=c(365,5));
	xDay<-1:365;
	for (day in xDay){
#		quaPpt[day,1]<-mean(met365[met365[,julC]==day,(metCol+1)],na.rm=T);
		quaPpt[day,2]<-mean(met365[met365[,julC]==day,(metCol+2)],na.rm=T);
		quaPpt[day,3:5]<-quantile(met365[met365[,julC]==day,(metCol+2)],na.rm=T,probs=c(0.2,0.5,0.8));
	}

	# plot
	xDay <- 1:365
	x11(width=14,height=8);
	plot.new();
	par(mar=c(3,3,1,1));
	plot(	x=xDay,
		y=xDay,
		type="n",
		ylim=c(0,max(quaPpt[,5],na.rm=TRUE)),
		axes=FALSE, xlab=FALSE
	);
	title(xlab=NULL,ylab=NULL,main=paste("Precipitation (mm)",figTit,sep=" - "));
	axis(1,	at=c(m00,m01,m02,m03,m04,m05,m06,m07,m08,m09,m10,m11,m12),
		labels=c("01-jan","31-jan","28-feb","31-mar","30-apr","31-may","30-jun","31-jul","31-aug","30-sep","31-oct","30-nov","31-dec")
	);
	axis(2,at=NULL); grid(nx=NA,ny=NULL);
	legend(	"center",
		legend=c("80th 29days totals (mm)","50th 29days totals (mm)","20th 29days totals (mm)","50th smoothed 29days totals (mm)","29days mean totals (mm)"),
		col=c("blue","blue","blue","red","black"),
		lty=c(3,1,3,1,1),
		lwd=c(1,1.5,1,1,1.5)
	);

	lines(xDay,quaPpt[,2],type="l",lty=1,lwd=1.5,col="black");
	lines(xDay,quaPpt[,3],type="l",lty=3,lwd=1,col="blue");
	lines(xDay,quaPpt[,4],type="l",lty=1,lwd=1.5,col="blue");
	lines(xDay,quaPpt[,5],type="l",lty=3,lwd=1,col="blue");
	lines(lowess(quaPpt[,4],f=1/16,iter=3),type="l",lty=1,col="red");

}