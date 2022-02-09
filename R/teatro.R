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
teatro <- function(mic3){
  
  noise1 <- runif(5,0,2)
  noise2 <- runif(5,0,2)
  noise <- matrix(c(noise1,noise2),2,5)
  mov_attoreA <- mov_attoreA+noise
  
  noise1 <- runif(5,0,2)
  noise2 <- runif(5,0,2)
  noise <- matrix(c(noise1,noise2),2,5)
  mov_attoreB <- mov_attoreB+noise
  
  # calcolo intensita' del suono ricevuto ad ogni mossa dai tre microfoni
  M <- matrix(mic1,2,5)
  suono_mic1_A <- 6*log(3000/colSums((mov_attoreA-M)^2))
  suono_mic1_B <- 6*log(3000/colSums((mov_attoreB-M)^2))

  M <- matrix(mic2,2,5)
  suono_mic2_A <- 6*log(3000/colSums((mov_attoreA-M)^2))
  suono_mic2_B <- 6*log(3000/colSums((mov_attoreB-M)^2))
  
  M <- matrix(mic3,2,5)
  suono_mic3_A <- 6*log(3000/colSums((mov_attoreA-M)^2))
  suono_mic3_B <- 6*log(3000/colSums((mov_attoreB-M)^2))
  
  # la voce e' catturata dal microfono che rileva l'intensita' maggiore
  intensityA <- pmax(suono_mic1_A,suono_mic2_A,suono_mic3_A)
  intensityB <- pmax(suono_mic1_B,suono_mic2_B,suono_mic3_B)
  
  out <- rbind(intensityA,intensityB)
  return(out)
}



search_solution = function(N_TESTS){
  
  MAX_INTENSITY = 0
  OPTIMAL_XY = c(0,0)
  
  for (i in c(1:N_TESTS)) {
    x = floor(runif(1, min=0, max=20)) # Generate TWO integer random numbers between 0 and 20
    y = floor(runif(1, min=0, max=10))
    xy = c(x,y)

    M_result = teatro(xy)
    sum_M = sum(M_result)   #    --> massimizzare questo vettore che ritorna f_teatro, perch� contiene le intensit�
    if (sum_M > MAX_INTENSITY) {
      MAX_INTENSITY = sum_M
      OPTIMAL_XY = xy
    }
  }
  # ciao ragazzi
  my_list = list("MAX_INTENSITY" = MAX_INTENSITY, "OPTIMAL_XY" = OPTIMAL_XY)
  return(my_list)
}

# ................................................................................#

N_TESTS = 10000
mic1 <- c(0,0) # coordinate del 1 microfono fisso
mic2 <- c(20,0) # coordinate del 2 microfono fisso

# simulo movimenti attori, con rumore casuale. Gli attori si muovono in 5 posizioni principali durante lo spettacolo
mov_attoreA <- matrix(c(2,2,9,3,12,5,8,7,10,7),2,5)
mov_attoreB <- matrix(c(18,2,15,4,12,5,10,4,15,3),2,5)

t_start = Sys.time()
solution = search_solution(N_TESTS)
t_delta = round(difftime(Sys.time(), t_start, units = 'secs'), 2)
cat("     MAX_INTENSITY:", solution$MAX_INTENSITY, "     OPTIMAL_XY:", solution$OPTIMAL_XY, '    ( seconds:', t_delta, ')')


# SECONDS
# 10k:   0.64
# 100k:  6.36
# 1kk:   63.67
