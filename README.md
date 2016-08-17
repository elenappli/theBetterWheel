# theBetterWheel

This CLPD with read from a SPI bus into a 18 bit shift register.
When the CLPD is trigger it will send out the contents of the 
shift registers to 18 solenoids. Bit 0 to solenoids 0, etc.
The solenoids I have a 25% duty cycle so the CLPD it triggered by looking for a
rising edge on an input pin the CPLD will drive the solenoids for 50ms and 
then have a dead time of 150ms for a period of 200ms
The CLPD with output it's output enable to an interupt pin that 
a microcontroller can use to determine when you shift in the new bits.
