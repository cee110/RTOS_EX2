/*
 * quickselect.h
 *
 *  Created on: 22 Jan 2014
 *      Author: tomcl
 *      Code to make simple multi-value combo select boxes with button interface
 *      UP/DOWN Buttons cycle through a list of boxes each positioned on screen
 *      LEFT/RIGHT Buttons change the values for the current box from a predefined list
 *
 */

#ifndef QUICKSELECT_H_
#define QUICKSELECT_H_

/*----------------------------STRUCTURE DEFINITIONS FOR SBOXES------------------------*/
/* label for a SBox - each SBox has a list of labels */
typedef struct tsl
{
	struct tsl *lnext;
	struct tsl *lprev;
	const char *text; 	/* pointer into list of labels */
	int value; 			/* integer constant identifying label */
} tSelectLabel;

/* SBox - all SBoxes can be linked together in a list*/
typedef struct tsb
{
	struct tsb *bnext;
	struct tsb *bprev;
	tSelectLabel *labels; 	/* pointer into list of labels */
//	int count; 				/* max number of characters of any label - size of SBox */
	const char *title;
	int boxid;				/* integer constant identifying SBox */
} tSelectBox;

typedef enum channel_enum{ACCEL, VOLTS} channel_enum;
/* Option Configuration Structure to Store User's Option */
typedef struct tsOpt
{
	uint32_t freq;
	uint32_t sample_size;
	channel_enum channelOpt;
} tuiConfig;

/*-------------------------------EXPORTED FUNCTIONS-------------------------------*/

extern void uerror(char *s); /* error function prints message on display and stops*/

/* convenience function writes a string to OLED in fixed 6*8 font and colour */
void WriteString(
		tContext *context,  /* graphics context shared by all print ops */
		const char *s, 		/* string to print */
		int selected, 		/* if non-zero chnage background */
		int xpos, int ypos 	/* position on screen in 6*8 characters */
		);


/*---------------------------------SBOX CREATION AND USE--------------------------*/
/*------------------------see quickselect.c for use example-----------------------*/

/* make a list of SBoxes from data in pSBoxDefs table */
/* called just once to initialise system */
/* returns the linked list of SBoxes */
tSelectBox *MakeSBoxList(tSelectBox *pSBoxDefs);


void vPollSBoxButton(
		void (*doBoxChange)( int, int) /* optional function called when selection
		 	 	 	 	 	 	 	 	* changes first parameter is SBox number
		 	 	 	 	 	 	 	 	* second parameter is number of new label
										*/
		);

int iSBoxValueGet( int id); 			/* get the number of the current label
										 * selected for SBox number id */

void vTestSBoxes(void);					/* example function to test SBoxes */


#endif /* QUICKSELECT_H_ */
