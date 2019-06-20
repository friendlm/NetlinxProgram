PROGRAM_NAME='main'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    Ming.liu3@harman.com	5/30/2019	initial version
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

//Define Physical Devices 
//dvVideoSwitch			= 5001:1:0	// Serial Interface #1 - Security Cameras
//dvVideoProj			= 5001:2:0	// Serial Interface #2 - Video Projector
//dvCOMPDVDPlayer		= 5001:3:0	// Serial Interface #3 - DVD/CD Player
//dvSVIDCamera			= 5001:4:0	// Serial Interface #4 - Camera Control
//
//dvHDMIReceiver		= 5001:11:0	// IR Interface     #11 - Satellite Receiver
//dvRelayDevices		= 5001:21:0	// Relay Device	    #21
//
//FOR TESTING
//dvVideoSwitch			= 8001:1:0	// Serial Interface #1 - Security Cameras
//dvVideoProj			= 8002:1:0	// Serial Interface #2 - Video Projector
//dvCOMPDVDPlayer		= 8003:1:0	// Serial Interface #3 - DVD/CD Player
//dvSVIDCamera			= 5001:4:0	// Serial Interface #4 - Camera Control
//dvHDMIReceiver		= 8005:1:0	// IR Interface     #11 - Satellite Receiver
//dvRelayDevices		= 5001:21:0	// Relay Device	    #21
//
//For Lighting Control
//dvLightControl		= 0:4:0
//
//TPD 5
//dvTP_RoomControl		= 10001:1:0	// Main Page
//dvTP_SVIDCamera		= 10001:10:0	// Camera Control
//dvTP_DVDPlayer		= 10001:11:0	// DVD Player
//dvTP_LightControl		= 10001:12:0	// Light Control
//dvTP_VideoProj		= 10001:13:0	// Room Control
//dvTP_HDMIReceiver		= 10001:14:0	// Satellite Receiver
//dvTP_VideoSwitch		= 10001:15:0	// Security Cameras
//
//Virtual Device for Sony Camera - EVID 100 
//vdvSVIDCamera			= 41001:1:0;
//vdvVirtualKeyPad		= 41002:1:0;


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
STRUCTURE _sLightStatus
{
    INTEGER	nLightIntensity;
    INTEGER	nFadeTime;
}
STRUCTURE _sLightZonePreset
{
    CHAR 	    cPresetName[255];
    _sLightStatus   sLightZones[4];	
}


DEFINE_VARIABLE
VOLATILE CHAR cVideoProjCmds[10][8];
VOLATILE CHAR cDVDPlayerCmds[16][3];

