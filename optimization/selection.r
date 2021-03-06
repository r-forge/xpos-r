##
 # FILE selection.r
 # AUTHOR olivier crespo
 # VERSION https://r-forge.r-project.org/projects/xpos-r/
 ####################################################################

##
 # SELECTION PROCESS BASED ON 2x2 selCri
 ####################################################################
 # selCri[1,]: minimize col1, if two even minimize col2
 # if two even candidates
 # selCri[2,]: maximize col1, if two even maximize col2
 ####################################################################
select_minTHminTHmaxTHmax <- function(penList)
{
	# this fct is not called if penList == 1
	# countdown to avoid to sort it when removing the promising region from the pending List
	indices <- array(penList$itemNo,dim=c(1,1));

	for (r in seq(penList$itemNo-1,1,-1)){
		index <- indices[1,1];
		if(penList$regEva[[r]]$selCri[1,1] < penList$regEva[[index]]$selCri[1,1]){
			indices <- array(r,dim=c(1,1));
		}else{
			if(penList$regEva[[r]]$selCri[1,1] == penList$regEva[[index]]$selCri[1,1]
			&& penList$regEva[[r]]$selCri[1,2] < penList$regEva[[index]]$selCri[1,2]){
				indices <- array(r,dim=c(1,1));
			}else{
				if(penList$regEva[[r]]$selCri[1,1] == penList$regEva[[index]]$selCri[1,1]
				&& penList$regEva[[r]]$selCri[1,2] == penList$regEva[[index]]$selCri[1,2]
				&& penList$regEva[[r]]$selCri[2,1] > penList$regEva[[index]]$selCri[2,1]){
					indices <- array(r,dim=c(1,1));
				}else{
					if(penList$regEva[[r]]$selCri[1,1] == penList$regEva[[index]]$selCri[1,1]
					&& penList$regEva[[r]]$selCri[1,2] == penList$regEva[[index]]$selCri[1,2]
					&& penList$regEva[[r]]$selCri[2,1] == penList$regEva[[index]]$selCri[2,1]
					&& penList$regEva[[r]]$selCri[2,2] > penList$regEva[[index]]$selCri[2,2]){
						indices <- array(r,dim=c(1,1));
					}else{
						if(penList$regEva[[r]]$selCri[1,1] == penList$regEva[[index]]$selCri[1,1]
						&& penList$regEva[[r]]$selCri[1,2] == penList$regEva[[index]]$selCri[1,2]
						&& penList$regEva[[r]]$selCri[2,1] == penList$regEva[[index]]$selCri[2,1]
						&& penList$regEva[[r]]$selCri[2,2] == penList$regEva[[index]]$selCri[2,2]){
							indices <- rbind(indices,r);
						}
					}
				}
			}
		}
	}

return(indices);
}

##
 # SELECTION PROCESS BASED ON 2x2 selCri
 ####################################################################
 # min of selCri[lin,col]
 ####################################################################
select_min <- function(penList,lin,col)
{
	# this fct is not called if penList == 1
	# countdown to avoid to sort it when removing the promising region from the pending List
	indices <- array(penList$itemNo,dim=c(1,1));

	for (r in seq(penList$itemNo-1,1,-1)){
		index <- indices[1,1];
		if(penList$regEva[[r]]$selCri[lin,col] < penList$regEva[[index]]$selCri[lin,col]){
			indices <- array(r,dim=c(1,1));
		}else{
			if(penList$regEva[[r]]$selCri[lin,col] == penList$regEva[[index]]$selCri[lin,col]){
				indices <- rbind(indices,r);
			}
		}
	}

return(indices);
}

##
 # SELECTION PROCESS BASED ON 2x2 selCri
 ####################################################################
 # min of sum(selCri[lin,])
 ####################################################################
select_minLin <- function(penList,lin)
{
	# this fct is not called if penList == 1
	# countdown to avoid to sort it when removing the promising region from the pending List
	indices <- array(penList$itemNo,dim=c(1,1));

	for (r in seq(penList$itemNo-1,1,-1)){
		index <- indices[1,1];
		if(sum(penList$regEva[[r]]$selCri[lin,]) < sum(penList$regEva[[index]]$selCri[lin,])){
			indices <- array(r,dim=c(1,1));
		}else{
			if(sum(penList$regEva[[r]]$selCri[lin,]) == sum(penList$regEva[[index]]$selCri[lin,])){
				indices <- rbind(indices,r);
			}
		}
	}

return(indices);
}

