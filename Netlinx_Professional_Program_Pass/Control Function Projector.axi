PROGRAM_NAME='Control Function Projector'

#IF_NOT_DEFINED __CONTROL_FUNCTION_PROJECTOR__
#DEFINE  __CONTROL_FUNCTION_PROJECTOR__

#INCLUDE 'Netlinx Professional Practice Constants'


(*************************************************************)
(*               FUNCTION DEFINITIONS GOES BELOW             *)
(*************************************************************)
DEFINE_FUNCTION fnParseVideoProjEventMassage(DEV dPanelDev, CHAR sMessage[])
{
    STACK_VAR CHAR cCmdBit[1];
    STACK_VAR CHAR cChecksumBit[1];
    
    cCmdBit      = MID_STRING(sMessage, 2, 1);
    cChecksumBit = RIGHT_STRING(sMessage, 1);
    
    //POWER ON AND OFFF COMMANDS
    IF((cCmdBit == "$00") && (cChecksumBit == "$F2")) 	//Power on confirm
    {
	ON[dPanelDev, BTN_PROJ_POWER]
    }
    IF((cCmdBit == "$01") && (cChecksumBit == "$F3")) 	//Power off confirm
    {
	OFF[dPanelDev, BTN_PROJ_POWER]
    }
    
    //SOURCE SELECTION COMMAND FEEDBACK
    IF((cCmdBit == "$03") && (cChecksumBit == "$F7")) 	//Select HDMI
    {
	nProjSourceSelection = SOURCE_SRECEIVER;	//For Button Feedback
	SEND_COMMAND dPanelDev, "'^TXT-', ITOA(TXT_SOURCE_INPUT), ',1&2,', 'HDMI'";
    }
    IF((cCmdBit == "$03") && (cChecksumBit == "$07")) 	//Select Component
    {
	nProjSourceSelection = SOURCE_DVD
	SEND_COMMAND dPanelDev, "'^TXT-', ITOA(TXT_SOURCE_INPUT), ',1&2,', 'COMPONENT'";
	//If DVDPlayer selected as source then create timeline to polling the status
    }
    IF((cCmdBit == "$03") && (cChecksumBit == "$FC")) 	//Select Video
    {
	nProjSourceSelection = SOURCE_SCAMERAS
	SEND_COMMAND dPanelDev, "'^TXT-', ITOA(TXT_SOURCE_INPUT), ',1&2,', 'VIDEO'";
    }
    IF((cCmdBit == "$03") && (cChecksumBit == "$01")) 	//Select S-Video
    {
	nProjSourceSelection = SOURCE_CAMERA
	SEND_COMMAND dPanelDev, "'^TXT-', ITOA(TXT_SOURCE_INPUT), ',1&2,', 'S-VIDEO'";
    }
    
    //RUNNING TIME CALCULATE
    IF(cCmdBit == "$8C")	//LAMP Information command
    {
	LOCAL_VAR CHAR nLampRunningTimeBit[4];
	
//	nLampRunningTimeBit[1] = MID_STRING(sMessage, 5,1)
//	nLampRunningTimeBit[2] = MID_STRING(sMessage, 6,1)
//	nLampRunningTimeBit[3] = MID_STRING(sMessage, 7,1)
//	nLampRunningTimeBit[4] = MID_STRING(sMessage, 8,1)
	nLampRunningTimeBit[1] = sMessage[5];
	nLampRunningTimeBit[1] = sMessage[6];
	nLampRunningTimeBit[1] = sMessage[7];
	nLampRunningTimeBit[1] = sMessage[8];
	
	nProjRunningTime = (nLampRunningTimeBit[4] << 24) + (nLampRunningTimeBit[3] << 16) + (nLampRunningTimeBit[2] << 8) + nLampRunningTimeBit[1];
    }
    // PROJECTOR STATUS 
    IF(cCmdBit == "$85")
    {	
	cProjRunningStatus   = MID_STRING(sMessage, 6, 1)
	cProjSelectedSource  = MID_STRING(sMessage, 7, 1)
    }
    
}

DEFINE_FUNCTION CHAR fnVideoProjCmdChecksum(CHAR sCommand[])
{
    // Example - "$02,$00,$00,$00,$00" 		
    LOCAL_VAR CHAR cChecksum;
    STACK_VAR INTEGER nCmdIndex;
    
    FOR(nCmdIndex=1; nCmdIndex <= LENGTH_ARRAY(sCommand); nCmdIndex++)
    {
	cChecksum = cChecksum + sCommand[nCmdIndex];
    }
    RETURN cChecksum;
}

#END_IF