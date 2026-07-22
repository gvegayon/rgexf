#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
Function getit(int i) {
  
  Environment env = Environment::namespace_env( "stats" );

  return env[".asSparse"];
}

/***R

getit(1)
# > stats::.asSparse
# Error: '.asSparse' is not an exported object from 'namespace:stats'
*/
