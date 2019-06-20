PROGRAM_NAME='Control Functions Common'

#IF_NOT_DEFINED __CONTROL_FUNCTIONS_COMMON__
#DEFINE __CONTROL_FUNCTIONS_COMMON__

DEFINE_FUNCTION fnSendString(DEV dDevice, CHAR cString[])
{
    SEND_STRING dDevice, "cString";
}

DEFINE_FUNCTION fnAppendContentToFile(CHAR cFilename[], CHAR cFileWriteContent[])
{
    STACK_VAR SLONG sFileOpenStatus;
    STACK_VAR SLONG sFileWriteStatus;
    
    FILE_SETDIR('\\');
    sFileOpenStatus = FILE_OPEN(cFilename, FILE_RW_APPEND)
    IF(sFileOpenStatus > 0)
    {
	 sFileWriteStatus = FILE_WRITE_LINE(sFileOpenStatus, cFileWriteContent, LENGTH_STRING(cFileWriteContent))
    }
    FILE_CLOSE(sFileOpenStatus)
}

DEFINE_FUNCTION fnWriteMACAddressToFile(DEV dDevice, CHAR cString[])
{
    STACK_VAR SLONG sFileOpenStatus;
    STACK_VAR SLONG sFileReadStatus;
    STACK_VAR CHAR  cLineContent[255];
    STACK_VAR CHAR  dDeviceString[15];
    LOCAL_VAR CHAR  bFindDevice;
    STACK_VAR INTEGER nDevNum;
    STACK_VAR INTEGER nDevPortNum;
    STACK_VAR INTEGER nDevSysNum;
    
    FILE_SETDIR('\\');
    bFindDevice = FALSE;
    sFileOpenStatus = FILE_OPEN(FILE_NAME_TO_WRITE, FILE_READ_ONLY);
    IF(sFileOpenStatus > 0)
    {
	sFileReadStatus = 1;
	WHILE(sFileReadStatus > 0)
	{
	    sFileReadStatus = FILE_READ_LINE(sFileOpenStatus, cLineContent, MAX_LENGTH_STRING(cLineContent));
	    dDeviceString = DuetParseCmdParam(cLineContent);
	    nDevNum 	= ATOI(REMOVE_STRING(dDeviceString, ':', 1));
	    nDevPortNum = ATOI(REMOVE_STRING(dDeviceString, ':', 1));
	    nDevSysNum  = ATOI(dDeviceString);
	    IF((nDevNum == dDevice.NUMBER) && (nDevPortNum == dDevice.PORT) && (nDevSysNum == dDevice.SYSTEM))
	    {
		bFindDevice = TRUE;
		BREAK;
	    }
	}
    }
    FILE_CLOSE(sFileOpenStatus);
    
    IF(bFindDevice = FALSE)
    {
	fnAppendContentToFile(FILE_NAME_TO_WRITE,cString);
    }
    ELSE
    {
	SEND_STRING 0, "'Device exist'";
    }
}


#END_IF