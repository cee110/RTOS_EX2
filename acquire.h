/*
 * acquire.h
 *
 *  Created on: 19 Feb 2014
 *      Author: Administrator
 */

#ifndef ACQUIRE_H_
#define ACQUIRE_H_

extern void AcquireMain(tContext* pContext, tuiConfig* p_uiConfig);

typedef struct tyb {
	const int MAX;
	const int MIN;
	const  channel_enum channel;
}tYBounds;

/****************************************************************
 * The series color configuration
 ****************************************************************/
typedef struct tsc {
	int MAX_COLOR;
	int MIN_COLOR;
	int AVE_COLOR;
}tseriesColor;
/****************************************************************
 * Stores the graphic configurations.
 * puiConfig is the struct that stores the user selectable preference
 * such as frequency, sample size and channel for logging data.
 *
 * pYBounds stores the Maximum and Minimum values for each possible channel setting.
 *
 * seriesColor stores the color associated with each series.
 * A series is the min, max or ave being plotted on a graph.
 *
 * Series Tilte stores the title to be displayed on the graph.
 *
 * pContext is the pointer to the context for drawing on the OLED.
 ****************************************************************/
typedef struct tgc {
	tuiConfig * puiConfig;
	tYBounds * pYbounds;
	tseriesColor* pSeriesColor;
	char* seriesTitle;
	tContext *pContext;
} tguiConfig;

#endif /* ACQUIRE_H_ */
