PROGRAM_NAME='Netlinx Professional Practice Constants'

#IF_NOT_DEFINED __NETLINX_PROFESSIONAL_PRACTICE_CONSTANTS__
#DEFINE __NETLINX_PROFESSIONAL_PRACTICE_CONSTANTS__

#INCLUDE 'SNAPI'

DEFINE_CONSTANT
(***********************************************************)
(*               TIMELINE CONSTANT DEFINITION              *)
(***********************************************************)
LONG nTL_BTN_FB				= 1;  //For Button Feedback
LONG nTL_POLLING_PROJ_STATUS		= 2;
LONG nTL_DVD_STATUS_POLLING		= 3;
LONG nTL_LIGHT_CONN_STATUS		= 4; //Light Connection


(***********************************************************)
(*               CONSTANT FOR ROOM CONTROL                 *)
(***********************************************************)
BTN_ROOM_LIGHT_CONTROL			= 10;
BTN_ROOM_SSEL_DVD			= 11;	//COMP    - DVD Player
BTN_ROOM_SSEL_CAMERA			= 12;	//SVIDEO  - Camera Control	
BTN_ROOM_SSEL_SRECEIVER			= 13;	//HDMI    - DSS Receiver
BTN_ROOM_SSEL_SCAMERAS			= 14;	//VIDEO   - Security Cameras
BTN_ROOM_CONTROL			= 15;

BTN_ROOM_SCREEN_UP			= 101;
BTN_ROOM_SCREEN_DN			= 102;
BTN_ROOM_SCREEN_STOP			= 103;
BTN_ROOM_SYS_POWER_ON			= 105;
BTN_ROOM_SYS_POWER_OFF			= 106;


(***********************************************************)
(*            RELAY PORT FOR POWER AND SCREEN              *)
(***********************************************************)
RELAY_SCREEN_UP				= 1;
RELAY_SCREEN_DN				= 3;
RELAY_SCREEN_STOP			= 2;
RELAY_SYS_APM_POWER			= 5;
RELAY_SYS_RACK_POWER			= 6;

RELAY_CHANNEL_OFF			= 0;

(***********************************************************)
(*            CONSTANT FOR VIDEO PROJECTOR                 *)
(***********************************************************)
SOURCE_DVD				= 1;	// DVD Player
SOURCE_CAMERA				= 2;	// Sony Camera Control
SOURCE_SRECEIVER			= 3;	// DSS Receiver
SOURCE_SCAMERAS				= 4;	// Camera Video Switch

BTN_SOURCE_HDMI				= 31;	// DSS Receiver
BTN_SOURCE_SVIDEO			= 32;	// Sony Camera Control
BTN_SOURCE_VIDEO			= 33;	// Camera Video Switch
BTN_SOURCE_COMP				= 34;	// DVD Player

TXT_COOL_DOWN_TIME			= 12;
TXT_WARM_UP_TIME			= 13;
TXT_LAMP_RUN_HOURS			= 14;
TXT_SOURCE_INPUT			= 15;

BTN_PROJ_POWER				= 255;

(***********************************************************)
(*            CONSTANT FOR SONY CAMERA MODULE              *)
(***********************************************************)
BTN_PRESET_ONE				= 261;
BTN_PRESET_TWO				= 262;
BTN_PRESET_THREE			= 263;

(***********************************************************)
(*            CONSTANT FOR SATELLITE RECEIVER              *)
(***********************************************************)
BTN_HDMI_CHANNEL_UP			= 225;
BTN_HDMI_CHANNEL_DN			= 226;

HDMI_PRESET_ONE				= 1041;
HDMI_PRESET_TWO				= 1042;
HDMI_PRESET_THREE			= 1043;
HDMI_PRESET_FOUR			= 1044;
HDMI_PRESET_FIVE			= 1045;
HDMI_PRESET_SIX				= 1046;

(***********************************************************)
(*            CONSTANT FOR LIGHT CONTROL                   *)
(***********************************************************)
BTN_ZONE_ONE_UP				= 35;
BTN_ZONE_ONE_DN				= 36;
BTN_ZONE_TWO_UP				= 37;
BTN_ZONE_TWO_DN				= 38;
BTN_ZONE_THREE_UP			= 39;
BTN_ZONE_THREE_DN			= 40;
BTN_ZONE_FOUR_UP			= 41;
BTN_ZONE_FOUR_DN			= 42;

BTN_SCENE_ONE				= 30;
BTN_SCENE_TWO				= 31;
BTN_SCENE_THREE				= 32;

