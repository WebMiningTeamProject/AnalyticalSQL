

-- aggregate average sentiment per provider by cluster (sentiment lookup)
create view average_sentiment_per_cluster_and_provider
as
SELECT 
	AVG(sl.sentiment) 'AVG Sentiment',
	rp.root_name 'Root News Provider',
	c.cluster_name 'Cluster Name'
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
create view average_sentiment_per_provider
as
select provider.root_name, (sentiment) Sentiment
from
NewsArticles articles
inner join SentimentLookup sl
on sl.source_uri = articles.source_uri
inner join NewsProviderComplete provider
on articles.news_provider = provider.name
group by provider.root_name;


-- average sentiment per cluster (sentiment lookup)
create view average_sentiment_per_cluster
as
SELECT 
    AVG(sl.sentiment) 'AVG Sentiment',
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
