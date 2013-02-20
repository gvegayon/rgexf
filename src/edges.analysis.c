#include <R.h>
#include <Rmath.h>
#include "rgexf.h"


void RCheckDplEdges(
/*##############################################################################
# Checks for duplicated edges
##############################################################################*/
  double *in_source,  // Input Source
  double *in_target,  // Input Target
  int    *undirected, // Weather to switch columns or not
  double *out_source, // Output Source
  double *out_target, // Output Target
  double *n_repeat    // Output Num of repeat
  )
{
  int nedges = sizeof(*in_source);
  int * n = &nedges;
  
  // Switchs sources and target
  if (*undirected == 1) {
    
    RSwitchEdges(n, in_source, in_target,
      out_source, out_target);
  }
  else {
    for(int i=0; i<nedges; i++) {
      out_source[i] = in_source[i];
      out_target[i] = in_target[i];
    }
  }
  
  // Counts the number of repetitions
  for(int i=0; i<nedges; i++) {
        
    // n_repat = -1 if the loop hasnt pass through it
    if (n_repeat[i] != -1) {
    
      // Current comparation
      int tmp_source=out_source[i];
      int tmp_target=out_target[i];
      
      for(int j = 0; j<nedges; j++) {
        
        // Should not compare the same link with it self
        if (i != j) {
          // If it is the same
          if (tmp_source == out_source[j] && tmp_target == out_target[j]) {
            n_repeat[i] = n_repeat[i] + 1;
            n_repeat[j] = -1;
          }            
        }
        
        if (n_repeat[i] == 0) n_repeat[i] = 1;
      }
    }
  }
}
