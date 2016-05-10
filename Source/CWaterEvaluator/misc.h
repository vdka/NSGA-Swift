/********************************************************
* This file contains the function prototypes for misc.c *
********************************************************/

/* Function Prototypes */

void print_vector(int *,int);
void print_nonreturn_vector(float *,int);
void print_float_vector(float *,int);
void print_matrix(int **,int,int);
void print_float_matrix(float **,int,int);
int roundup(float);
void copy_vector(int *,int *,int);
void copy_float_vector(float *,float *,int);
void copy_matrix(int **,int **,int,int);
float sum_float_vector(float *,int);
int sum_vector(int *,int);
int sum_matrix(int **,int,int);
int imax(int,int);
void initialise_vector(int *,int,int);
void initialise_matrix(int **,int,int,int);
void initialise_float_vector(float *,int,float);
void initialise_float_matrix(float **matrix,int,int,float);
int get_vector_maximum(int *,int *,int *,int);
int get_vector_minimum(int *,int *,int *,int);
int get_vector_maximum1(int *,int);
int find_value(int *,int,int);
int compare_vectors(int *,int *,int);
float compute_standard_deviation(int *,int,float);
