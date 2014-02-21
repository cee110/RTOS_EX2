/*
 * acquire.h
 *
 *  Created on: 19 Feb 2014
 *      Author: Administrator
 */

#ifndef ACQUIRE_H_
#define ACQUIRE_H_

extern void AcquireMain(tContext* pContext, tuiConfig* p_uiConfig);

typedef struct tgc {
	const int MAX;
	const int MIN;
	const  channel_enum channel;
}tguiConfig;

typedef enum series_enum{MAX, MIN, AVE}seriesName;
typedef struct tsc{
	const seriesName series;
	const int color;
}seriesColor;
#endif /* ACQUIRE_H_ */