VOLATILE _sLightZonePreset	sLightPresetScene[3];

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
#INCLUDE 'Netlinx Professional Practice Libraries'
DEFINE_MODULE 'Sony_EVID100_Comm_dr1_0_0' SonyCamera(vdvSVIDCamera, dvSVIDCamera)
DEFINE_MODULE 'VirtualKeypad_dr1_0_0'  VirtualKeyPad (vdvVirtualKeyPad, vdvVirtualKeyPad)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
#WARN 'I Spend 16 Hours on this program'
#WARN 'System Requ ver:  Device Specs ver: v2.2; VideoFlow ver: Connector Detail ver: ControlSingleLines ver:'
#WARN 'Code tested on master / contrlller type NX2200 with firmware version: 1.5.78' 
//CODE FOR BUTTON FEEDBACK GOES HERE
TIMELINE_CREATE(nTL_BTN_FB, nTimeButtonFb, LENGTH_ARRAY(nTimeButtonFb), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
//LOAD VIDEO PROJECTOR COMMANDS
{
    cVideoProjCmds[1] = "$02,$00,$00,$00,$00,$02" 		// Power on
    cVideoProjCmds[2] = "$02,$01,$00,$00,$00,$03"		// Power off
    cVideoProjCmds[3] = "$02,$03,$00,$00,$02,$01,$01,$09"	// Input Select HDMI - S RECEIVER
    cVideoProjCmds[4] = "$02,$03,$00,$00,$02,$01,$11,$19"	// Input Select Component - DVD
    cVideoProjCmds[5] = "$02,$03,$00,$00,$02,$01,$06,$0E"	// Input Select Video Switch
    cVideoProjCmds[6] = "$02,$03,$00,$00,$02,$01,$0B,$13"	// Input Select S-video - Camera
    cVideoProjCmds[7] = "$02,$10,$00,$00,$00,$12"		// Picture Mute ON 
    cVideoProjCmds[8] = "$02,$11,$00,$00,$00,$13"		// Picture Mute OFF 
    cVideoProjCmds[9] = "$03,$8C,$00,$00,$00,$8F"		// LAMP Information
    cVideoProjCmds[10]= "$00,$85,$00,$D0,$01,$01,$57"		// Running Status Requext
}

{
    //As the document specification, all commands and response are returned by a carriage return
    //the carriage return is "$0d"
    cDVDPlayerCmds[1]  = "$20,$21,$0d"		//PLAY, CARRAGE RETURN?
    cDVDPlayerCmds[2]  = "$20,$20,$0d"		//STOP
    cDVDPlayerCmds[3]  = "$20,$22,$0d"		//PAUSE
    cDVDPlayerCmds[4]  = "$20,$34,$0d"		//Skip Forward   - FFWD 
    cDVDPlayerCmds[5]  = "$20,$33,$0d"		//Skip Reverse	 - REW  
    cDVDPlayerCmds[6]  = "$20,$32,$0d"		//Search Forward - SFWD
    cDVDPlayerCmds[7]  = "$20,$31,$0d"		//Search Reverse - SREV
    //COMMAND FOR DVD ONLY
    cDVDPlayerCmds[8]  = "$24,$2A,$0d"		//MENU_FUNC - Channel #44
    cDVDPlayerCmds[9]  = "$24,$2C,$0d"		//MENU_UP   - Channel #45
    cDVDPlayerCmds[10] = "$24,$2D,$0d"		//MENU_DN   - Channel #46
    cDVDPlayerCmds[11] = "$24,$2E,$0d"		//MENU_RT   - Channel #48
    cDVDPlayerCmds[12] = "$24,$2F,$0d"		//MENU_LT   - Channel #47
    cDVDPlayerCmds[13] = "$24,$2B,$0d"		//MENU_SELECT - Channel #49
    
    cDVDPlayerCmds[14] = "$21,$11,$0d"		//Disk Type Inqury
    cDVDPlayerCmds[15] = "$21,$12,$0d"		//Transport Status Inquiry
    cDVDPlayerCmds[16] = "$22,$00,$0d"		//Power Toggle
}

{
    //LIGHT CONTROL INITIALIZATION
    STACK_VAR INTEGER nPreset;
    STACK_VAR INTEGER nZones;
    
    FOR(nPreset=0;nPreset<=LIGHT_PRESET_NUMBERS; nPreset++)
    {
	sLightPresetScene[nPreset].cPresetName = "'PRESET SCENE ', ITOA(nPreset)";
	FOR(nZones=0;nZones<=LIGHT_ZONE_NUMBERS; nZones++)
	{
	    sLightPresetScene[nPreset].sLightZones[nZones].nFadeTime = 5;
	    sLightPresetScene[nPreset].sLightZones[nZones].nLightIntensity = 100 - 10*nPreset;
	}
    }
}

{
    //nTL_LIGHT_CONN_STATUS
    fnReadIPAddressFromFile(sLightIPAddressFile)
    CREATE_BUFFER dvLightControl, cLightDevBuffer;
    TIMELINE_CREATE(nTL_LIGHT_CONN_STATUS, nTimeLightStatus, LENGTH_ARRAY(nTimeLightStatus), TIMELINE_ABSOLUTE, TIMELINE_REPEAT);
}

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
TIMELINE_EVENT[nTL_BTN_FB]
{
    // BUTTONS FEEDBACK ON MAIN PAGE
    [dvTP_RoomControl, BTN_ROOM_SSEL_DVD]	= (nProjSourceSelection == SOURCE_DVD);
    [dvTP_RoomControl, BTN_ROOM_SSEL_CAMERA]	= (nProjSourceSelection == SOURCE_CAMERA);
    [dvTP_RoomControl, BTN_ROOM_SSEL_SRECEIVER]	= (nProjSourceSelection == SOURCE_SRECEIVER);
    [dvTP_RoomControl, BTN_ROOM_SSEL_SCAMERAS]	= (nProjSourceSelection == SOURCE_SCAMERAS);
    [dvTP_RoomControl,  BTN_ROOM_SYS_POWER_ON]  = (fnSysPowerStatus(dvRelayDevices));
    
    //VIRTUAL KEYPAD FEEDBACK
    [vdvVirtualKeyPad, VIR_BTN_DVD]		= (nProjSourceSelection == SOURCE_DVD);
    [vdvVirtualKeyPad, VIR_BTN_CAMERA]		= (nProjSourceSelection == SOURCE_CAMERA);
    [vdvVirtualKeyPad, VIR_BTN_SRECEIVER]	= (nProjSourceSelection == SOURCE_SRECEIVER);
    [vdvVirtualKeyPad, VIR_BTN_SWITCH]		= (nProjSourceSelection == SOURCE_SCAMERAS);
    [vdvVirtualKeyPad, VIR_BTN_SYS_POWER]	= (fnSysPowerStatus(dvRelayDevices));
    
    [dvTP_VideoProj, BTN_SOURCE_HDMI]		= (nProjSourceSelection == SOURCE_SRECEIVER);
    [dvTP_VideoProj, BTN_SOURCE_SVIDEO]		= (nProjSourceSelection == SOURCE_CAMERA);
    [dvTP_VideoProj, BTN_SOURCE_VIDEO]		= (nProjSourceSelection == SOURCE_SCAMERAS);
    [dvTP_VideoProj, BTN_SOURCE_COMP]		= (nProjSourceSelection == SOURCE_DVD);
    
    //SCREEN RELAY FEEDBACK
    [dvTP_RoomControl, BTN_ROOM_SCREEN_UP] 	= (nScreenStatus == RELAY_SCREEN_UP);
    [dvTP_RoomControl, BTN_ROOM_SCREEN_DN] 	= (nScreenStatus == RELAY_SCREEN_DN);
    [dvTP_RoomControl, BTN_ROOM_SCREEN_STOP] 	= (nScreenStatus == RELAY_SCREEN_STOP);

    //SONY CAMEAR CONTROL FEEDBACK
    [dvTP_SVIDCamera, TILT_UP_FB] 		= [vdvSVIDCamera, TILT_UP];
    [dvTP_SVIDCamera, TILT_DN_FB] 		= [vdvSVIDCamera, TILT_DN];
    [dvTP_SVIDCamera, PAN_LT_FB] 		= [vdvSVIDCamera, PAN_LT];
    [dvTP_SVIDCamera, PAN_RT_FB] 		= [vdvSVIDCamera, PAN_RT];
    [dvTP_SVIDCamera, ZOOM_OUT_FB] 		= [vdvSVIDCamera, ZOOM_OUT];
    [dvTP_SVIDCamera, ZOOM_IN_FB] 		= [vdvSVIDCamera, ZOOM_IN];
    
    //HDMI RECEIVER FEEDBACK
    [dvTP_HDMIReceiver, HDMI_PRESET_ONE]	= (nHDMIPresetNum == 1);
    [dvTP_HDMIReceiver, HDMI_PRESET_TWO]	= (nHDMIPresetNum == 2);
    [dvTP_HDMIReceiver, HDMI_PRESET_THREE]	= (nHDMIPresetNum == 3);
    [dvTP_HDMIReceiver, HDMI_PRESET_FOUR]	= (nHDMIPresetNum == 4);
    [dvTP_HDMIReceiver, HDMI_PRESET_FIVE]	= (nHDMIPresetNum == 5);
    [dvTP_HDMIReceiver, HDMI_PRESET_SIX]	= (nHDMIPresetNum == 6);
    
}

(*****************************************************************)
(*                     CODE FOR ROOM CONTROL                     *)
(*****************************************************************)
BUTTON_EVENT[dvTP_RoomControl,0]
{
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	    CASE BTN_ROOM_LIGHT_CONTROL:
	    {
		TO[dvTP_RoomControl,BTN_ROOM_LIGHT_CONTROL]
	    }
	    CASE BTN_ROOM_SSEL_DVD:
	    {
		nProjSourceSelection = SOURCE_DVD;
		IF(!fnSysPowerStatus(dvRelayDevices))
		{
		    CALL 'SYSTEM POWER ON'
		}
		ELSE
		{
		    fnSendString(dvVideoProj, cVideoProjCmds[4])
		}
		BREAK;
	    }
	    CASE BTN_ROOM_SSEL_CAMERA:
	    {
		nProjSourceSelection = SOURCE_CAMERA;
		IF(!fnSysPowerStatus(dvRelayDevices))
		{
		    CALL 'SYSTEM POWER ON'
		}
		ELSE
		{
		    fnSendString(dvVideoProj, cVideoProjCmds[6])
		}
		BREAK;
	    }
	    CASE BTN_ROOM_SSEL_SRECEIVER:
	    {
		nProjSourceSelection = SOURCE_SRECEIVER;
		IF(!fnSysPowerStatus(dvRelayDevices))
		{
		    CALL 'SYSTEM POWER ON'
		}
		ELSE
		{
		    fnSendString(dvVideoProj, cVideoProjCmds[3])
		}
		BREAK;
	    }
	    CASE BTN_ROOM_SSEL_SCAMERAS:
	    {
		nProjSourceSelection = SOURCE_SCAMERAS;
		IF(!fnSysPowerStatus(dvRelayDevices))
		{
		    CALL 'SYSTEM POWER ON'
		}
		ELSE
		{
		    fnSendString(dvVideoProj, cVideoProjCmds[5])
		}
		BREAK;
	    }
	    CASE BTN_ROOM_CONTROL:
	    {
		TO[dvTP_RoomControl, BTN_ROOM_CONTROL]
		BREAK;
	    }
	    CASE BTN_ROOM_SYS_POWER_ON:
	    {
		CALL 'SYSTEM POWER ON'
		BREAK;
	    }
	    CASE BTN_ROOM_SYS_POWER_OFF:
	    {
		CALL 'SYSTEM POWER OFF'
		BREAK;
	    }
	    
	    CASE BTN_ROOM_SCREEN_UP:
	    {
		ON[dvRelayDevices,RELAY_SCREEN_UP]
		WAIT 25
		{
		    OFF[dvRelayDevices,RELAY_SCREEN_UP]
		}
	    }
	    CASE BTN_ROOM_SCREEN_DN:
	    {
		ON[dvRelayDevices,RELAY_SCREEN_DN]
		WAIT 25
		{
		    OFF[dvRelayDevices,RELAY_SCREEN_DN]
		}
	    }
	    CASE BTN_ROOM_SCREEN_STOP:
	    {
		ON[dvRelayDevices,RELAY_SCREEN_STOP]
		WAIT 5
		{
		    OFF[dvRelayDevices,RELAY_SCREEN_STOP]
		}
	    }
	}
    }
}
CHANNEL_EVENT[dvRelayDevices, RELAY_SCREEN_UP]
{
    ON:
    {
	nScreenStatus = RELAY_SCREEN_UP;
    }
    OFF:
    {
	nScreenStatus = RELAY_CHANNEL_OFF
    }
}
CHANNEL_EVENT[dvRelayDevices, RELAY_SCREEN_DN]
{
    ON:
    {
	nScreenStatus = RELAY_SCREEN_DN;
    }
    OFF:
    {
	nScreenStatus = RELAY_CHANNEL_OFF
    }
}
CHANNEL_EVENT[dvRelayDevices, RELAY_SCREEN_STOP]
{
    ON:
    {
	nScreenStatus = RELAY_SCREEN_STOP;
    }
    OFF:
    {
	nScreenStatus = RELAY_CHANNEL_OFF
    }
}

