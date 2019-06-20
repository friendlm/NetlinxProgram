PROGRAM_NAME='Netlinx Professional Practice Devices'

#IF_NOT_DEFINED __NETLINX_PROFESSIONAL_PRACTICE_DEVICES__
#DEFINE __NETLINX_PROFESSIONAL_PRACTICE_DEVICES__

#INCLUDE 'Netlinx Professional Practice Constants'
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
//Define Physical Devices 
dvVideoSwitch				= 5001:1:0	// Serial Interface #1 - Security Cameras
dvVideoProj				= 5001:2:0	// Serial Interface #2 - Video Projector
dvCOMPDVDPlayer				= 5001:3:0	// Serial Interface #3 - DVD/CD Player
dvSVIDCamera				= 5001:4:0	// Serial Interface #4 - Camera Control
dvRelayDevices				= 5001:8:0	// Relay Device	    #21
dvHDMIReceiver				= 5001:9:0	// IR Interface     #11 - Satellite Receiver



//FOR TESTING
//dvVideoSwitch				= 8001:1:0	// Serial Interface #1 - Security Cameras
//dvVideoProj				= 8002:1:0	// Serial Interface #2 - Video Projector
//dvCOMPDVDPlayer			= 8003:1:0	// Serial Interface #3 - DVD/CD Player
//dvSVIDCamera				= 5001:4:0	// Serial Interface #4 - Camera Control
//dvHDMIReceiver			= 8005:1:0	// IR Interface     #11 - Satellite Receiver
//dvRelayDevices			= 5001:21:0	// Relay Device	    #21

//For Lighting Control
dvLightControl			= 0:4:0

//TPD 5
dvTP_RoomControl		= 10001:1:0	// Main Page
dvTP_SVIDCamera			= 10001:10:0	// Camera Control
dvTP_DVDPlayer			= 10001:11:0	// DVD Player
dvTP_LightControl		= 10001:12:0	// Light Control
dvTP_VideoProj			= 10001:13:0	// Room Control
dvTP_HDMIReceiver		= 10001:14:0	// Satellite Receiver
dvTP_VideoSwitch		= 10001:15:0	// Security Cameras

//Virtual Device for Sony Camera - EVID 100 
vdvSVIDCamera			= 41001:1:0;
vdvVirtualKeyPad		= 41002:1:0;

DEFINE_MUTUALLY_EXCLUSIVE
([dvRelayDevices, RELAY_SCREEN_UP], [dvRelayDevices, RELAY_SCREEN_DN], [dvRelayDevices, RELAY_SCREEN_STOP])
([dvTP_DVDPlayer, 1]..[dvTP_DVDPlayer,3], [dvTP_DVDPlayer, 6], [dvTP_DVDPlayer, 7])
([dvTP_LightControl, BTN_SCENE_ONE], [dvTP_LightControl, BTN_SCENE_TWO],[dvTP_LightControl, BTN_SCENE_THREE])


#END_IF
