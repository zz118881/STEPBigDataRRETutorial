##############################################################################
###
### Revolution R Enterprise ²���W��
### �Ĵ���ޢw�����E 
###
### Analysis Step
### 1.Specify the NameNode
### 2.Create a compute context for Hadoop
### 3.Copy a data set into the HDFS
### 4.Create a date source
### 5.Summarize your data
### 6.Fit a linear model to the data
### 7.Analyzing a Large Data Set With RevoScaleR
### 7-1 ���o��ƤΤW�Ǧ�hdfs
### 7-2 �]�w����T �[�t�B��Ĳv
### 7-3 �]�w�ɮרӷ�
### 7-4 �u�ʰj�k
### 7-5 Importing Data As Composite XDF Files
### 7-6 �βզXxdf�ɦA����@���u�ʦ^�k
### 7.7 Prediction on Large Data 
### �ɥR Create a Non-waiting Compute Context(�Ȳ�)
### �ɥR ����hdfs��ƥH��x�q����
### �ɥR �bHadoop���x�W����ƲM�~
### �ɥR �Nxdf���ରcsv
###
### �������e�`����Revolution R Enterprise �d��
##################################################################################

### 1.Specify the NameNode

# �Ծ\²���ΤW�Ҥ��e

##################################################################################
 
### 2.Create a compute context for hadoop

# RRE�Ȥ�ݥi�z�L����RRE�A�óz�LSSH��w�h�s�u��Hadoop�O���䤤�@�xnode��RRE�A
# �H��node�h���O���i�淾�q�A�ϥ��O���귽�i��B��C
# �s�Jnode���e�A�������T�{�Ȥ�ݬO�_���U��Putty�A�Y�L�ФW���i��U��
# �Ȥ�ݬO�_�w����node��private key�A�óz�LPutty�ѫȤ�ݤ���J�K�X�s�u��node
# �Y�L�A�Х��]�w

# RRE���T�س]�w�s�u��node�A�o�̱ĥ��z�LPutty�x�s�i�s�u����T��ARRE�|�ۦ�}��Putty�i��s�u���覡

# ���s�u��node���ϥΪ̱b��
mySshUsername<-"cloudera"
# �s�bputty����session�W��
mySshHostname<-"CDH4.7SingleNode"
# �bnode���a�ݨ����RRE�s������Ƨ����|�A�Фŧ�ʦ���
myShareDir <- paste("/var/RevoShare",mySshUsername,sep="/")
# �bhdfs��RRE�s������Ƨ����|�A�Фŧ�ʦ���
myHdfsShareDir <-paste("/user/RevoShare",mySshUsername,sep="/")

# �s�W�@��ComputeContext�A�ѰO�ѼƤ��e�Цۤv�WRdocument�d�A��ۤv���n�B�A�i�F�ѸӨ��
# sshClientDir �г]�w�Aputty���x�s���|
myHadoopCluster <- RxHadoopMR(
	hdfsShareDir=myHdfsShareDir,
	shareDir=myShareDir,
	sshUsername=mySshUsername,
	sshHostname=mySshHostname,
	sshClientDir="D:\\putty"
	)

# �i�DRRE �L�����n�p�⪺ComputeContext��myHadoopCluster
rxSetComputeContext(myHadoopCluster)

#################################################################################

### 3.Copying a Data File into the Hadoop Distributed File System

# ���F�n�F������B��A���Ʀs�JHdfs�����n���ʧ@
# ���B�i�]�w��node��native File System �����ɮ�copy�i�JHDFS�A
# ��i�q�Ȥ�ݱN�ɮ׶ǤJnode�A�A��node�ǤJHDFS
# �Y�n�q�Ȥ�ݶ��ɮצ�HDFS�Шϥ� rxHadoopCopyFromClient()
# rxHadoopCopyFromClient(source=source,hdfsDest=inputDir)
# �Ѽ�source���ɮרӷ��A�Ѽ�hdfsDest���n�s�bhdfs����m

# ���B���HRRE�����d���ɮװ��ܽd�A�qnode������ͨt�ζǤJHDFS������

# ���T�{�ɮ׬O�_�s�b(�D���n�B�J�A�G���ѡA���ݭn�ϥΦA�ϥΧY�i)�A�Y�^��True�A�h�s�b
# file.exists(system.file("SampleData/AirlineDemoSmall.csv"),package="RevoScaleR")

