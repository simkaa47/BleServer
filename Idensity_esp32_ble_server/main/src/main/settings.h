#ifndef INC_SETTINGS_H_
#define INC_SETTINGS_H_

#include "adc_module.h"
#include "analog_module_task.h"

#define DEVICE_NAME						"Device"
#define DEVICE_ORDER_NUM				"abc123"
#define DEVICE_TYPE						"type11"
#define DEVICE_FW_VERSION				"v.1.0"
#define DEVICE_POSITION_NUM				"n987"

#define SETTINGS_DELIM_CHR				'='
#define SETTINGS_ADC_MODE_STR			"adc_mode"
#define SETTINGS_ADC_SYNC_MODE_STR		"adc_sync_mode"
#define SETTINGS_ADC_SYNC_LEVEL_STR		"adc_sync_level"
#define SETTINGS_ADC_PROC_MODE_STR		"adc_proc_mode"
#define SETTINGS_ADC_PROC_CNTR_STR		"adc_proc_cntr"
#define SETTINGS_TIMER_MAX_STR			"timer_max"
#define SETTINGS_PREAMP_MODEL_STR		"preamp_model"
#define SETTINGS_PREAMP_GAIN_STR		"preamp_gain"
#define SETTINGS_UDP_LENGTH_STR			"udp_length"
#define SETTINGS_HV_TARGET_STR			"hv_target"
#define SETTINGS_AM_DAC_SRC_STR			"am_dac_src"
#define SETTINGS_ADC_PROC_CNTR_CLC_STR	"adc_proc_calc_cntr"
#define SETTINGS_ADC_STD_TM_CLS_STR		"adc_std_tm_closed"
#define SETTINGS_ADC_STD_TM_OPN_STR		"adc_std_tm_open"
#define SETTINGS_ADC_SNG_MEAS_TM_STR	"adc_single_meas_time"
#define SETTINGS_ADC_CAL_CUR_NDX_STR	"adc_calib_curve_ndx"
#define SETTINGS_ADC_MOV_AVG_DEP_STR	"adc_mov_avg_depth"
#define SETTINGS_ADC_CAL_COEF_STR		"adc_calib_coeff"
#define SETTINGS_ADC_CON_COEF_STR		"adc_conv_coeff"
#define SETTINGS_SERIAL_SELECT_STR		"serial_select"
#define SETTINGS_SERIAL_BAUDRATE_STR	"serial_baudrate"
#define SETTINGS_RTC_SET_STR			"rtc_set"
#define SETTINGS_MEAS_UNIT_STR			"meas_unit"
#define SETTINGS_STD_STR				"std"
#define SETTINGS_MEAS_PROC_STR			"meas_proc"
#define SETTINGS_MEAS_PROC_NDX_STR		"meas_prc_ndx"
#define SETTINGS_AM_OUT_STR				"am_out_sett"
#define SETTINGS_AM_IN_STR				"am_in_sett"
#define SETTINGS_MAC_ADDR				"mac"
#define SETTINGS_ISOTOPE_STR			"isotope"
#define SETTINGS_ISOTOPE_INDEX      	"isotope_index"
#define SETTINGS_SRC_INST_DATE_STR		"src_inst_date"
#define SETTINGS_SRC_EXP_DATE_STR		"src_exp_date"
#define SETTINGS_PIPE_DIAMETER_STR		"pipe_diameter"
#define SETTINGS_EMUL_MASK_STR			"emul_mask"
#define SETTINGS_EMUL_CNTR_STR			"emul_cntr"
#define SETTINGS_EMUL_LOG_MEAS_STR		"emul_log_meas"
#define SETTINGS_EMUL_LOG_LIQ_STR		"emul_log_liquid"
#define SETTINGS_EMUL_TEMP_STR			"emul_temp"
#define SETTINGS_EMUL_DENS_MOM_STR		"emul_dens_moment"
#define SETTINGS_EMUL_DENS_RSLT_STR		"emul_dens_result"
#define SETTINGS_EMUL_AN_OUT_CUR_STR	"emul_an_out_cur"
#define SETTINGS_EMUL_AN_IN_VAL_STR		"emul_an_in_val"
#define SETTINGS_UDP_STR				"udp_sett"
#define SETTINGS_TCP_STR				"tcp_sett"
#define SETTINGS_KALMAN_STR				"kalman_sett"
#define SETTINGS_AM_TEMP_COEFFS_STR		"am_temp_coeffs"
#define SETTINGS_TEMP_SRC_STR			"temperature_src"
#define SETTINGS_DEVICE_TYPE_STR		"device_type"
#define SETTINGS_LEVELMETER_LENGTH_STR	"levelmeter_ln"
#define SETTINGS_SERIAL_NUM         	"sn"
#define SETTINGS_HV_DATA_TO_485_NUM    	"hv_to_485"
#define SETTINGS_BASELINE_UKLON_STR    	"baseline_uklon"
#define SETTINGS_BASELINE_FREE_STR    	"baseline_free"

