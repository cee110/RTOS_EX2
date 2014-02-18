/*
 * quickselect.c
 *
 *  Created on: 22 Jan 2014
 *      Author: tomcl
 */
#include <stdint.h>
#include <stdbool.h>
#include "grlib/grlib.h"
#include "utils/ustdlib.h"
#include "driverlib/gpio.h"
#include "drivers/buttons.h"
#include "drivers/cfal96x64x16.h"
#include "quickselect.h"


/*------------------------SBOX DEFINITIONS FOR EXAMPLE--------------------------------*/

/* these would normally be defined in the user file, not here */

/*
 * These integer constants can be chosen arbitrarily as IDs for boxes and labels
 * All label IDs must be distinct within one box. All box IDs must be distinct
 * This allows the label ids to have some numeric meaning if needed
 */

/*
 * Box IDs and label IDs need not all be distinct but
 * for error checking this is recommended
 * */
#define BOX1 10
#define XPOS1 0
#define YPOS1 0

#define BOX2 11
#define XPOS2 0
#define YPOS2 2

#define BOX1_VOLT 1
#define BOX1_ACCEL 2

#define BOX2_FIRST 3
#define BOX2_SECOND 4
#define BOX2_THIRD 5

	/* each box has a separate array of labels */
tSelectLabel pConfigFreq[]={
		{0,0,"10 Hz", 10},
		{0,0,"100 Hz", 100},
		{0,0,"1000 Hz", 1000},
		{0,0,0,0} /* required all zero struct to terminate labels 	*/
};

tSelectLabel pConfigSample[]={
		{0,0,"1", 1},
		{0,0,"2",2},
		{0,0,"4",4},
		{0,0,"8", 8},
		{0,0,"16",16},
		{0,0,"32",32},
		{0,0,0,0} /* required all zero struct to terminate labels 	*/
};

/* each box has a separate array of labels */
tSelectLabel pConfigChannel[]={
	{0,0,"ACCEL", ACCEL},
	{0,0,"VOLTS", VOLTS},
	{0,0,0,0} /* required all zero struct to terminate labels 	*/
};


tSelectLabel pStartLabel[] = {{0,0,"Start",0},{0,0,0,0}};
/*
 * array defining all boxes used (2 in this example)
 * definition must reference a label array previously defined
 */
tSelectBox pSBoxDefinitions[] = {
		/*        labels        xpos  ypos  boxid 					*/
		{ 0, 0, pConfigFreq, "Config Freq", 0},
		{ 0, 0, pConfigSample, "Config Size", 1},
		{ 0, 0, pConfigChannel, "Config Chl", 2},
		{0,0, pStartLabel,"Start Graph?",3},
		{0,0,0,0,0}	/* required all zero struct to end boxes 	*/
};

/***********************************************
 *
 * Stores User Configuration
 ************************************************/
tuiConfig uiConfig = {10,1, ACCEL};
volatile tContext sContext; 	/* needed for graphics */
/*--------------------------------SBOX IMPLEMENTATION-------------------------------*/


void WriteString(tContext *context, const char *s,int reversed, int xpos, int ypos);

void uerror(char *s)
{
	tContext sContext;
    CFAL96x64x16Init();
    //
    // Initialize the graphics context.
    //
    GrContextInit(&sContext, &g_sCFAL96x64x16);
    WriteString(&sContext, "ERROR:", 0, 0, 3);
    WriteString(&sContext, s, 0, 0, 5);
    GrFlush(&sContext);
	for (;;);
}

int len(const char *s){
	int i = 0;
	while (*s++) i++;
	return i;
}





static tSelectBox *pCurrentSBox;

/* initialise the SBox double-linked lists */
tSelectBox *MakeSBoxList(tSelectBox *pSBoxDefs)
{
	tSelectBox *pb;
	tSelectLabel *plab;
	for (pb = pSBoxDefs; pb->labels; pb++)
	{
		if  (pb == pSBoxDefs) {
			/*link first box */
			pb->bnext = pb->bprev = pb;
		} else {
			/* link other boxes */
			pb->bprev = (pb-1);
			pb->bprev->bnext = pb;
			pb->bnext = pb;
		}

		plab = pb->labels; /* this is the start of the list of labels */
		/* link labels into pb->items list */
		for (plab=pb->labels; plab->text; plab++)
		{
			if (plab == pb->labels) {
				/* link first label */
				plab->lnext = plab->lprev = plab;
			} else {
				/*link other labels */
				plab->lprev = plab-1;
				plab->lprev->lnext = plab;
				plab->lnext= plab;

			}
			/* make sure the box width is the size of teh longest label */
//			if (pb->width < len(plab->lab))
//				pb->width = len(plab->lab);
		}
	}
	return pSBoxDefs;
}