# �]�w�s�JHdfs����m�ARRE�]�p�z���O��n�B�⪺�ɮצs�JHdfs��/share��Ƨ��A�Unode��RRE�|�q����Ƨ�Ū���
bigDataDirRoot <-"/share"

# �n���ɮצs�J�Y��Ƨ����ɡA�������T�{�Ӹ�Ƨ��O�_�s�b�C
# �i��rxHadoopCommand("hadoop����ͫ��O")�A�Υ�RRE���ت��d�ߨ��
rxHadoopListFiles(bigDataDirRoot)

# �YHdfs�����s�b/share/AirlineDemoSmall��Ƨ��h����H�U���ѫ��O
# �аOnative system�ɮצ�m
# source <- system.file("SampleData/AirlineDemoSmall.csv",package="RevoScaleR")
# �w�]�ɮצs����|
inputDir <- file.path(bigDataDirRoot,"AirlineDemoSmall")
# �bHdfs�̷ӭ�w�]�����|�إ߸�Ƨ�
# rxHadoopMakeDir(inputDir)
# ��nativeFileSystem��file�ƻs�iHdfs
# �Y�O��client�ݧ��ƽƻs�ihdfs�h�ϥ�rxHadoopCopyFromClient(source,hdfsDest)
# rxHadoopCopyFromLocal(source,inputDir)
# �d�\Hdfs��/share��Ƨ��U���ɮ�
# rxHadoopListFiles(inputDir)

##########################################################################

### 4.Creating a Data Source

# RRE�w�]�|���j�Mlocal�ݪ�nativeFileSystem�A
# �Y�nRRE�w�]�h���L�ɮרt�Ϊ��ܥi�ϥ�rxSetFileSystem()
# ���B�ϥΥt�~�@�ؤ覡�A�p��ΰ����L�ʧ@�ɡA�A���w�n�M�䪺fileSystem
hdfsFS<-RxHdfsFileSystem() 

# ����ƪ��ܼƳ]�w�n�򥻸�T�A�i�`�ٹB��ɶ�
colInfo<- list(
	DayOfWeek=list(
		type="factor",
		levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
		)
	)

# �ɮ׬Ocsv�A�ݤ�r����ơA�G�ϥ�RxTextData��ƥh�i��RRE�o�O��r��ơA
# file : ����r��ƪ��ɮ׸��|
# missingValueString : ����|�Ȫ����ܱqNA�令���w���r��
# colInfo : ��Ƥ��ܼƪ���T�A�i���]�A��RRE�۰ʰ���
# fileSystem : ���w�h����ɮרt�Χ�M�ɮ�
airDS <- RxTextData(
	file=inputDir,
	missingValueString="M",
	colInfo=colInfo,
	fileSystem=hdfsFS
	)
###########################################################################

### 5.Summarizing Your Data

# ���ư��ԭz�ʲέp
adsSummary<-rxSummary(~ArrDelay+CRSDepTime+DayOfWeek,data=airDS)
adsSummary

###########################################################################

### 6.Fitting a Linear Model

arrDelayLm1 <-rxLinMod(ArrDelay~DayOfWeek,data=airDS)
summary(arrDelayLm1)

###########################################################################

### 7-1 ���o��ƤΤW�Ǧ�hdfs

# ���h�U���U���������Ҧ����
# http://packages.revolutionanalytics.com/datasets/AirOnTimeCSV2012/
# �U���n�A��Jhdfs����/share/airOnTime12/CSV�A���|��A�аѦ�²���C

###########################################################################

### 7-2 �]�w����T �[�t�B��Ĳv

airDataDir <- file.path(bigDataDirRoot,"/airOnTime12/CSV")

