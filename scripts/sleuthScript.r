library(sleuth)
library(dplyr)
stab = read.table("KallistoTable", header=TRUE)

so = sleuth_prep(stab)

so = sleuth_lrt(so, '2dpi', '6dpi')


