PROGRAM_NAME='Control Function Virtual Keypad'
#IF_NOT_DEFINED __CONTROL_FUNCTION_VIRTUAL_KEYPAD__
#DEFINE __CONTROL_FUNCTION_VIRTUAL_KEYPAD__



DEFINE_FUNCTION fnSetVirtualKeypadButtonName()
{
    	send_command vdvVirtualKeyPad, "'LINETEXT1-'"
	send_command vdvVirtualKeyPad, "'LINETEXT2-AMX'"
	send_command vdvVirtualKeyPad, "'LINETEXT3-'"
	send_command vdvVirtualKeyPad, "'LABEL1-',BUTTON1"
	send_command vdvVirtualKeyPad, "'LABEL2-',BUTTON2"
	send_command vdvVirtualKeyPad, "'LABEL3-',BUTTON3"
	send_command vdvVirtualKeyPad, "'LABEL4-',BUTTON4"
	send_command vdvVirtualKeyPad, "'LABEL5-',BUTTON5"
	send_command vdvVirtualKeyPad, "'LABEL6-',BUTTON6"
	send_command vdvVirtualKeyPad, "'LABEL7-',BUTTON7"
	send_command vdvVirtualKeyPad, "'LABEL8-',BUTTON8"
	send_command vdvVirtualKeyPad, "'LABEL9-',BUTTON9"
	send_command vdvVirtualKeyPad, "'LABEL10-',BUTTON10"
	send_command vdvVirtualKeyPad, "'LABEL11-',BUTTON11" 
	send_command vdvVirtualKeyPad, "'LABEL12-',BUTTON12"
}




#END_IF