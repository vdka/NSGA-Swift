/* Constants */

#define small_number 0.00001
#define MAXINT 2147483647
#define max_chars 80
#define start_item 1
#define start_crop 1
#define start_month 1
#define start_member 1
#define start_position 1
#define start_iteration 1
#define m 12
#define divers_pc 0.1 
#define start_objective 1
#define num_objectives 2
#define replace 1
#define genetic 2
#define periodic 0
#define detected 1
#define min_area 10
#define min_num_crops 2
#define net_revenue_objective 1
#define environment_objective 2
#define groundwater_pumping_objective 3
#define sol_selection 0.1
/* #define divers_pc 0.02 */
/* #define divers_pc 1 */ 

/* The custom data types */

typedef char string[max_chars];
typedef struct
{
   int c;
   int cw;
   int cp;
   int min_tarea;
   int tarea;
   float gw_proportion;
   int gw_limit;
   int *inflow;
   int *cgm;
   int *vcost;
   float *allocation;
   float **wreq;
   int *tenvf;
   int *area_limits;
} water_type;
