PROGRAM_NAME='Control Function Video Switch'
#IF_NOT_DEFINED __CONTROL_FUNCTION_VIDEO_SWITCH__
#DEFINE __CONTROL_FUNCTION_VIDEO_SWITCH__

#INCLUDE 'Netlinx Professional Practice Constants'

DEFINE_FUNCTION fnParseVideoSwitchMessage(DEV dVideoSwitch,CHAR cVideoSwitchMessage[])
{
    LOCAL_VAR CHAR cCheckSum[1];
    LOCAL_VAR INTEGER nInputNum;
    LOCAL_VAR INTEGER nOutputNum;
    LOCAL_VAR INTEGER nButtonNum;
    
    cCheckSum  = RIGHT_STRING(cVideoSwitchMessage, 1);
    nOutputNum = ATOI(MID_STRING(cVideoSwitchMessage, 4, 1));
    
    IF (cCheckSum == 'S')
    {
	IF(LENGTH_ARRAY(cVideoSwitchMessage) == 8)
	{
	    nInputNum = ATOI(MID_STRING(cVideoSwitchMessage, 7, 1));
	}
	ELSE
	{
	    nInputNum = ATOI(MID_STRING(cVideoSwitchMessage, 7, 2));
	}
    }
    IF(cCheckSum == 'X')
    {
	SEND_STRING 0, "'COMMAND ERROR - ', cVideoSwitchMessage"
    }
    
    nButtonNum = nInputNum * 10 + nOutputNum;
    //BUTTON FEEDBACK CODE
    OFF[dVideoSwitch,  nVideoSwitchButtons[nOutputNum]]
    ON[dVideoSwitch, nButtonNum]
}

#END_IF