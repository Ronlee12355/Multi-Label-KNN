# compute hamming loss, given a matrix of true labels and a matrix of predicted probabilities.
# true_labels: Matrix of true labels, columns corresponding to labels and rows to instances.
# predictions: Matrix of probabilities predicted by a classifier.

HammingLoss<-function(true_labels, predictions){
  if(nrow(true_labels) != nrow(predictions) | ncol(true_labels) != ncol(predictions)){
    stop("labels and predictions should be in the same format")
  }
  result = 0
  M=ncol(true_labels)
  N=nrow(true_labels)
  
  result<-sapply(seq(nrow(true_labels)), function(x){
    tmp<-true_labels[x,] == predictions[x,]
    tmp<-ifelse(tmp == F, 1, 0)
    return(sum(tmp)/M)
  })
  
  return(sum(result)/N)
}