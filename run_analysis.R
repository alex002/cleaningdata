## Set working directory
setwd(paste('f:/Users/GT/Desktop/Coursera',
            '/Data Science/Cleaning Data/',
            'Project/UCI HAR Dataset',sep=''))

##--------------------------------------------
## Read all training data into R
##--------------------------------------------
## Feature name
fname=read.table('./features.txt',sep='')

## Find the features
fidx <- grep("mean\\(\\)|std\\(\\)", fname[,2]) 
nfname <- fname[fidx,2]

## Training data
tdata=read.table('./train/x_train.txt',sep='')
tdata=tdata[,fidx]
colnames(tdata)=nfname

## Training index
tidx=read.table('./train/y_train.txt',sep='')
colnames(tidx)='Activity'

## Training subject
tsub=read.table('./train/subject_train.txt',sep='')
colnames(tsub)='Subject'

## Merge the training data with activity
train=cbind(tsub,tidx,tdata)

## Processing the test data using the same procedures
sdata=read.table('./test/x_test.txt',sep='')
sdata=sdata[,fidx]
colnames(sdata)=nfname

sidx=read.table('./test/y_test.txt',sep='')
colnames(sidx)='Activity'

ssub=read.table('./test/subject_test.txt',sep='')
colnames(ssub)='Subject'

test=cbind(ssub,sidx,sdata)


## Merge test and train data
data=rbind(train,test)

## Create a new parameter to calculate group mean
data$o=data$Activity+10*data$Subject


## Compute mean for each column based on the index
ndata=matrix(nrow=180,ncol=ncol(data))
ndata=data.frame(ndata)
for(i in 1:ncol(data)){
      ndata[,i]=tapply(data[,i],data$o,mean)
}
colnames(ndata)=colnames(data)

## Descriptive activity
dact=read.table('./activity_labels.txt',sep='')

## Substitute the activity with descriptive words
ndata$Activity=factor(ndata$Activity,
                      levels=dact$V1,labels=dact$V2)

## Output data
write.table(fdata,file='result.txt',col.names=T)

