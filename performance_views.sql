--------------------------------------------------------------------------------
-- The following statements allow to calculate the accuracy.

-- ALTER statements are given to quickly make changes to existing views. 
-- When setting up a new db you can replace alter by create.
--------------------------------------------------------------------------------


-- SVM
ALTER VIEW SentimentSVMAccuracy
as
select count(*) / (select count(*) from SentimentEvaluation) Accuracy 
from SentimentEvaluation se
INNER JOIN NewsArticlesLinearSVM_B svm
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

-- Stanford Core NLP (longest sentence)
alter view 
SentimentStanfordNlpAccuracy
as
select count(*) / (select count(*) from SentimentEvaluation) Accuracy from SentimentEvaluation se
INNER JOIN SentimentCoreNlp st
on se.source_uri = st.source_uri
where se.sentiment = st.pos_neg_sentiment;

-- Stanford Core NLP (average sentence)
ALTER view 
SentimentStanfordNlpAvgSentenceAccuracy
as
select count(*) / (select count(*) from SentimentEvaluation) Accuracy from SentimentEvaluation se
INNER JOIN SentimentCoreNlp st
on se.source_uri = st.source_uri
where se.sentiment = st.pos_neg_avg_sentiment;


-- Wrapper View
ALTER VIEW
AllAccuracies
AS
select "Lookup" as "Method", Accuracy from SentimentLookupAccuracy
UNION
select "StanfordNlp (longest sentence)" as "Method", Accuracy from SentimentStanfordNlpAccuracy
UNION
select "StanfordNlp (longest sentence)" as "Method", Accuracy from SentimentStanfordNlpAvgSentenceAccuracy
UNION
select "NaiveBayes" as "Method", Accuracy from SentimentNaiveBayesAccuracy
UNION
select "SVM" as "Method", Accuracy from SentimentSVMAccuracy;

-- Sentiment Lookup Precision
alter view 
SentimentLookupPrecision
as
select count(*)/(
	select count(*) 
    from SentimentLookup sl
    inner join SentimentEvaluation eval
    on eval.source_uri = sl.source_uri
    where sl.pos_neg_sentiment = 1
) from SentimentEvaluation se
INNER JOIN SentimentLookup st
on se.source_uri = st.source_uri
where se.sentiment = st.pos_neg_sentiment
and se.sentiment = 1;

-- Sentiment Lookp Recall
alter view 
SentimentLookupRecall
as
select count(*)/
(
select count(*) from SentimentEvaluation where sentiment = 1
) 
as recall
from SentimentEvaluation se
INNER JOIN SentimentLookup st
on se.source_uri = st.source_uri
where se.sentiment = st.pos_neg_sentiment
and se.sentiment = 1;

-- F1 sentiment lookup
alter view SentimentLookupF1
as
select 
(
	2 * 
	(
		select prec from SentimentLookupPrecision
	)
	*
	(
		select recall from SentimentLookupRecall
	)
)
/
(
	(
		select prec from SentimentLookupPrecision
	)
	+
	(
		select recall from SentimentLookupRecall
	)
) as F1;


-- stanford core nlp recall (longest sentence)
alter view 
SentimentCoreNlpRecall
as
select count(*)/(
select count(*) from SentimentEvaluation where sentiment = 1
) 
as recall
from SentimentEvaluation se
INNER JOIN SentimentCoreNlp st
on se.source_uri = st.source_uri
where se.sentiment = st.pos_neg_sentiment
and se.sentiment = 1;

-- stanford core nlp precision (longest sentence)
alter view 
SentimentCoreNlpPrecision
as
select count(*)/(
	select count(*) 
    from SentimentCoreNlp sl
    inner join SentimentEvaluation eval
    on eval.source_uri = sl.source_uri
    where sl.pos_neg_sentiment = 1
) as prec
from SentimentEvaluation se
INNER JOIN SentimentCoreNlp st
on se.source_uri = st.source_uri
where se.sentiment = st.pos_neg_sentiment
and se.sentiment = 1;


-- stanford core nlp f1
create view SentimentCoreNlpF1
as
select 
(
	2 * 
	(
		select prec from SentimentCoreNlpPrecision
	)
	*
	(
		select recall from SentimentCoreNlpRecall
	)
)
/
(
	(
		select prec from SentimentCoreNlpPrecision
	)
	+
	(
		select recall from SentimentCoreNlpRecall
	)
) as F1;


