PROGRAM_NAME='Control Function Light'
#IF_NOT_DEFINED __CONTROL_FUNCTION_LIGHT__
#DEFINE __CONTROL_FUNCTION_LIGHT__

#INCLUDE 'SNAPI'
(***********************************************************)
(*               Read Content from Specific File           *)
(***********************************************************)
DEFINE_FUNCTION fnReadIPAddressFromFile(CHAR cFileName[])
{
    STACK_VAR SLONG sFileOpenStatus;
    LOCAL_VAR SLONG sFileReadLineStatus;
    STACK_VAR CHAR cOnelineContent[255];
    STACK_VAR INTEGER INC;
    
    FILE_SETDIR('\\'); //FTP Root Directory
    sFileOpenStatus = FILE_OPEN(cFileName, FILE_READ_ONLY);
    
    IF(sFileOpenStatus > 0)
    {
	sFileReadLineStatus = 1;
	WHILE(sFileReadLineStatus > 0)
	{
	    sFileReadLineStatus = FILE_READ_LINE(sFileOpenStatus, cOnelineContent, MAX_LENGTH_STRING(cOnelineContent))
	    
	    fnParseIPAddressLine(cOnelineContent);
	}
	FILE_CLOSE(sFileOpenStatus);
    }
    ELSE
    {
	SEND_STRING 0, "'FILE READ ERROR - ', ITOA(sFileOpenStatus)"
    }
}

(***********************************************************)
(*               Parse IP Address and Port Info            *)
(***********************************************************)
DEFINE_FUNCTION fnParseIPAddressLine(CHAR sLineContent[])
{
    LOCAL_VAR CHAR devLight[25];
    
    //Get Light Device Number, Port and System
    devLight = DuetParseCmdParam(sLineContent);
    dLightDevice.NUMBER = ATOI(REMOVE_STRING(devLight, ':', 1))
    dLightDevice.PORT   = ATOI(REMOVE_STRING(devLight, ':', 1))
    dLightDevice.SYSTEM = ATOI(devLight)
    
    //Get IP Address and Port Number for IP Connection
    sLightsIPAddress    = DuetParseCmdParam(sLineContent);
    nLightsPortNum      = ATOI(DuetParseCmdParam(sLineContent));
}

(***********************************************************)
(*              Deal with IP Connection error              *)
(***********************************************************)
DEFINE_FUNCTION char[100] fnIPConnectionError(long iErrorCode) {
    char iReturn[100]
    
    switch(iErrorCode) 
    {
	case  1 : iReturn = "'Invalid server address'";
	case  2 : iReturn = "'Invalid server port'";
	case  3 : iReturn = "'Invalid value for Protocol'";
	case  4 : iReturn = "'Unable to open communication port with server'";
	case  6 : iReturn = "'Connection refused'";
	case  7 : iReturn = "'Connection timed out'";
	case  8 : iReturn = "'Unknown connection error'";
	case  9 : iReturn = "'Already closed'";
	case 10 : iReturn = "'Binding error'";
	case 11 : iReturn = "'Listening error'";
	case 14 : iReturn = "'Local port already used'";
	case 15 : iReturn = "'UDP socket already listening'";
	case 16 : iReturn = "'Too many open sockets'";
	default : iReturn = "'(',itoa(iErrorCode),')Undefined'";
    }
    RETURN iReturn
}

(***********************************************************)
(*              Deal with Light Device Message             *)
(***********************************************************)
DEFINE_FUNCTION fnDealwithLightMessages(CHAR sLightMessage[])
{
    LOCAL_VAR INTEGER nZoneNum;
    LOCAL_VAR INTEGER nLevelValue;
    LOCAL_VAR INTEGER nZoneLevelNum;
    LOCAL_VAR FLOAT nZoneLevelValue;
    
    nZoneNum 		= ATOI(MID_STRING(sLightMessage,7,1))
    nLevelValue 	= ATOI(MID_STRING(sLightMessage,10,3))
    
    nZoneLevelNum 	= 10 + (nZoneNum - 1);
    nZoneLevelValue	= nLevelValue * 255 / 100
    
    SEND_LEVEL dvTP_LightControl, nZoneLevelNum, nZoneLevelValue;
}

(***********************************************************)
(*              Deal with Preset scene                     *)
(***********************************************************)





#END_IF