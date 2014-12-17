##########################################################################
#
# Revolution R Enterprise �w �ͦ��j�k�ؼҩҨϥΪ�formula
# �����E
# �Ĵ����
#   
#
# �L�h�}��R�A�ؼҥi�ϥ� . (dot) �N�������ܼ�
# �b�ϥ�rxFunction�ɡA�h�L�k�H.(dot)�N�������ܼ�
# �G�ϥΦ���k����Ҧ��ܼƤγ]�p�R���ܼƻP�s�W�ܼ�
#
##########################################################################

# dataSource  ����ƨӷ�
# depVar      �����ܼ�
# rmIndepVar  ���n�R�������ܼ�
# addIndepVar ���n�s�W�����ܼƤηs�榡(����:�椬��)
generateFormula<-function(dataSource,depVar,rmIndepVar="",addIndepVar=NULL){
	
	# ���o��ƪ��Ҧ����W��
	tempNames<-names(dataSource)
	
	# �R�����ܼƤΤ��Q�[����ܼơA�s�W�Q�n�[��ܼƤηs�榡
	tempIndepVar<-c(tempNames[(tempNames!=rmIndepVar)&(tempNames!=depVar)],addIndepVar)
	
	# ���]�w�榡�������ܼ�
	resultFormula<-paste(depVar,"~",sep="")
	
	# �H�K
	for(i in tempIndepVar){
		resultFormula<-paste(resultFormula,i,"+",sep="")	
	}
	
	# ���hformula�̫�褧+���A�ó]����ƶǦ^��
	return(substr(resultFormula,start=1,stop=nchar(resultFormula)-1))
}

# generateFormula(mortDS,names(mortDS)[6],names(mortDS)[3:4])
# generateFormula(mortDS,names(mortDS)[6],names(mortDS)[3:4],"ccDebt^2")
# rxLinMod(generateFormula(mortDS,names(mortDS)[6]),data=mortDS)
# rxLinMod(generateFormula(mortDS,names(mortDS)[6],names(mortDS)[3:4],"ccDebt^2"),data=mortDS)