(*****************************************************************)
(*              CODE FOR VIDEO PROJECTOR CONTROL                 *)
(*****************************************************************)
DATA_EVENT[dvVideoProj]
{
    ONLINE:
    {
	SEND_COMMAND dvVideoProj, "'SET BAUD 38400,N,8,1'"
	SEND_COMMAND dvVideoProj, "'HSOFF'" // No hardware shaking
    }
    STRING:
    {
	LOCAL_VAR CHAR cLampInformation[9] 
	
	cLampInformation = DATA.TEXT
	fnParseVideoProjEventMassage(dvTP_VideoProj, cLampInformation); 
    }
}

BUTTON_EVENT[dvTP_VideoProj, 0]
{
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	    CASE BTN_SOURCE_HDMI:
	    {
		fnSendString(dvVideoProj, cVideoProjCmds[3])
		//UPDATE BUTTON STATUS ACCORDING TO THE CONFIRMATION
	    }
	    CASE BTN_SOURCE_SVIDEO:
	    {
		fnSendString(dvVideoProj, cVideoProjCmds[6])
	    }
	    CASE BTN_SOURCE_VIDEO:
	    {
		fnSendString(dvVideoProj, cVideoProjCmds[5])
	    }
	    CASE BTN_SOURCE_COMP:
	    {
		fnSendString(dvVideoProj, cVideoProjCmds[4])
	    }	
	    CASE BTN_PROJ_POWER:
	    {
		//IF(nVideoProjPowerStatus == TRUE)
		IF((cProjRunningStatus != $05) && (cProjRunningStatus != $03) && (cProjRunningStatus == $00))
		{
		    //POWER ON VIDEO PROJECTOR 
		    fnSendString(dvVideoProj, cVideoProjCmds[1])
		}
		IF((cProjRunningStatus != $05) && (cProjRunningStatus != $03) && (cProjRunningStatus == $04))
		{
		     fnSendString(dvVideoProj, cVideoProjCmds[2])
		}
		//TIME LINE TO POLLING LAMP HOUR EVERY 30 SECOND
		//UPDATE TXT PART
		IF(!TIMELINE_ACTIVE(nTL_POLLING_PROJ_STATUS))
		{
		    TIMELINE_CREATE(nTL_POLLING_PROJ_STATUS, nTimeProjStatus, LENGTH_ARRAY(nTimeProjStatus), TIMELINE_ABSOLUTE, TIMELINE_REPEAT);
		}
		ELSE
		{
		    SEND_STRING 0, "'Timeline has been created ', ITOA(nTL_POLLING_PROJ_STATUS)"
		}
	    }
	}
    }
}
TIMELINE_EVENT[nTL_POLLING_PROJ_STATUS]
{
    fnSendString(dvVideoProj, cVideoProjCmds[9])
    fnSendString(dvVideoProj, cVideoProjCmds[10])
    
    IF(cProjRunningStatus == $04) //POWER ON
    {
	STACK_VAR LONG nRunningHours;
	
	nRunningHours = nProjRunningTime / 3600;
	SEND_COMMAND dvTP_VideoProj, "'^TXT-', ITOA(TXT_LAMP_RUN_HOURS), ',1&2,', ITOA(nRunningHours)"
    }
    IF(cProjRunningStatus == $03) //Warming up
    {
	SEND_COMMAND dvTP_VideoProj, "'^TXT-', ITOA(TXT_WARM_UP_TIME), ',1&2,', ITOA(nProjRunningTime)"
    }
    IF(cProjRunningStatus == $05) //Cooling Down
    {
	SEND_COMMAND dvTP_VideoProj, "'^TXT-', ITOA(TXT_COOL_DOWN_TIME), ',1&2,', ITOA(nProjRunningTime)"
    }
}
(*****************************************************************)
(*              CODE FOR DVD PLAYER  CONTROL                     *)
(*****************************************************************)
DATA_EVENT[dvCOMPDVDPlayer]
{
    ONLINE:
    {
	SEND_COMMAND dvCOMPDVDPlayer, "'SET BAUD 9600,N,8,1'"
	SEND_COMMAND dvCOMPDVDPlayer, "'HSOFF'"
    }
    STRING:
    {
	LOCAL_VAR CHAR cDVDPlayerMessage[3];
	
	cDVDPlayerMessage = DATA.TEXT;
	SEND_STRING 0, "'DVD MESSAGES .... ', cDVDPlayerMessage";
	fnDealwithDVDPlayerMessage(cDVDPlayerMessage)
    }
}
//Timeline has been created in projector function file.
TIMELINE_EVENT[nTL_DVD_STATUS_POLLING]
{
    fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[15])
}

