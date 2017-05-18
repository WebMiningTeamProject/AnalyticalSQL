

select avg(t.sentiment), t.news_provider, t.cluster_id 
from
(
	select sentiment.news_provider, sentiment.source_uri, sentiment.sentiment, cluster.cluster_id 
	from 
	(
		select n.source_uri, n.news_provider, s.sentiment 
		from NewsArticles n, SentimentCoreNlp s 
		where s.source_uri = n.source_uri) sentiment, 
	(
		select source_uri, cluster_id, rank 
		from ClusterAssignment 
		where rank = 1
		) cluster 
	where cluster.source_uri = sentiment.source_uri
	) t 
group by news_provider, cluster_id 
order by t.cluster_id;



-- NOTE:

-- CLUSTER
(select source_uri, cluster_id, rank from ClusterAssignment where rank = 1) cluster

-- SENTIMENT with News Provider
(select n.source_uri, n.news_provider, s.sentiment from NewsArticles n, SentimentCoreNlp s where s.source_uri = n.source_uri) sentiment




