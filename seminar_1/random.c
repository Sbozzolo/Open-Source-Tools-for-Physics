/* time.h for time() */
#include <time.h>
/* stdlib for rand */
#include <stdlib.h>
/* stdio for printf */
#include <stdio.h>

/* argc = number of arguments supplied, it is always at least 1 because
   the program it self it is counted as argument */
/* argv = array of arguments */
int main ( int argc, char **argv ) {

  /* Save argc and argv in other variables */
  int    n_arguments = argc;
  char **arguments   = argv;

  /* Check that the number of arguments is right */
  if (n_arguments != 4){
    printf("Wrong number of arguments!\n");
    printf("Usage: %s number_of_numbers minimum maximum\n", argv[0]);
    /* If it is not exit  */
    return 1;

  }else{

    /* Inizialize seed for randomness */
    srand(time(NULL));

    /* counter */
    int i = 0;

    int number  = atoi(arguments[1]);
    int minimum = atoi(arguments[2]);
    int maximum = atoi(arguments[3]);

    /* Print random numbers */
    for (i; i < number; i++){
      printf("%i\n", rand() % (maximum - minimum + 1) + minimum);
    }
  }

  return 0;
}