#define ISOTOPE_CS137					"Cs-137"
#define ISOTOPE_CO60					"Co-60"
#define ISOTOPE_NA22					"Ca-22"
#define ISOTOPE_AM241					"Am-241"
#define ISOTOPES_QTY					4

#define SETTINGS_ADC_MODE_DFLT			ADC_MOD_MODE_OSC
#define SETTINGS_ADC_SYNC_MODE_DFLT		ADC_MOD_SYNC_WAIT
#define SETTINGS_ADC_SYNC_LEVEL_DFLT	1000
#define SETTINGS_ADC_PROC_MODE_DFLT		ADC_MOD_PROC_RAW
#define SETTINGS_ADC_PROC_CNT_DFLT		100
#define SETTINGS_PREAMP_MODEL_DFLT		0
#define SETTINGS_PREAMP_GAIN_DFLT		1
#define SETTINGS_UDP_LENGTH_DFLT		100
#define SETTINGS_ADC_CAL_COEFF_DFLT		1.0f
#define SETTINGS_ADC_CON_COEFF_DFLT		1.0f
#define SETTINGS_ADC_CNTR_CLC_NDX_DFLT	0
#define SETTINGS_ADC_STD_TM_CLS_DFLT	100
#define SETTINGS_ADC_STD_TM_OPN_DFLT	100
#define SETTINGS_ADC_STD_CLS_DFLT		400
#define SETTINGS_ADC_STD_OPN_DFLT		400
#define SETTINGS_ADC_TM_MS_SNGL_DFLT	100
#define SETTINGS_ADC_CALIB_CURVE_DFLT	1
#define SETTINGS_ADC_MOV_AVG_DPT_DFLT	10
#define SETTINGS_DAC_SRC_DFLT			0
#define SETTINGS_HV_TARGET_DFLT			0
#define SETTINGS_SERIAL_DEFAULT			0
#define SETTINGS_SERIAL_BAUDRATE_DEFAULT	115200
#define SETTINGS_NAME_DFLT				"noname"
#define SETTINGS_ISOTOPE_DFLT			ISOTOPE_CS137
#define SETTINGS_HALF_LIFE_DFLT			100.0f
#define SETTINGS_PIPE_DIAM_DFLT			1000
#define SETTINGS_SD_MEAS_RSLT_WR_DFLT	0
#define SETTINGS_HV_MOD_DATA_TO_485_DFLT	0

#define DEVICE_STATE_COMM_ADC			(1 << 0)
#define DEVICE_STATE_COMM_PWR			(1 << 1)
#define DEVICE_STATE_COMM_07			(1 << 2)
#define DEVICE_STATE_COMM_PC			(1 << 3)

