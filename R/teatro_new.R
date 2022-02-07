"
  Test case B: posizionamento microfono.

   DESCRIZIONE
   In un teatro c'e' un palco di forma rettangolare di dimensioni 20x10 metri, modellizzato come il rettangolo [0,20]x[0,10].
   Ai due angoli del palco di fronte al pubblico (ovvero in (0,0) e in (20,0) ) sono posizionati due microfoni fissi.
   Un TERZO microfono e' mobile e va posizionato in modo da massimizzare la ricezione  della voce degli attori.
  
   In uno spettacolo recitano due attori, che durante le scene si muovono secondo un  percorso abbastanza ben definito, ma affetto da rumore. 
   Gli attori si muovono in 5 posizioni principali durante lo spettacolo.
   L'intensita' del suono ricevuto dai tre microfoni e' inversamente proporzionale alla distanza dagli attori.
  
   In ogni posizione, la voce e' trasmessa dal microfono che rileva l'intensita' maggiore.
  
   DOMANDA
   Come va posizionato il microfono mobile (la cui posizione e' fissa durante lo spettacolo), per massimizzare la ricezione della voce di entrambi gli attori?
  
   INPUT:
     mic3=vettore bidimensionale con le coordinate (x,y) del terzo microfono
  
   OUTPUT: 
   matrice 2x5 contenente:
     1 riga: intensita' voce massima rilevata dai microfoni per ciascuna delle 5 posizioni sul palco dell'attore A
     2 riga: intensita' voce massima rilevata dai microfoni per ciascuna delle 5 posizioni sul palco dell'attore B
"

# ................................ FUNCTIONS .....................................#

compute_mics_intensity = function(mov_attoreA, mov_attoreB, mic3) {
  # calcolo intensita' del suono ricevuto ad ogni mossa dai tre microfoni
  M = matrix(mic1,2,5)
  suono_mic1_A = 6*log(3000/colSums((mov_attoreA-M)^2))
  suono_mic1_B = 6*log(3000/colSums((mov_attoreB-M)^2))
  
  M = matrix(mic2,2,5)
  suono_mic2_A = 6*log(3000/colSums((mov_attoreA-M)^2))
  suono_mic2_B = 6*log(3000/colSums((mov_attoreB-M)^2))
  
  M = matrix(mic3,2,5)
  suono_mic3_A = 6*log(3000/colSums((mov_attoreA-M)^2))
  suono_mic3_B = 6*log(3000/colSums((mov_attoreB-M)^2))
  
  # la voce e' catturata dal microfono che rileva l'intensita' maggiore
  intensityA = pmax(suono_mic1_A, suono_mic2_A, suono_mic3_A) # o mean
  intensityB = pmax(suono_mic1_B, suono_mic2_B, suono_mic3_B) # o mean
  
  intensities = rbind(intensityA, intensityB) # out
  sum_intensity = sum(intensities)
  
  return(sum_intensity)
}



get_mics_intensity = function(mic3){
  
  noise1 = runif(5,-1,1)
  noise2 = runif(5,-1,1)
  noise = matrix(c(noise1,noise2),2,5)
  mov_attoreA = mov_attoreA + noise
  
  noise1 = runif(5,-1,1)
  noise2 = runif(5,-1,1)
  noise = matrix(c(noise1,noise2),2,5)
  mov_attoreB = mov_attoreB + noise
  
  sum_intensity = compute_mics_intensity(mov_attoreA, mov_attoreB, mic3)
  return (sum_intensity)
}


get_mics_intensity_with_NO_noise = function(mic3){
  
  sum_intensity = compute_mics_intensity(mov_attoreA, mov_attoreB, mic3)
  return (sum_intensity)
}





find_best_xy_ALGO_1 = function() {
  
  Max_Intensity = 0;
  Best_xy = 0;
  
  for (i in c(1:N_TESTS)) {
    xy = c(runif(1, min=0, max=20), runif(1, min=0, max=10))
    intensities = get_mics_intensity(xy)
    
    if (intensities > Max_Intensity) {
      Max_Intensity = intensities
      Best_xy = xy
    }
  }
  my_list = list("Algo" = 'Algo_1', "Max_Intensity" = Max_Intensity, "Best_xy" = Best_xy)
  return(my_list)
}




find_best_xy_ALGO_2 = function() {
  
  x = runif(1, min=0, max=20) # Generate TWO random numbers between 0 and 20
  y = runif(1, min=0, max=10)
  Best_xy = c(x,y);
  Max_Intensity = get_mics_intensity(Best_xy)
  
  xy = c(runif(1, min=0, max=20), runif(1, min=0, max=10))
  
  for (i in c(1:N_TESTS)) {
    d = rnorm(2, mean = 0, sd = 1)
    xy = xy + d
    
    intensities = get_mics_intensity(xy)
    
    if (intensities > Max_Intensity) {
      Max_Intensity = intensities
      Best_xy = xy
    }
  }
  my_list = list("Algo" = 'Algo_2', "Max_Intensity" = Max_Intensity, "Best_xy" = Best_xy)
  return(my_list)
}





find_best_xy_FDSA = function() {
  L = numeric()
    
  #scelgo i parametri del metodo
  alpha = -0.3
  gamma = -0.1
  a = 0.01
  A = N_TESTS * 0.075
  c = -1
  
  #scelgo il guess iniziale per i parametri in modo casuale
  x = runif(1, min_1, max_1) 
  y = runif(1, min_2, max_2)
  xy = c(x,y)
  
  i = 0
  while (i < N_TESTS) {
    
    ck = c/(i+1)^gamma   # approssimo la derivata con le differenze finite
    
    
    gx = (get_mics_intensity(c(x+ck, y)) - get_mics_intensity(c(x-ck, y))) / (2*ck) # rapporto incrementale variando x
    gy = (get_mics_intensity(c(x, y+ck)) - get_mics_intensity(c(x, y-ck))) / (2*ck) # rapporto incrementale variando y
    
    ak = a/(i+1+A)^alpha
    
    x = min(max(x - ak*gx, min_1), max_1)
    y = min(max(y - ak*gy, min_2), max_2)
    #cat(" i",i,"     ck:", ck, '    ak', ak, "    gx;", gx, '      gy', gy, "     x", x, "     y", y, "\n")
    
    i = i+1
  }
  
  Best_xy = c(x,y)
  Max_Intensity = get_mics_intensity(Best_xy)
  
  my_list = list("Algo" = 'Algo_FDSA', "Max_Intensity" = Max_Intensity, "Best_xy" = Best_xy)
  return(my_list)
}




find_best_xy_GENETIC = function() {
  library(graphics)
  library(stats)
  library(GA)
  
  f2  =  function(x)  get_mics_intensity(x[1]) + 1000

  GA  =  ga(type = "real-valued", 
          fitness = f2,
          lower = c(min_1, min_2), 
          upper = c(max_1, max_2), 
          popSize = 100, maxiter = 250, run = 20, monitor =FALSE)
  # ?ga
  # type:     the type of genetic algorithm to be run depending on the nature of decision variables. Possible values are:
    #            "binary" (if decision variable is binary)    |  "real-valued" (floating numbers)     |  "permutation" (to reorder a list of objects)
  # fitness:  the fitness function, any allowable R function which takes as input an individual string representing a potential solution, and returns a numerical value describing its "fitness".
  # lower:    a vector of length equal to the decision variables providing the lower bounds of the search space in case of real-valued or permutation encoded optimizations.
  # run:      se per TOT generazioni consecutive non ottengo un miglioramento, allora stoppo
  # popSize:  il numero di campioni che trovo inizialmente, e che faccio evolvere in seguito nell'ottimizzazione genetica
  # maxiter:  il numero massimo di iterazioni
  
  #summary(GA)  #grafico di evoluzione fitness
  #plot(GA)

  my_list = list("Algo" = 'Algo Genetic', "Max_Intensity" = GA@fitness[1], "Best_xy" = c(GA@solution[1], GA@solution[2]))
  return(my_list)
}
# ................................................................................#


# ....... VALORI INPUT ..........
N_ROUNDS = 100
N_TESTS = 100
# ...............................


# ....... VALORI FISSI ..........
mic1 = c(0,0) # coordinate del 1 microfono fisso
mic2 = c(20,0) # coordinate del 2 microfono fisso

# simulo movimenti attori, con rumore casuale. Gli attori si muovono in 5 posizioni principali durante lo spettacolo
mov_attoreA = matrix(c(2,2,9,3,12,5,8,7,10,7), 2, 5)
mov_attoreB = matrix(c(18,2,15,4,12,5,10,4,15,3), 2, 5)

#mov_attoreA = matrix(c(10,5,10,5,10,5,10,5,10,5), 2, 5)
#mov_attoreB = matrix(c(10,5,10,5,10,5,10,5,10,5), 2, 5)


#estremi del range del primo parametro
min_1 = 0
max_1 = 20

#estremi del range del secondo parametro
min_2 = 0
max_2 = 10
# ...............................



# ------------  CALCOLI  ................#

v_x = c() # vettori per plottare posizioni microfono 3
v_y = c()


T_START = Sys.time()
for (i in c(1:N_ROUNDS)) {
  t_start = Sys.time()
  solution = find_best_xy_FDSA()

  # find_best_xy_ALGO_1       find_best_xy_ALGO_2     find_best_xy_FDSA     find_best_xy_GENETIC
  t_delta = round(difftime(Sys.time(), t_start, units = 'secs'), 2)
  cat("   i:",i, "   ", solution$Algo, "    N_TESTS:", N_TESTS,"     Max_Intensity:", solution$Max_Intensity, "     Best_xy:", solution$Best_xy, '    ( seconds:', t_delta, ')\n')
  v_x = c(v_x, solution$Best_xy[1])
  v_y = c(v_y, solution$Best_xy[2])
}

t_delta = round(difftime(Sys.time(), T_START, units = 'secs'), 2)
cat("    ", solution$Algo, "    N�tests done:", N_ROUNDS*N_TESTS, '    ( seconds:', t_delta, ')\n')

# ...............................



# ------------ PLOTS ................#
# Microfoni 1,2,3
plot(v_x, v_y, main = solution$Algo, col='red', pch=1,
     xlab = "X axis", ylab = "Y axis",
     xlim = c(0,20), ylim = c(0,10))
points(0,0, col='red', pch=2)
points(20,0, col='red', pch=2)

# Attori A e B
for (i in c(1:dim(mov_attoreA)[2])) {
  points(mov_attoreA[1,i], mov_attoreA[2,i], col='blue', pch = 'A')
  points(mov_attoreB[1,i], mov_attoreB[2,i], col='blue', pch = 'B')
}
# ...............................