BUTTON_EVENT[dvTP_DVDPlayer, 0]
{
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	    CASE PLAY:
	    {
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[1])
		nDVDCmdConfirm = PLAY;
		BREAK;
	    }
	    CASE STOP:
	    {
		nDVDCmdConfirm = STOP;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[2])
		BREAK;
	    }
	    CASE PAUSE:
	    {
		nDVDCmdConfirm = PAUSE;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[3]);
		BREAK;
	    }
	    CASE FFWD:
	    {
		//USING VARIABLE FEEDBACK FOR DVD-ONLY BUTTONS
		nDVDCmdConfirm = FFWD;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[4]);
		
		BREAK;
	    }
	    CASE REW:
	    {
		nDVDCmdConfirm = REW;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[5]);
		
		BREAK;
	    }
	    CASE SFWD:
	    {
		nDVDCmdConfirm = SFWD;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[6]);
		
		BREAK;
	    }
	    CASE SREV:
	    {
		nDVDCmdConfirm = SREV;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[7]);
		
		BREAK;
	    }
	    CASE MENU_FUNC:
	    {
		nDVDCmdConfirm = MENU_FUNC;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[8]);
		
		BREAK;
	    }
	    CASE MENU_UP:
	    {
		nDVDCmdConfirm = MENU_UP
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[9]);
		
		BREAK;
	    }
	    CASE MENU_DN:
	    {
		nDVDCmdConfirm = MENU_DN;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[10])
		
		BREAK;
	    }
	    CASE MENU_LT:
	    {
		nDVDCmdConfirm = MENU_LT;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[12])
		
		BREAK;
	    }
	    CASE MENU_RT:
	    {
		nDVDCmdConfirm = MENU_RT;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[11])
		BREAK;
		
		
	    }
	    CASE MENU_SELECT:
	    {
		nDVDCmdConfirm = MENU_SELECT;
		fnSendString(dvCOMPDVDPlayer, cDVDPlayerCmds[13])
		BREAK;
	    }
	}
    }
}