#define DEVICE_STATE_PARAMS_12V_OK		(1 << 0)
#define DEVICE_STATE_PARAMS_HV_RUN		(1 << 1)
#define DEVICE_STATE_PARAMS_HV_OK		(1 << 2)
#define DEVICE_STATE_PARAMS_HV_DNG		(1 << 3)
#define DEVICE_STATE_PARAMS_HC_OK		(1 << 4)
#define DEVICE_STATE_PARAMS_HC_DNG		(1 << 5)
#define DEVICE_STATE_PARAMS_TEMP_OK		(1 << 6)
#define DEVICE_STATE_PARAMS_PULSES_OK	(1 << 7)
#define DEVICE_STATE_PARAMS_HV_OFF		(1 << 8)
#define DEVICE_STATE_PARAMS_TIME_OK		(1 << 9)

#define DEVICE_STATE_ANALOG_PWR(x)		(1 << x)
#define DEVICE_STATE_ANALOG_COMM(x)		(1 << (2 + x))
#define DEVICE_STATE_ANALOG_I_OK		(1 << 4)
#define DEVICE_STATE_ANALOG_I_DNG		(1 << 5)
#define DEVICE_STATE_ANALOG_U_LOOP_OK	(1 << 6)
#define DEVICE_STATE_ANALOG_U_LOOP_LOW	(1 << 7)
#define DEVICE_STATE_ANALOG_U_LOOP_HI	(1 << 8)
#define DEVICE_STATE_ANALOG_UI_OUT		(1 << 9)

#define SETTINGS_NAME_SIZE				10
#define SETTINGS_ISOTOPE_SIZE			10


typedef struct
{
  uint8_t WeekDay;  /*!< Specifies the RTC Date WeekDay.
                         This parameter can be a value of @ref RTC_WeekDay_Definitions */

  uint8_t Month;    /*!< Specifies the RTC Date Month (in BCD format).
                         This parameter can be a value of @ref RTC_Month_Date_Definitions */

  uint8_t Date;     /*!< Specifies the RTC Date.
                         This parameter must be a number between Min_Data = 1 and Max_Data = 31 */

  uint8_t Year;     /*!< Specifies the RTC Date Year.
                         This parameter must be a number between Min_Data = 0 and Max_Data = 99 */

}RTC_DateTypeDef;

// Размер = 2 + 1 + "1" + 4 + 4*8 + 4 = 44 Б
typedef struct
{
	uint16_t duration;
	uint8_t type;
	float value;
	float result[ADC_MODULE_PROC_CNTRS_QTY];
	RTC_DateTypeDef date;
} TStd_Struct;

// Размер = 1 + 1 + 2 = 4 Б
typedef struct
{
	uint8_t calib_curve_ndx;
	uint8_t std_ndx;
	uint16_t cntr_ndx;
} TMeas_Range_Struct;

typedef struct
{
	uint8_t ei_ndx;
	uint16_t duration;
	RTC_DateTypeDef date;
	float result;
	float phys_value;
	float half_life_compensated;
} TStandartisation_Struct;

typedef struct
{
	RTC_DateTypeDef date;
	float attenuation;
	float phys_value;
} TCalib_Curve_Src_Value;

typedef struct
{
	TMeas_Density_Type d_type; // При расчётах плотности калибровка может быть как по общей плотности так и по концентрации
	uint8_t type;
	uint8_t ei_ndx;
	float coeffs[6];
} TCalib_Curve_Strct;

typedef struct
{
	uint8_t ei_ndx;
	float phys_value;
} TDensity_Strct;

typedef struct
{
	uint8_t active;
	uint8_t ei_ndx;
	uint8_t src;
	float coeffs[2];
} TCompensation_Strct;

typedef struct
{
	uint8_t active;
	uint16_t threshold;
} TFast_Change_Strct;

