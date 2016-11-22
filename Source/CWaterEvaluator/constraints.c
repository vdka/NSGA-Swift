#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "common.h"
#include "constraints.h"
#include "mh_misc.h"
#include "misc.h"


float evaluate_total_constraint_violation(int *solution_x,float *p,float **wreq,int *allocation,int c,float gw_proportion,int gw_limit,int tarea,int *area_limits,int min_tarea,int* env_cost, int* tenvf)
{
   int c_index,m_index;
   float total,total_violation=0;
   /* Constraint 1 */
   total=0;
   for(m_index=start_month;m_index<=m;m_index++)
   {
      total+=p[m_index];
   }
   if(total>gw_limit) total_violation+=(total-gw_limit);

    for (m_index = start_month; m_index <= m; m_index++) {
        int monthly_target = tenvf[m_index];
        int monthly_env_cost = env_cost[m_index];
        int min_env_cost = monthly_target * 0.5;
        if (monthly_env_cost < min_env_cost) {
            total_violation += min_env_cost - monthly_env_cost;
        }
    }
   /* Constraint 2 */
   /* printf("TV=%f\n",total_violation); */
   /* for(m_index=start_month;m_index<=m;m_index++)
   {
      if(p[m_index]>(gw_proportion*allocation[m_index])) total_violation+=
      (p[m_index]-(gw_proportion*allocation[m_index]));
   } */
   /* Constraint 3 */
   /* printf("TV=%f\n",total_violation); */
   total=0;
   for(c_index=start_crop;c_index<=c;c_index++)
   {
      total+=solution_x[c_index];
   }
   if(total>tarea) total_violation+=(total-tarea);
   if(total<min_tarea) total_violation+=(min_tarea-total);
   for(c_index=start_crop;c_index<=c;c_index++)
   {
      if(area_limits[c_index])
      {
         if(solution_x[c_index]>area_limits[c_index]) total_violation+=
         (solution_x[c_index]-area_limits[c_index]);
      }
   }
   /* printf("TV=%f\n",total_violation); */
   return total_violation;
}


void calculate_allocation(int *allocation,int *inflow,int *envf)
{
   int m_index; 
   for(m_index=start_month;m_index<=m;m_index++) allocation[m_index]=inflow
   [m_index]-envf[m_index];
   /* printf("Allocation:\n"); */
   /* print_vector(allocation,m); */
}


void calculate_p(float *p,int c,float **wreq,int *solution_x,int *allocation)
{
   int m_index,c_index;
   float total;
   /* printf("Water requirements:\n"); */
   for(m_index=start_month;m_index<=m;m_index++)
   {
      total=0;
      for(c_index=start_crop;c_index<=c;c_index++)
      {
         total+=(wreq[m_index][c_index]*solution_x[c_index]);
      }
      p[m_index]=total-allocation[m_index];
      /* printf("%f ",total); */
   }
   /* printf("\n Pumping:\n"); 
   print_float_vector(p,m); */
}
