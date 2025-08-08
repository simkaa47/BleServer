#ifndef INC_ADC_MODULE_H_
#define INC_ADC_MODULE_H_

#define ADC_MODULE_PROC_CNTRS_QTY		8
#define ADC_MEAS_STD_NUM				3
#define ADC_MEAS_CALIB_VAL_NUM			10
#define SETTINGS_ADC_MEAS_PROC_NUM		8
#define SETTINGS_ADC_MEAS_RANGE_NUM		3
#define ADC_MEAS_AVER_SIZE_MAX			100

typedef enum { TOTAL_DENSITY,CONCENTRATION_1,CONCENTRATION_2, NO_RESULT} TMeas_Density_Type;
typedef enum {ADC_MOD_PROC_RAW, ADC_MOD_PROC_CNTRS_FULL, ADC_MOD_PROC_CNTRS_RANGE} TADC_Module_Proc_Modes;
typedef enum {ADC_MOD_MODE_OSC, ADC_MOD_MODE_MAX_VALS} TADC_Module_Work_Modes;
typedef enum {ADC_MOD_SYNC_WAIT, ADC_MOD_SYNC_AUTO} TADC_Module_Sync_Modes;
typedef enum { POLY_CALC,ATTENUATION_CALC,NO_CALC_TYPE} TMeas_Proc_Calc_Type;
typedef enum { DENSITY,LEVEL, NO_TYPE} TMeas_Device_Type; 
typedef enum {MEAS_TYPE_DENSITY, MEAS_TYPE_MASS_CONCENTRATION_PHASE1,MEAS_TYPE_MASS_CONCENTRATION_PHASE2, MEAS_TYPE_PERC_CONCENTRATION_PH1_TO_ALL,MEAS_TYPE_PERC_CONCENTRATION_PH2_TO_ALL,MEAS_TYPE_PERC_CONCENTRATION_PH2_TO_PH1,MEAS_TYPE_PERC_CONCENTRATION_PH1_TO_PH2} TMeas_Proc_Meas_Type;


typedef struct
{
	uint8_t ndx;
	float counter;
	float phys_vals[SETTINGS_ADC_MEAS_RANGE_NUM];
	float phys_val_range_aver;
	float aver_buffer[ADC_MEAS_AVER_SIZE_MAX];
	int aver_buffer_ndx;
	float phys_val_complete_aver;
	int meas_in_progress;
	int meas_ndx;
} TMeas_Proc_Data_Struct;

typedef struct
{
	uint8_t request_src;		// Инициатор запроса данных в модуль (0 - внешнее устройство, 1 - сам контроллер)
	uint8_t request_issued;		// Выставлен запрос
	uint8_t module_active;			// Флаг 'Модуль активирован'
	float v_set;				// В
	float v_in;					// В
	float v_out;				// В
	float i;					// А
} THV_Module_Telemetry_Struct;

typedef struct
{
	float t_int;				// C
	float t_ext;				// C
} TTemp_Module_Telemetry_Struct;


#endif /* INC_ADC_MODULE_H_ */