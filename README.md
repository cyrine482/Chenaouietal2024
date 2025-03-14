# Chenaoui et al. 2024
This is the code for the model  described in the paper 
Chenaoui, C., Marilleau, N. & Miled, S.B. Towards a generic agent-based vector-host model: effects of carrying capacity and host mobility. Appl Netw Sci 9, 33 (2024). https://doi.org/10.1007/s41109-024-00629-z


This table summarizes the parameters used in the **VectorHost model**, which simulates the interactions and dynamics between vectors (e.g., ticks) and hosts (e.g., cattle, rodents). The table includes key user-modified parameters such as host speed, initial populations  of vectors and hosts, lethal temperatures for vectors, and mortality rates along with additional parameters related to vector and hosts behaviors as described in the paper.

| **Parameter**        | **Variable**         | **Value**  | **Min** | **Max** | **Unit**   | **Category** | **Description**                               |
|----------------------|----------------------|------------|---------|---------|------------|--------------|-----------------------------------------------|
| MIN_H_SPEED          | MIN_H_SPEED          | 0.02       | -       | -       | km/h      | Host         | Minimum Host speed                            |
| MAX_H_SPEED          | MAX_H_SPEED          | 0.5        | -       | -       | km/h      | Host         | Maximum Host speed                            |
| START_ACTIVE_TIME    | START_ACTIVE_TIME    | 9.0        | -       | -       | hour      | Host         | Start active hour                             |
| END_ACTIVE_TIME      | END_ACTIVE_TIME      | 16.0       | -       | -       | hour      | Host         | End active hour                               |
| INI_NUM_CATTLE       | INI_NUM_CATTLE       | 20         | 0       | -       | -          | Host         | Initial number of cattle                      |
| INI_NUM_RODENT       | INI_NUM_RODENT       | 30         | 0       | -       | -          | Host         | Initial number of rodents                     |
| INI_NUM_VECTOR       | INI_NUM_VECTOR       | 150        | 1       | -       | -          | Vector       | Initial number of vectors                     |
| LETHAL_TEMP_SUP_L    | LETHAL_TEMP_SUP_L    | 35         | 30      | -       | °C        | Vector       | Larva Superior Lethal Temp                    |
| LETHAL_TEMP_SUP_N    | LETHAL_TEMP_SUP_N    | 35         | 20      | -       | °C        | Vector       | Nymph Superior Lethal Temp                    |
| LETHAL_TEMP_SUP_E    | LETHAL_TEMP_SUP_E    | 35         | 30      | -       | °C        | Vector       | Egg Superior Lethal Temp                      |
| LETHAL_TEMP_SUP_A    | LETHAL_TEMP_SUP_A    | 35         | 30      | -       | °C        | Vector       | Adult Superior Lethal Temp                    |
| LETHAL_TEMP_INF_N    | LETHAL_TEMP_INF_N    | -15        | -30     | 50      | °C        | Vector       | Nymph Inferior Lethal Temp                    |
| LETHAL_TEMP_INF_A    | LETHAL_TEMP_INF_A    | -15        | -30     | 50      | °C        | Vector       | Adult Inferior Lethal Temp                    |
| LETHAL_TEMP_INF_L    | LETHAL_TEMP_INF_L    | -15        | -       | -       | °C        | Vector       | Larva Inferior Lethal Temp                    |
| LETHAL_TEMP_INF_E    | LETHAL_TEMP_INF_E    | -15        | -       | -       | °C        | Vector       | Egg Inferior Lethal Temp                      |
| PERCEPTION_DISTANCE  | PERCEPTION_DISTANCE  | 5          | -       | -       | m          | Vector       | Perception distance                           |
| ProbToLay            | ProbToLay            | 1.0        | 0.0     | 1.0     | -          | Vector       | Probability to lay eggs (adults only)         |
| P_NAT_MOR_N          | P_NAT_MOR_N          | 0.002      | 0.0     | 1.0     | -          | Vector       | Natural mortality probability for nymph       |
| P_NAT_MOR_L          | P_NAT_MOR_L          | 0.004      | 0.0     | 1.0     | -          | Vector       | Natural mortality probability for larva       |
| P_NAT_MOR_E          | P_NAT_MOR_E          | 0.000      | 0.0     | 1.0     | -          | Vector       | Natural mortality probability for egg         |
| P_NAT_MOR_A          | P_NAT_MOR_A          | 0.000      | 0.0     | 1.0     | -          | Vector       | Natural mortality probability for adult       |
| P_ATTACH             | P_ATTACH             | 0.7        | 0.0     | 1.0     | -          | Vector       | Probability of attachment                     |
| AttachToDetach       | AttachToDetach       | 7          | 1       | 10      | -          | Vector       | Duration of attachment until detachment       |
| HostSeeking          | HostSeeking          | false      | -       | -       | -          | Vector       | Whether the vector seeks a host               |
| TimeDieQuesting      | TimeDieQuesting      | 14463900.0 | 0.0     | 13140014400.0 | -    | Vector       | Time to die when questing (if not attached)   |
| fecundity            | fecundity            | 5.0        | 0.0     | 3000.0  | -          | Vector       | Hypothetical fecundity                        |
| THRESHOLD_T_N        | THRESHOLD_T_N        | 4.0        | -       | -       | °C        | Vector       | Temperature threshold for diapause (nymph)   |
| THRESHOLD_T_L        | THRESHOLD_T_L        | 2.0        | -       | -       | °C        | Vector       | Temperature threshold for diapause (larva)   |
| THRESHOLD_T_E        | THRESHOLD_T_E        | 1.0        | -15.0   | 35.0    | °C        | Vector       | Temperature threshold for diapause (egg)     |
| THRESHOLD_T_A        | THRESHOLD_T_A        | 4.0        | -       | -       | °C        | Vector       | Temperature threshold for diapause (adult)   |
| id                   | id                   | 1          | -       | -       | -          | Simulation   | Simulation ID                                 |
| parasite_max         | parasite_max         | 3.0        | 0.0     | 100.0   | -          | Host         | Carrying capacity of parasite                 |