(*****************************************************************)
(*              CODE FOR SONY CAMERA MODULE                      *)
(*****************************************************************)
DATA_EVENT[vdvSVIDCamera]
{
    ONLINE:
    {
	SEND_COMMAND vdvSVIDCamera, "'SET BAUD 9600,N,8,1'"
    }
    STRING:
    {
	LOCAL_VAR CHAR cDVDFBString[14];
	LOCAL_VAR CHAR cDVDPresetValue[1];
	LOCAL_VAR INTEGER nBTNChannelNum;
	
	cDVDFBString    = DATA.TEXT;
	cDVDPresetValue = MID_STRING(cDVDFBString,14,1);
	nBTNChannelNum  = ATOI(cDVDPresetValue) + 260;
	ON[dvTP_SVIDCamera, nBTNChannelNum];
    }
}

//Buttons for Sony Camera, feedback provide by channel
BUTTON_EVENT[dvTP_SVIDCamera, 0]
{
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	    CASE TILT_UP:
	    {
		TO[vdvSVIDCamera, TILT_UP];	//When press - ON, release - OFF
		BREAK;
	    }
	    CASE TILT_DN:
	    {
		TO[vdvSVIDCamera, TILT_DN];
		BREAK;
	    }
	    CASE PAN_LT:
	    {
		TO[vdvSVIDCamera, PAN_LT];
		BREAK;
	    }
	    CASE PAN_RT:
	    {
		TO[vdvSVIDCamera, PAN_RT];
		BREAK;
	    }
	    CASE ZOOM_OUT:
	    {
		TO[vdvSVIDCamera, ZOOM_OUT];
		BREAK;
	    }
	    CASE ZOOM_IN:
	    {
		TO[vdvSVIDCamera, ZOOM_IN];
		BREAK;
	    }
	    CASE BTN_PRESET_ONE:
	    {
		SEND_STRING vdvSVIDCamera, "'CAMERAPRESET-1'";
		BREAK;
	    }
	    CASE BTN_PRESET_TWO:
	    {
		SEND_STRING vdvSVIDCamera, "'CAMERAPRESET-2'";
		BREAK;
	    }
	    CASE BTN_PRESET_THREE:
	    {
		SEND_STRING vdvSVIDCamera, "'CAMERAPRESET-3'";
		BREAK;
	    }
	}
    }
}
LEVEL_EVENT[dvTP_SVIDCamera, FOCUS_LVL]
{
    LOCAL_VAR INTEGER nLVLValue;
    
    nLVLValue = LEVEL.VALUE;
    SEND_LEVEL vdvSVIDCamera, FOCUS_LVL, nLVLValue;
}
LEVEL_EVENT[vdvSVIDCamera, FOCUS_LVL]
{
    LOCAL_VAR INTEGER nLVLValue;
    
    nLVLValue = LEVEL.VALUE;
    SEND_LEVEL dvTP_SVIDCamera, FOCUS_LVL, nLVLValue;
}

