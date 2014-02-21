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
#include "utils/uartstdio.h"
#include "driverlib/gpio.h"
#include "drivers/buttons.h"
#include "drivers/cfal96x64x16.h"
#include "exercise2.h"
#include "uicontrol.h"





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
#define TITLEXPOS 0
#define TITLEYPOS 0

#define ITEMXPOS 0
#define ITEMYPOS 2

	/* each box has a separate array of labels */
tSelectLabel pConfigFreq[]={
		{0,0,"10 Hz", 10},
		{0,0,"100 Hz", 100},
		{0,0,"1 kHz", 1000},
		{0,0,"10 kHz", 10000},
		{0,0,"100 kHz", 100000},
		{0,0,"1 MHz", 1000000},
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
tSelectBox pCurrentSBoxDefinitions[] = {
		/*        labels        xpos  ypos  boxid 					*/
		{ 0, 0, pConfigFreq, "Config Freq", 0},
		{ 0, 0, pConfigSample, "Config Size", 1},
		{ 0, 0, pConfigChannel, "Config Chl", 2},
		{0,0, pStartLabel,"Start Graph?",3},
		{0,0,0,0,0}	/* required all zero struct to end boxes 	*/
};

/******************************************************************************
 * Pointer to the current display item
 ******************************************************************************/
static tSelectBox *pCurrentSBox;
//volatile tContext sContext; 	/* needed for graphics */
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


/* initialise the SBox double-linked lists */
tSelectBox *MakeSBoxList(tSelectBox *pCurrentSBoxDefs)
{
	tSelectBox *pb;
	tSelectLabel *plab;
	for (pb = pCurrentSBoxDefs; pb->labels; pb++)
	{
		if  (pb == pCurrentSBoxDefs) {
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
	return pCurrentSBoxDefs;
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
processOptions(tuiConfig* p_uiConfig) {
	if (pCurrentSBox == &pCurrentSBoxDefinitions[0])
		p_uiConfig->freq = pCurrentSBox->labels->value;
	if (pCurrentSBox == &pCurrentSBoxDefinitions[1])
		p_uiConfig->sample_size = pCurrentSBox->labels->value;
	if (pCurrentSBox == &pCurrentSBoxDefinitions[2])
		p_uiConfig->channelOpt = pCurrentSBox->labels->value;
	if (pCurrentSBox ==  &pCurrentSBoxDefinitions[3]){
		//		Start Logging
		p_uiConfig->uiState = logging;
	}
}
/******************************************************************************
 * Controls all the button functions across the app.
 * No other function should do this.
 ******************************************************************************/
void vPollSBoxButton(tContext* sContext, tuiConfig* p_uiConfig)
{
	uint8_t buttons, buttons_raw;
	ButtonsPoll(&buttons, &buttons_raw);
	buttons = buttons & buttons_raw;
	if (p_uiConfig->uiState == idle) {
		if (buttons & UP_BUTTON){
			pCurrentSBox = pCurrentSBox->bprev;
			UARTprintf("UP \n");
		}
		if (buttons & DOWN_BUTTON){
			pCurrentSBox = pCurrentSBox->bnext;
			UARTprintf("DOWN \n");
		}
		if (buttons & LEFT_BUTTON){
			pCurrentSBox->labels = pCurrentSBox->labels->lprev;
			UARTprintf("LEFT \n");
		}
		if (buttons & RIGHT_BUTTON) {
			pCurrentSBox->labels = pCurrentSBox->labels->lnext;
			UARTprintf("RIGHT \n");
		}
		if (buttons & SELECT_BUTTON) {
			processOptions(p_uiConfig);
			UARTprintf("SELECT BUTTON \n");
		}
		if (buttons & (UP_BUTTON | DOWN_BUTTON | LEFT_BUTTON | RIGHT_BUTTON)) {
			vPaintSBoxes(sContext);
		}
	}
	else if(p_uiConfig->uiState == logging) {
		if (buttons & (UP_BUTTON | DOWN_BUTTON | LEFT_BUTTON | RIGHT_BUTTON)) {
			p_uiConfig->uiState = idle;
			vPaintSBoxes(sContext);
		}
	}
}

/******************************************************************************
 * Initialises the UI
 ******************************************************************************/
void vInitUI(tContext* sContext)
{
	pCurrentSBox = MakeSBoxList(pCurrentSBoxDefinitions);
	vPaintSBoxes(sContext);
}

/*------------------------------EXAMPLE CODE USING SBOXES-------------------------*/