// Размер = 4*3 + 1 + "1" + 2 + 1 + "3" + 4 = 24 Б
typedef struct
{
#if 0
	TMeas_Range_Struct range[SETTINGS_ADC_MEAS_RANGE_NUM];
	uint8_t std_ndx;
	uint16_t duration;
	uint8_t avg_length;
	float half_life;
	float density_liquid;
	float density_solid;
#else
	TStandartisation_Struct standartisation[ADC_MEAS_STD_NUM];
	TCalib_Curve_Src_Value calib_src_values[ADC_MEAS_CALIB_VAL_NUM];
	TCalib_Curve_Strct calib_curve;
	TDensity_Strct density_liquid_d1;
	TDensity_Strct density_solid_d2;
	TCompensation_Strct compensation_temp[3];
	TCompensation_Strct compensation_steam;
	TMeas_Proc_Meas_Type meas_type; // можно сделать массивом со следующим параметром.
	TMeas_Proc_Meas_Type additional_meas_type;// Чтоб при работе могли рассчитываться два параметра , например плотность и концентрация
	TFast_Change_Strct fast_change;
	uint16_t duration;
	uint16_t averaging_depth;
	uint8_t ei_ndx;
	uint16_t pipe_diam;
	float att_coeffs[2];
	TMeas_Proc_Calc_Type calc_type;
	float volume_coeffs[4];
#endif
} TMeas_Process_Struct;

typedef struct
{
	uint8_t type;
	uint16_t beginning;
	uint16_t width;
	float CPeakFind;
	float CPeakSmooth;
	uint16_t TopPerc;
	uint16_t BotPerc;
} TCounters_Settings_Struct;

typedef struct
{
	float speed;
	float smooth;
} Kalman_Settings_Struct;

// Размер = 4 + 4 + 2 + "2" + 4 + 1 + 1 + 1 + "1" + 2*8*2 + 1 + "3" + 2 + 2 + 4 + 4 + 2 + 1 + 1 + 1*8 + 4*8*6 + 4*3*2 + 4*3*2 + 44*12 + 24*4 + 1 + "3" = 948 Б
typedef struct
{
	TADC_Module_Work_Modes mode;
	TADC_Module_Sync_Modes sync_mode;
	uint16_t sync_level;
	TADC_Module_Proc_Modes proc_mode;
	uint8_t data_send_en;
	uint8_t data_write_en;
	uint8_t data_file_open;
	uint8_t cntr_calc_ndx;
	uint16_t std_time_gate_closed;
	uint16_t std_time_gate_open;
	uint32_t std_gate_closed;
	uint32_t std_gate_open;
	uint16_t meas_single_time;
	uint8_t calib_curve_ndx;
	uint8_t mov_avg_depth;
	TMeas_Process_Struct meas_process[SETTINGS_ADC_MEAS_PROC_NUM];
	uint8_t meas_process_current;
	uint16_t fast_change_k;
	TCounters_Settings_Struct counters_settings[3/*ADC_MODULE_PROC_CNTRS_NEW_QTY*/];
	Kalman_Settings_Struct kalman_settings[3/*ADC_MODULE_PROC_CNTRS_NEW_QTY*/];
} TADC_Module_Settings;

// Размер = 2 Б
typedef struct
{
	uint8_t model;
	uint8_t gain;
} TPreamp_Settings;

// Размер = 1 + "3" + 4 + 1 + 1 + "2" + 4 + 4 = 20 Б
typedef struct
{
	uint8_t on_off;
	uint8_t  type;
	uint8_t ei_ndx;
	uint8_t meas_proc_ndx;
	uint8_t var_ndx;
	float val_low_thr;
	float val_high_thr;
	int val_low_thr_uA;
	int val_high_thr_uA;
} TAM_Output_Settings;

typedef struct
{
	uint8_t on_off;
	uint8_t input_type;
	uint8_t value_type;
	float coeffs[3];
	float temp_coeff_A;
	float temp_coeff_B;
} TAM_Input_Settings;