##
 # SELECTION PROCESS BASED ON 2x2 selCri
 ####################################################################
 # min strict positif (>0) of selCri[lin,col]
 ####################################################################
select_minPos <- function(penList,lin,col)
{
	# this fct is not called if penList == 1
	# countdown to avoid to sort it when removing the promising region from the pending List

	# find a non zero initialisation
	rank <- penList$itemNo;
	repeat{
		indices <- array(rank,dim=c(1,1));
		
		rank <- rank -1;
		if(indices[1,1]>0 || rank<1)	break;
	}
	
	if(rank>1){
	for (r in seq(rank,1,-1)){
		index <- indices[1,1];
		if(penList$regEva[[r]]$selCri[lin,col] > 0
		&& penList$regEva[[r]]$selCri[lin,col] < penList$regEva[[index]]$selCri[lin,col]){
			indices <- array(r,dim=c(1,1));
		}else{
			if(penList$regEva[[r]]$selCri[lin,col] > 0
			&& penList$regEva[[r]]$selCri[lin,col] == penList$regEva[[index]]$selCri[lin,col]){
				indices <- rbind(indices,r);
			}
		}
	}}

return(indices);
}

##
 # SELECTION PROCESS BASED ON 2x2 selCri
 ####################################################################
 # max of selCri[lin,col]
 ####################################################################
select_max <- function(penList,lin,col)
{
	# this fct is not called if penList == 1
	# countdown to avoid to sort it when removing the promising region from the pending List
	indices <- array(penList$itemNo,dim=c(1,1));

	for (r in seq(penList$itemNo-1,1,-1)){
		index <- indices[1,1];
		if(penList$regEva[[r]]$selCri[lin,col] > penList$regEva[[index]]$selCri[lin,col]){
			indices <- array(r,dim=c(1,1));
		}else{
			if(penList$regEva[[r]]$selCri[lin,col] == penList$regEva[[index]]$selCri[lin,col]){
				indices <- rbind(indices,r);
			}
		}
	}

return(indices);
}

##
 # SELECT THE PROMISING REGION(S) FROM PENDING REGIONS
 ####################################################################
 # selection implies that the promising regions will be removed from the pending regions
 ####################################################################
 # selMeth=0: (default) min of selCri line 1
 # selMeth=1: 0 with restriction to selCri[1,1]==0
 # selMeth=2: 0 + those that minimize selCri[2,1]
 # selMeth=3: 1 out of 2 from 0
 # selMeth=4: 10 oldest in 0
 ####################################################################
