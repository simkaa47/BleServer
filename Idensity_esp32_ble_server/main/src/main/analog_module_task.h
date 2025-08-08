#ifndef INC_AM_MODULE_TASK_H_
#define INC_AM_MODULE_TASK_H_

typedef struct
{
	union
	{
		float v_test;			// В
		float i_out;			// А
	};
	union
	{
		float v_rx;				// В
		float i_loop;			// А
		float i_in;				// А
		float v_in;				// В
	};
	union
	{
		float v_dac;
	};
} TAnalog_Module_Telemetry_Struct;



#endif