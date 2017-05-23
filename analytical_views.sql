

-- aggregate average sentiment per provider by cluster (sentiment lookup)
ALTER VIEW 
average_sentiment_per_cluster_and_provider_pos_neg
AS
SELECT 
	AVG(sl.pos_neg_sentiment) 'Sentiment',
	rp.root_name 'Provider',
	c.cluster_name 'Cluster'
FROM
	NewsArticles a
	INNER JOIN
	ClusterAssignment ca ON a.source_uri = ca.source_uri
	AND ca.rank = 1
	INNER JOIN
	SentimentLookup sl ON a.source_uri = sl.source_uri
	INNER JOIN
	NewsProviderComplete rp ON a.news_provider = rp.name
	INNER JOIN
	Cluster c ON ca.cluster_id = c.cluster_id
GROUP BY rp.root_name , c.cluster_name;

-- average sentiment per provider (sentiment lookup)
ALTER VIEW 
average_sentiment_per_provider_pos_neg
AS
SELECT
	provider.root_name, 
	avg(pos_neg_sentiment) Sentiment
FROM
	NewsArticles articles
	INNER JOIN SentimentLookup sl
	ON sl.source_uri = articles.source_uri
	INNER JOIN NewsProviderComplete provider
	ON articles.news_provider = provider.name
GROUP BY provider.root_name;


-- average sentiment per cluster (sentiment lookup)
ALTER VIEW average_sentiment_per_cluster_pos_neg
AS
SELECT 
    AVG(sl.pos_neg_sentiment) 'AVG Sentiment',
    c.cluster_name 'Cluster Name'
FROM
	NewsArticles a
	INNER JOIN
	ClusterAssignment ca ON a.source_uri = ca.source_uri
	AND ca.rank = 1
	INNER JOIN
	SentimentLookup sl ON a.source_uri = sl.source_uri
	INNER JOIN
	Cluster c ON ca.cluster_id = c.cluster_id
GROUP BY c.cluster_name;
