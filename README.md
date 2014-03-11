<h1> Data Logging and Shock Detection App </h1> 
<h3> For the LM4F232 Evaluation Board. </h3>
This is a simple application that displays the accelerometer z-axis and voltage input data on the OLED display. To navigate through the settings, press up and down to scroll between different setting topics. Press left and right to scroll between options for a specific topic. Press SELECT to lock onto a setting. If SELECT is not pressed, the settings are not saved.
The shock monitoring system starts at runtime but once a shock is detected, the waveform is plotted on a graph and the led blinks for about 10 seconds. Within this time, the graph can be cancelled but the led will still be blinking. Normal waveform can still be plotted but the shock monitoring will start again when the led stops blinking.
The normal waveform graph can be cancelled at any time so there is no need for reset. New setting can be selected after cancelling a graph.
<br>
<h2>Errata:</h2>
The ADC0 does not sample for 100 kHz and 1 MHz so when selecting these options, operation is not guaranteed. The observation is that there is a relationship between unregistering an old ISR for the specific ADC0 and registering a new ISR. If no unregistering occurs, the ADC works fine. However, with re-registry comes change of timer0 period so that may also be part of issue.
Moreover, the shock monitor does not output a waveform when shock is detected whilst waiting for volts waveform trigger. My guess is this may be related to the first problem. In this case there is an issue with online interrupt handler registry which is speculated to be fixed by placing the vector table at the beginning of the SRAM address using the command --first while linking.
