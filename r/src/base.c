/*
 * This library provides an R server for Q
 *
 * See kx wiki https://code.kx.com/trac/wiki/Cookbook/IntegratingWithR
 */

#include <errno.h>
#include <string.h>
#include <R.h>
#include <Rdefines.h>
#include <Rembedded.h>
#include <Rinterface.h>
#include <R_ext/Parse.h>
#include <k.h>

#include "common.c"
#include "rserver.c"

int R_SignalHandlers = 0;