select <- function(proList,penList,selMeth=0)
{
	##### select promising regions
	if (penList$itemNo<2){
		selectedReg <- array(1,dim=c(1,1));
	}else{
		# basic initial selection
		selectedReg <- select_minLin(penList,1);
		########################################
		# keep selection rule in here and selection of the best consistent (update_bestList)
		########################################

		switch(selMeth,
			   ## 0: nothing more
			{  ## 1: reduce the selected regions to those with minimal selCri[1,1]
				for (r in seq(dim(selectedReg)[1],1,-1)){
					if(penList$regEva[[selectedReg[r]]]$selCri[1,1]>0){ selectedReg <- selectedReg[-r];}
				}
				selectedReg <- array(selectedReg,dim=length(selectedReg));

			},{## 2: initial + min selCri[2,1]
				#if(length(selectedReg)>9){
				#	selectedReg <- array(selectedReg[row(selectedReg)%%2==round(runif(1))],dim=c(ceiling(length(selectedReg)/2),1));
				#}
				selectedReg2 <- select_minPos(penList,2,1);
				#if(length(selectedReg2)>9){
				#	selectedReg2 <- array(selectedReg2[row(selectedReg2)%%2==round(runif(1))],dim=c(ceiling(length(selectedReg2)/2),1));
				#}
				for (r in 1:length(selectedReg2)){
					if(length(selectedReg[selectedReg==selectedReg2[r]])==0){
						selectedReg <- array(
							c(selectedReg[selectedReg>selectedReg2[r]],selectedReg2[r],selectedReg[selectedReg<selectedReg2[r]]),
							dim=c(dim(selectedReg)[1]+1,1)
						);
					}
				}
			},{## 3: 1 out of 2 of initial
				if(length(selectedReg)>9){
					selectedReg <- array(selectedReg[row(selectedReg)%%2==round(runif(1))],dim=c(ceiling(length(selectedReg)/2),1));
				}
			},{## 4: no more than 10 in initial
				if(length(selectedReg)>10){
					selectedReg <- array(selectedReg[(length(selectedReg)-9):length(selectedReg),1],dim=c(10,1));
				}
			}
		);			
	}

	##### I want some randomness
	# I started by randomely chosing the regEva number,
	# but because they actually are piled FILO, using a uniform law does not mean picking uniformely
	# I actually want to give more probability to pick a top region which has not been explored for a while
	## choose one pending region randomly within the non chosen
	if( dim(selectedReg)[1] < penList$itemNo){
# pick the top one
#		ranReg <- 1;
#		while(length(selectedReg[selectedReg==ranReg]) > 0){
#			ranReg <- ranReg+1;
#		}
# pick exp randomely (high proba on the top of the pile)
		repeat{
				ranReg <- ceiling(rexp(1,(10/penList$itemNo)));
				if(ranReg <= penList$itemNo && length(selectedReg[selectedReg==ranReg]) == 0)	break;
		}
		# insert ranReg at the right place
		selectedReg <- array(
			c(selectedReg[selectedReg>ranReg],ranReg,selectedReg[selectedReg<ranReg]),
			dim=c(dim(selectedReg)[1]+1,1)
		);
	}

	##### add them to proList
	for (r in 1:dim(selectedReg)[1]){
		proList$itemNo <- proList$itemNo +1;
		proList$regEva <- c(proList$regEva,list(penList$regEva[[selectedReg[r]]]));
	}

	##### remove them from penList
	# should be sorted decreasing...
	for (r in 1:dim(selectedReg)[1]){
		penList$regEva <- penList$regEva[-selectedReg[r]];
		penList$itemNo <- penList$itemNo -1;
	}

return(list("pro"=proList,"pen"=penList));
}


##
 # UPDATE THE LIST OF CURRENT BEST REGIONS
 ####################################################################
 # BEST LEAVES ONLY
 # OTHERWISE YOU'LL NEVER GET (MULTICRITERIA) BETTER THAN THE FIRST BEST
 ####################################################################
update_bestList <- function(proList,besList,evalMeth,criterion)
{
	# probably useless... but
	if(proList$itemNo==0){
		return(besList);
	}

	# remove from besList the parent region of any region in proList
	if(besList$itemNo > 0){
		varNo <- dim(besList$regEva[[1]]$regDef)[2];
		for( rBes in seq(besList$itemNo,1,-1)){	# countdown because it might end up in removing a region
			for( rPro in 1:proList$itemNo){
				inside_no <- 0;
				for( var in 1:varNo){
					if(proList$regEva[[rPro]]$regDef[1,var] >= besList$regEva[[rBes]]$regDef[1,var]
					&& proList$regEva[[rPro]]$regDef[2,var] <= besList$regEva[[rBes]]$regDef[2,var]){
						inside_no <- inside_no +1;
					}
				}
				if ( inside_no == varNo){
					# remove rBes from besList
					besList$regEva <- besList$regEva[-rBes];
					besList$itemNo <- besList$itemNo -1;
					# and go to next rBes
					break;
				}
			}
		}
	}

	# merge besList and proList
	for (reg in 1:proList$itemNo){
		besList$itemNo <- besList$itemNo +1;
		besList$regEva <- c(besList$regEva,list(proList$regEva[[reg]]));
	}
	
	if (besList$itemNo>1){
		## update multicriteria evaluation of besList
		#
		#	MAKE SURE PROLIST IS NOT DISTURBED IN MAIN.r !!! NOT DONE YET
		#
		if (evalMeth==5){	# otherwise it is still up to date
			besList <- evaluate_proList(besList,evalMeth,criterion);
		}
		
		## select a region as best regarding to reg$selCri[1,1] only
		# countdown useless here, but not necessary to change
		########################################
		# keep selection of the best in here and selection rule consistent (select)
		########################################
		indices <- array(besList$itemNo,dim=1);
		for (r in seq(besList$itemNo-1,1,-1)){
			index <- indices[1];
			if(sum(besList$regEva[[r]]$selCri[1,]) < sum(besList$regEva[[index]]$selCri[1,])){
				indices <- array(r,dim=1);
			}else{
				if(sum(besList$regEva[[r]]$selCri[1,]) == sum(besList$regEva[[index]]$selCri[1,])){
					indices <- rbind(indices,r);
				}
			}
		}
		
		## keep only the best in the list
		for (r in seq(besList$itemNo,1,-1)){
			if(length(indices[indices==r])>0){
			}else{
				besList$regEva <- besList$regEva[-r];
				besList$itemNo <- besList$itemNo -1;
			}
		}
	}

return(besList);
}

