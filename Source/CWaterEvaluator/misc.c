#include <stdio.h>
#include <math.h>
#include "common.h"
#include "misc.h"


void print_vector(int *vector,int num_elements)
{
   int i;
   for(i=1;i<=num_elements;i++) 
   {
      printf("%d ",vector[i]);
   }
   printf("\n");
}


void print_nonreturn_vector(float *vector,int num_elements)
{
   int i;
   for(i=1;i<=num_elements;i++) 
   {
      printf("%f ",vector[i]);
   }
}


void print_float_vector(float *vector,int num_elements)
{
   int i;
   for(i=1;i<=num_elements;i++) 
   {
      printf("%f ",vector[i]);
   }
   printf("\n");
}


void print_matrix(int **matrix,int n,int m1)
{
   int i;
   for(i=1;i<=n;i++)
   {
      print_vector(matrix[i],m1);
   }
}


void print_float_matrix(float **matrix,int n,int m1)
{
   int i;
   for(i=1;i<=n;i++)
   {
      print_float_vector(matrix[i],m1);
   }
}


int roundup(float a)
{
   int b=(int)a;
   if(a-b>0)
      return b+1;
   else
      return b;
}


void copy_vector(int *a,int *b,int n)
{
   int i;
   for(i=1;i<=n;i++) b[i]=a[i];
}


void copy_float_vector(float *a,float *b,int n)
{
   int i;
   for(i=1;i<=n;i++) b[i]=a[i];
}


void copy_matrix(int **a,int **b,int m1,int n)
{
   int i;
   for(i=1;i<=m1;i++) copy_vector(a[i],b[i],n);
}


float sum_float_vector(float *a,int n)
{
   int i;
   float sum=0;
   for(i=1;i<=n;i++) sum+=a[i];
   return sum;
}


int sum_vector(int *a,int n)
{
   int i,sum=0;
   for(i=1;i<=n;i++) sum+=a[i];
   return sum;
}


int sum_matrix(int **a,int m1,int n)
{
   int i,sum=0;
   for(i=1;i<=n;i++) sum+=sum_vector(a[i],m1);
   return sum;
}


int imax(int a,int b)
{
   if (a>b)
      return a;
   else
      return b;
}


void initialise_vector(int *vector,int n,int value)
{
   int i;
   for(i=1;i<=n;i++) vector[i]=value;
}


void initialise_matrix(int **matrix,int n,int m1,int value)
{
   int i;
   for(i=1;i<=n;i++) initialise_vector(matrix[i],m1,value);
}


void initialise_float_vector(float *vector,int n,float value)
{
   int i;
   for(i=1;i<=n;i++) vector[i]=value;
}


void initialise_float_matrix(float **matrix,int n,int m1,float value)
{
   int i;
   for(i=1;i<=n;i++) initialise_float_vector(matrix[i],m1,value);
}


int get_vector_maximum(int *vector,int *present1,int *present2,int n)
{
   int i,max_index=0,max_value=0;
   for(i=1;i<=n;i++)
   {
      if(present1[i]&&present2[i]&&(vector[i]>max_value)) 
      {
         max_index=i;
         max_value=vector[i];
      }
   }
   return max_index;
}


int get_vector_minimum(int *vector,int *present1,int *present2,int n)
{
   int i,min_index=0,min_value=MAXINT;
   for(i=1;i<=n;i++)
   {
      if(present1[i]&&present2[i]&&(vector[i]<min_value)) 
      {
         min_index=i;
         min_value=vector[i];
      }
   }
   return min_index;
}


int get_vector_maximum1(int *vector,int n)
{
   int i,max;
   max=vector[1];
   for(i=2;i<=n;i++)
   {
      if(vector[i]>max)
      {
         max=vector[i];
      }
   }
   return max;
}


int find_value(int *a,int v,int n)
{
   int i;
   for(i=1;i<=n;i++)
   {
      if(v==a[i]) return i;
   }
   return 0;
}


int compare_vectors(int *a,int *b,int n)
{
   int i;
   for(i=1;i<=n;i++)
   {
      if(a[1]!=b[1]) return 0;  
   }
   return 1;
}


float compute_standard_deviation(int *a,int n,float average)
{
   int i;
   float total=0;
   for(i=1;i<=n;i++) total+=pow(a[i]-average,2);
   return sqrt(total/n);
}