airlineColInfo <- list(
	MONTH = list(newName = "Month", type = "integer"),
	DAY_OF_WEEK = list(
		newName = "DayOfWeek", type = "factor",
		levels = as.character(1:7),
		newLevels = c("Mon", "Tues", "Wed", "Thur", "Fri", "Sat","Sun")
		),
	UNIQUE_CARRIER = list(
		newName = "UniqueCarrier", type = 
		"factor"
		),
	ORIGIN = list(
		newName = "Origin", 
		type = "factor"
		),
	DEST = list(
		newName = "Dest", 
		type = "factor"
		),
	CRS_DEP_TIME = list(
		newName = "CRSDepTime", 
		type = "integer"
		),
	DEP_TIME = list(
		newName = "DepTime", 
		type = "integer"
		),
	DEP_DELAY = list(
		newName = "DepDelay", 
		type = "integer"
		),
	DEP_DELAY_NEW = list(
		newName = "DepDelayMinutes", 
		type = "integer"
		),
	DEP_DEL15 = list(
		newName = "DepDel15", 
		type = "logical"
		),
	DEP_DELAY_GROUP = list(
		newName = "DepDelayGroups", 
		type = "factor",
		levels = as.character(-2:12),
		newLevels = c(
			"< -15", "-15 to -1","0 to 14", "15 to 29",
			"30 to 44", "45 to 59", "60 to 74",
			"75 to 89", "90 to 104", "105 to 119",
			"120 to 134", "135 to 149", "150 to 164",
			"165 to 179", ">= 180")
		),
	ARR_DELAY = list(
		newName = "ArrDelay", 
		type = "integer"
		),
	ARR_DELAY_NEW = list(
		newName = "ArrDelayMinutes", 
		type = "integer"
		),
	ARR_DEL15 = list(
		newName = "ArrDel15", 
		type = "logical"
		),
	AIR_TIME = list(
		newName = "AirTime", 
		type =  "integer"
		),
	DISTANCE = list(
		newName = "Distance",
 		type = "integer"
		),
	DISTANCE_GROUP = list(
		newName = "DistanceGroup", 
		type = "factor",
		levels = as.character(1:11),
		newLevels = c(
			"< 250", "250-499", "500-749", "750-999",
			"1000-1249", "1250-1499", "1500-1749", "1750-1999",
			"2000-2249", "2250-2499", ">= 2500")
		)
	) 

#####################################################################

### 7-3 �]�w�ɮרӷ�

varNames<-names(airlineColInfo)
hdfsFS<-RxHdfsFileSystem()
bigAirDS<-RxTextData(
	airDataDir,
	colInfo=airlineColInfo,
	varsToKeep=varNames,
	fileSystem=hdfsFS
	)

#####################################################################

### 7-4 �u�ʰj�k

# �ؼҨì�����O�ɶ�
system.time(
	delayArr<-rxLinMod(
		ArrDelay~DayOfWeek,
		data=bigAirDS,
		cube=T
		)
	)
summary(delayArr)

#####################################################################

### 7-5 Importing Data As Composite XDF Files

# �bRRE�A���˨ϥΪ��ɮ׮榡��xdf�A�i���ɸ�Ʀb�w�лP�O���鶡���洫�t��
# �Ԩ�²�������СA�bHadoop���ɮצs��xdf�榡�A�|�O�Hset���覡�x�s�A���ɦW��xdfd�Pxdfm
# xdfm���W�U�A���t�Ϊ��D�ɮצb���Ӹ`�I�W�C
# �{�b�ܽd��h��csv���ର�@��Composite Xdf File
# rowsPerRead���C�@��BLOCK�n�s��h�ֵ����
# numRows���nŪ���h�֦��ơA-1����Ū�C
bigAirXdfName<-"/user/RevoShare/cloudera/AirlineOnTime2012"
airData<-RxXdfData(bigAirXdfName,fileSystem=hdfsFS)
blockSize<-250000
numRowsToRead=-1
rxImport(
	inData=bigAirDS,
	outFile=airData,
	rowsPerRead=blockSize,
	overwrite=T,
	numRows=numRowsToRead
	)

#####################################################################

### 7-6 �βզXxdf�ɦA����@���u�ʦ^�k
system.time(
	delayArr<-rxLinMod(
		ArrDelay~DayOfWeek,
		data=airData,
		cube=T
		)
	)
print(
	summary(delayArr)
	)

#####################################################################

### 7.7 Prediction on Large Data

# �@��|�N���R��Ƥ����T��(�ؼҡB�վ�B����)�Ψ��(�ؼҡB����)
# modelObject �� �Ψӹw�����ҫ��Adata���n�Ψӥͦ��w�����G��data
rxPredict(
	modelObject=delayArr,
	data=airData,
	overwrite=T
	)

# �Ъ`�N �ϥ�rxPredict�A��J��ƥi��csv�ɡA
# ����X��ƥ��w��xdf�榡�A�G�p�G�Ʊ�NrxPredict�����Goutput�X�h�A
# �ЦbrxPrexdict��Ƥ��[�ioutData�ѼơA�åBoutData�ѼƩұ��������󥲶���RxXdfData����

