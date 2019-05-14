# compute the MLKNN result
# train: matrix that contains features
# cv = 3 cross validation number
# k = 5 number of knn
# smoothing = 1 laplace smoothing
# ignore.nearest=T whether to ignore the nearest instance


MLKNN<-function(train = NULL, train.label = NULL, cv = 3, k = 5, smoothing = 1, ignore.nearest=T){
  if(is.null(train) | is.null(train.label)){
    stop("train set and test set cannot be NULL")
  }
  M<-ncol(train)
  N<-nrow(train)
  folds<-caret::createFolds(1:N, k = cv)
  final<-lapply(folds, function(x){
    cv.train<-train[-x,]
    label.cv.train<-train.label[-x,]
    cv.test<-train[x,]
    label.cv.test<-train.label[x,]
    
    model<-MLKNN(train = cv.train, train.label = label.cv.train, test = cv.test, 
                 k = k, smoothing = smoothing, ignore.nearest = ignore.nearest)
    
    out<-list()
    model.cutoff<-ifelse(model >= 0.5, 1, 0)
    out[["hamming_loss"]]<-HammingLoss(label.cv.test, model.cutoff)
    out[["one_error"]]<-OneError(label.cv.test, model)
    out[["coverage"]]<-Coverage(label.cv.test, model)
    out[["average_precision"]]<-AveragePrecision(label.cv.test, model)
    out[["ranking_loss"]]<-RankingLoss(label.cv.test, model)
    return(out)
  })
  
  return(as.matrix(unlist(final)))
}