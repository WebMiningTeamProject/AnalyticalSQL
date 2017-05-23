

-- aggregate average sentiment per provider by cluster
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