#LBHTest<-RxXdfData("/user/RevoShare/cloudera/LBHTest",fileSystem=hdfsFS)
#rxPredict(
#	modelObject=delayArr,
#	data=airData,
#	outData=LBHTest,
#	overwrite=T
#	)

####################################################################

### �ɥR Create a Non-waiting Compute Context

# �i��u�@����ݥh����A���A��RSession���i�~�򵹧A�ϥ�

# �]�wComputeContext
myNoWaitJobCC <- RxHadoopMR(
	hdfsShareDir=myShareDir,
	shareDir=myShareDir,
	sshUsername=mySshUsername,
	sshHostname=mySshHostname,
	sshClientDir="D:\\putty",
	wait=F
	)
rxSetComputeContext(myNoWaitJobCC)

# �]�w�ɮרӷ�
bigAirXdfName<-"/user/RevoShare/cloudera/AirlineOnTime2012"
hdfsFS<-RxHdfsFileSystem() 
myNoWaitXdfSource<-RxXdfData(
	bigAirXdfName,
	fileSystem=hdfsFS
	)

# �]�w�u�@
getInfoJob<-rxGetInfo(myNoWaitXdfSource,getVarInfo=T,numRows=6)

# ���o�u�@���p�Arunning�O�٦b�i��Afinished�O�w�g�����C
rxGetJobStatus(getInfoJob)

# ���o�u�@���G�A�p�G�u�@�|�������A�|�����~�T��
rxGetJobResults(getInfoJob)

# �p�G�b�]�w�u�@���خɡA�ѰOassign�@���ܼ�(�ҡGgetInfoJob)����Job
# �i�� rxgLastPendingJob���^�̫�@�Ӱ��檺job
forgetAssign<-rxgLastPendingJob
rxGetJobStatus(forgetAssign)

# �ΤӦh�ΤӲn�A���`Job���槹����A���|�M���Ȧs�A
# ���p�G�O�Q���椤�_���ΨS�����������쵲�G���A�Ȧs�N�ܦ��F�U���A����вM�zJob
# ���]�w�n�M�����d��γ�@job
myJobs<-rxGetJobs(
	myNoWaitJobCC,
	startTime=as.POSIXct("2014/12/5 16:30"),
	endTime=as.POSIXct("2014/12/5 17:20")
	)
rxCleanupJobs(myJobs)


####################################################################

### �ɥR,���ɸ�ƶq�ä��O�ܤj�A�Τ����B��A�t�פϦӤ�qHDFS������ƨ쥻���ݰ��B��ӱo�C

# �H�U�d�Ҭ��qhdfs������ƶi���ݧ@�B��
rxSetComputeContext("local")
inputFile<-file.path(bigDataDirRoot,"AirlineDemoSmall/AirlineDemoSmall.csv")
airDSLocal<-RxTextData(file=inputFile,missingValueString="M",colInfo=colInfo,fileSystem=hdfsFS)
adsSummary<-rxSummary(~ArrDelay+CRSDepTime+DayOfWeek,data=airDSLocal)
adsSummary
rxSetComputeContext(myHadoopCluster)

############################################################################

### �ɥR �bHadoop���x�W����ƲM�~

# ���Ƨ@�M�~�A�R�����n�����Φ��ɨϥ�rxPredict()��ƨS���woutData�A
# ���ɹw���᪺���G�|�Ƽg�ܭ��ơA�Y���Q�n�w���᪺���G�ݯd�b���ƤW�A��i�ϥΦ��B�J

#newAirDir<-"/user/RevoShare/cloudera/newAirData"
#newAirXdf<-RxXdfData(newAirDir,fileSystem=hdfsFS)
#rxDataStep(
#	inData=airData,
#	outFile=newAirXdf,
#	varsToDrop=c("ArrDel15_Pred","ArrDel15_Resid"),
#	rowSelection=!is.na(ArrDelay)&(DepDelay>-60)
#	)

############################################################################

### �Nxdf���ରcsv��

# ���ǤH�i��Q�n�洫�ƾڡA���襲����^csv�A�аѦҥH�U�d��

giveMeCSV<-RxTextData(file="iAmCSV.csv")
putXdf<-RxXdfData(file="nowExist.xdf")
rxDataStep(
	inData=putXdf,
	outFile=giveMeCSV
	)