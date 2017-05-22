

select aggregatedSentiment.*, cluster.terms, cluster.cluster_name
from
(
	select npc.root_name, avg(articleLevel.sentiment) sentiment, cluster_id
	from
	(
		select sentiment.news_provider, sentiment.source_uri, sentiment.sentiment, cluster_assignment.cluster_id
		from
		-- get sentiment and cluster for each article 
		(
			-- sentiment
			select n.source_uri, n.news_provider, s.sentiment 
			from NewsArticles n, SentimentLookup s 
			where s.source_uri = n.source_uri
		) sentiment, 
		(
			-- cluster of rank 1
			select source_uri, cluster_id, rank 
			from ClusterAssignment 
			where rank = 1
		) cluster_assignment 
		-- use source_uri to map sentiment and cluster to article
		where cluster_assignment.source_uri = sentiment.source_uri
	) articleLevel 
	-- join News Provider Root Name
	inner join NewsProviderComplete npc on npc.name = articleLevel.news_provider
	group by npc.root_name, cluster_id
) aggregatedSentiment
inner join Cluster cluster
on cluster.cluster_id = aggregatedSentiment.cluster_id
order by cluster_id asc;

