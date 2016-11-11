#include <stdio.h>
#include <stdlib.h>
#include "common.h"
#include "objectives.h"

void evaluate_all_objectives(int c, int cp, int cw, int* solution_x, int* cgm, int* vsosts,
                             float** wreq, int* tenvf, int* envf, float* p, float* nr_cost,
                             int* env_cost) {
    *nr_cost = evaluate_net_revenue(c, cp, cw, solution_x, cgm, wreq, vsosts, p);
    evaluate_environment_costs(tenvf, envf, env_cost);
}

float evaluate_net_revenue(int c, int cp, int cw, int* solution_x, int* cgm, float** wreq,
                           int* vcosts, float* p) {
    int   c_index, m_index, total1 = 0, total4 = 0;
    float total2 = 0, total3 = 0, net_revenue;
    for (c_index = start_crop; c_index <= c; c_index++)
        total1 += (cgm[c_index] * solution_x[c_index]);
    /* printf("Crop Gross Margins:\n");
    for(c_index=start_crop;c_index<=c;c_index++) printf("%d ",cgm[c_index]*
    solution_x[c_index]);
    printf("\n"); */
    /* Zero out negative pumping values */
    for (m_index                       = start_month; m_index <= m; m_index++)
        if (p[m_index] < 0) p[m_index] = 0.0;
    /* printf("Monthly river water costs:\n"); */
    for (m_index = start_month; m_index <= m; m_index++) {
        for (c_index = start_crop; c_index <= c; c_index++) {
            total2 += (wreq[m_index][c_index] * solution_x[c_index]);
        }
        total2 -= p[m_index];
        /* printf("%f ",total2*cw); */
    }
    /* printf("\n"); */
    for (m_index = start_month; m_index <= m; m_index++) {
        total3 += p[m_index];
    }
    /* printf("Pumping costs:\n");
    printf("%f ",total3*cp);
    printf("\n");
    printf("Crop variable costs:\n");
    for(c_index=start_crop;c_index<=c;c_index++) printf("%d ",vcosts[c_index]*
    solution_x[c_index]);
    printf("\n"); */
    for (c_index = start_crop; c_index <= c; c_index++)
        total4 += (vcosts[c_index] * solution_x[c_index]);
    net_revenue = total1 - total2 * cw - total3 * cp - total4;
    return net_revenue;
}

void evaluate_environment_costs(int* tenvf, int* envf, int* env_cost) {
    int m_index;
    for (m_index = start_month; m_index <= m; m_index++) {
        int v = tenvf[m_index] - envf[m_index];
        if (v >= 0) {

            env_cost[m_index] = (tenvf[m_index] - envf[m_index]);
        }
    }
}
