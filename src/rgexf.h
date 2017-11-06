/*

*/

#include <stdio.h>

void RSwitchEdges(
// Orders every pair of edges putting as source
// the one with the lowest id number
  int *nedges, 
  double * in_source, 
  double * in_target,
  double * out_source, 
  double * out_target) 
{
  for(int i=0; i<*nedges; i++) {
      
      // If source < target
      if (in_source[i] < in_target[i]) {
        out_source[i] = in_source[i];
        out_target[i] = in_target[i];
      }
      else { // Otherwhise
        out_target[i] = in_source[i];
        out_source[i] = in_target[i];
      }
    }
}