##
 # KEEP THE BEST DECISION ONLY
 ####################################################################
 # keepMeth=0: (default) nothing change
 # keepMeth=1: remove the last half of decisions
 # keepMeth=2: keep only the dec reaching the best [per,cri] per objectives
 # keepMeth=3: keep only the dec reaching non dominated [per,cri]
 ####################################################################
keepTheBests <- function(proList,keepMeth=0)
{
	criNo <- dim(proList$regEva[[1]]$decEva[[1]])[2];

	for(r in 1:proList$itemNo){
		decNo <- proList$regEva[[r]]$itemNo;
		perNo <- ifelse(is.null(dim(proList$regEva[[r]]$decEva)[2]),1,dim(proList$regEva[[r]]$decEva)[2]);

		if(decNo>1+1){	# I want at least 2 of them
		switch(keepMeth,
		{ 	## 1
			for(d in seq(decNo,round(decNo/2)+1,-1)){
				proList$regEva[[r]]$decDef <- proList$regEva[[r]]$decDef[-d];
				proList$regEva[[r]]$decEva <- proList$regEva[[r]]$decEva[-d];
				proList$regEva[[r]]$itemNo <- proList$regEva[[r]]$itemNo-1;
			}
		
		},{	## 2
			if(decNo>1){
				## find the 'criNo' bests
				bestDec <- array(decNo,dim=criNo);
				bestVal <- array(NA,dim=criNo);
				for (c in 1:criNo){
					bestVal[c] <- min(proList$regEva[[r]]$decEva[[bestDec[c]]][,c]);
				}
				for(d in seq(decNo-1,1,-1)){
					for (c in 1:criNo){
						if ( min(proList$regEva[[r]]$decEva[[d]][,c]) < bestVal[c] ){
							bestDec[c] <- d;
							bestVal[c] <- min(proList$regEva[[r]]$decEva[[d]][,c]);
						}
					}
				}
				## remove everything else
				for(d in seq(decNo,1,-1)){
					if(length(bestDec[bestDec==d])==0){
						proList$regEva[[r]]$decDef <- proList$regEva[[r]]$decDef[-d];
						proList$regEva[[r]]$decEva <- proList$regEva[[r]]$decEva[-d];
						proList$regEva[[r]]$itemNo <- proList$regEva[[r]]$itemNo-1;
					}
				}
			}
		},{	## 3
			if(decNo>1){
				## find out non dominated [dec,per]
				dominated <- array(0,dim=c(decNo,perNo));
				for (d1 in 1:(decNo-1)){
					for (p1 in 1:perNo){
						for (d2 in (d1+1):decNo){
							for (p2 in 1:perNo){
								switch(paretoDomi_decPerVSdecPer(proList$regEva[[r]]$decEva[[d1]][p1,1:criNo],proList$regEva[[r]]$decEva[[d2]][p2,1:criNo]),
									## [d1,p1] is dominating [d2,p2]
								{	dominated[d2,p2] <- dominated[d2,p2]+1;
								},{	## [d2,p2] is dominating [d1,p1]
									dominated[d1,p1] <- dominated[d1,p1]+1;
								},{	## I do not care for here
								}
								);
							}
						}			
					}
				}
				## remove all decision that do not have a non dominated [dec,per]
				for(d in seq(decNo,1,-1)){
					if (min(dominated[d,]) > 0){
						proList$regEva[[r]]$decDef <- proList$regEva[[r]]$decDef[-d];
						proList$regEva[[r]]$decEva <- proList$regEva[[r]]$decEva[-d];
						proList$regEva[[r]]$itemNo <- proList$regEva[[r]]$itemNo-1;
					}
				}
			}
		}
		);
		}
	}

return(proList);
}
