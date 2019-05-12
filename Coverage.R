# compute hamming loss, given a matrix of true labels and a matrix of predicted probabilities.
# true_labels: Matrix of true labels, columns corresponding to labels and rows to instances.
# predictions: Matrix of probabilities predicted by a classifier.

Coverage<-function(true_labels, predictions){
  if(nrow(true_labels) != nrow(predictions) | ncol(true_labels) != ncol(predictions)){
    stop("labels and predictions should be in the same format")
  }
  result = 0
  M=ncol(true_labels)
  N=nrow(true_labels)
  
  result<-sapply(seq(nrow(true_labels)), function(x){
    tmp<-rbind(true_labels[x,], predictions[x,])
    tmp<-tmp[,order(tmp[2,],decreasing = T)]
    
    return(rev(as.vector(which(tmp[1,] == 1)))[1] - 1)
  })
  result[is.na(result)]<-0
  return(sum(result)/N)
}