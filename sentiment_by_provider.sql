select providerName.root_name NewsOutlet, avg(articleAndRoot.sentiment) Sentiment
from
(
	select article.source_uri,  article.news_provider, article.sentiment, root.root_id
	from
	(
		-- article and sentiment
		select n.source_uri, n.news_provider, s.sentiment 
		from NewsArticles n, SentimentLookup s 
		where s.source_uri = n.source_uri
	) article
	inner join ProviderRoot root
	on root.name = article.news_provider
) articleAndRoot
inner join ProviderRootName providerName
on articleAndRoot.root_id = providerName.root_id
group by NewsOutlet;
