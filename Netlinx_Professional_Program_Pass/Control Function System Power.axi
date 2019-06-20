PROGRAM_NAME='Control Function System Power'
#IF_NOT_DEFINED __CONTROL_FUNCTION_SYSTEM_POWER__
#DEFINE __CONTROL_FUNCTION_SYSTEM_POWER__

#INCLUDE 'SNAPI'
#INCLUDE 'Netlinx Professional Practice Constants'
#INCLUDE 'Netlinx Professional Practice Devices'


DEFINE_CALL 'SYSTEM POWER ON'
{
    
    IF(!fnSysPowerStatus(dvRelayDevices))
    {
	ON[dvRelayDevices, RELAY_SYS_RACK_POWER]; 		//Turn Device Power Relay
	
	SET_PULSE_TIME(25)
	PULSE[dvRelayDevices, RELAY_SCREEN_DN]			//Lower Screen
	SET_PULSE_TIME(5)
	
	SEND_STRING dvVideoProj, "$02,$00,$00,$00,$00,$02"	//Turn on the video projector
	
	WAIT 10
	{
	    ON[dvRelayDevices, RELAY_SYS_APM_POWER]
	    WAIT 300
	    {
		//IF THE SOURCE INITIATED, THEN TURN THE SOURCE AND AMPLIFIER
		IF(nProjSourceSelection == SOURCE_SRECEIVER)
		{ 
		    //Power on HDMI - Satellite Receiver
		    ON[dvHDMIReceiver, POWER]
		    SEND_STRING dvVideoProj, "$02,$03,$00,$00,$02,$01,$01,$09";
		    //SEND_COMMAND dvTP_VideoProj, "'^TXT-', ITOA(TXT_SOURCE_INPUT), ',1&2,', 'HDMI'";
		}
		IF(nProjSourceSelection == SOURCE_DVD)
		{
		    //Power on Component - DVD/CD Player
		    SEND_STRING dvCOMPDVDPlayer, "$22, $00";
		    SEND_STRING dvVideoProj, "$02,$03,$00,$00,$02,$01,$11,$19";
		    //SEND_COMMAND dvTP_VideoProj, "'^TXT-',ITOA(TXT_SOURCE_INPUT), ',1&2,', 'COMPONENT'";
		}
		IF(nProjSourceSelection == SOURCE_SCAMERAS)
		{
		    //No need to power on the security switch
		    SEND_STRING dvVideoProj, "$02,$03,$00,$00,$02,$01,$06,$0E";
		    //SEND_COMMAND dvTP_VideoProj, "'^TXT-', ITOA(TXT_SOURCE_INPUT), ',1&2,', 'VIDEO'"
		}
		IF(nProjSourceSelection == SOURCE_CAMERA)
		{
		    //Power S-Video
		    ON[vdvSVIDCamera, PWR_ON];
		    SEND_STRING dvVideoProj, "$02,$03,$00,$00,$02,$01,$0B,$13";
		    //SEND_COMMAND dvTP_RoomControl, "'^TXT-', ITOA(TXT_SOURCE_INPUT), ',1&2,', 'S-VIDEO'"
		}
	    }
	}
	IF(!TIMELINE_ACTIVE(nTL_DVD_STATUS_POLLING))
	{
	    TIMELINE_CREATE(nTL_DVD_STATUS_POLLING, nTimeDVDStatus, LENGTH_ARRAY(nTimeDVDStatus), TIMELINE_ABSOLUTE, TIMELINE_REPEAT);
	}
    }
    ELSE
    {
	//Turn on the popup page "confirm"
	SEND_COMMAND dvTP_RoomControl, "'^PPG-Confirm'"
    }
    
}

DEFINE_CALL 'SYSTEM POWER OFF'
{
    SEND_STRING dvCOMPDVDPlayer, "$22, $00"; 		// Shutdown DVD Player
    OFF[dvHDMIReceiver, POWER]				// Shutdown Satellite Receiver
    SEND_STRING dvVideoProj, "$02,$01,$00,$00,$00,$03"	// Shutdown Video Projector
    OFF[vdvSVIDCamera, PWR_OFF]				// Shutdown local camera
    
    WAIT 20
    {
	//Raise the screen
	SET_PULSE_TIME(25)
	PULSE[dvRelayDevices, RELAY_SCREEN_UP]
	SET_PULSE_TIME(5)
	
	WAIT 40	// The 6th second
	{
	    OFF[dvRelayDevices, RELAY_SYS_APM_POWER];
	    WAIT 40
	    {
		OFF[dvRelayDevices, RELAY_SYS_RACK_POWER];
	    }
	}
    }
}

DEFINE_FUNCTION CHAR fnSysPowerStatus(DEV dMasterDev)
{
    IF([dMasterDev, RELAY_SYS_APM_POWER] && [dMasterDev, RELAY_SYS_RACK_POWER])
    {
	RETURN TRUE;
    }
    ELSE
    {
	RETURN FALSE;
    }
}

#END_IF