void WriteString(tContext *context, const char *s, int selected, int xpos, int ypos)
{
	int colbg = ClrBlack;
	int colfg = ClrWhite;
	// Clear Display First.
	tRectangle sRect;
	sRect.i16XMin = xpos*6;
	sRect.i16YMin = ypos*8;
	sRect.i16XMax = (xpos+13)*6;
	sRect.i16YMax =  (ypos+1)*8;
  GrContextForegroundSet(context, ClrBlack);
  GrRectFill(context, &sRect);
	if (selected)
	{
		colbg = ClrDarkGreen;
	}
	GrContextBackgroundSet(context,colbg);
	GrContextForegroundSet(context,colfg);
	GrContextFontSet( context, &g_sFontFixed6x8);
	GrStringDraw(context, s, -1, xpos*6, ypos*8,1);
}


void vPaintSBoxes(tContext *context)
{
	tSelectBox *p = pCurrentSBox;
	tSelectLabel* pLabel;
		// First Draw Title
	WriteString(context, p->title, 0, 3, 2);
	pLabel = pCurrentSBox->labels;
	// Secondly Draw the Option
	WriteString(context, pLabel->text, 1, 3, 4);
    GrFlush( context);
}
void
processOptions() {
	if (pCurrentSBox == &pSBoxDefinitions[0])
		uiConfig.freq = pCurrentSBox->labels->value;
	if (pCurrentSBox == &pSBoxDefinitions[1])
		uiConfig.sample_size = pCurrentSBox->labels->value;
	if (pCurrentSBox == &pSBoxDefinitions[2])
		uiConfig.channelOpt = pCurrentSBox->labels->value;
	if (pCurrentSBox ==  &pSBoxDefinitions[3]){}
//		Start Logging
}
void vPollSBoxButton(void (*doBoxChange)( int, int))
{
	uint8_t buttons, buttons_raw;
	ButtonsPoll(&buttons, &buttons_raw);
	buttons = buttons & buttons_raw;
	if (buttons & UP_BUTTON)
		pCurrentSBox = pCurrentSBox->bprev;
	if (buttons & DOWN_BUTTON)
		pCurrentSBox = pCurrentSBox->bnext;
	if (buttons & LEFT_BUTTON)
		pCurrentSBox->labels = pCurrentSBox->labels->lprev;
	if (buttons & RIGHT_BUTTON)
		pCurrentSBox->labels = pCurrentSBox->labels->lnext;
	if (buttons & SELECT_BUTTON)
		processOptions();
	if (buttons & (UP_BUTTON | DOWN_BUTTON | LEFT_BUTTON | RIGHT_BUTTON |SELECT_BUTTON))
		vPaintSBoxes(&sContext);
}



//int iSBoxValueGet( int id)
//{
//	tSelectBox *p = pCurrentSBox;
//	while (1)
//	{
//		if (p->boxid == id)
//			return p->items->value;
//		p = p->bnext;
//		if (p == pCurrentSBox)
//			break;
//	}
//	return 0;
//}

/*------------------------------EXAMPLE CODE USING SBOXES-------------------------*/

void vInitSBoxes(void)
{
	pCurrentSBox = MakeSBoxList(pSBoxDefinitions);
}

void vTestSBoxes(void)
{
//	tContext sContext; 	/* needed for graphics */
    CFAL96x64x16Init(); /* initialise controller */
    ButtonsInit(); 		/* initialise buttons */
//    char str[17];		/* space for string printed */
//    int b1, b2;

    //
    // Initialize the graphics context.
    //
    GrContextInit(&sContext, &g_sCFAL96x64x16);

	vInitSBoxes(); /* set up to test SBoxes */
	vPaintSBoxes(&sContext);
	while (1) {
		/* vProcessSBoxButton should be called regularly */
		vPollSBoxButton(0); 					/* poll keys, changing SBoxes if needed */
						/* display current SBox contents */
//		b1 = iSBoxValueGet(BOX1);				/* get values of SBoxes */
//		b2 = iSBoxValueGet(BOX2);
//		usprintf(str, "box: 1=%d,2=%d", b1, b2);/* print out values on bottom line */
//		WriteString(&sContext, str, 0, 0, 7);
	}
}