TXT_LIGHT_SCENE_SEL			= 10;

LIGHT_PRESET_NUMBERS			= 3; //How many preset scenes
LIGHT_ZONE_NUMBERS			= 4;

LVL_ZONE_ONE_INTENSITY			= 10;
LVL_ZONE_TWO_INTENSITY			= 11;
LVL_ZONE_THREE_INTENSITY		= 12;
LVL_ZONE_FOUR_INTENSITY			= 13;

(***********************************************************)
(*            CONSTANT    CUSTOME EVENT                    *)
(***********************************************************)
CUSTOM_EVENT_ID				= 0;
CUSTOM_EVENT_TYPE			= 1315

(***********************************************************)
(*            CONSTANT FOR VIRTUAL KEYPAD                  *)
(***********************************************************)

BUTTON1 				= 'Button 1'
BUTTON2					= 'Button 2'
BUTTON3 				= 'Button 3'
BUTTON4 				= 'Button 4'
BUTTON5 				= 'DVD/CD'
BUTTON6 				= 'Camera'
BUTTON7 				= 'Sat.Rcvr.'
BUTTON8 				= 'Security Camera'
BUTTON9 				= 'Button 9'
BUTTON10 				= 'Button 10'
BUTTON11 				= 'Button 11'
BUTTON12 				= 'System Power'

VIR_BTN_DVD				= 5;
VIR_BTN_CAMERA				= 6;
VIR_BTN_SRECEIVER			= 7;
VIR_BTN_SWITCH				= 8;
VIR_BTN_SYS_POWER			= 12;


(***********************************************************)
(*                DEFINE GLOBAL VARIABLES                  *)
(***********************************************************)
DEFINE_VARIABLE
VOLATILE INTEGER nProjSourceSelection;	//Global variable for project source selection
VOLATILE LONG 	 nProjRunningTime;
VOLATILE CHAR 	 cProjRunningStatus[1];   
VOLATILE CHAR    cProjSelectedSource[1]; 
VOLATILE INTEGER nScreenStatus;

//FOR DVD PLAYER
VOLATILE INTEGER nDVDCmdConfirm;

//FOR LIGHT CONTROL
VOLATILE CHAR bLightIPConnection = FALSE;
VOLATILE CHAR sLightsIPAddress[15];
VOLATILE INTEGER nLightsPortNum;
DEV dLightDevice;   		
VOLATILE CHAR cLightDevBuffer[2000];

#IF_NOT_DEFINED sLightIPAddressFile
VOLATILE CHAR sLightIPAddressFile[] = {'IP_ADDRESSING.txt'}
#END_IF

#IF_NOT_DEFINED FILE_NAME_TO_WRITE
CHAR FILE_NAME_TO_WRITE[] = {'MAC_ADDRESS.TXT'}
#END_IF

//FOR SATELLIE RECEIVER
VOLATILE INTEGER nHDMIPresetNum;

//FOR TIME LINES
#IF_NOT_DEFINED nTimeButtonFb
VOLATILE LONG nTimeButtonFb[] = 
{
    100
}
#END_IF

#IF_NOT_DEFINED nTimeProjStatus  
VOLATILE LONG nTimeProjStatus[] = 
{
    30000
}
#END_IF

#IF_NOT_DEFINED nTimeDVDStatus
VOLATILE LONG nTimeDVDStatus[] =
{
    1000
}	
#END_IF

#IF_NOT_DEFINED nTimeLightStatus
VOLATILE LONG nTimeLightStatus[] =
{
    60000
}	
#END_IF

#IF_NOT_DEFINED nVideoSwitchButtons
VOLATILE INTEGER nVideoSwitchButtons[][] =
{
    {1,11,21,31,41,51,61,71,81,91,101,111,121},
    {2,12,22,32,42,52,62,72,82,92,102,112,122},
    {3,13,23,33,43,53,63,73,83,93,103,113,123},
    {4,14,24,34,44,54,64,74,84,94,104,114,124}
}	
#END_IF

#IF_NOT_DEFINED nVirtualButtons
VOLATILE INTEGER nVirtualButtons[] =
{
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12
}
#END_IF

//DEFINE SATELLITE RECEIVER CHANNELS
#IF_NOT_DEFINED nSReceiverChannels
VOLATILE INTEGER nSReceiverChannels[] =
{
    16,
    22,
    34,
    125,
    134,
    140
}
#END_IF

#END_IF  //__NETLINX_PROFESSIONAL_PRACTICE_CONSTANTS__