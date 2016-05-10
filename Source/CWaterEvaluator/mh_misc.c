#include <stdio.h>
#include <stdlib.h>
#include "common.h"
#include "misc.h"

water_type read_water_file(string water_file_name)
{
   int c_index,m_index,fse;
   water_type water;
   FILE *water_file;
   water_file=fopen(water_file_name,"r");
   fse=fscanf(water_file,"%d",&water.c);
   fse=fscanf(water_file,"%d %d %d %d",&water.cw,&water.cp,&water.min_tarea,
   &water.tarea);
   /* printf("%d %d %d %d\n",water.c,water.cw,water.cp,water.tarea); */
   fse=fscanf(water_file,"%f %d",&water.gw_proportion,&water.gw_limit);
   water.inflow=(int *)calloc(m+1,sizeof(int));
   for(m_index=start_month;m_index<=m;m_index++) fse=fscanf(water_file,"%d",
   &water.inflow[m_index]); 
   water.cgm=(int *)calloc(water.c+1,sizeof(int));
   for(c_index=start_crop;c_index<=water.c;c_index++) fse=fscanf(water_file,
   "%d",&water.cgm[c_index]); 
   /* print_vector(water.cgm,water.c); */
   water.vcost=(int *)calloc(water.c+1,sizeof(int));
   for(c_index=start_crop;c_index<=water.c;c_index++) fse=fscanf(water_file,
   "%d",&water.vcost[c_index]); 
   /* print_vector(water.vcost,water.c); */
   water.wreq=(float **)calloc(m+1,sizeof(float *));

   /* print_vector(water.pump,m); */
   for(m_index=start_month;m_index<=m;m_index++) 
   {
      water.wreq[m_index]=(float *)calloc(water.c+1,sizeof(float));
      for(c_index=start_crop;c_index<=water.c;c_index++) 
      {
         fse=fscanf(water_file,"%f",&water.wreq[m_index][c_index]); 
      }
   }
   /* print_float_matrix(water.wreq,m,water.c); */
   water.tenvf=(int *)calloc(m+1,sizeof(int));
   for(m_index=start_month;m_index<=m;m_index++) fse=fscanf(water_file,"%d",
   &water.tenvf[m_index]); 
   water.area_limits=(int *)calloc(water.c+1,sizeof(int));
   for(c_index=start_crop;c_index<=water.c;c_index++) fse=fscanf(water_file,
   "%d",&water.area_limits[c_index]);
   fse++;
   fclose(water_file);
   return water;
}