(*****************************************************************)
(*              CODE FOR HDMI SATELLITE RECEIVER                 *)
(*****************************************************************)
DATA_EVENT[dvHDMIReceiver]
{
    ONLINE:
    {
	SEND_COMMAND dvHDMIReceiver, "'SET MODE IR'";
	SEND_COMMAND dvHDMIReceiver, "'CARON'"
	SEND_COMMAND dvHDMIReceiver, "'CTOF',2"
	SEND_COMMAND dvHDMIReceiver, "'CTON',3"
	
	SEND_COMMAND dvHDMIReceiver, "'XCHM-1'";
    }
}
BUTTON_EVENT[dvTP_HDMIReceiver, 0]
{
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	    CASE BTN_HDMI_CHANNEL_UP:
	    {
		PULSE[dvHDMIReceiver, CHAN_UP]
	    }
	    CASE BTN_HDMI_CHANNEL_DN:
	    {
		PULSE[dvHDMIReceiver, CHAN_DN]
	    }
	    CASE HDMI_PRESET_ONE:
	    {
		nHDMIPresetNum = 1;
		SEND_COMMAND dvHDMIReceiver,"'XCH ', ITOA(nSReceiverChannels[1])";
	    }	    
	    CASE HDMI_PRESET_TWO:
	    {
		nHDMIPresetNum = 2;
		SEND_COMMAND dvHDMIReceiver,"'XCH ', ITOA(nSReceiverChannels[2])";
	    }
	    CASE HDMI_PRESET_THREE:
	    {
		nHDMIPresetNum = 3;
		SEND_COMMAND dvHDMIReceiver,"'XCH ', ITOA(nSReceiverChannels[3])";
	    }	    
	    CASE HDMI_PRESET_FOUR:	
	    {
		nHDMIPresetNum = 4;
		SEND_COMMAND dvHDMIReceiver,"'XCH ', ITOA(nSReceiverChannels[4])";
	    }
	    CASE HDMI_PRESET_FIVE:
	    {
		nHDMIPresetNum = 5;
		SEND_COMMAND dvHDMIReceiver,"'XCH ', ITOA(nSReceiverChannels[5])";
	    }
	    CASE HDMI_PRESET_SIX:
	    {
		nHDMIPresetNum = 6;
		SEND_COMMAND dvHDMIReceiver,"'XCH ', ITOA(nSReceiverChannels[6])";
	    }
	}
    }
}

CHANNEL_EVENT[dvHDMIReceiver, CHAN_UP]
{
    ON:
    {
	ON[dvTP_HDMIReceiver, BTN_HDMI_CHANNEL_UP];
    }
    OFF:
    {
	OFF[dvTP_HDMIReceiver, BTN_HDMI_CHANNEL_UP];
    }
}

CHANNEL_EVENT[dvHDMIReceiver, CHAN_DN]
{
    ON:
    {
	ON[dvTP_HDMIReceiver, BTN_HDMI_CHANNEL_DN];
    }
    OFF:
    {
	OFF[dvTP_HDMIReceiver, BTN_HDMI_CHANNEL_DN];
    }
}




(*****************************************************************)
(*              CODE FOR SWITCH - SECURITY CAMERAS               *)
(*****************************************************************)
DATA_EVENT[dvVideoSwitch]
{
    ONLINE:
    {
	SEND_COMMAND dvVideoSwitch, "'SET BAUD 9600,N,8,1'"
	SEND_COMMAND dvVideoSwitch, "'HSOFF'" //Disable HW Handshaking
    }
    STRING:
    {
	LOCAL_VAR CHAR cVideoSwitchMessage[9]
	
	cVideoSwitchMessage = DATA.TEXT;
	fnParseVideoSwitchMessage(dvTP_VideoSwitch, cVideoSwitchMessage)
    }
}
BUTTON_EVENT[dvTP_VideoSwitch,0]
{	
    PUSH:
    {
	LOCAL_VAR INTEGER nButtonNumber;
	LOCAL_VAR INTEGER nInputPortNum;
	LOCAL_VAR INTEGER nOutputPortNum;
	
	nButtonNumber  = BUTTON.INPUT.CHANNEL;
	nInputPortNum  = nButtonNumber / 10;
	nOutputPortNum = nButtonNumber % 10;
	
	//SEND_STRING dvVideoSwitch, "ITOA(nInputPortNum), '*', ITOA(nOutputPortNum), 'S'";
	fnSendString(dvVideoSwitch, "ITOA(nInputPortNum), '*', ITOA(nOutputPortNum), 'S'");
	fnSendString(dvVideoProj, cVideoProjCmds[5]);
    }
}
(*****************************************************************)
(*              CODE FOR LIGHT CONTROL - IP CONNECTION           *)
(*****************************************************************)

