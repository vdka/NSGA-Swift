#include "evaluator.h"
#include "common.h"
#include "constraints.h"
#include "mh_misc.h"
#include "misc.h"
#include "objectives.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// env_cost should be an array of 12 int values
int evaluateWaterC(int argc, char** argv, float* nr_cost, int* env_cost, float* feas_violation) {
    int *      solution_x, sol_length, crop, month, *envf, *allocation;
    float*     p;
    string     file_name;
    water_type water;
    if (argc == 1) print_exit_message(argv);
    strcpy(file_name, argv[file_name_index]);
    sol_length = atoi(argv[sol_length_index]);
    envf       = (int*) calloc(m + 1, sizeof(int));
    /* printf("%d %d %d %d\n",num_non_solution_args,sol_length,
    num_non_solution_args+sol_length,argc); */
    /* printf("%d %d %d %d\n",num_non_solution_args,sol_length,
    num_non_solution_args+sol_length,argc); */
    if (argc != num_non_solution_args + sol_length + m) print_exit_message(argv);
    solution_x = (int*) calloc(sol_length + 1, sizeof(int));
    /* printf("A \n"); */
    for (crop            = start_crop; crop <= sol_length; crop++)
        solution_x[crop] = atoi(argv[sol_length_index + crop]);
    for (month      = start_month; month <= m; month++)
        envf[month] = atoi(argv[sol_length_index + sol_length + month]);
    /* printf("B \n"); */
    water = read_water_file(file_name);
    /* printf("C \n"); */
    p          = (float*) calloc(m + 1, sizeof(float));
    allocation = (int*) calloc(m + 1, sizeof(int));
    /* printf("D \n"); */
    calculate_allocation(allocation, water.inflow, envf);
    /* printf("E \n"); */
    calculate_p(p, water.c, water.wreq, solution_x, allocation);
    /* printf("F \n"); */
    evaluate_all_objectives(water.c, water.cp, water.cw, solution_x, water.cgm, water.vcost,
                            water.wreq, water.tenvf, envf, p, nr_cost, env_cost);
    /* printf("H \n"); */
    *feas_violation =
        evaluate_total_constraint_violation(solution_x, p, water.wreq, allocation, water.c,
                                            water.gw_proportion, water.gw_limit, water.tarea,
                                            water.area_limits, water.min_tarea);
    //   printf("%f %d %f\n",*nr_cost,*env_cost,*feas_violation);
    /* printf("%f\n",feas_violation); */
    for (int m_index = start_month; m_index <= m; m_index++) {
        free(water.wreq[m_index]);
    }
    free(water.inflow);
    free(water.cgm);
    free(water.vcost);
    free(water.wreq);
    free(water.tenvf);
    free(water.area_limits);
    free(solution_x);
    free(allocation);
    free(envf);
    free(p);
    return 0;
}

void print_exit_message(char* argv[]) {
    fprintf(stderr, "Usage: %s file_name n solution_x[1]...solution_x[n] ", argv[0]);
    fprintf(stderr, "envf[1] ... envf[m]\n");
    exit(1);
}
