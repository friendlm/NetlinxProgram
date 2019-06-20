PROGRAM_NAME='Control Function DVD Player'
#IF_NOT_DEFINED __CONTROL_FUNCTION_DVD_PLAYER__
#DEFINE __CONTROL_FUNCTION_DVD_PLAYER__

#INCLUDE 'Netlinx Professional Practice Constants'

DEFINE_FUNCTION fnDealwithDVDPlayerMessage(CHAR cDVDPlayerMessage[])
{
    STACK_VAR CHAR cCommandBit[1];
    STACK_VAR CHAR cCmdResponse[1];
    
    cCommandBit	  = LEFT_STRING(cDVDPlayerMessage,1);
    cCmdResponse  = MID_STRING(cDVDPlayerMessage,2,1);

    IF(cCommandBit == $05)
    {
	IF(nProjSourceSelection == SOURCE_DVD)
	{
	     fnSendString(dvCOMPDVDPlayer, "$22, $00, $0D") //Toggle the power
	}
    }
    //DEAL WITH CD AND DVD TYPE
    ELSE IF(cCommandBit == $11) 
    {
	IF(cCmdResponse == $02)
	{
	    //Disable Buttons on TP for CD Player
	    SEND_COMMAND dvTP_DVDPlayer, "'^BMF-44.49, 1&2, %EN0'";
	}
	IF(cCmdResponse == $01)
	{
	    //Disable Buttons on TP for CD Player
	    SEND_COMMAND dvTP_DVDPlayer, "'^BMF-44.49, 1&2, %EN1'";
	}
    }
    //PANEL BUTTONS FEEDBACK
    ELSE IF(cCommandBit == $12)
    {
	IF(cCmdResponse == $01)
	{
	    ON[dvTP_DVDPlayer, PLAY];
	}
	IF(cCmdResponse == $02)
	{
	    ON[dvTP_DVDPlayer, STOP]
	}
	IF(cCmdResponse == $03)
	{
	    ON[dvTP_DVDPlayer, PAUSE]
	}
	IF(cCmdResponse == $06)
	{
	    ON[dvTP_DVDPlayer, SREV]
	}
	IF(cCmdResponse == $07)
	{
	    ON[dvTP_DVDPlayer, SFWD]
	}
    }
    ELSE IF(cCommandBit == $06)
    {
	IF(nDVDCmdConfirm == MENU_FUNC) 
	{
	    PULSE[dvTP_DVDPlayer, MENU_FUNC]
	}
	IF(nDVDCmdConfirm == MENU_SELECT) 
	{
	    PULSE[dvTP_DVDPlayer, MENU_SELECT]
	}
	IF(nDVDCmdConfirm == MENU_UP) 
	{
	    PULSE[dvTP_DVDPlayer, MENU_UP]
	}
	IF(nDVDCmdConfirm == MENU_DN) 
	{
	    PULSE[dvTP_DVDPlayer, MENU_DN]
	}
	IF(nDVDCmdConfirm == MENU_RT) 
	{
	    PULSE[dvTP_DVDPlayer, MENU_RT]
	}
	IF(nDVDCmdConfirm == MENU_LT) 
	{
	    PULSE[dvTP_DVDPlayer, MENU_LT]
	}
	IF(nDVDCmdConfirm = FFWD) 
	{
	    PULSE[dvTP_DVDPlayer, FFWD]
	}
	IF(nDVDCmdConfirm = REW) 
	{
	    PULSE[dvTP_DVDPlayer, REW]
	}
    }
    ELSE
    {
	SEND_STRING 0, "'COMMAND ERROR - '"
    }
}



#END_IF