DATA_EVENT[dvLightControl]
{
    ONLINE:
    {
	bLightIPConnection = TRUE;
    }
    OFFLINE:
    {
	bLightIPConnection = FALSE;
	IF(!TIMELINE_ACTIVE(nTL_LIGHT_CONN_STATUS))
	{
	    TIMELINE_CREATE(nTL_LIGHT_CONN_STATUS, nTimeLightStatus, LENGTH_ARRAY(nTimeLightStatus), TIMELINE_ABSOLUTE, TIMELINE_REPEAT);
	}
	ELSE
	{
	    TIMELINE_SET(nTL_LIGHT_CONN_STATUS, nTimeLightStatus[1] - 10000);
	}
    }
    ONERROR:
    {
	IF(!TIMELINE_ACTIVE(nTL_LIGHT_CONN_STATUS))
	{
	    TIMELINE_CREATE(nTL_LIGHT_CONN_STATUS, nTimeLightStatus, LENGTH_ARRAY(nTimeLightStatus), TIMELINE_ABSOLUTE, TIMELINE_REPEAT);
	}
	ELSE
	{
	    AMX_LOG(AMX_ERROR,"'dvIP_ROKU:onerror ->',fnIPConnectionError(data.number)");
	    SWITCH (data.number)
	    {
		case 7:
		{
		    TIMELINE_SET(nTL_LIGHT_CONN_STATUS, nTimeLightStatus[1] - 1000);
		}
		default:
		{
		    TIMELINE_SET(nTL_LIGHT_CONN_STATUS, 0);
		}
	    }
	}
    }
    STRING:
    {
	STACK_VAR CHAR cLightMessages[12];
	
	cLightMessages = DATA.TEXT;
	fnDealwithLightMessages(cLightMessages);
    }
}
TIMELINE_EVENT[nTL_LIGHT_CONN_STATUS]
{
    IF(bLightIPConnection == FALSE)
    {
	IP_CLIENT_OPEN(dLightDevice.PORT, sLightsIPAddress, nLightsPortNum, IP_TCP)
    }
}

BUTTON_EVENT[dvTP_LightControl, 0]
{
    PUSH:
    {
	SWITCH(BUTTON.INPUT.CHANNEL)
	{
	    CASE BTN_ZONE_ONE_UP:
	    {
		TO[dvTP_LightControl, BTN_ZONE_ONE_UP];
		SEND_STRING dvLightControl, "'RAISEDIM,[1:1]',$0D"
	    }
	    CASE BTN_ZONE_ONE_DN:
	    {
		TO[dvTP_LightControl, BTN_ZONE_ONE_DN];
		SEND_STRING dvLightControl, "'LOWERDIM,[1:1]',$0D"
	    }
	    CASE BTN_ZONE_TWO_UP:
	    {
		TO[dvTP_LightControl, BTN_ZONE_TWO_UP];
		SEND_STRING dvLightControl, "'RAISEDIM,[1:2]',$0D"
	    }
	    CASE BTN_ZONE_TWO_DN:
	    {
		TO[dvTP_LightControl, BTN_ZONE_TWO_DN];
		SEND_STRING dvLightControl, "'LOWERDIM,[1:2]',$0D"
	    }
	    
	    CASE BTN_ZONE_THREE_UP:
	    {
		TO[dvTP_LightControl, BTN_ZONE_THREE_UP];
		SEND_STRING dvLightControl, "'RAISEDIM,[1:3]',$0D"
	    }
	    CASE BTN_ZONE_THREE_DN:
	    {
		TO[dvTP_LightControl, BTN_ZONE_THREE_DN];
		SEND_STRING dvLightControl, "'LOWERDIM,[1:3]',$0D"
	    }
	    
	    CASE BTN_ZONE_FOUR_UP:
	    {
		TO[dvTP_LightControl, BTN_ZONE_FOUR_UP];
		SEND_STRING dvLightControl, "'RAISEDIM,[1:4]',$0D"
	    }
	    CASE BTN_ZONE_FOUR_DN:
	    {
		TO[dvTP_LightControl, BTN_ZONE_FOUR_DN];
		SEND_STRING dvLightControl, "'LOWERDIM,[1:4]',$0D"
	    }
	    
	    CASE BTN_SCENE_ONE:
	    {
		ON[dvTP_LightControl, BTN_SCENE_ONE];
		SEND_COMMAND dvTP_LightControl, "'^TXT-', ITOA(TXT_LIGHT_SCENE_SEL), ',1&2,', sLightPresetScene[1].cPresetName"
		
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[1].sLightZones[1].nLightIntensity), ',', ITOA(sLightPresetScene[1].sLightZones[1].nFadeTime), ',[1:1]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[1].sLightZones[2].nLightIntensity), ',', ITOA(sLightPresetScene[1].sLightZones[2].nFadeTime), ',[1:2]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[1].sLightZones[3].nLightIntensity), ',', ITOA(sLightPresetScene[1].sLightZones[3].nFadeTime), ',[1:3]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[1].sLightZones[4].nLightIntensity), ',', ITOA(sLightPresetScene[1].sLightZones[4].nFadeTime), ',[1:4]',$0D"
	    }
	    CASE BTN_SCENE_TWO:
	    {
		ON[dvTP_LightControl, BTN_SCENE_TWO];
		SEND_COMMAND dvTP_LightControl, "'^TXT-', ITOA(TXT_LIGHT_SCENE_SEL), ',1&2,', sLightPresetScene[2].cPresetName"
		
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[2].sLightZones[1].nLightIntensity), ',', ITOA(sLightPresetScene[2].sLightZones[1].nFadeTime), ',[1:1]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[2].sLightZones[2].nLightIntensity), ',', ITOA(sLightPresetScene[2].sLightZones[2].nFadeTime), ',[1:2]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[2].sLightZones[3].nLightIntensity), ',', ITOA(sLightPresetScene[2].sLightZones[3].nFadeTime), ',[1:3]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[2].sLightZones[4].nLightIntensity), ',', ITOA(sLightPresetScene[2].sLightZones[4].nFadeTime), ',[1:4]',$0D"
	    }
	    CASE BTN_SCENE_THREE:
	    {
		ON[dvTP_LightControl, BTN_SCENE_THREE];
		SEND_COMMAND dvTP_LightControl, "'^TXT-', ITOA(TXT_LIGHT_SCENE_SEL), ',1&2,', sLightPresetScene[3].cPresetName"
		
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[3].sLightZones[1].nLightIntensity), ',', ITOA(sLightPresetScene[3].sLightZones[1].nFadeTime), ',[1:1]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[3].sLightZones[2].nLightIntensity), ',', ITOA(sLightPresetScene[3].sLightZones[2].nFadeTime), ',[1:2]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[3].sLightZones[3].nLightIntensity), ',', ITOA(sLightPresetScene[3].sLightZones[3].nFadeTime), ',[1:3]',$0D"
		SEND_STRING dvLightControl, "'FADEDIM,', ITOA(sLightPresetScene[3].sLightZones[4].nLightIntensity), ',', ITOA(sLightPresetScene[3].sLightZones[4].nFadeTime), ',[1:4]',$0D"
	    }
	}
    }
}
(*****************************************************************)
(*             Write MAC Address for Panel Device                *)
(*****************************************************************)
DATA_EVENT[dvTP_RoomControl]
{
    ONLINE:
    {
	SEND_COMMAND dvTP_RoomControl, "'?MAC'";
    }
}

