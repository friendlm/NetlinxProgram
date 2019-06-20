PROGRAM_NAME='Control Function Sony Camera'
#IF_NOT_DEFINED __CONTROL_FUNCTION_SONY_CAMERA__
#DEFINE __CONTROL_FUNCTION_SONY_CAMERA__

DEFINE_FUNCTION INTEGER fnSonyCameraPreset(CHAR cSonyCameraMessage[])
{
    LOCAL_VAR INTEGER nSonyCameraPresetNum;
    nSonyCameraPresetNum = ATOI(RIGHT_STRING(cSonyCameraMessage, 1))
    
    RETURN nSonyCameraPresetNum;
}

#END_IF 