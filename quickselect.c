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
tSelectLabel pSBoxData1[]={
		{0,0,"VOLT", BOX1_VOLT},
		{0,0,"ACCEL", BOX1_ACCEL},
		{0,0,0,0} /* required all zero struct to terminate labels 	*/
};

tSelectLabel pSBoxData2[]={
		{0,0,"first", BOX2_FIRST},
		{0,0,"second",BOX2_SECOND},
		{0,0,"third",BOX2_THIRD},
		{0,0,0,0} /* required all zero struct to terminate labels 	*/
};

/*
 * array defining all boxes used (2 in this example)
 * definition must reference a label array previously defined
 */
tSelectBox pSBoxDefinitions[] = {
		/*        labels        xpos  ypos  boxid 					*/
		{ 0, 0, pSBoxData1, 0, XPOS1, YPOS1, BOX1},
		{ 0, 0, pSBoxData2, 0, XPOS2, YPOS2, BOX2},
		{0,0,0,0,0,0,0} /* required all zero struct to end boxes 	*/
};

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
	for (pb = pSBoxDefs; pb->items; pb++)
	{
		if  (pb == pSBoxDefs) {
			/*link first box */
			pb->bnext = pb->bprev = pb;
		} else {
			/* link other boxes */
			pb->bprev = (pb-1)->bnext;
			pb->bnext = (pb-1);
			pb->bnext->bprev = pb;
			pb->bprev->bnext = pb;
		}

		plab = pb->items; /* this is the start of the list of labels */
		/* link labels into pb->items list */
		for (plab=pb->items; plab->lab; plab++)
		{
			if (plab == pb->items) {
				/* link first label */
				plab->lnext = plab->lprev = plab;
			} else {
				/*link other labels */
				plab->lprev = pb->items->lnext;
				plab->lnext = pb->items;
				plab->lnext->lprev = plab;
				plab->lprev->lnext = plab;

			}
			/* make sure the box width is the size of teh longest label */
			if (pb->width < len(plab->lab))
				pb->width = len(plab->lab);
		}
	}
	return pSBoxDefs;
}


void WriteString(tContext *context, const char *s, int selected, int xpos, int ypos)
{
	int colbg = ClrBlack;
	int colfg = ClrWhite;
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
	int is_selected, i;
	while (1)
	{
		is_selected = (p == pCurrentSBox);
		WriteString(context, p->items->lab, is_selected, p->xpos, p->ypos);
		for (i = len(p->items->lab); i < p->width; i++)
		{
			WriteString(context, " ", is_selected, p->xpos+i, p->ypos);
		}
		p = p->bnext;
		if (p == pCurrentSBox) break;
	}
    GrFlush( context);

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
		pCurrentSBox->items = pCurrentSBox->items->lprev;
	if (buttons & RIGHT_BUTTON)
		pCurrentSBox->items = pCurrentSBox->items->lnext;
	if (buttons & (UP_BUTTON | DOWN_BUTTON | LEFT_BUTTON | RIGHT_BUTTON))
		if (doBoxChange)
			doBoxChange(pCurrentSBox->boxid, pCurrentSBox->items->value);
}

int iSBoxValueGet( int id)
{
	tSelectBox *p = pCurrentSBox;
	while (1)
	{
		if (p->boxid == id)
			return p->items->value;
		p = p->bnext;
		if (p == pCurrentSBox)
			break;
	}
	return 0;
}

/*------------------------------EXAMPLE CODE USING SBOXES-------------------------*/

void vInitSBoxes(void)
{
	pCurrentSBox = MakeSBoxList(pSBoxDefinitions);
}

void vTestSBoxes(void)
{
	tContext sContext; 	/* needed for graphics */
    CFAL96x64x16Init(); /* initialise controller */
    ButtonsInit(); 		/* initialise buttons */
    char str[17];		/* space for string printed */
    int b1, b2;

    //
    // Initialize the graphics context.
    //
    GrContextInit(&sContext, &g_sCFAL96x64x16);

	vInitSBoxes(); /* set up to test SBoxes */

	while (1) {
		/* vProcessSBoxButton should be called regularly */
		vPollSBoxButton(0); 					/* poll keys, changing SBoxes if needed */
		vPaintSBoxes(&sContext);				/* display current SBox contents */
		b1 = iSBoxValueGet(BOX1);				/* get values of SBoxes */
		b2 = iSBoxValueGet(BOX2);
		usprintf(str, "box: 1=%d,2=%d", b1, b2);/* print out values on bottom line */
		WriteString(&sContext, str, 0, 0, 7);
	}
}