CUSTOM_EVENT[dvTP_RoomControl, CUSTOM_EVENT_ID, CUSTOM_EVENT_TYPE]
{
    LOCAL_VAR CHAR cFileWriteCont[255]
    
    cFileWriteCont  = "ITOA(dvTP_RoomControl.NUMBER),':', ITOA(dvTP_RoomControl.PORT), ':', ITOA(dvTP_RoomControl.SYSTEM),',', custom.text,',', DATE,' ', TIME"
    fnWriteMACAddressToFile(dvTP_RoomControl, cFileWriteCont)
}
(*****************************************************************)
(*            Code for Virtual Keypad                            *)
(*****************************************************************)
DATA_EVENT[vdvVirtualKeyPad]
{
    online:
    {
	fnSetVirtualKeypadButtonName();
    }
}

BUTTON_EVENT[vdvVirtualKeyPad, nVirtualButtons]
{
    PUSH:
    {
	STACK_VAR INTEGER nVirtualKey;
	nVirtualKey = GET_LAST(nVirtualButtons);
	
	IF(nVirtualKey == VIR_BTN_DVD)
	{
	    nProjSourceSelection = SOURCE_DVD;
	    SEND_COMMAND dvTP_RoomControl, "'^PPG-DVDCD Player'"
	    IF(!fnSysPowerStatus(dvRelayDevices))
	    {
		CALL 'SYSTEM POWER ON'
	    }
	    ELSE
	    {
		fnSendString(dvVideoProj, cVideoProjCmds[4])
	    }
	}
	ELSE IF(nVirtualKey == VIR_BTN_CAMERA)
	{
	    nProjSourceSelection = SOURCE_CAMERA;
	    SEND_COMMAND dvTP_RoomControl, "'^PPG-Camera Control'"
	    IF(!fnSysPowerStatus(dvRelayDevices))
	    {
		CALL 'SYSTEM POWER ON'
	    }
	    ELSE
	    {
		fnSendString(dvVideoProj, cVideoProjCmds[6])
	    }
	}
	ELSE IF(nVirtualKey == VIR_BTN_SRECEIVER)
	{
	    nProjSourceSelection = SOURCE_SRECEIVER;
	    SEND_COMMAND dvTP_RoomControl, "'^PPG-Satellite Receiver'"
	    IF(!fnSysPowerStatus(dvRelayDevices))
	    {
		CALL 'SYSTEM POWER ON'
	    }
	    ELSE
	    {
		fnSendString(dvVideoProj, cVideoProjCmds[3])
	    }
	}
	ELSE IF(nVirtualKey == VIR_BTN_SWITCH)
	{
	    nProjSourceSelection = SOURCE_SCAMERAS;
	    SEND_COMMAND dvTP_RoomControl, "'^PPG-Security Cameras'"
	    IF(!fnSysPowerStatus(dvRelayDevices))
	    {
		CALL 'SYSTEM POWER ON'
	    }
	    ELSE
	    {
		fnSendString(dvVideoProj, cVideoProjCmds[5])
	    }
	}
	ELSE IF(nVirtualKey == VIR_BTN_SYS_POWER)
	{
	    CALL 'SYSTEM POWER ON'
	}
	ELSE
	{
	    SEND_STRING 0, "'Key Number has not been defined - ', ITOA(nVirtualKey)"
	}
    }
}


(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)

DEFINE_PROGRAM

(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)


