-- ALTER statements are given to quickly make changes to existing views. 
-- When setting up a new db you can replace alter by create.

-- SVM
ALTER VIEW SentimentSVMAccuracy
as
select count(*) / (select count(*) from SentimentEvaluation) Accuracy 
from SentimentEvaluation se
INNER JOIN NewsArticlesLinearSVM_I svm
on se.source_uri = svm.source_uri
where se.sentiment = svm.sentiment;

-- Naive Bayes
ALTER VIEW 
SentimentNaiveBayesAccuracy
as
select count(*) / (select count(*) from SentimentEvaluation) Accuracy from SentimentEvaluation se
INNER JOIN NewsArticlesNaiveBayes_SPSentiment svm
on se.source_uri = svm.source_uri
where se.sentiment = svm.sentimentAsNumber;

-- Lookup
ALTER VIEW 
SentimentLookupAccuracy
as
select count(*) / (select count(*) from SentimentEvaluation) Accuracy from SentimentEvaluation se
INNER JOIN SentimentLookup lm
on se.source_uri = lm.source_uri
where se.sentiment = lm.pos_neg_sentiment;

-- Stanford Core NLP
ALTER VIEW 
SentimentStanfordNlpAccuracy
as
select count(*) / (select count(*) from SentimentEvaluation) Accuracy from SentimentEvaluation se
INNER JOIN SentimentCoreNlp st
on se.source_uri = st.source_uri
where se.sentiment = st.pos_neg_sentiment;

-- Wrapper View
ALTER VIEW
AllAccuracies
AS
select "Lookup" as "Method", Accuracy from SentimentLookupAccuracy
UNION
select "StanfordNlp" as "Method", Accuracy from SentimentStanfordNlpAccuracy
UNION
select "NaiveBayes" as "Method", Accuracy from SentimentNaiveBayesAccuracy
UNION
select "SVM" as "Method", Accuracy from SentimentSVMAccuracy;