// Размер = 948 + 2 + 2 + 1 + "3" + 2 + 2 + 1*2*2 + 20*2*2 + 1 + "3" + 4 = 1052 Б
typedef struct
{
	TADC_Module_Settings adc_module;
	uint16_t timer_max_ms;
	TPreamp_Settings preamp;
	uint8_t sd_available;
	uint16_t udp_length;
	uint16_t hv_target;
	uint8_t am_dac_src[2][2];
	TAM_Output_Settings am_out[2];
	TAM_Input_Settings am_in[2];
	uint8_t serial_select;
	uint32_t serial_baudrate;
	uint8_t current_isotope_index;
	RTC_DateTypeDef src_installation_date;
	float src_activity_at_installation;
	RTC_DateTypeDef src_expiration_date;
	uint8_t udp_ip_port[4];
	uint16_t udp_port;
	uint8_t sd_meas_results_wr_en;
	uint8_t tcp_ip[12];
	int temperature_src;
	TMeas_Device_Type device_type;
	float levelmeter_length;
	uint8_t macAddr[6];
	char device_SN[10];
	int hv_module_data_to_485;
	uint8_t modbus_addr;
} TSettings;

// Размер = 2 Б
typedef struct
{
	uint16_t adc:1;
	uint16_t pwr:1;
	uint16_t bdp07:1;
	uint16_t pc:1;
} TComm_State_Struct;

// Размер = 2 Б
typedef struct
{
	uint16_t pwr_0:1;
	uint16_t pwr_1:1;
	uint16_t comm_0:1;
	uint16_t comm_1:1;
	uint16_t i_ok:1;
	uint16_t i_dng:1;
	uint16_t u_ok:1;
	uint16_t u_low:1;
	uint16_t u_high:1;
	uint16_t iu_exceed:1;
} TAnalog_Out_State_Struct;

// Размер = 2 Б
typedef struct
{
	uint16_t comm_0:1;
	uint16_t comm_1:1;
} TAnalog_Out_Comm_Check_Struct;

// Размер = 2 + 2 + 2 + "2" + 2*2 + 2*2 = 44 Б
typedef struct
{
	TComm_State_Struct comm_state;
	TComm_State_Struct comm_check_finished;
	uint16_t device_phys_params_state;
	TAnalog_Out_State_Struct analog_out_state[2];
	TAnalog_Out_Comm_Check_Struct analog_out_comm_check_finished[2];
} TDevice_State;

// Размер = 4 + 4 + 4 + 4 + 8*2 = 48 Б
typedef struct
{
	float temperature;
	float u_12V;
	float u_hv;
	float i;
	TAnalog_Module_Telemetry_Struct analog_module_params[4];
	float analog_module_out_i[2];
} TPhysDeviceParams;

// Размер = 4 + 1 + 1 + 1 + "1" + 2 + 2 + 2*2 + 48 = 76 Б
typedef struct
{
	RTC_DateTypeDef date;
	uint8_t hour;
	uint8_t minute;
	uint8_t second;
	TComm_State_Struct comm_state;
	uint16_t device_phys_params_state;
	TAnalog_Out_State_Struct analog_out_state[2];
	TPhysDeviceParams phys_params;
	uint16_t log_src;
	uint16_t log_src_param;
} TLog_Struct;

typedef struct
{
	union
	{
		struct
		{
			float counts;
			float log_meas;
			float log_liquid;
			float temparature;
			float density_current;
			float density_resulted;
		};
		float f_data[6];
	};
	uint8_t emulated_vars_mask;
} TEmulated_Meas_Proc_Vars;

typedef struct
{
	uint16_t current_out;
	uint16_t input;
	uint8_t emulated_vars_mask;
} TEmulated_Analog_InOut_Vars;

typedef struct
{
	char * name;
	float half_life;
} TIsotope_Struct;;

enum {REQ_SRC_EXT, REQ_SRC_SELF};

int settingsLoad (void);
int settingsFileRead (char * file_name, char * data, int * size);
int settingsInitDefault (void);
int settingsSave (void);
int settingsLoadFRAM (void);
int settingsSaveFRAM (void);
void deviceStateInit (void);
int logSaveFRAM (TLog_Struct * log);
int logReadFRAM (TLog_Struct * log, uint32_t ndx);
int logNumGet (uint32_t * num_start, uint32_t * num_stop);
int logClear (void);

#endif /* INC_SETTINGS_H_ */
