# compute the MLKNN result
# train: matrix that contains features
# test: test matrix, test should have the same label numbers like train
# train.label: label matrix
# k: the number of neighbor
# smoothing: the Laplace smoothing
# ignore.nearest: whether to ignore the nearest

MLKNN<-function(train = NULL, train.label = NULL, test = NULL, k = 5, smoothing = 1, ignore.nearest = T){
  if(is.null(train) | is.null(test)){
    stop("train set and test set cannot be NULL")
  }
  eudist<-function(x,y){
    return(sqrt(sum((x-y)^2)))
  }
  test.row<-nrow(test)
  test.col<-ncol(test)
  N<-nrow(train)
  M<-ncol(train)
  MAP.1<-(apply(label_matrix, 2, sum)+smoothing)/(N+2*smoothing)
  MAP.0<-1-MAP.1
  result<-matrix(0,nrow = test.row, ncol = test.col)
  
  for (i in 1:test.row) {
    distance<-apply(train, 1, function(x){
      return(eudist(test[i,], x))
    })
    if(ignore.nearest){
      nearest.k<-distance[order(distance,decreasing = F)][2:(k+1)]
    }else{
      nearest.k<-distance[order(distance,decreasing = F)][1:k]
    }
    
    data.k<-train.label[which(distance %in% nearest.k),]
    pec1<-(smoothing+apply(data.k, 2, sum))/(smoothing*k+apply(train.label, 2, sum))
    pec0<-(smoothing+(k-apply(data.k, 2, sum)))/(smoothing*k+(N-apply(train.label, 2, sum)))
    
    tmp.p<-matrix(0,nrow = 2, ncol = M)
    tmp.p[1,]<-pec1 * MAP.1
    tmp.p[2,]<-pec0 * MAP.0
    result[i,]<-apply(tmp.p, 2, max)
  }
  return(result)
}